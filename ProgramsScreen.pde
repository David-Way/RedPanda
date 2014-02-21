//this class is used for displaying the users exercise programme
class ProgramsScreen {
        
        //declare a variable to store a reference to the class that called it
        private RedPanda context;
        //create image arrays to store the button images
        private PImage[] menuBack = new PImage[3];
        private PImage[] exerciseOne = new PImage[3];
        private PImage[] exerciseTwo = new PImage[3];
        private PImage[] exerciseThree = new PImage[3];
        private PImage[] logout = new PImage[3];
        //create array to store the buttons
        private Button []buttons;
        //create a Gp5 group for this screen
        private Group programmesGroup;
        boolean start = false;
        int timer;
        //declare variables for the demo gifs
        Gif exercise_one_tut;
        Gif exercise_two_tut;
        Gif exercise_three_tut;
        
        //constructor set the context to the class that called it
        public ProgramsScreen(RedPanda c) {
                this.context = c;
        }

        //this function loads the assets used by the class
        void loadImages() {
                //load images  for button buttons
                this.menuBack[0]  = loadImage("images/NewUI/menu.jpg"); //normal state
                this.menuBack[1]  = loadImage("images/NewUI/menuOver.jpg"); //mouse over
                this.menuBack[2]  = this.menuBack[0]; //mouse click
                this.exerciseOne[0] = loadImage("images/NewUI/exercise1.jpg"); //normal state
                this.exerciseOne[1] = loadImage("images/NewUI/exercise1Over.jpg"); //mouse over
                this.exerciseOne[2] = this.exerciseOne[0]; //mouse click
                this.exerciseTwo[0] = loadImage("images/NewUI/exercise2.jpg"); //normal state
                this.exerciseTwo[1] = loadImage("images/NewUI/exercise2Over.jpg"); //mouse over
                this.exerciseTwo[2] = this.exerciseTwo[0]; //mouse click
                this.exerciseThree[0] = loadImage("images/NewUI/exercise3.jpg"); //normal state
                this.exerciseThree[1] = loadImage("images/NewUI/exercise3Over.jpg"); //mouse over
                this.exerciseThree[2] = this.exerciseThree[0]; //mouse click
                this.logout[0] = loadImage("images/NewUI/logout.jpg"); //normal state
                this.logout[1] = loadImage("images/NewUI/logoutOver.jpg"); //mouse over
                this.logout[2] = this.logout[0]; //mouse click
                //load the demo gifs
                this.exercise_one_tut = new Gif(context,"images/ex1_sml.gif");
                this.exercise_two_tut = new Gif(context,"images/ex2_sml.gif");
                this.exercise_three_tut = new Gif(context,"images/ex3_sml.gif");
        }

        //create the programmes screen UI
        public void create() {
                start = false;
                cp5.setAutoDraw(false);
                exercise_one_tut.play(); //play the demo gifs
                exercise_two_tut.play();
                exercise_three_tut.play();
        
                //create a group for this screen
                programmesGroup = cp5.addGroup("programmesGroup")
                        .setPosition(0, 0)
                                .hideBar()
                                ;
                
                //create an array for the buttons
                buttons = new Button[5];

                //create a menu back button, set its image, group and posistion
                buttons[0] = cp5.addButton("menuBackProgrammes")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;
                                                        
                //create an exercise button, set its image, group and posistion
                buttons[1] = cp5.addButton("exerciseOne")
                        .setPosition(10, 100)
                                .setImages(exerciseOne)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;

                //create an exercise two button, set its image, group and posistion
                buttons[2] = cp5.addButton("exerciseTwo")
                        .setPosition(262, 100)
                                .setImages(exerciseTwo)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;

                //create an exercise three button, set its image, group and posistion
                buttons[3] = cp5.addButton("exerciseThree")
                        .setPosition(502, 100)
                                .setImages(exerciseThree)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;
                                                        
                //create a logout button, set its image, group and posistion
                buttons[4] = cp5.addButton("logoutPrograms")
                        .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(programmesGroup)
                                                        ;
        }
        
        //this function draws the cp5 object UI elements as well as the demo exercise gifs
        void drawUI() {
                cp5.draw();
                image(exercise_one_tut, 10, 325); //draw the gif at the given position
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
        
        
        //this function is called to remove the buttons, group UI elements and to stop the demo gifs
        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) { //loop through all the button and 
                        buttons[i].remove(); //remove them
                        buttons[i] = null;
                }
                exercise_one_tut.stop(); //stop the demo gifs
                exercise_two_tut.stop();
                exercise_three_tut.stop();
                cp5.getGroup("programmesGroup").remove(); //remove the UI group from the cp5 object for this screen
        }
}

