class ProgressScreen {

        private RedPanda context;

        private PImage[] menuBack = new PImage[3];
        private PImage[] logout = new PImage[3];
        private PImage[] previous = new PImage[3];
        private PImage[] next = new PImage[3];
        private Button []buttons;
        private Group progressGroup;
        boolean start = false;
        int timer;
        ProgressChart chart;
        Programme programme;
        int currentChartNumber = 0;

        public ProgressScreen(RedPanda c) {
                this.context = c;                
        }

        void loadImages() {
                //load images  for login button
                this.menuBack[0]  = loadImage("images/menu.jpg");
                this.menuBack[1]  = loadImage("images/menuOver.jpg");
                this.menuBack[2]  = loadImage("images/menu.jpg");
                this.logout[0] = loadImage("images/logout.jpg");
                this.logout[1] =loadImage("images/logoutOver.jpg");
                this.logout[2] =loadImage("images/logout.jpg");

                this.previous[0] = loadImage("images/previous.jpg");
                this.previous[1] =loadImage("images/previous.jpg");
                this.previous[2] =loadImage("images/previous.jpg");

                this.next[0] = loadImage("images/next.jpg");
                this.next[1] =loadImage("images/next.jpg");
                this.next[2] =loadImage("images/next.jpg");
        }

        public void create(Programme _programme) {
                this.programme = _programme;
                start = false;
                cp5.setAutoDraw(false);

                progressGroup = cp5.addGroup("progressGroup")
                        .setPosition(0, 0)
                                .hideBar()
                                        ;

                buttons = new Button[4];

                buttons[0] = cp5.addButton("menuBackProgress")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(progressGroup)
                                                        ;

                buttons[1] = cp5.addButton("logoutProgress")
                        .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(progressGroup)
                                                        ;

                buttons[2] = cp5.addButton("previousChart")
                        .setPosition(10, 515)
                                .setImages(previous)
                                        .updateSize()
                                                .setGroup(progressGroup)
                                                        ;

                buttons[3] = cp5.addButton("nextChart")
                        .setPosition(1084, 515)
                                .setImages(next)
                                        .updateSize()
                                                .setGroup(progressGroup)
                                                       ;
                //programme = Programme.getInstance();
                createChart();
        }

        void createChart() {

                switch (currentChartNumber) {
                case 0: 
                        chart = new ProgressChart(context, new float[] {
                                1900, 1910, 1920, 1930, 1940, 1950, 
                                1960, 1970, 1980, 1990, 2000
                        }
                        , 
                        new float[] { 
                                6322, 6489, 6401, 7657, 9649, 9767, 
                                12167, 15154, 18200, 23124, 28645
                        }
                        , "Date", "Score");
                        break;
                }
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
                                println("Menu Back called");
                                menuBack();
                        }
                }
                else if (leftHand.x > (978/2.5) && leftHand.x < (1190/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                {
                        if (start == false) {
                                println("Over Log out");
                                start = true;
                                timer = millis();
                        }
                        if (checkTimer() == 1) {
                                println("logout called");
                                makeLogout();
                        }
                }
                else {
                        start = false;
                        loaderOff();
                        //Over Nothing");
                }
        }

        public int checkTimer() {
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
                pushStyle();
           
                fill(255, 180);
                rect(10, 95, 1180, 495);
             
                popStyle();
                cp5.draw();
                chart.drawUI();
                drawInfo();
        }
        
        public void drawInfo() {
                pushStyle();
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
                text("Programme version: " + programme.getEnd_date(), 10, 105);
                textSize(24);
                text("Chart Legend ", 10, 145); 
                //text("Start Date: " + programme.getStart_date(), 10, 70);
                popMatrix(); 
                popStyle();
        }

        public void controlEvent(ControlEvent theEvent) {
                if (theEvent.getController().getName().equals("previousChart")) { //f the button was the log in button
                        println("previous chart");
                }

                if (theEvent.getController().getName().equals("nextChart")) { //f the button was the log in button
                        println("next chart");
                }
        }

        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                cp5.getGroup("progressGroup").remove();
                //progressGroup.remove();
        }
}

