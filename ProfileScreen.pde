class ProfileScreen {

        private RedPanda context;

        private PImage[] close = new PImage[3];
        private PImage backgroundImage;
        private Group profileGroup;
        private Button []buttons;
        private Textlabel [] textlabels;

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

                cp5.setAutoDraw(false);


                profileGroup = cp5.addGroup("profileGroup")
                        .setPosition(700, 30)
                                .setSize(260, 400)
                                        .setBackgroundColor(color(51, 196, 242))
                                                ;

                buttons = new Button[1];
                textlabels = new Textlabel[7];

                buttons[0] = cp5.addButton("profileClose")
                        .setPosition(240, -10)
                                .setImages(close)
                                        .updateSize()
                                                .setGroup(profileGroup)
                                                        ;
                       textlabels[0] = cp5.addTextlabel("name")
                    .setText("Name : John Doe")
                    .setPosition(10,10)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[1] = cp5.addTextlabel("age")
                    .setText("Age : 30")
                    .setPosition(10,30)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[2] = cp5.addTextlabel("gender")
                    .setText("Gender : Male")
                    .setPosition(10,50)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[3] = cp5.addTextlabel("height")
                    .setText("Height : 188cm")
                    .setPosition(10,70)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[4] = cp5.addTextlabel("weight")
                    .setText("Weight : 88kg")
                    .setPosition(10,90)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                textlabels[5] = cp5.addTextlabel("injury")
                    .setText("Injury type : Shoulder strain")
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

        void drawUI() {
                cp5.draw();
        }

        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                cp5.getGroup("profileGroup").remove();
                //profileGroup.remove();
        }
}

