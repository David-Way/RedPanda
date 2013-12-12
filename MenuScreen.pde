class MenuScreen {

        private RedPanda context;

        private PImage[] program = new PImage[3];
        private PImage[] profile = new PImage[3];
        private PImage[] progress = new PImage[3];
        private PImage[] comments = new PImage[3];
        private PImage[] logout = new PImage[3];
        private Button []buttons;
        private Group menuGroup;
        boolean start = false;
        int timer;



        public MenuScreen(RedPanda c) {
                this.context = c;
        }

        void loadImages() {

                //load images  for login button
                this.program[0]  = loadImage("images/program.png");
                this.program[1]  =loadImage("images/programover.png");
                this.program[2]  =loadImage("images/program.png");
                this.profile[0] = loadImage("images/profile.png");
                this.profile[1] =loadImage("images/profileover.png");
                this.profile[2] =loadImage("images/profile.png");
                this.progress[0] = loadImage("images/progress.png");
                this.progress[1] = loadImage("images/progressover.png");
                this.progress[2] = loadImage("images/progress.png");
                this.comments[0] = loadImage("images/comments.png");
                this.comments[1] =loadImage("images/commentsover.png");
                this.comments[2] =loadImage("images/comments.png");
                this.logout[0] = loadImage("images/logout.png");
                this.logout[1] =loadImage("images/logoutover.png");
                this.logout[2] =loadImage("images/logout.png");
        }

        public void create() {

                cp5.setAutoDraw(false);

                menuGroup = cp5.addGroup("menuGroup")
                        .setPosition(0, 0)
                                ;

                buttons = new Button[5];


                buttons[0] = cp5.addButton("program")
                        .setPosition(10, 10)
                                .setImages(program)
                                        .updateSize()
                                                .setGroup(menuGroup);

                buttons[1] = cp5.addButton("profile")
                        .setPosition(465, 10)
                                .setImages(profile)
                                        .updateSize()
                                                .setGroup(menuGroup) ;


                buttons[2] = cp5.addButton("progress")
                        .setPosition(10, 238)
                                .setImages(progress)
                                        .updateSize()
                                                .setGroup(menuGroup);


                buttons[3] = cp5.addButton("comments")
                        .setPosition(465, 238)
                                .setImages(comments)
                                        .updateSize()
                                                .setGroup(menuGroup);


                buttons[4] = cp5.addButton("logout")
                        .setPosition(1054, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(menuGroup);
        }

        void drawUI() {
                cp5.draw();
        }


        void checkBtn(PVector convertedLeftJoint, PVector convertedRightJoint ) {

                PVector leftHand = convertedLeftJoint;
                PVector rightHand = convertedRightJoint;
                // CHECK FOR PROGRAM BUTTON
                //LEft hand check (leftHand.x > 10 && leftHand.x < 459 && leftHand.y > 10 && leftHand.y < 232) || 
                //rightHand.x > 10/2 && rightHand.x < 459/2 && rightHand.y > 10/2 && rightHand.y < 232/2
                if (leftHand.x > 10/2.5 && leftHand.x < 459/2.5 && leftHand.y > 10/2.5 && leftHand.y < 232/2.5)
                {
                        if (start == false) {
                                println("Over Program");
                                start = true;
                                timer = millis();
                        }
                        if (checkTimer() == 1) {
                                println("Program called");
                                makeProgram();
                        }
                }//CHECK FOR PROFILE BUTTON
                //(leftHand.x > 465 && leftHand.x < 684 && leftHand.y > 10 && leftHand.y < 232) || 
                //rightHand.x > 465/2 && rightHand.x < 684/2 && rightHand.y > 10/2 && rightHand.y < 232/2
                else if (leftHand.x > 465/2.5 && leftHand.x < 684/2.5 && leftHand.y > 10/2.5 && leftHand.y < 232/2.5)
                {
                        if (start == false) {
                                println("Over Profile");
                                start = true;
                                timer = millis();
                        }
                        if (checkTimer() == 1) {
                                 println("Profile Called");
                                makeProfile();
                        }
                }//CHECK FOR PROGRESS BUTTON
                //(leftHand.x > 10 && leftHand.x < 459 && leftHand.y > 238 && leftHand.y < 456) || 
                //rightHand.x > 10/2 && rightHand.x < 459/2 && rightHand.y > 238/2 && rightHand.y < 456/2
                else if (leftHand.x > 10/2.5 && leftHand.x < 459/2 && leftHand.y > 238/2.5 && leftHand.y < 456/2.5)
                {
                        if (start == false) {
                                println("Over Progress");
                                start = true;
                                timer = millis();
                        }
                        if (checkTimer() == 1) {
                                println("Progress called");
                                makeProgress();
                        }
                }//CHECK FOR COMMENTS BUTTON
                //(leftHand.x > 465 && leftHand.x < 684 && leftHand.y > 238 && leftHand.y < 456) || (
                //rightHand.x > 465/2 && rightHand.x < 684/2 && rightHand.y > 238/2 && rightHand.y < 456/2
                else if (leftHand.x > 465/2.5 && leftHand.x < 684/2.5 && leftHand.y > 238/2.5 && leftHand.y < 456/2.5)
                {
                        if (start == false) {
                                println("Over Comments");
                                start = true;
                                timer = millis();
                        }
                        if (checkTimer() == 1) {
                                 println("Comemnts called");
                                makeComments();
                        }
                }//CHECK FOR LOGOUT BUTTON
                //(leftHand.x >1054 && leftHand.x < 1090 && leftHand.y > 10 && leftHand.y < 57) || (
                //rightHand.x > 1054/2 && rightHand.x < 1090/2 && rightHand.y > 10/2 && rightHand.y < 57/2
                else if (leftHand.x >1054/2.5 && leftHand.x < 1090/2.5 && leftHand.y > 10/2.5 && leftHand.y < 57/2.5)
                {
                        if (start == false) {
                                println("Over Logout");
                                start = true;
                                timer = millis();
                        }
                        if (checkTimer() == 1) {
                                 println("Logout Called");
                                makeLogout();
                        }
                }
                else {
                        start = false;
                        println("Over Nothing");
                }
        }


        public int checkTimer() {
                int totalTime = 7000;
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
                for ( int i = 0 ; i < buttons.length; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                cp5.getGroup("menuGroup").remove();
        }
}

