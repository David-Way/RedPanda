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
                        .setPosition(690, 40)
                                .setSize(260, 400)
                                        .setBackgroundColor(color(51, 196, 242))
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
                    .setText("Name : " + user.getLast_name() + ", " + user.getFirst_name())
                    .setPosition(10,10)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[1] = cp5.addTextlabel("age")
                    .setText("DOB : " + user.getDob())
                    .setPosition(10,30)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[2] = cp5.addTextlabel("gender")
                    .setText("Gender : " + user.getSex() )
                    .setPosition(10,50)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[3] = cp5.addTextlabel("height")
                    .setText("Height : " + user.getHeight() + "cm")
                    .setPosition(10,70)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[4] = cp5.addTextlabel("weight")
                    .setText("Weight : " + user.getWeight() + "kg")
                    .setPosition(10,90)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[5] = cp5.addTextlabel("injury")
                    .setText("Injury type : " + user.getInjury_type())
                    .setPosition(10,110)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[6] = cp5.addTextlabel("programmeDesc")
                    .setText("Programme : Shoulder Stretching")
                    .setPosition(10,130)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;
        }

        void checkBtn(PVector convertedLeftJoint, PVector convertedRightJoint ) {

                PVector leftHand = convertedLeftJoint;
                PVector rightHand = convertedRightJoint;

                if (leftHand.x > (910/2.5) && leftHand.x < (970/2.5) && leftHand.y > (20/2.5) && leftHand.y < (80/2.5))
                {
                        if (start == false) {
                                println("Close Profile Called");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                makeProfileClose();
                        }
                }else {
                        start = false;
                        loaderOff();
                        println("Over Nothing");
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
                cp5.draw();
        }

        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                cp5.getGroup("profileGroup").remove();

        }
}

