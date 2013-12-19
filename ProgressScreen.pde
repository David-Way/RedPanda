class ProgressScreen {

        private RedPanda context;

        private PImage[] menuBack = new PImage[3];
        private PImage[] logout = new PImage[3];
        private Button []buttons;
        private Group progressGroup;
        boolean start = false;
        int timer;

        public ProgressScreen(RedPanda c) {
                this.context = c;
        }

        void loadImages() {
                //load images  for login button
                this.menuBack[0]  = loadImage("images/menu.jpg");
                this.menuBack[1]  = loadImage("images/menuOver.jpg");
                this.menuBack[2]  = loadImage("images/menu.jpg");
                this.logout[0] = loadImage("images/logout.jpg");
                this.logout[1] =loadImage("images/logoutOver.jpg");
                this.logout[2] =loadImage("images/logout.jpg");
        }

        public void create() {
                start = false;
                cp5.setAutoDraw(false);

                progressGroup = cp5.addGroup("progressGroup")
                        .setPosition(0, 0)
                                ;

                buttons = new Button[2];

                buttons[0] = cp5.addButton("menuBackProgress")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(progressGroup)
                                                        ;

                buttons[1] = cp5.addButton("logoutProgress")
                        .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(progressGroup)
                                                        ;
        }

        void checkBtn(PVector convertedLeftJoint, PVector convertedRightJoint ) {

                PVector leftHand = convertedLeftJoint;
                PVector rightHand = convertedRightJoint;

                if (leftHand.x > (10/2.5) && leftHand.x < (222/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                {
                        if (start == false) {
                                println("Over Menu Back");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                println("Menu Back called");
                                menuBack();
                        }
                }else if(leftHand.x > (978/2.5) && leftHand.x < (1190/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                 {
                        if(start == false){
                                println("Over Log out");
                                start = true;
                                timer = millis();
                        }if(checkTimer() == 1){
                                println("logout called");
                                makeLogout();
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
                cp5.getGroup("progressGroup").remove();
                //progressGroup.remove();
        }
}

