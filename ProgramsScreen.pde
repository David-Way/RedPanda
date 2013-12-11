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
                this.menuBack[0]  = loadImage("images/menu.png");
                this.menuBack[1]  = loadImage("images/menuover.png");
                this.menuBack[2]  = loadImage("images/menuover.png");
                this.exerciseOne[0]  = loadImage("images/exercise1.png");
                this.exerciseOne[1]  =loadImage("images/exercise1over.png");
                this.exerciseOne[2]  =loadImage("images/exercise1over.png");
                this.exerciseTwo[0] = loadImage("images/exercise2.png");
                this.exerciseTwo[1] =loadImage("images/exercise2over.png");
                this.exerciseTwo[2] =loadImage("images/exercise2over.png");
                this.exerciseThree[0] = loadImage("images/exercise3.png");
                this.exerciseThree[1] = loadImage("images/exercise3over.png");
                this.exerciseThree[2] = loadImage("images/exercise3over.png");
                this.logout[0] = loadImage("images/logout.png");
                this.logout[1] =loadImage("images/logoutover.png");
                this.logout[2] =loadImage("images/logoutover.png");
        }

        public void create() {

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
                        .setPosition(10, 70)
                                .setImages(exerciseOne)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;

                buttons[2] = cp5.addButton("exerciseTwo")
                        .setPosition(242, 70)
                                .setImages(exerciseTwo)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;


                buttons[3] = cp5.addButton("exerciseThree")
                        .setPosition(482, 70)
                                .setImages(exerciseThree)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;



                buttons[4] = cp5.addButton("logout")
                        .setPosition(1054, 10)
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
                //(leftHand.x > 10 && leftHand.x < 106 && leftHand.y > 10 && leftHand.y < 57) || (
                if (rightHand.x > 10 && rightHand.x < 106 && rightHand.y > 10 && rightHand.y < 57)
                {
                        if (start == false) {
                                println("true");
                                start = true;
                                timer = millis();
                        }
                        if (checkTimer() == 1) {
                                menuBackPrograms();
                        }
                }//CHECK FOR EXERCISE ONE BUTTON
                //(leftHand.x > 10 && leftHand.x < 232 && leftHand.y > 70 && leftHand.y < 288) || (
                else if (rightHand.x > 10 && rightHand.x < 232 && rightHand.y > 70 && rightHand.y < 288)
                {
                        if (start == false) {
                                println("true");
                                start = true;
                                timer = millis();
                        }
                        if (checkTimer() == 1) {
                                makeExerciseOne();
                        }
                }//CHECK FOR EXCERCISE TWO BUTTON
                //(leftHand.x > 242 && leftHand.x < 464 && leftHand.y > 70 && leftHand.y < 288) || (
                /*else if(rightHand.x > 242 && rightHand.x < 464 && rightHand.y > 70 && rightHand.y < 288)
                 {
                 if(start == false){
                 println("true");
                 start = true;
                 timer = millis();
                 }if(checkTimer() == 1){
                 makeExerciseOne();
                 }
                 }//CHECK FOR EXERCISE THREE BUTTON
                 //(leftHand.x > 482 && leftHand.x < 504 && leftHand.y > 70 && leftHand.y < 288) || (
                 else if(rightHand.x > 482 && rightHand.x < 504 && rightHand.y > 70 && rightHand.y < 288)
                 {
                 if(start == false){
                 println("true");
                 start = true;
                 timer = millis();
                 }if(checkTimer() == 1){
                 makeExerciseOne();
                 }
                 }//CHECK FOR LOGOUT BUTTON
                 //(leftHand.x > 1054 && leftHand.x < 1090 && leftHand.y > 10 && leftHand.y < 57) || (
                 else if(rightHand.x > 1054 && rightHand.x < 1090 && rightHand.y > 10 && rightHand.y < 57)
                 {
                 if(start == false){
                 println("true");
                 start = true;
                 timer = millis();
                 }if(checkTimer() == 1){
                 makeLogout();
                 }
                 }*/                else {
                        start = false;
                        println("false");
                }
        }


        public int checkTimer() {
                println("timer called");
                int totalTime = 5000;
                int checkInt = 0;
                if (start) {
                        int passedTime = millis() - timer;
                        if (passedTime > totalTime) {
                                println("Buttons timed");
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

