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
        Gif exercise_one_tut;
        Gif exercise_two_tut;
        Gif exercise_three_tut;

        public ProgramsScreen(RedPanda c) {
                this.context = c;
        }

        void loadImages() {

                //load images  for login button
                this.menuBack[0]  = loadImage("images/NewUI/menu.jpg");
                this.menuBack[1]  = loadImage("images/NewUI/menuOver.jpg");
                this.menuBack[2]  = loadImage("images/NewUI/menu.jpg");
                this.exerciseOne[0]  = loadImage("images/NewUI/exercise1.jpg");
                this.exerciseOne[1]  =loadImage("images/NewUI/exercise1Over.jpg");
                this.exerciseOne[2]  =loadImage("images/NewUI/exercise1.jpg");
                this.exerciseTwo[0] = loadImage("images/NewUI/exercise2.jpg");
                this.exerciseTwo[1] =loadImage("images/NewUI/exercise2Over.jpg");
                this.exerciseTwo[2] =loadImage("images/NewUI/exercise2.jpg");
                this.exerciseThree[0] = loadImage("images/NewUI/exercise3.jpg");
                this.exerciseThree[1] = loadImage("images/NewUI/exercise3Over.jpg");
                this.exerciseThree[2] = loadImage("images/NewUI/exercise3.jpg");
                this.logout[0] = loadImage("images/NewUI/logout.jpg");
                this.logout[1] =loadImage("images/NewUI/logoutOver.jpg");
                this.logout[2] =loadImage("images/NewUI/logout.jpg");
                this.exercise_one_tut = new Gif(context,"images/ex1_sml.gif");
                this.exercise_two_tut = new Gif(context,"images/ex2_sml.gif");
                this.exercise_three_tut = new Gif(context,"images/ex3_sml.gif");
        }

        public void create() {
                start = false;
                cp5.setAutoDraw(false);
                exercise_one_tut.play();
                exercise_two_tut.play();
                exercise_three_tut.play();

                programmesGroup = cp5.addGroup("programmesGroup")
                        .setPosition(0, 0)
                                .hideBar()
                                ;

                buttons = new Button[5];

                buttons[0] = cp5.addButton("menuBackProgrammes")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;

                buttons[1] = cp5.addButton("exerciseOne")
                        .setPosition(10, 100)
                                .setImages(exerciseOne)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;


                buttons[2] = cp5.addButton("exerciseTwo")
                        .setPosition(262, 100)
                                .setImages(exerciseTwo)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;

                 
                                                    

                buttons[3] = cp5.addButton("exerciseThree")
                        .setPosition(502, 100)
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
                image(exercise_one_tut, 10, 325);
                image(exercise_two_tut, 262, 325);
                image(exercise_three_tut, 502, 325);    
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
                else if (leftHand.x > (10/2.5) && leftHand.x < (236/2.5) && leftHand.y > (100/2.5) && leftHand.y < (331/2.5))
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
                else if(leftHand.x > (262/2.5) && leftHand.x < (488/2.5) && leftHand.y > (100/2.5) && leftHand.y < (331/2.5))
                 {
                        if(start == false){
                                println("Over Exercise Two");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }if(checkTimer() == 1){
                                println("Exercise Two called");
                                makeExerciseTwo();
                        }
                 }//CHECK FOR EXERCISE THREE BUTTON
                 //(leftHand.x > 482/2.5 && leftHand.x < 504/2.5 && leftHand.y > 70/2.5 && leftHand.y < 288/2.5) || (
                 //rightHand.x > 482/2.5 && rightHand.x < 504/2.5 && rightHand.y > 70/2.5 && rightHand.y < 288/2.5
                 else if(leftHand.x > (502/2.5) && leftHand.x < (728/2.5) && leftHand.y > (100/2.5) && leftHand.y < (331/2.5))
                 {
                        if(start == false){
                                println("Over Exercise Three");
                                start = true;
                                timer = millis();
                                loaderOn();
                         }if(checkTimer() == 1){
                                println("Exercise Three called");
                                makeExerciseThree();
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

        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                exercise_one_tut.stop();
                exercise_two_tut.stop();
                exercise_three_tut.stop();
                cp5.getGroup("programmesGroup").remove();
        }
}

