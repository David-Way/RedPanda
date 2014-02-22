//this class is used for displaying and recording an exercising using xml data
//the program can load the prescibed movement comprised of the pre recorded joint 
//position data of 3 selected joints
class XMLExerciseClassOptimised {
        
        //declare variables to store screen main objects
        RedPanda parent;
        SimpleOpenNI context;
        User user;
        Exercise e;
        //declare array to store the joints to be tracked 
        int [] jointID;
        int userID;
        //create structure for storing target positions for the exercise
        ArrayList<ArrayList<PVector>> framesGroup = new ArrayList<ArrayList<PVector>>(3);
        ArrayList<PVector> framesOne;
        ArrayList<PVector> framesTwo;
        ArrayList<PVector> framesThree;

        //declare arrayst to store the button images
        private PImage[] menuBack = new PImage[3];
        private PImage[] logout = new PImage[3];
        private PImage[] cancel = new PImage[3];
        private Button []buttons;
        private Group exerciseGroup2;

        long startTime = 0;
        //declare the message objects needed
        Message message;
        Message timerMessage;
        Message directionMessage;
        Message continueMessage;
        //default values for exercise
        String exerciseName;
        float c = (float)0.0;
        float offByDistance = (float)0.0;
        int currentFrame = 0;
        int numberOfFrames = 0;
        int numberOfReps = 5;
        int currentRep = 0;
        //boolean state flags
        boolean paused = false;
        boolean recording = false;
        boolean exerciseStarted = false;
        boolean exerciseComplete = false;
        Gif target;
        //default font values
        final int FONT_30 = 30;
        final int FONT_24 = 24;
        //set colours for user avatar
        color userColourRed = color(255, 0, 0);
        color userColourGreen = color(0, 255, 0);
        color userColourBlue = color(0, 0, 255);
        color userColourGrey = color(155, 155, 155);
        color userColourWhite = color(255, 255, 255);
        color currentUserColour = userColourWhite;
        //declare and initiliase variables used by the automatic programme advancement function
        boolean finishedTimerStarted = false;
        long finishStartTime = 0;

        PVector messagePosition = new PVector(10, 100);
        IntVector userList;

        //XMLExerciseClassOptimised constructor, takes a reference to the Redpanda class
        XMLExerciseClassOptimised(RedPanda parent) {
                this.parent = parent;
                this.jointID = new int[3]; //initialise array t hat holds the selected joints
        }

        //create function takes reference to the kinect, the user object, the three joints to be tracked and the exercise to execute
        void create(SimpleOpenNI tempContext, User user, int tempJointIDOne, int tempJointIDTwo, int tempJointIDThree, Exercise ex) {
                target = new Gif(parent, "images/target.gif"); //load the taget gif
                //initilise required variables 
                this.context = tempContext; 
                this.user = user;
                userList = new IntVector();
                this.jointID[0] = tempJointIDOne; //store the chosen joint parameters
                this.jointID[1] = tempJointIDTwo;
                this.jointID[2] = tempJointIDThree;
                //create arrays to store each joints point data for each frame
                this.framesOne = new ArrayList<PVector>(); 
                this.framesTwo = new ArrayList<PVector>();
                this.framesThree = new ArrayList<PVector>();
                //framesCenter = new ArrayList<PVector>();
                this.framesGroup.add(framesOne); //add these arrays to a group array
                this.framesGroup.add(framesTwo);
                this.framesGroup.add(framesThree);
                //set exercise info
                this.e = ex;
                this.exerciseName = e.getName();
                this.numberOfReps = e.getRepetitions();

                //create UI elements
                cp5.setAutoDraw(false);

                //create UI elements group for this scene
                exerciseGroup2 = cp5.addGroup("exerciseGroup2")
                        .setPosition(0, 0)
                                .hideBar()
                                        ;
                //create an array for the buttons to make them easier to remove
                buttons = new Button[3];

                //create a menu back button, set the size and image
                buttons[0] = cp5.addButton("menuBackExercises2")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(exerciseGroup2)
                                                        ;

                //create a logout button, set the size and image
                buttons[1] = cp5.addButton("logoutExercise2")
                        .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(exerciseGroup2)
                                                        ;

                //create a cancel button, set the size and image, set it invisible
                buttons[2] = cp5.addButton("cancelProgramme2")
                        .setPosition(494, 515)
                                .setImages(cancel)
                                        .updateSize()
                                                .setVisible(false)
                                                        .setGroup(exerciseGroup2)
                                                                ;

                //create message UI elements
                message = new Message(209, 400, messagePosition, "Hi " + user.getFirst_name() + ",\nWelcome to the " + e.getName()  +  " exercise " + "\n\nTarget Reps: " + e.getRepetitions() + "\n\nCurrent Reps: " + currentRep + "\n\nComplete: " + (int)Math.round(100.0 / numberOfReps * currentRep) + "%"  +"\n\nDescription:\n" + e.getDescription());
                message.create("mgroup", "lname");
                //startTime  = System.currentTimeMillis();

                //initiliase the needed UI message objects, set positions, content and size
                timerMessage = new Message(209, 50, new PVector(978, 100), "Time: 0s");
                timerMessage.create("a", "b");

                directionMessage = new Message(240, 100, new PVector(480, 400), "Get into positon in front of the camera.");
                directionMessage.create("c", "d");

                continueMessage = new Message(10, 10, new PVector(0, 0), "", FONT_24);
                continueMessage.create("s", "q");

                //set exercise 
                exerciseComplete = false;
                currentFrame = 0;
                numberOfFrames = 0;
                paused = false;
                recording = false;
                exerciseComplete = false;
        }

        void drawUI(boolean drawHUD) {
                //update kinect information
                context.update();
                //message.drawUI();
                directionMessage.drawUI();
                //println(currentRep);

                if (drawHUD) { //if the parameter passed into the function is true then draw the debug HUD
                        drawHeadsUpDisplay();
                }

                //set the lights an stroke for the scene
                lights();
                noStroke();
                //this centers the kinect 640x480 view window on the 1200x600 processing sketch area
                //the data needs to be rotated on its x axis to invert the y values, the kinect uses negative y values for up
                translate(width/2, height/2, 0);
                rotateX(radians(180));

                //get the users vivible to the kinect
                context.getUsers(userList);

                //if the there is a visible user ad the exercise isnt complete
                if (userList.size() > 0 && !exerciseComplete) {
                        //get the id of the first user
                        int userId = userList.get(0);
                        setUser(userId);
                        //if the kinect is tracking the users skeleton
                        if ( context.isTrackingSkeleton(userId)) {
                                //check to see if the exercis is has been started
                                if (!exerciseStarted) {
                                        startTime  = System.currentTimeMillis(); //get the current time, the start time
                                        exerciseStarted = true;
                                }
                                drawSkeleton(userId); //draw the user
                                // if we're recording tell the recorder to capture this frame
                                if (recording) { //if recordng 
                                        setUserColour(userColourRed); //change the avatar colour to red
                                        if (numberOfFrames%30 == 0) { //record every 30th frame, every 1 second
                                                recordFrame();
                                        }
                                        //increment the current frame number
                                        numberOfFrames++;
                                } 
                                else {
                                        //the user should be grey
                                        setUserColour(userColourWhite);
                                        //display user directions
                                        directionMessage.destroy();
                                        directionMessage = new Message(209, 150, new PVector(978, 160), "The blue targets will lead you throught the exercise. Try to follow them.");
                                        directionMessage.create("e", "f");

                                        drawExerciseSkeleton(userId); //draw the user avatar
                                        
                                        //create message to show the current time
                                        timerMessage.destroy();
                                        timerMessage = new Message(209, 50, new PVector(978, 100), "Time: " + ((System.currentTimeMillis() - startTime) / 1000) + "s");
                                        timerMessage.create("g", "h");
                                        
                                        //if user is close to points
                                        if (checkUserCompliance(userId)) {
                                                nextFrame(); //advance to the next target position
                                        }
                                }
                        }
                }
        }

        //this functon returns true if the users 2nd two joints are within a distance of 200
        boolean checkUserCompliance(int userId) {
                //set result variable to be returned
                boolean result = false;
                //get the posisitons of the targets, adjusted to the users current ancor point
                //for example if the first join is the shoulder all other target points are calculated in relation to it
                //this allows the the targets to move with the user so they can complete the exercise in any position
                ArrayList<PVector> exercisePointsForCurrentFrame = getAdjustedPositions(new PVector(0, 0, 0));

                PVector c1 = new PVector();
                PVector c2 = new PVector();
                PVector c3 = new PVector();

                //get the posisiton of the tracked joint visible to the kinect
                context.getJointPositionSkeleton(userId, jointID[2], c1);
                context.getJointPositionSkeleton(userId, jointID[1], c2);
                context.getJointPositionSkeleton(userId, jointID[0], c3);

                //get the two other target joints, joint 0 is the anchor joint
                PVector p1 = exercisePointsForCurrentFrame.get(2);
                PVector p2 = exercisePointsForCurrentFrame.get(1);
                //PVector p3 = exercisePointsForCurrentFrame.get(0);
                
                //this commented out code was for measuring the magnitude of the distance between the vector points in 3d space
                //it notified the user when they were within acceptable margins of distance for the x and y values but not for the x.
                //it was removed and replaced with a more simple measurement of compliance
                //reconstruct current jont position
                /*PVector aimPoint = PVector.add(c3, p2);
                 aimPoint = PVector.add(aimPoint, p1);
                 
                 println("c1.z=" +  c1.z + " aimPoint.z=" +aimPoint.z);
                 
                 //check for correct z position                
                 
                 if (truec1.x - aimPoint.x < 220 && c1.y - aimPoint.y < 220) {
                 
                /*if (true/*c1.x - aimPoint.x < 220 && c1.y - aimPoint.y < 220) {
                 
                 directionMessage.destroy();    
                 if (aimPoint.z > c1.z + 200) {                                                        
                 directionMessage = new Message(240, 100, new PVector(950, 150), "Move Joint Back Slightly!");                                
                 println("move back p=" +  p1.z + " aimPoint=" +aimPoint.z);
                 } 
                 else if (c1.z < aimPoint.z - 200) {
                 directionMessage = new Message(240, 100, new PVector(950, 150), "Move Joint Forward Slightly!");
                 println("move forward");
                 } 
                 else {
                 directionMessage = new Message(240, 0, new PVector(950, 150), "");
                 } 
                 
                 directionMessage.create("mgroup2", "lname2");
                 } 
                 else if (!directionMessage.check()) {
                 //directionMessage.destroy();
                 
                 }     */

                //alternative compliance measurement
                //flatten the ponts to ignore z axis, recreate the real position of the target points
                //by adding the vectors to the posistion of the current anchor point
                PVector added1 = PVector.add(p1, c3);
                PVector added2 =  PVector.add(p2, c3);
                PVector flat1 = new PVector(added1.x, added1.y);
                PVector flat2 = new PVector(added2.x, added2.y);
                PVector flatA = new PVector(c1.x, c1.y);
                PVector flatB = new PVector(c2.x, c2.y);

                //if the distance between the points is less than 200 or the x and y
                if ((flatA.dist(flat1) < 200  && flatB.dist(flat2) < 200)) { 
                        result = true; //if the user is close to both these points set the result to true
                } 
                return result;
        }
        
        //getters and setters for user id and user colour
        void setUserColour(color c) {
                currentUserColour = c;
        }

        void setUser(int tempUserID) { 
                userID = tempUserID;
        }

        PVector getPosition(int joint) {
                return framesGroup.get(joint).get(currentFrame);
        }

        //this function returns the raw relational recorded position data for each joint through all frames
        ArrayList<PVector> getPositions() {
                ArrayList<PVector> p = new ArrayList<PVector>();
                for (int i = 0; i < 3; i++) {                        
                        p.add(framesGroup.get(i).get(currentFrame));
                }
                return p;
        }

        ArrayList<PVector> getAdjustedPositions(PVector anchorJoint) {
                //pushMatrix();
                //scale(0.8f);
                ArrayList<PVector> p = new ArrayList<PVector>();
                for (int i = 0; i < 3; i++) {
                        PVector temp = framesGroup.get(i).get(currentFrame);
                        if (i == 0) {
                                //temp = anchorJoint; 
                                temp.z  = anchorJoint.z;
                        }
                        p.add(temp);
                }
                //popMatrix();
                return p;
        }

        void drawExerciseSkeleton(int userId) {

                pushStyle();
                pushMatrix();

                PVector anchorJoint = new PVector();
                context.getJointPositionSkeleton(userId, jointID[0], anchorJoint);

                ArrayList<PVector> exercisePointsForCurrentFrame = getAdjustedPositions(anchorJoint);

                scale(0.8f);
                PVector p1 = new PVector();
                PVector p2 = new PVector();
                PVector p3 = new PVector();
                // left arm
                //context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, p3);
                //context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, p2);
                p1 = exercisePointsForCurrentFrame.get(2);
                p2 = exercisePointsForCurrentFrame.get(1);
                p3 = exercisePointsForCurrentFrame.get(0);

                //translate(p3.x, p3.y, p3.z);
                translate(anchorJoint.x, anchorJoint.y, anchorJoint.z);
                //sphere(40);
                target.play();
                //image(target, -75, -75, 275, 275);


                pushMatrix();
                translate(p1.x, p1.y, p1.z);

                //sphere(50);
                image(target, -125, -125, 250, 250);
                popMatrix();

                pushMatrix();
                translate(p2.x, p2.y, p2.z);

                //sphere(50);
                image(target, -125, -125, 250, 250);
                popMatrix();


                /*pushMatrix();                
                 //translate(p3.x, p3.y, p3.z);
                 //translate(anchorJoint.x, anchorJoint.y, anchorJoint.z);
                 println(anchorJoint.z);
                 Limb2 testLimb2 = new Limb2( anchorJoint, p2, 0.3f, 0.3f, userColourBlue);
                 testLimb2.draw();
                 
                 testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, userColourGreen);
                 testLimb2.draw();
                 popMatrix();*/

                popMatrix();
                popStyle();
        }     

        // draw the skeleton with the selected joints
        void drawSkeleton(int userId) {
                pushMatrix();
                //println("Skeleton");
                //rotateX(radians(-180));
                //translate(-320,-240, 0);
                scale(0.8f);

                PVector p1 = new PVector();
                PVector p2 = new PVector();
                float radius;

                //println("left arm");
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, p1);
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, p2);
                Limb2 testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                radius = testLimb2.draw();
                Joint joint = new Joint(p1, radius);
                joint.draw();
                joint = new Joint(p2, radius);
                joint.draw();

                p1.set(p2);
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                radius = testLimb2.draw();
                joint = new Joint(p2, radius);
                joint.draw();

                //println("right arm");
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, p1);
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                radius = testLimb2.draw();
                joint = new Joint(p1, radius);
                joint.draw();
                joint = new Joint(p2, radius);
                joint.draw();
                p1.set(p2);
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                radius = testLimb2.draw();
                joint = new Joint(p2, radius);
                joint.draw();

                //println("left leg");
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, p1);
                joint = new Joint(p1, radius);
                joint.draw();
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                radius = testLimb2.draw();
                joint = new Joint(p2, radius);
                joint.draw();
                p1.set(p2);
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                radius = testLimb2.draw();
                joint = new Joint(p2, radius);
                joint.draw();


                //println("right leg");
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, p1);
                joint = new Joint(p1, radius);
                joint.draw();
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                radius = testLimb2.draw();
                joint = new Joint(p2, radius);
                joint.draw();
                p1.set(p2);
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                radius = testLimb2.draw();
                joint = new Joint(p2, radius);
                joint.draw();

                //println("torso");
                PVector p3 = new PVector();
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, p1);
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, p2);
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, p3);
                // fiddle with offset here
                testLimb2 = new Limb2(p1, new PVector((p2.x+p3.x)/2.f, (p2.y+p3.y)/2.f, (p2.z+p3.z)/2.f), 0.7f, 0.7f, currentUserColour);
                testLimb2.draw();

                //println("head");
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, p1);
                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, p2);
                //p1.add(0,100,0);
                p2.add(0, 100, 0);
                testLimb2 = new Limb2(p1, p2, 0.7f, 0.5f, currentUserColour);
                radius = testLimb2.draw();
                joint = new Joint(p1, radius);
                joint.draw();
                popMatrix();
        }


        void recordFrame() {
                //record the positions of the 3 chosen joints
                //first joint will be anchor point
                PVector positionAnchor = new PVector(); 
                //PVector positionPoint = new PVector(); 
                // PVector storedTorso = new PVector();

                //record the anchor joint position
                context.getJointPositionSkeleton(userID, jointID[0], positionAnchor);
                framesGroup.get(0).add(positionAnchor);

                for (int i = 1; i < 3; i++) { //loop through each joint 
                        PVector positionPoint = new PVector();           
                        context.getJointPositionSkeleton(userID, jointID[i], positionPoint); //get the posistion of the anchor point                      
                        PVector differenceVector = PVector.sub( positionPoint, positionAnchor); //get the vector difference between it and each joint
                        framesGroup.get(i).add(differenceVector); //save the vvector difference as the value for this joint on the current frame
                }
        }

        //this function is called on every frame that the user is close enough to the targets
        void nextFrame() { 
                //if the exercise isnt paused
                if (!paused) {
                        currentFrame++; //incremement the current fframe number
                        if (currentFrame == framesGroup.get(0).size()) { //if the current frame is equall to the total number of frames
                                currentFrame = 0; //loop back to the start of the exercise
                                currentRep++; //increase the number of completed repetitions
                                //PVector pos = new PVector(10, 100);
                                if (currentRep < numberOfReps) { //check to see if they have completed their prescribed number of repietions       
                                        //display a message giving completion information if they havent completed the exercise
                                        message.destroy();                            
                                        message = new Message(209, 280, messagePosition, "Target Reps: " + e.getRepetitions() + "\n\nCurrent Rep: " + currentRep + "\n\nComplete: " + (int)Math.round(100.0 / numberOfReps * currentRep) + "%" +"\n\nDescription:\n" + e.getDescription());
                                        message.create("mgroup", "lname");
                                } 
                                else if (!exerciseComplete) { //other wise on exercise complete
                                        long elapsedTime = (System.currentTimeMillis() - startTime) / 1000; //get the time it took to complete
                                        int score = (int)(numberOfReps*100/elapsedTime*10); //calculate the users score
                                        String scoreFeedback = ""; //create string for storing feedback
                                        String timeFeedback = "";

                                        if (score < 300) { //deterimine score feeback string
                                                scoreFeedback = "Your score isnt bad, but there is room for improvement, keep at it!";
                                        } 
                                        else if (score >= 300 &&  score < 650) {
                                                scoreFeedback = "Your score is very good. Nice work!";
                                        } 
                                        else {
                                                scoreFeedback = "Excellent score, you're really improving.";
                                        }

                                        if (elapsedTime < 15) { //determine time feedback string
                                                timeFeedback = "You completed the exercise very quickly.";
                                        } 
                                        else if (elapsedTime >= 15 &&  elapsedTime < 45) {
                                                timeFeedback = "You finished the exercise at a good pace.";
                                        } 
                                        else {
                                                timeFeedback = "Try to finish a little faster next time if you can.";
                                        }
        
                                        //create an empty message set 
                                        timerMessage.destroy();
                                        timerMessage = new Message(240, 0, new PVector(1950, 100), "");
                                        timerMessage.create("a", "b");
                                        directionMessage.destroy();
                                        directionMessage = new Message(240, 0, new PVector(1950, 400), "");
                                        directionMessage.create("c", "d");
                                        
                                        //create a completion message
                                        message.destroy();                                        
                                        message = new Message(550, 300, new PVector(325, 100), "Well Done!"  + "\n\nTime to Complete: " + elapsedTime + " seconds" + "\n\nScore: " + score/10 + " points \n\n" + scoreFeedback + "\n\n" + timeFeedback, FONT_24);
                                        message.create("mgroup", "lname");
                                        //message.destroy();
                                        exerciseComplete = true; //set exercise complete to true
                                        //create a date object and retrieve the current date in integer format
                                        DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
                                        Date currentDate = new Date();
                                        int date = int(dateFormat.format(currentDate));

                                        //create a record DAO and post a new record to the database using the information created during the exercise
                                        RecordDAO dao = new RecordDAO();
                                        dao.setRecord(new Record(0, user.getUser_id(), e.getExercise_id(), date, (int)elapsedTime, numberOfReps, score, "Error"));
                                        exerciseComplete = true;
                                }
                        }
                }
        }

        void drawHeadsUpDisplay() { //used for debugiing
                pushMatrix();
                // create hud with frame info
                fill(0);
                text("totalFrames: " + framesGroup.get(0).size(), 5, 10);
                text("recording: " + recording, 5, 24);
                text("currentFrame: " + currentFrame, 5, 38 );
                popMatrix();
        }

        void loadImages() {
                //load images  for buttons
                this.menuBack[0]  = loadImage("images/NewUI/menu.jpg");        //normal
                this.menuBack[1]  = loadImage("images/NewUI/menuOver.jpg");//hover
                this.menuBack[2]  = loadImage("images/NewUI/menu.jpg");        //click
                this.logout[0] = loadImage("images/NewUI/logout.jpg");
                this.logout[1] = loadImage("images/NewUI/logoutOver.jpg");
                this.logout[2] = loadImage("images/NewUI/logout.jpg");
                this.cancel[0] = loadImage("images/NewUI/cancel.jpg");
                this.cancel[1] = loadImage("images/NewUI/cancelOver.jpg");
                this.cancel[2] = loadImage("images/NewUI/cancel.jpg");
        }

        void toggleRecording() { //change the programs recording state
                recording = !recording;
                System.out.println("recording state: " + recording);
        }

        void loadPressed() { //load default exercise
                readXML("default");
        }

        void savePressed() { //save the recorded exercise
                writeXML("right arm curl"); //using this name
        }

        void readXML(String fileName) { //reads the xml docment of the given name
                currentFrame = 0;
                paused = true;
                framesGroup = null; //reset the current exercise data if ther is any
                //reuild the data structure for storing joint/frame info
                framesGroup = new ArrayList<ArrayList<PVector>>(3);
                framesOne = new ArrayList<PVector>();
                framesTwo = new ArrayList<PVector>();
                framesThree = new ArrayList<PVector>();

                framesGroup.add(framesOne);
                framesGroup.add(framesTwo);
                framesGroup.add(framesThree);

                //create the path that the file is to be read from using the given file name
                //String pathName = "C:\\Users\\David\\Documents\\Processing\\movementRecorderClass\\" + "xml-exercises\\" + fileName + ".xml";
                String pathName = sketchPath("xml-exercises") + "\\" + fileName  + ".xml";


                Document dom;
                // Make an  instance of the DocumentBuilderFactory
                DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
                try {
                        // use the factory to take an instance of the document builder
                        DocumentBuilder db = dbf.newDocumentBuilder();
                        // parse using the builder to get the DOM mapping of the XML file
                        dom = db.parse(pathName);
                        dom.getDocumentElement().normalize();
                        //get the joints nodes
                        NodeList joints = dom.getElementsByTagName("joint");

                        System.out.println("Root element :"  
                                + dom.getDocumentElement().getNodeName());

                        ////loop through each of the joint nodes
                        for (int i = 0; i < joints.getLength(); i++) {
                                Node joint = joints.item(i);
                                NodeList frames = joint.getChildNodes();
                                //loop through the frame nodes in each joint
                                for (int j = 0; j < frames.getLength(); j++) {
                                        Node frameNode = frames.item(j);
                                        Element frame = (Element) frameNode; 
                                        //retirve the data for x, y and z positions from each frame 
                                        framesGroup.get(i).add(new PVector(Integer.parseInt(frame.getAttribute("xpos").toString()), Integer.parseInt(frame.getAttribute("ypos")), Integer.parseInt(frame.getAttribute("zpos"))));
                                }
                        }

                        Element doc = dom.getDocumentElement();

                        currentFrame = 0; //reset the current frame to start the exercise from the begining
                        paused = false;
                        System.out.println(fileName + " loaded.");
                }
                catch (Exception e) {
                        e.printStackTrace();
                }
        }

        //this function is used to write out the recorded point data to an xml file
        public void writeXML(String fileName) { //writes xml file of given name
                try {
                        //create a path for the the exercise to be saved to 
                        //String pathName =  "C:\\Users\\David\\Documents\\Processing\\movementRecorderClass\\" + "xml-exercises\\" + fileName;
                        String pathName = sketchPath("xml-exercises") + "\\" + fileName + ".xml";
                        //create a new document object using the document builder object
                        DocumentBuilderFactory documentFactory = DocumentBuilderFactory
                                .newInstance();
                        DocumentBuilder documentBuilder = documentFactory
                                .newDocumentBuilder();

                        // define root elements for the document
                        Document document = documentBuilder.newDocument();
                        Element rootElement = document.createElement("exercise");
                        document.appendChild(rootElement); //add the root element to the ocument

                                //loop through the data for each joint
                        for (int j = 0; j < 3; j++) {
                                //create a joint element
                                Element joint = document.createElement("joint");
                                rootElement.appendChild(joint); //add it to the root element
                                //give the joint element an atribute, joint number and se its value
                                Attr jointNumber = document.createAttribute("jointnumber");
                                jointNumber.setValue(Integer.toString(j));
                                joint.setAttributeNode(jointNumber);

                                //for each joint loop through the data for each recorded frame
                                for (int i = 0; i < framesGroup.get(j).size(); i++) {
                                        //create a frame object and add it to its joint
                                        Element f = document.createElement("frame");
                                        joint.appendChild(f);

                                        //add the x,y and z attributes to joint object
                                        Attr xposition = document.createAttribute("xpos");
                                        xposition.setValue(Integer.toString((int)Math.round(framesGroup.get(j).get(i).x)));
                                        f.setAttributeNode(xposition);

                                        Attr yposition = document.createAttribute("ypos");
                                        yposition.setValue(Integer.toString((int)Math.round(framesGroup.get(j).get(i).y)));
                                        f.setAttributeNode(yposition);

                                        Attr zposition = document.createAttribute("zpos");
                                        zposition.setValue(Integer.toString((int)Math.round(framesGroup.get(j).get(i).z)));
                                        f.setAttributeNode(zposition);
                                }
                        }

                        // creating and write to xml file using the created values
                        TransformerFactory transformerFactory = TransformerFactory
                                .newInstance();
                        Transformer transformer = transformerFactory.newTransformer();
                        DOMSource domSource = new DOMSource(document);
                        StreamResult streamResult = new StreamResult(new File(pathName));

                        transformer.transform(domSource, streamResult);

                        //reset the current frame so the exercise starts from the begining
                        currentFrame = 0;

                        System.out.println(fileName + " saved to specified path!");
                } 
                catch (ParserConfigurationException pce) {
                        pce.printStackTrace();
                } 
                catch (TransformerException tfe) {  
                        tfe.printStackTrace();
                }
        }

        //this function returns true if the exercise is complete
        public boolean checkForComplete() {
                return exerciseComplete;
        }

        //this function is called by the RedPanda file when the check for complete returns true
        public void startFinishTimer() {
                //if the timer hasnt been started already, finishedTimeStarted is not true 
                if (!finishedTimerStarted) { //create timer
                        finishStartTime = System.currentTimeMillis() /1000; //get the current time
                        finishedTimerStarted = true; //set the finishedTimeStarted variable to true so the finishStart time is not set on next check
                } 
                else { //if timer started is true check timer
                        if ((System.currentTimeMillis()/1000) - finishStartTime > 10) { //if 10 seconds has passed
                                parent.autoMoveToScreenThree(); //call this function in the RedPanda class to advance to the next exercise
                        }

                        //draw cancel button
                        buttons[2].setVisible(true);
                        //destrol the previous continue message
                        continueMessage.destroy();                             
                        //create a new message showing the current time left until the autoMoveToScreenThree function is going to be called
                        continueMessage = new Message(550, 50, new PVector(325, 410), "Next exercise in "+ (10 -((System.currentTimeMillis()/1000) - finishStartTime)) + " seconds, use Cancel to quit.", FONT_24);
                        continueMessage.create("zz", "tt");
                }
        }

        //this function is used to remove the UI elemts for this screen
        void destroy() {                
                for ( int i = 0 ; i < buttons.length ; i++ ) { //loop through the buttons
                        buttons[i].remove(); //remove them
                        buttons[i] = null;
                }
                cp5.getGroup("exerciseGroup2").remove(); //remove the Cp5 groupd
                message.destroy(); //destroy the message display objects
                timerMessage.destroy();
                directionMessage.destroy();
                continueMessage.destroy();
                //System.gc();
        }
}

