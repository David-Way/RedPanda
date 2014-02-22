//this class is used for displaying the record comments
class CommentsScreen {

        //declare a variable to store a reference to the class that called it
        private RedPanda context;

        //create image arrays to store the button images
        private PImage[] menuBack = new PImage[3];
        private PImage[] logout = new PImage[3];
        private PImage border;
        //Create arrays to hold buttons
        private Button []buttons;
        private Button []buttons2;
        //Create cp5 group
        private Group commentsGroup;
        //Create exercise arraylist
        ArrayList<Exercise> e = new ArrayList<Exercise>();
        boolean start = false;
        int timer;
        int j=0;
        Textarea myTextarea;

        public CommentsScreen(RedPanda c) {
                this.context = c;
        }

         //this function loads the assets used by the class
        void loadImages() {
                //load images buttons
                this.menuBack[0]  = loadImage("images/NewUI/menu.jpg");
                this.menuBack[1]  = loadImage("images/NewUI/menuOver.jpg");
                this.menuBack[2]  = this.menuBack[0];
                this.logout[0] = loadImage("images/NewUI/logout.jpg");
                this.logout[1] = loadImage("images/NewUI/logoutOver.jpg");
                this.logout[2] = this.logout[0];
                this.border = loadImage("images/NewUI/comment_border.png");
        }

        //create the UI elements
        public void create(User user, Programme programme) {
                //Set start to flase to reset hand tracking
                start = false;
                cp5.setAutoDraw(false);
                //Create font for cp5 buttons
                PFont p = createFont("arial",24); 
                cp5.setControlFont(p);
                cp5.setColorBackground(color(68, 142, 174));

                 //create a group for this screen
                commentsGroup = cp5.addGroup("commentsGroup")
                        .setPosition(0, 0)
                                .hideBar()
                                        ;

                //Buttons array for menu back and log out
                buttons = new Button[2];

                buttons[0] = cp5.addButton("menuBackComments")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(commentsGroup)
                                                        ;

                buttons[1] = cp5.addButton("logoutComments")
                        .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(commentsGroup)
                                                        ;

                //Check if there is a programme object
                if (programme.getProgramme_id() != -1) {
                        
                        try {
                                //Fill exercise Array with exercises from programme object                              
                                e = programme.getExercises();
                                //Create new buttons array to same size as exercise array   
                                buttons2 = new Button[e.size()];
                                //Loop to create buttons for each exercise
                                for (int i = 0; i < e.size(); i++) {
                                        println("make button");
                                        int x = 200;
                                        int y = 515;
                                        int width = 250;
                                        int height = 70;
                                        int padding = 30;
                                        //Set button values dynamically
                                        buttons2[i] = cp5.addButton(e.get(i).getName())
                                                .setPosition(x + (width*i) + (padding*i), y)
                                                .setBroadcast(false)
                                                .setValue(e.get(i).getExercise_id())
                                                .setBroadcast(true)
                                                .setWidth(width)
                                                .setHeight(height)
                                                .setGroup(commentsGroup)
                                                        ;    
                                }  
                                //Call buttonClicked function with first exercise id
                                buttonClicked(e.get(0).getExercise_id());            
                
                        } catch (Exception ex) {
                                System.out.println("exercises not retrieved/set");
                    }

                  }      
        }


        //Function to display comments for each exercise
        //Called when exercises have been loaded, load first one automatically
        void buttonClicked(float btnValue){
                //J is incremented on each click to give the text area a different name
                //each time. This is to avoid conflicts
                j++;
                //Create comment arraylist, fill comment arraylist
                ArrayList<Comment> comment  = new ArrayList<Comment>();
                CommentDAO commentDAO = new CommentDAO();
                comment=commentDAO.getComments(user.getUser_id(), int(btnValue));
                String commentsText = "";
                //Loop through comment arraylist, filing text area with comments
                //For each exercise
                for (int i=0; i < comment.size(); i++){
                        String date = String.valueOf(comment.get(i).getDateEntered());
                        int Year=int(date.substring(0, 4));
                        int Month=int(date.substring(4, 6));
                        int Day=int(date.substring(6, 8));
                        String r_date = String.valueOf(comment.get(i).getRecordDate());
                        int r_year=int(r_date.substring(0, 4));
                        int r_month=int(r_date.substring(4, 6));
                        int r_day=int(r_date.substring(6, 8));
                          commentsText = (commentsText + "Comment left on:" + Day +" / " + Month + " / "+ Year +
                          "\nExercise recorded on:" + r_day +" / " + r_month + " / "+ r_year +
                          "\n Feedback : \n" + comment.get(i).getComment() + 
                          "\n\n");
                    }
                //Create name for text area
                //Set values of textarea
                String name = ("txt" + j);
                myTextarea = cp5.addTextarea(name)
                                .setPosition(20,110)
                                .setSize(1160,380)
                                .setFont(createFont("arial",24))
                                .setLineHeight(34)
                                .setColor(color(51, 196, 242))
                                .setColorBackground(color(255,255, 255))
                                .setColorForeground(color(255,100))
                                .setGroup(commentsGroup)
                                ;
                myTextarea.setText(commentsText);

                }


        
        //Function to draw cp5 UI and border image
        void drawUI() {
                cp5.draw();
                 image(border, 10, 100);
        }

        //function to destroy screen
        //Loops through button arrays to remove and set to null
        //Removes group and textarea from cp5 element
        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                for ( int i = 0 ; i < buttons2.length ; i++ ) {
                        buttons2[i].remove();
                        buttons2[i] = null;
                }
                myTextarea.remove();
                cp5.getGroup("commentsGroup").remove();
        }
}

