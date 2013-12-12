class CommentsScreen {

        private RedPanda context;

        private PImage[] menuBack = new PImage[3];
        private PImage[] logout = new PImage[3];
        private Button []buttons;
        private Group commentsGroup;
        boolean start = false;
        int timer;

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


        void checkBtn(PVector convertedLeftJoint, PVector convertedRightJoint ) {

                PVector leftHand = convertedLeftJoint;
                PVector rightHand = convertedRightJoint;

                if (leftHand.x > 10/2.5 && leftHand.x < 106/2.5 && leftHand.y/2.5 > 10/2.5 && leftHand.y < 57/2.5)
                {
                        if (start == false) {
                                println("Over Menu Back");
                                start = true;
                                timer = millis();
                        }
                        if (checkTimer() == 1) {
                                 println("Menu Back Called");
                                menuBackComments();
                        }
                }else if(leftHand.x > 1054/2.5 && leftHand.x < 1090/2.5 && leftHand.y > 10/2.5 && leftHand.y < 57/2.5)
                 {
                 if(start == false){
                 println("Over Log out");
                 start = true;
                 timer = millis();
                 }if(checkTimer() == 1){
                         println("Logout called");
                 makeLogout();
                 }
                 }else {
                        start = false;
                        println("Over Nothing");
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

