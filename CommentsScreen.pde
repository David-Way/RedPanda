class CommentsScreen {

        private RedPanda context;

        private PImage[] menuBack = new PImage[3];
        private PImage[] logout = new PImage[3];
        private Button []buttons;
        private Group commentsGroup;

        public CommentsScreen(RedPanda c) {
                this.context = c;
        }

        void loadImages() {
                //load images  for login button
                this.menuBack[0]  = loadImage("images/menu.png");
                this.menuBack[1]  = loadImage("images/menuover.png");
                this.menuBack[2]  = loadImage("images/menuover.png");
                this.logout[0] = loadImage("images/logout.png");
                this.logout[1] =loadImage("images/logoutover.png");
                this.logout[2] =loadImage("images/logoutover.png");
        }

        public void create() {

                cp5.setAutoDraw(false);

                commentsGroup = cp5.addGroup("commentsGroup")
                        .setPosition(0, 0)
                                ;

                buttons = new Button[2];

                buttons[0] = cp5.addButton("menuBackComments")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(commentsGroup)
                                                        ;

                buttons[1] = cp5.addButton("logoutComments")
                        .setPosition(1054, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(commentsGroup)
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
                cp5.getGroup("commentsGroup").remove();
                //commentsGroup.remove();
        }
}

