//this class is used for displaying the users profile
class ProfileScreen {

        //declare a variable to store a reference to the class that called it
        private RedPanda context;
        //create image arrays to store the button images
        private PImage[] close = new PImage[3];
        //create a Gp5 group for this screen
        private Group profileGroup;
        //create array to store the buttons
        private Button []buttons;
        //create array to store the textlabels
        private Textlabel [] textlabels;
        //Boolean start for timer
        //Timer int for timer seconds count
        boolean start = false;
        int timer;

        //constructor set the context to the class that called it
        public ProfileScreen(RedPanda c) {
                this.context = c;
        }

        //this function loads the assets used by the class
        void loadImages() {

               //load images for UI
                this.close[0]  = loadImage("images/close.png");
                this.close[1]  =loadImage("images/closeover.png");
                this.close[2]  = this.close[0];
        }

        //create the programmes screen UI
        public void create() {
                start = false;
                cp5.setAutoDraw(false);


                //create a group for this screen
                profileGroup = cp5.addGroup("profileGroup")
                        .setPosition(700, 65)
                                .setSize(260, 400)
                                        .setBackgroundColor(color(62, 151, 139))
                                             .hideBar()
                                                ;

                //initialise the button array
                //initialist the textlabels array                           
                buttons = new Button[1];
                textlabels = new Textlabel[7];

                //create a profile close button, set its image, group and posistion
                buttons[0] = cp5.addButton("profileClose")
                        .setPosition(220, -20)
                                .setImages(close)
                                        .updateSize()
                                                .setGroup(profileGroup)
                                                        ;


                //create an name textlabel, set its image, group and posistion
                textlabels[0] = cp5.addTextlabel("name")
                    .setText("Name : \n" + user.getLast_name() + ", " + user.getFirst_name())
                    .setPosition(10,10)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                //create an age textlabel, set its image, group and posistion
                textlabels[1] = cp5.addTextlabel("age")
                    .setText("\nDOB : \n" + user.getDob())
                    .setPosition(10,35)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                //create a gender textlabel, set its image, group and posistion
                textlabels[2] = cp5.addTextlabel("gender")
                    .setText("\nGender : \n" + user.getSex() )
                    .setPosition(10,80)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                //create an height textlabel, set its image, group and posistion
                textlabels[3] = cp5.addTextlabel("height")
                    .setText("\nHeight : \n" + user.getHeight() + "cm")
                    .setPosition(10,125)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                //create an weight textlabel, set its image, group and posistion
                textlabels[4] = cp5.addTextlabel("weight")
                    .setText("\nWeight : \n" + user.getWeight() + "kg")
                    .setPosition(10,175)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                //create an injury textlabel, set its image, group and posistion
                textlabels[5] = cp5.addTextlabel("injury")
                    .setText("\nInjury type : \n" + user.getInjury_type())
                    .setPosition(10,225)
                    .setColorValue(0xffffffff)
                    .setFont(createFont("Arial",18))
                    .setGroup(profileGroup)
                    ;

                //create a program textlabel, set its image, group and posistion
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
        public boolean checkTimer() {
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

        //this function draws the cp5 object UI elements as well as the demo exercise gifs
        void drawUI() {
                cp5.draw();
        }

        //this function is called to remove the buttons, group UI elements and to stop the demo gifs
        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) {//loop through all the button and
                        buttons[i].remove(); //remove them
                        buttons[i] = null;
                }
                for ( int i = 0 ; i < textlabels.length ; i++ ) { //loop through all the button and
                        textlabels[i].remove(); //remove them
                        textlabels[i] = null;
                }
                cp5.getGroup("profileGroup").remove(); //remove the UI group from the cp5 object for this screen

        }
}

