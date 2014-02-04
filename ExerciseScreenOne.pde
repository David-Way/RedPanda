class ExerciseScreenOne {

        private RedPanda context;

        private PImage[] menuBack = new PImage[3];
        private PImage[] logout = new PImage[3];
        private Button []buttons;
        private Group exerciseGroup;
        boolean start = false;
        int timer;

        public ExerciseScreenOne(RedPanda c) {
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

                exerciseGroup = cp5.addGroup("exerciseGroup")
                        .setPosition(0, 0)
                                .hideBar()
                                ;

                buttons = new Button[2];

                buttons[0] = cp5.addButton("menuBackExercises")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(exerciseGroup)
                                                        ;

                buttons[1] = cp5.addButton("logoutExcercises")
                       .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(exerciseGroup)
                                                        ;
        }

        void checkBtn(PVector convertedLeftJoint, PVector convertedRightJoint ) {

                PVector leftHand = convertedLeftJoint;
                PVector rightHand = convertedRightJoint;

                if (leftHand.x > (10/2.5) && leftHand.x < (222/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                {
                        if (start == false) {
                                println("Menu back called");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                menuBack();
                        }
                }else if(leftHand.x > (978/2.5) && leftHand.x < (1190/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                {
                        if(start == false){
                                println("Over logout");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }if(checkTimer() == 1){
                            println("Log out called");
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
                cp5.getGroup("exerciseGroup").remove();
                //exerciseGroup.remove();
        }



        ////////////////////////////////////////////////////////////////////////////
//SKELETON DRAWING
void trackSkeleton(SimpleOpenNI kinect) {

        // update the cam
        kinect.update();

        IntVector userList = new IntVector();
        kinect.getUsers(userList);
        if (userList.size() > 0) {
            int userId = userList.get(0);

                if (kinect.isTrackingSkeleton(userId)) {
                        pushStyle();
                        strokeWeight(5);
                        stroke(255, 0, 0);
                        drawSkeleton(userId);
                        popStyle();

                }
        }
}


// draw the skeleton with the selected joints
void drawSkeleton(int userId) {
        pushMatrix();
        println("Skeleton");
        //rotateX(radians(-180));
        //translate(-320,-240, 0);
        scale(0.8f);

        PVector p1 = new PVector();
        PVector p2 = new PVector();
        float radius;

       println("left arm");
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, p1);
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, p2);
        Limb testLimb = new Limb(p1,p2,0.3f,0.3f);
        radius = testLimb.draw();
        Joint joint = new Joint(p1, radius);
        joint.draw();
        joint = new Joint(p2, radius);
        joint.draw();

        p1.set(p2);
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, p2);
        testLimb = new Limb(p1,p2,0.3f,0.3f);
        radius = testLimb.draw();
        joint = new Joint(p2, radius);
        joint.draw();

        println("right arm");
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, p1);
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, p2);
        testLimb = new Limb(p1,p2,0.3f,0.3f);
        radius = testLimb.draw();
        joint = new Joint(p1, radius);
        joint.draw();
        joint = new Joint(p2, radius);
        joint.draw();
        p1.set(p2);
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, p2);
        testLimb = new Limb(p1,p2,0.3f,0.3f);
        radius = testLimb.draw();
        joint = new Joint(p2, radius);
        joint.draw();

        println("left leg");
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, p1);
        joint = new Joint(p1, radius);
        joint.draw();
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, p2);
        testLimb = new Limb(p1,p2,0.3f,0.3f);
        radius = testLimb.draw();
        joint = new Joint(p2, radius);
        joint.draw();
        p1.set(p2);
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, p2);
        testLimb = new Limb(p1,p2,0.3f,0.3f);
        radius = testLimb.draw();
        joint = new Joint(p2, radius);
        joint.draw();
        

        println("right leg");
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, p1);
        joint = new Joint(p1, radius);
        joint.draw();
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, p2);
        testLimb = new Limb(p1,p2,0.3f,0.3f);
        radius = testLimb.draw();
        joint = new Joint(p2, radius);
        joint.draw();
        p1.set(p2);
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, p2);
        testLimb = new Limb(p1,p2,0.3f,0.3f);
        radius = testLimb.draw();
        joint = new Joint(p2, radius);
        joint.draw();

        println("torso");
        PVector p3 = new PVector();
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, p1);
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, p2);
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, p3);
        // fiddle with offset here
        testLimb = new Limb(p1,new PVector((p2.x+p3.x)/2.f,(p2.y+p3.y)/2.f,(p2.z+p3.z)/2.f), 0.7f, 0.7f );
        testLimb.draw();

        println("head");
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, p1);
        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, p2);
        //p1.add(0,100,0);
        p2.add(0,100,0);
        testLimb = new Limb(p1,p2,0.7f,0.5f);
        radius = testLimb.draw();
        joint = new Joint(p1, radius);
        joint.draw();
        popMatrix();
       
}

}

