class LoginScreen {

        private RedPanda context;
        // Array to strore login buttons images
        private PImage[] login_images = new PImage[3];
        private PImage loginBackgroundImage;
        private PImage logoImage;
        private Textfield[] textfields;
        private Button[] buttons;
        private Group loginGroup;

        // constructor takes reference to the main class, sets it to context. Use
        // "context" instead of "this" when drawing
        public LoginScreen(RedPanda c) {
                this.context = c;
        }

        public void loadImages() {
                // load images for login button
                this.login_images[0] = loadImage("images/login_button_a.png");
                this.login_images[1] = loadImage("images/login_button_b.png");
                this.login_images[2] = loadImage("images/login_button_a.png");

                // load background image & logo
                this.loginBackgroundImage = loadImage("images/background.png");
                this.logoImage = loadImage("images/logo.png");
        }

        public void create() {

                cp5.setAutoDraw(false);

                // draw background image
                image(loginBackgroundImage, 0, 0, 1200, 600);

                // insert version number top left of screen
                textSize(14);
                fill(color(211, 217, 203));
                text("version 1.01", 45 + 1, 10 + 1);
                fill(255);
                text("version 1.01", 45, 10);
                
                image(logoImage, 506, 185, 180, 101);

                // set and draw title text with drop shadow
                String title = "Red Panda";
                String subTitle = "Physio";
                textSize(32);
                fill(color(211, 217, 203));
                //text(title, (width / 2) + 2, 238 + 2);
                fill(255);
                //text(title, width / 2, 238);
                // draw subtitle text with drop shadow
                textSize(24);
                fill(color(211, 217, 203));
                //text(subTitle, (width / 2) + 2, 268 + 2);
                fill(255);
                //text(subTitle, width / 2, 268);

                PFont font = createFont("courier", 24);
                loginGroup = cp5.addGroup("loginGroup")
                        .setPosition(0, 0)
                               .hideBar()
                                ;

                textfields = new Textfield[2];
                buttons = new Button[1];

                textfields[0] = cp5.addTextfield("userName")
                        .setLabelVisible(true)
                        .setCaptionLabel("USERNAME")
                                .setColorCaptionLabel(color(51, 196, 242))
                                        .setColor(color(255, 255, 255))
                                                .setColorActive(color(51, 196, 242))
                                                        .setColorBackground(color(51, 196, 242))
                                                                .setColorForeground(color(211, 217, 203))
                                                                        // .setImage(userNameImage)
                                                                        .setPosition(width / 2 - 109, 294).setSize(218, 48)
                                                                                .setFont(font)
                                                                                        // .setFocus(selectedTextField[0])
                                                                                        // .keepFocus(selectedTextField[0])
                                                                                        .setText("patient")
                                                                                        //.setAutoClear(false)
                                                                                                .setGroup(loginGroup).setId(1);

                textfields[1] = cp5.addTextfield("password")
                        .setLabelVisible(true)
                                .setCaptionLabel("PASSWORD")
                                        .setColorCaptionLabel(color(51, 196, 242))
                                                .setColor(color(255, 255, 255))
                                                        .setColorActive(color(51, 196, 242))
                                                                .setColorBackground(color(51, 196, 242))
                                                                        .setColorForeground(color(211, 217, 203))
                                                                                // .setImages(passwordImage, passwordImage, passwordImage)
                                                                                .setPosition(width / 2 - 109, 359)
                                                                                        .setSize(218, 48)
                                                                                                .setFont(font)
                                                                                                                // .setPasswordMode(true)
                                                                                                                // .setFocus(selectedTextField[1])
                                                                                                                // .keepFocus(selectedTextField[1])
                                                                                                                .setText("patient")
                                                                                                                .setGroup(loginGroup)
                                                                                                                        .setId(2);

                buttons[0] = cp5.addButton("log in").setColorBackground(color(8, 187, 209))
                        .setPosition(width / 2 - 110, 424).setImages(login_images)
                                .updateSize().setGroup(loginGroup).setId(3);
        }

        void drawUI() {
                cp5.draw();
        }

        public void displayError(String s) {
                fill(51, 196, 242);
                textSize(20);
                text(s, width / 2 - 109, 475, 218, 48);  // Text wraps within text box
        }

        public void drawFade() {
                //draws white box with alpha over error message area
                noStroke();
                fill(255, 3);
                rect( width / 2 - 109, 475, 218, 48);
        }

        void destroy() {
                for ( int i = 0 ; i < textfields.length; i++ ) {
                        textfields[i].remove();
                        textfields[i] = null;
                }
                for ( int i = 0 ; i < buttons.length ; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                cp5.getGroup("loginGroup").remove();
        }
}

