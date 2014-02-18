class MenuScreen {

        private RedPanda context;

        private PImage[] programme = new PImage[3];
        private PImage[] profile = new PImage[3];
        private PImage[] progress = new PImage[3];
        private PImage[] comments = new PImage[3];
        private PImage[] logout = new PImage[3];
        private Button []buttons;
        private Textlabel [] textlabels;
        String welcomeMessage;

        private Group menuGroup;
        boolean start = false;
        int timer;



        public MenuScreen(RedPanda c) {
                this.context = c;
        }

        void loadImages() {

                //load images  for login button
                this.programme[0]  = loadImage("images/programme.jpg");
                this.programme[1]  =loadImage("images/programmeOver.jpg");
                this.programme[2]  =loadImage("images/programme.jpg");
                this.profile[0] = loadImage("images/profile.jpg");
                this.profile[1] =loadImage("images/profileOver.jpg");
                this.profile[2] =loadImage("images/profile.jpg");
                this.progress[0] = loadImage("images/progress.jpg");
                this.progress[1] = loadImage("images/progressOver.jpg");
                this.progress[2] = loadImage("images/progress.jpg");
                this.comments[0] = loadImage("images/comments.jpg");
                this.comments[1] =loadImage("images/commentsOver.jpg");
                this.comments[2] =loadImage("images/comments.jpg");
                this.logout[0] = loadImage("images/logout.jpg");
                this.logout[1] =loadImage("images/logoutOver.jpg");
                this.logout[2] =loadImage("images/logout.jpg");
        }

        public void create(User user, Record record) {
                if (record.getRecord_id() != -1) {
                String date = String.valueOf(record.getDateDone());
                //Date date = new Date();
                int Year=int(date.substring(0,4));
                int Month=int(date.substring(4,6));
                int Day=int(date.substring(6,8));
                welcomeMessage = ("Welcome " + user.getUser_name() + ".\nYou last completed an exercise on : " + Year + " / " + Month + " / " + Day);
                }else{
                    welcomeMessage = ("Welcome " + user.getUser_name() + ". Lets get started");
                }
                cp5.setAutoDraw(false);

                menuGroup = cp5.addGroup("menuGroup")
                        .setPosition(0, 0)
                                .hideBar()
                                ;

                buttons = new Button[5];


                buttons[0] = cp5.addButton("programme")
                        .setPosition(10, 10)
                                .setImages(programme)
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
                        .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(menuGroup);

                textlabels = new Textlabel[1];

                textlabels[0] = cp5.addTextlabel("message")
                    .setText(welcomeMessage)
                    .setPosition(10, 538)
                    .setWidth(465)
                    .setHeight(40)
                    .setColorValue(color(51, 196, 242))
                    .setFont(createFont("Arial",30))
                    .setGroup(menuGroup)
                    ;

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
                if (leftHand.x > (10/2.5) && leftHand.x < (459/2.5) && leftHand.y > (10/2.5) && leftHand.y < (232/2.5))
                {
                        if (start == false) {
                                println("Over Programme");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                println("Program called");
                                makeProgramme();
                        }
                }//CHECK FOR PROFILE BUTTON
                //(leftHand.x > 465 && leftHand.x < 684 && leftHand.y > 10 && leftHand.y < 232) || 
                //rightHand.x > 465/2 && rightHand.x < 684/2 && rightHand.y > 10/2 && rightHand.y < 232/2
                else if (leftHand.x > (465/2.5) && leftHand.x < (684/2.5) && leftHand.y > (10/2.5) && leftHand.y < (232/2.5))
                {
                        if (start == false) {
                                println("Over Profile");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                 println("Profile Called");
                                makeProfile();
                        }
                }//CHECK FOR PROGRESS BUTTON
                //(leftHand.x > 10 && leftHand.x < 459 && leftHand.y > 238 && leftHand.y < 456) || 
                //rightHand.x > 10/2 && rightHand.x < 459/2 && rightHand.y > 238/2 && rightHand.y < 456/2
                else if (leftHand.x > (10/2.5) && leftHand.x < (459/2) && leftHand.y > (238/2.5) && leftHand.y < (456/2.5))
                {
                        if (start == false) {
                                println("Over Progress");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                println("Progress called");
                                makeProgress();
                        }
                }//CHECK FOR COMMENTS BUTTON
                //(leftHand.x > 465 && leftHand.x < 684 && leftHand.y > 238 && leftHand.y < 456) || (
                //rightHand.x > 465/2 && rightHand.x < 684/2 && rightHand.y > 238/2 && rightHand.y < 456/2
                else if (leftHand.x > (465/2.5) && leftHand.x < (684/2.5) && leftHand.y > (238/2.5) && leftHand.y < (456/2.5))
                {
                        if (start == false) {
                                println("Over Comments");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                 println("Comemnts called");
                                makeComments();
                        }
                }//CHECK FOR LOGOUT BUTTON
                //(leftHand.x >1054 && leftHand.x < 1090 && leftHand.y > 10 && leftHand.y < 57) || (
                //rightHand.x > 1054/2 && rightHand.x < 1090/2 && rightHand.y > 10/2 && rightHand.y < 57/2
                else if (leftHand.x > (978/2.5) && leftHand.x < (1190/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                {
                        if (start == false) {
                                println("Over Logout");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                 println("Logout Called");
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
                for ( int i = 0 ; i < textlabels.length ; i++ ) {
                        textlabels[i].remove();
                        textlabels[i] = null;
                }
                cp5.getGroup("menuGroup").remove();
        }
}

