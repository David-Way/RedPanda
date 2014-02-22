//this class is used to generate and display graphs made from the users record data
//the users records are generated every time they complete an exercise
class ProgressScreen {

        private RedPanda context;
        //image arrays used for storing the button images
        private PImage[] menuBack = new PImage[3];
        private PImage[] logout = new PImage[3];
        private PImage[] previous = new PImage[3];
        private PImage[] next = new PImage[3];
        //image array for storing current chart indicator image
        private PImage[] dots = new PImage[3];
        //array for storing button elements
        private Button []buttons;
        private Group progressGroup;
        boolean start = false;
        int timer;
        //ProgressChart chart; //no longer used
        JFreeProgressChart chartObject; 
        PImage chartImage;
        Programme programme;
        ArrayList<Exercise> exs;
        //variable for storing an array list of records for each exercise in an arraylist
        ArrayList<ArrayList<Record>> records;
        //set current chart number to the first one
        int currentChartNumber = 0;
        ArrayList<ArrayList<float[]>> charts = new ArrayList<ArrayList<float[]>>(); 
        PFont Font1;

        //progress screen constructor, takes reference to the RedPanda class
        public ProgressScreen(RedPanda c) {
                this.context = c;
                //create font 
                Font1 = createFont("Arial Bold", 30);
        }

        void loadImages() {
                //load images  for buttons
                this.menuBack[0]  = loadImage("images/NewUI/menu.jpg"); //normal
                this.menuBack[1]  = loadImage("images/NewUI/menuOver.jpg"); //hover/over
                this.menuBack[2]  = menuBack[0]; //click

                this.logout[0] = loadImage("images/NewUI/logout.jpg");
                this.logout[1] = loadImage("images/NewUI/logoutOver.jpg");
                this.logout[2] = logout[0];

                this.previous[0] = loadImage("images/NewUI/previous.png");
                this.previous[1] = loadImage("images/NewUI/previousOver.png");
                this.previous[2] = previous[0];

                this.next[0] = loadImage("images/NewUI/next.png");
                this.next[1] = loadImage("images/NewUI/nextOver.png");
                this.next[2] = next[0];
                
                //load images for the current chart indicator
                this.dots[0] = loadImage("images/NewUI/1_3.png"); //chart 1
                this.dots[1] = loadImage("images/NewUI/2_3.png"); //chart 2
                this.dots[2] = loadImage("images/NewUI/3_3.png"); //chart 3
        }
        
        //create function takes the users programme object as a parameter
        public void create(Programme _programme) {
                this.programme = _programme;
                start = false;

                //create and configure UI elements
                cp5.setAutoDraw(false);
                
                //create a Cp5 group for this screen
                progressGroup = cp5.addGroup("progressGroup")
                        .setPosition(0, 0)
                                .hideBar()
                                        ;

                //initialise array of buttons
                buttons = new Button[4];

                //create a menu back button and add to group 
                buttons[0] = cp5.addButton("menuBackProgress")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(progressGroup)
                                                        ;

                //create a logout button and add to group 
                buttons[1] = cp5.addButton("logoutProgress")
                        .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(progressGroup)
                                                        ;
                                                        
                //create a previous chart button for navigating charts and add to group 
                buttons[2] = cp5.addButton("previousChart")
                        .setPosition(10, 515)
                                .setImages(previous)
                                        .updateSize()
                                                .setGroup(progressGroup)
                                                        ;

                //create a next chart button for navigating charts and add to group 
                buttons[3] = cp5.addButton("nextChart")
                        .setPosition(1084, 515)
                                .setImages(next)
                                        .updateSize()
                                                .setGroup(progressGroup)
                                                        ;
                                                        
                //load the record data and generate first chart
                loadChartData();                   
                createChart();
        }

        //this function is called when the screen is setup
        void loadChartData() {
                //it gets the users exercises from its programme object
                exs = programme.getExercises();
                //creates an array to store the users records
                records = new ArrayList<ArrayList<Record>>();
                RecordDAO dao = new RecordDAO();

                //loop through the users exercises
                for (int i = 0; i < exs.size(); i ++) {   
                        //get the records for this user, for each exercise and add it to the records arraylist                
                        records.add(dao.getRecords(user.getUser_id(), exs.get(i).getExercise_id()));
                }
        }

        //this function generates a chart image using the JFreeCharts java library
        void createChart() {
                //get the records for the exercise in the position of the current chart number
                ArrayList<Record> rs = records.get(currentChartNumber);
                
                //create integer arrays to store relevant record data
                int[] dates = new int[rs.size()];
                int[] score = new int[rs.size()];
                int[] time = new int[rs.size()];
                //loop through record array for the current exercise
                for (int i = 0; i < rs.size(); i++) { 
                        //get each record from the array
                        Record record = rs.get(i);          
                        //get the date, score and timt to complete for the record       
                        int  dd = record.getDateDone();
                        int sc = record.getScore();
                        int tm = record.getTimeToComplete();
                        //add these values to the int arrays                        
                        dates[i] = dd;
                        score[i] = sc;
                        time[i] = tm;
                }  
                
                //create a chart object, pass the integer arrays, exercise name, axis names as parameters
                chartObject = new JFreeProgressChart(dates, score, time, exs.get(currentChartNumber).getName(), "Date", "Score", "Time");
                //retrieve a PImage from the created chart object
                chartImage = chartObject.getChartImage();
        }
        
        

        //this function draws the UI elements for the screen
        void drawUI() {
                cp5.draw();
                //chart.drawUI();
                //draw the chart image to the  page
                image(chartImage, 116, 100);  

                //draw current chart number
                //fill(123);
                //textSize(32);
                //textFont(Font1);
                //text((currentChartNumber +1) + "/" +  exs.size(), 600, 550);
                
                //draw the current chart navigation indicator       
                image(dots[currentChartNumber], 512, 524, 175, 51);
                //drawInfo();
        }

        //this function draws information about the users programme, no longer used
        public void drawInfo() {
                pushStyle(); //function saves the current style settings
                pushMatrix();
                translate(764, 105);  
                textAlign(LEFT);   
                fill(255);
                textSize(24);
                text("Progress Details", 10, 28);
                textSize(16);
                text("Start Date: " + programme.getCreate_date(), 10, 45); 
                text("End Date: " + programme.getEnd_date(), 10, 65);
                text("Number of Exercises: " + programme.getEnd_date(), 10, 85);
                //text("Programme version: " + programme.getVersion, 10, 105);
                popMatrix(); 
                popStyle();  //function restores the previous style settings
        }

        public void nextChartPressed() { //chart navigation , next chart
                if (currentChartNumber < exs.size() -1) {
                        currentChartNumber++;
                } 
                else {
                        currentChartNumber = 0;
                }
                createChart();                
        }

        public void previousChartPressed() { //chart navigation, previous chart
                if (currentChartNumber > 0) {
                        currentChartNumber--;
                } 
                else {
                        currentChartNumber = exs.size() -1;
                }
                createChart();
        }

        //function used to remove the UI elements and the Cp5 group of the screen
        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                cp5.getGroup("progressGroup").remove();
        }
}

