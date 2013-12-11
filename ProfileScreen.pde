class ProfileScreen {

        private RedPanda context;

        private PImage[] close = new PImage[3];
        private PImage backgroundImage;
        private Group profileGroup;
        private Button []buttons;

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

                buttons[0] = cp5.addButton("profileClose")
                        .setPosition(240, -10)
                                .setImages(close)
                                        .updateSize()
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

