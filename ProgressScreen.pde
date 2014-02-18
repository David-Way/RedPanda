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
        //ProgressChart chart;
        JFreeProgressChart chartObject;
        PImage chartImage;
        Programme programme;
        ArrayList<Exercise> exs;
        ArrayList<ArrayList<Record>> records;
        int currentChartNumber = 0;
        ArrayList<ArrayList<float[]>> charts = new ArrayList<ArrayList<float[]>>(); 

        public ProgressScreen(RedPanda c) {
                this.context = c;
        }

        void loadImages() {
                //load images  for buttons
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

                //create UI elements
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
                //generate charts
                loadChartData();                   
                createChart();
        }

        void loadChartData() {
                exs = programme.getExercises();
                records = new ArrayList<ArrayList<Record>>();
                RecordDAO dao = new RecordDAO();

                for (int i = 0; i < exs.size(); i ++) {
                        records.add(dao.getRecords(user.getUser_id(), exs.get(i).getExercise_id()));
                }
        }

        void createChart() {
                ArrayList<Record> rs = records.get(currentChartNumber);

                float[] dates = new float[rs.size()];
                float[] score = new float[rs.size()];
                float[] time = new float[rs.size()];
                for (int i = 0; i < rs.size(); i++) {                        
                        float  dd = rs.get(i).getDateDone();
                        float sc = rs.get(i).getScore();
                        float tm = rs.get(i).getTimeToComplete();                        
                        dates[i] = dd;
                        score[i] = sc;
                        time[i] = tm;
                }  

                chartObject = new JFreeProgressChart(dates, score, time, exs.get(currentChartNumber).getName(), "Date", "Score", "Time");
                chartImage = chartObject.getChartImage();
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

                //fill(255, 180);
                //rect(10, 95, 1180, 495);

                popStyle();
                cp5.draw();
                //chart.drawUI();
                
                image(chartImage, 116, 100);    
                //draw current chart number
                fill(123);
                textSize(32);
                text(currentChartNumber + "/" +  exs.size(), 600, 550);           

                drawInfo();
        }

        public void drawInfo() {
                pushStyle();
                pushMatrix();
                translate(764, 105);  
                textAlign(LEFT);   
                fill(255);
                textSize(24);
                //text("Progress Details", 10, 28);
                textSize(16);
                text("Start Date: " + programme.getCreate_date(), 10, 45); 
                text("End Date: " + programme.getEnd_date(), 10, 65);
                text("Number of Exercises: " + programme.getEnd_date(), 10, 85);
                //text("Programme version: " + programme.getEnd_date(), 10, 105);
                textSize(24);
                //text("Chart Legend ", 10, 145); 
                //text("Start Date: " + programme.getStart_date(), 10, 70);
                popMatrix(); 
                popStyle();
        }

        public void nextChartPressed() { //chart navigation , next chart
                if (currentChartNumber < exs.size() -1) {
                        currentChartNumber++;
                } 
                else {
                        currentChartNumber = 0;
                }
                loadChartData();                   
                println(currentChartNumber);
                createChart();
        }

        public void previousChartPressed() { //chart navigation, previous chart
                if (currentChartNumber > 0) {
                        currentChartNumber--;
                } 
                else {
                        currentChartNumber = exs.size() -1;
                }
                println(currentChartNumber);
                loadChartData();                   

                createChart();
        }


        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                cp5.getGroup("progressGroup").remove();
        }
}

