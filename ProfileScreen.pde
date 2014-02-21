class ProfileScreen {

        private RedPanda context;

        private PImage[] close = new PImage[3];
        private PImage backgroundImage;
        private Group profileGroup;
        private Button []buttons;
        private Textlabel [] textlabels;
        boolean start = false;
        int timer;

        public ProfileScreen(RedPanda c) {
                this.context = c;
        }

        void loadImages() {

                //load images  for close button
                this.close[0]  = loadImage("images/close.png");
                this.close[1]  =loadImage("images/closeover.png");
                this.close[2]  =loadImage("images/close.png");
                this.backgroundImage = loadImage("images/profilebg.png");
        }

        public void create() {
                start = false;
                cp5.setAutoDraw(false);


                profileGroup = cp5.addGroup("profileGroup")
                        .setPosition(700, 65)
                                .setSize(260, 400)
                                        .setBackgroundColor(color(62, 151, 139))
                                             .hideBar()
                                                ;

                buttons = new Button[1];
                textlabels = new Textlabel[7];

                buttons[0] = cp5.addButton("profileClose")
                        .setPosition(220, -20)
                                .setImages(close)
                                        .updateSize()
                                                .setGroup(profileGroup)
                                                        ;

                textlabels[0] = cp5.addTextlabel("name")
                    .setText("Name : \n" + user.getLast_name() + ", " + user.getFirst_name())
                    .setPosition(10,10)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[1] = cp5.addTextlabel("age")
                    .setText("\nDOB : \n" + user.getDob())
                    .setPosition(10,35)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[2] = cp5.addTextlabel("gender")
                    .setText("\nGender : \n" + user.getSex() )
                    .setPosition(10,80)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[3] = cp5.addTextlabel("height")
                    .setText("\nHeight : \n" + user.getHeight() + "cm")
                    .setPosition(10,125)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[4] = cp5.addTextlabel("weight")
                    .setText("\nWeight : \n" + user.getWeight() + "kg")
                    .setPosition(10,175)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[5] = cp5.addTextlabel("injury")
                    .setText("\nInjury type : \n" + user.getInjury_type())
                    .setPosition(10,225)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[6] = cp5.addTextlabel("programmeDesc")
                    .setText("\nProgramme \n: Shoulder Stretching")
                    .setPosition(10,280)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;
        }

        //CheckBtn called from main file, sending in the converted 3d perspective 
        //positioning of the left and right hand into a flat plane
        void checkBtn(PVector convertedLeftJoint, PVector convertedRightJoint ) {
                //set PVectors to vectors sent in
                PVector leftHand = convertedLeftJoint;
                PVector rightHand = convertedRightJoint;

                //If left hand x position is within the boundaries of the close profile button
                //Start is set to false initially, once left hand x is within these boundaries start will be set to true
                //the timer will be set and loaderOn() is called, which changes the hand image to a loader gif
               
                if (leftHand.x > (910/2.5) && leftHand.x < (970/2.5) && leftHand.y > (20/2.5) && leftHand.y < (80/2.5))
                {       
                        if (start == false) {
                                println("Close Profile Called");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer()) {
                                makeProfileClose();
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
        public int checkTimer() {
                int totalTime = 5000;
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

        void drawUI() {
                pushStyle();
                //textMode(SCREEN);
                cp5.draw();
                popStyle();
        }

        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                for ( int i = 0 ; i < textlabels.length ; i++ ) {
                        textlabels[i].remove();
                        textlabels[i] = null;
                }
                cp5.getGroup("profileGroup").remove();

        }
}

