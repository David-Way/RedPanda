//this class is used for displaying the main menu screen
class MenuScreen {

        //declare a variable to store a reference to the class that called it
        private RedPanda context;
        //create image arrays to store the button images
        private PImage[] programme = new PImage[3];
        private PImage[] profile = new PImage[3];
        private PImage[] progress = new PImage[3];
        private PImage[] comments = new PImage[3];
        private PImage[] logout = new PImage[3];
        //create arrays to store the buttons and textlabels
        private Button []buttons;
        private Textlabel [] textlabels;
        //String for welcome message
        String welcomeMessage;
        //cp5 group
        private Group menuGroup;
        //Start boolean for handtracking
        //Timer for hand tracking
        boolean start = false;
        int timer;

        //constructor set the context to the class that called it
        public MenuScreen(RedPanda c) {
                this.context = c;
        }

        //this function loads the assets used by the class
        void loadImages() {

                //load images for buttons
                this.programme[0]  = loadImage("images/NewUI/programme.jpg");
                this.programme[1]  =loadImage("images/NewUI/programmeOver.jpg");
                this.programme[2]  =this.programme[0];
                this.profile[0] = loadImage("images/NewUI/profile.jpg");
                this.profile[1] =loadImage("images/NewUI/profileOver.jpg");
                this.profile[2] = this.profile[0];
                this.progress[0] = loadImage("images/NewUI/progress.jpg");
                this.progress[1] = loadImage("images/NewUI/progressOver.jpg");
                this.progress[2] = this.progress[0];
                this.comments[0] = loadImage("images/NewUI/comments.jpg");
                this.comments[1] =loadImage("images/NewUI/commentsOver.jpg");
                this.comments[2] =this.comments[0];
                this.logout[0] = loadImage("images/NewUI/logout.jpg");
                this.logout[1] =loadImage("images/NewUI/logoutOver.jpg");
                this.logout[2] =this.logout[0];
        }

        //create the programmes screen UI and initialises variables
        public void create(User user, Record record) {
                //If there is a valid record object
                //Parse the date and create a welcome message
                if (record.getRecord_id() != -1) {
                String date = String.valueOf(record.getDateDone());
                //Date date = new Date();
                int Year=int(date.substring(0,4));
                int Month=int(date.substring(4,6));
                int Day=int(date.substring(6,8));
                welcomeMessage = ("Welcome " + user.getFirst_name() + ".\nYou last completed an exercise on : " + Year + " / " + Month + " / " + Day);
                }
                //If record object is not valid create a different welsome message
                else{
                    welcomeMessage = ("Welcome " + user.getFirst_name() + ". Lets get started");
                }
                //Set cp5 autodraw to false 
                //Set start to false for hand tracking to reset
                cp5.setAutoDraw(false);
                start = false;

                //Add cp5 group
                menuGroup = cp5.addGroup("menuGroup")
                        .setPosition(0, 0)
                                .hideBar()
                                ;

                //Initialise buttons array
                buttons = new Button[5];

                //Button for programme
                buttons[0] = cp5.addButton("programme")
                        .setPosition(10, 10)
                                .setImages(programme)
                                        .updateSize()
                                                .setGroup(menuGroup);

                //Button for profile
                buttons[1] = cp5.addButton("profile")
                        .setPosition(465, 10)
                                .setImages(profile)
                                        .updateSize()
                                                .setGroup(menuGroup) ;

                //Button for progress
                buttons[2] = cp5.addButton("progress")
                        .setPosition(10, 238)
                                .setImages(progress)
                                        .updateSize()
                                                .setGroup(menuGroup);

                //Button for comments
                buttons[3] = cp5.addButton("comments")
                        .setPosition(465, 238)
                                .setImages(comments)
                                        .updateSize()
                                                .setGroup(menuGroup);

                //Button for logout
                buttons[4] = cp5.addButton("logout")
                        .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(menuGroup);

                //Initialise textlabels array
                textlabels = new Textlabel[1];

                //Text label to hold start message
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

        //Function to draw UI
        void drawUI() {
                cp5.draw();
        }


        //CheckBtn called from main file, sending in the converted 3d perspective 
        //positioning of the left and right hand into a flat plane
        void checkBtn(PVector convertedLeftJoint, PVector convertedRightJoint ) {

                //set PVectors to vectors sent in
                PVector leftHand = convertedLeftJoint;
                PVector rightHand = convertedRightJoint;
                //If left hand x position is within the boundaries of the button
                //Start is set to false initially, once left hand x is within these boundaries start will be set to true
                //the timer will be set and loaderOn() is called, which changes the hand image to a loader gif
                if (leftHand.x > (10/2.5) && leftHand.x < (459/2.5) && leftHand.y > (10/2.5) && leftHand.y < (232/2.5))
                {
                        if (start == false) {
                                println("Over Programme");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer()) {
                                println("Program called");
                                makeProgramme();
                        }
                }//If left hand x position is within the boundaries of the button
                //Start is set to false initially, once left hand x is within these boundaries start will be set to true
                //the timer will be set and loaderOn() is called, which changes the hand image to a loader gif
                else if (leftHand.x > (465/2.5) && leftHand.x < (684/2.5) && leftHand.y > (10/2.5) && leftHand.y < (232/2.5))
                {
                        if (start == false) {
                                println("Over Profile");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer()) {
                                 println("Profile Called");
                                makeProfile();
                        }
                }//If left hand x position is within the boundaries of the button
                //Start is set to false initially, once left hand x is within these boundaries start will be set to true
                //the timer will be set and loaderOn() is called, which changes the hand image to a loader gif
                else if (leftHand.x > (10/2.5) && leftHand.x < (459/2) && leftHand.y > (238/2.5) && leftHand.y < (456/2.5))
                {
                        if (start == false) {
                                println("Over Progress");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer()) {
                                println("Progress called");
                                makeProgress();
                        }
                }//If left hand x position is within the boundaries of the button
                //Start is set to false initially, once left hand x is within these boundaries start will be set to true
                //the timer will be set and loaderOn() is called, which changes the hand image to a loader gif
                else if (leftHand.x > (465/2.5) && leftHand.x < (684/2.5) && leftHand.y > (238/2.5) && leftHand.y < (456/2.5))
                {
                        if (start == false) {
                                println("Over Comments");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer()) {
                                 println("Comemnts called");
                                makeComments();
                        }
                }//If left hand x position is within the boundaries of the button
                //Start is set to false initially, once left hand x is within these boundaries start will be set to true
                //the timer will be set and loaderOn() is called, which changes the hand image to a loader gif
                else if (leftHand.x > (978/2.5) && leftHand.x < (1190/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                {
                        if (start == false) {
                                println("Over Logout");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer()) {
                                 println("Logout Called");
                                makeLogout();
                        }
                }
                //If left hand position goes outside the boundaries of the button set start to false again
                //Turn off loading gif image, replace for hand image.
                else {
                        start = false;
                        loaderOff();
                }
        }

         //checkTimer will only return true if passed time is greater than the total time set.
        public boolean checkTimer() {
                int totalTime = 7000;
                boolean checkInt = false;
                if (start) {
                        int passedTime = millis() - timer;
                        if (passedTime > totalTime) {
                                checkInt = true;
                        }
                        else {
                                checkInt = false;
                        }
                }
                return checkInt;
        }

        //this function is called to remove the buttons and group UI elements
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

