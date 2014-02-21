class CommentsScreen {

        private RedPanda context;

        private PImage[] menuBack = new PImage[3];
        private PImage[] logout = new PImage[3];
        private PImage border;
        private Button []buttons;
        private Button []buttons2;
        private Group commentsGroup;
        ArrayList<Exercise> e = new ArrayList<Exercise>();
        boolean start = false;
        int timer;
        int j=0;
        Textarea myTextarea;

        public CommentsScreen(RedPanda c) {
                this.context = c;
        }

        void loadImages() {
                //load images  for login button
                this.menuBack[0]  = loadImage("images/NewUI/menu.jpg");
                this.menuBack[1]  = loadImage("images/NewUI/menuOver.jpg");
                this.menuBack[2]  = loadImage("images/NewUI/menu.jpg");
                this.logout[0] = loadImage("images/NewUI/logout.jpg");
                this.logout[1] =loadImage("images/NewUI/logoutOver.jpg");
                this.logout[2] =loadImage("images/NewUI/logout.jpg");
                this.border = loadImage("images/NewUI/comment_border.png");
        }

        public void create(User user, Programme programme) {
                start = false;
                cp5.setAutoDraw(false);
                PFont p = createFont("arial",24); 
                cp5.setControlFont(p);
                cp5.setColorBackground(color(68, 142, 174));

                commentsGroup = cp5.addGroup("commentsGroup")
                        .setPosition(0, 0)
                                .hideBar()
                                        ;



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

                  if (programme.getProgramme_id() != -1) {
                        
                        try {
                              
                                e = programme.getExercises();   
                                buttons2 = new Button[e.size()];
                                for (int i = 0; i < e.size(); i++) {
                                        println("make button");
                                        int x = 200;
                                        int y = 515;
                                        int width = 250;
                                        int height = 70;
                                        int padding = 30;
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

                                buttonClicked(e.get(0).getExercise_id());            
                
                        } catch (Exception ex) {
                                System.out.println("exercises not retrieved/set");
                    }

                  }      
        }

        void buttonClicked(float btnValue){
                j++;
                ArrayList<Comment> comment  = new ArrayList<Comment>();
                CommentDAO commentDAO = new CommentDAO();
                comment=commentDAO.getComments(user.getUser_id(), int(btnValue));
                String commentsText = "";
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


        void checkBtn(PVector convertedLeftJoint, PVector convertedRightJoint ) {

                PVector leftHand = convertedLeftJoint;
                PVector rightHand = convertedRightJoint;

                if (leftHand.x > (10/2.5) && leftHand.x < (222/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                {
                        if (start == false) {
                                println("Over Menu Back");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                println("Menu Back Called");
                                menuBack();
                        }
                }
                else if (leftHand.x > (978/2.5) && leftHand.x < (1190/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                {
                        if (start == false) {
                                println("Over Log out");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                println("Logout called");
                                makeLogout();
                        }
                }
                else {
                        start = false;
                        loaderOff();
                        //println("Over Nothing");
                }
        }

        public int checkTimer() {
                println("timer called");
                int totalTime = 5000;
                int checkInt = 0;
                if (start) {
                        int passedTime = millis() - timer;
                        if (passedTime > totalTime) {
                                checkInt = 1;
                        }
                        else {
                                checkInt = -1;
                        }
                }
                return checkInt;
        }


        void drawUI() {
                cp5.draw();
                 image(border, 10, 100);
        }

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

