class ProgramsScreen {

        private RedPanda context;

        private PImage[] menuBack = new PImage[3];
        private PImage[] exerciseOne = new PImage[3];
        private PImage[] exerciseTwo = new PImage[3];
        private PImage[] exerciseThree = new PImage[3];
        private PImage[] logout = new PImage[3];
        private Button []buttons;
        private Group programmesGroup;
        boolean start = false;
        int timer;

        public ProgramsScreen(RedPanda c) {
                this.context = c;
        }

        void loadImages() {

                //load images  for login button
                this.menuBack[0]  = loadImage("images/menu.jpg");
                this.menuBack[1]  = loadImage("images/menuOver.jpg");
                this.menuBack[2]  = loadImage("images/menu.jpg");
                this.exerciseOne[0]  = loadImage("images/exercise1.jpg");
                this.exerciseOne[1]  =loadImage("images/exercise1Over.jpg");
                this.exerciseOne[2]  =loadImage("images/exercise1.jpg");
                this.exerciseTwo[0] = loadImage("images/exercise2.jpg");
                this.exerciseTwo[1] =loadImage("images/exercise2Over.jpg");
                this.exerciseTwo[2] =loadImage("images/exercise2.jpg");
                this.exerciseThree[0] = loadImage("images/exercise3.jpg");
                this.exerciseThree[1] = loadImage("images/exercise3Over.jpg");
                this.exerciseThree[2] = loadImage("images/exercise3.jpg");
                this.logout[0] = loadImage("images/logout.jpg");
                this.logout[1] =loadImage("images/logoutOver.jpg");
                this.logout[2] =loadImage("images/logout.jpg");
        }

        public void create() {
                start = false;
                cp5.setAutoDraw(false);


                programmesGroup = cp5.addGroup("programmesGroup")
                        .setPosition(0, 0)
                                ;

                buttons = new Button[5];

                buttons[0] = cp5.addButton("menuBackProgrammes")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;

                buttons[1] = cp5.addButton("exerciseOne")
                        .setPosition(10, 120)
                                .setImages(exerciseOne)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;

                buttons[2] = cp5.addButton("exerciseTwo")
                        .setPosition(242, 120)
                                .setImages(exerciseTwo)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;


                buttons[3] = cp5.addButton("exerciseThree")
                        .setPosition(482, 120)
                                .setImages(exerciseThree)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;



                buttons[4] = cp5.addButton("logoutPrograms")
                        .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;
        }

        void drawUI() {
                cp5.draw();
        }


        void checkBtn(PVector convertedLeftJoint, PVector convertedRightJoint ) {

                PVector leftHand = convertedLeftJoint;
                PVector rightHand = convertedRightJoint;
                // CHECK FOR MENUBACK BUTTON
                //(leftHand.x > 10/2.5 && leftHand.x < 106/2.5 && leftHand.y/2.5 > 10/2.5 && leftHand.y < 57/2.5) || (
                //rightHand.x > 10/2.5 && rightHand.x < 106/2.5 && rightHand.y > 10/2.5 && rightHand.y < 57/2.5
                if (leftHand.x > (10/2.5) && leftHand.x < (222/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                {
                        if (start == false) {
                                println("Over MenuBack");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                 println("Menu Back called");
                                menuBack();
                        }
                }//CHECK FOR EXERCISE ONE BUTTON
                //(leftHand.x > 10/2.5 && leftHand.x < 232/2.5 && leftHand.y > 70/2.5 && leftHand.y < 288/2.5) || (
                //rightHand.x > 10/2.5 && rightHand.x < 232/2.5 && rightHand.y > 70/2.5 && rightHand.y < 288/2.5
                else if (leftHand.x > (10/2.5) && leftHand.x < (232/2.5) && leftHand.y > (120/2.5) && leftHand.y < (338/2.5))
                {
                        if (start == false) {
                                println("Over Exercise One");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                println("Exercise One called");
                                makeExerciseOne();
                        }
                }//CHECK FOR EXCERCISE TWO BUTTON
                //(leftHand.x > 242/2.5 && leftHand.x < 464/2.5 && leftHand.y > 70/2.5 && leftHand.y < 288/2.5) || (
                //rightHand.x > 242/2.5 && rightHand.x < 464/2.5 && rightHand.y > 70/2.5 && rightHand.y < 288/2.5
                else if(leftHand.x > (242/2.5) && leftHand.x < (464/2.5) && leftHand.y > (120/2.5) && leftHand.y < (338/2.5))
                 {
                        if(start == false){
                                println("Over Exercise Two");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }if(checkTimer() == 1){
                                println("Exercise Two called");
                                makeExerciseOne();
                        }
                 }//CHECK FOR EXERCISE THREE BUTTON
                 //(leftHand.x > 482/2.5 && leftHand.x < 504/2.5 && leftHand.y > 70/2.5 && leftHand.y < 288/2.5) || (
                 //rightHand.x > 482/2.5 && rightHand.x < 504/2.5 && rightHand.y > 70/2.5 && rightHand.y < 288/2.5
                 else if(leftHand.x > (482/2.5) && leftHand.x < (504/2.5) && leftHand.y > (120/2.5) && leftHand.y < (338/2.5))
                 {
                        if(start == false){
                                println("Over Exercise Three");
                                start = true;
                                timer = millis();
                                loaderOn();
                         }if(checkTimer() == 1){
                                println("Exercise Three called");
                                makeExerciseOne();
                        }
                 }//CHECK FOR LOGOUT BUTTON
                 //(leftHand.x > 1054/2.5 && leftHand.x < 1090/2.5 && leftHand.y > 10/2.5 && leftHand.y < 57/2.5) || (
                 //rightHand.x > 1054/2.5 && rightHand.x < 1090/2.5 && rightHand.y > 10/2.5 && rightHand.y < 57/2.5
                 else if(leftHand.x > (978/2.5) && leftHand.x < (1190/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                 {
                        if(start == false){
                                println("Over Logout");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }if(checkTimer() == 1){
                                println("Logout called");
                                makeLogout();
                        }
                 }else {
                        start = false;
                        loaderOff();
                        println("Over Nothing");
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

        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                cp5.getGroup("programmesGroup").remove();
        }
}

