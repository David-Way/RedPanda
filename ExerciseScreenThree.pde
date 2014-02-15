class ExerciseScreenThree {

        private RedPanda context;

        private PImage[] menuBack = new PImage[3];
        private PImage[] logout = new PImage[3];
        private Button []buttons;
        private Group exerciseGroup3;
        Gif countDownIcon;
        Gif target;
        Timer debouncingTimer;
        //reps for exercise
        int MAX_REPS = 5;
        float MIN_DIST = 100;
        int exerciseId;
        int reps = 0;
        int timeLeft = 0;
        int score;
        //Start point of exercise
        PVector startPoint = new PVector();
        PVector startPos = new PVector(); 
        PVector currentPos = new PVector();
        //Array of hightestpoint per rep
        PVector  highestPoint[];


        boolean startExercise = false;
        int timerCountDown;
        boolean start = false;
        boolean firstTime = true;
        boolean finished = false;
        boolean enterData = true;
        Message message;
        Record record;
        RecordDAO recordDAO;
        User user;
        int trackingUserId;
        int userId;
        float lastTime;
        int timer;
        long startTime;
        int timeCompleted;

        public ExerciseScreenThree(RedPanda c) {
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

        public void create(User user, Exercise e) {
                countDownIcon = new Gif(context, "images/countdown.gif");
                target = new Gif(context, "images/target.gif");
                exerciseId = e.getExercise_id();
                userId = user.getUser_id();
                MAX_REPS = e.getRepetitions();
                highestPoint = new PVector[MAX_REPS];
                startPoint = null;
                for ( int i = 0 ; i < MAX_REPS ; i++ ) {
                        highestPoint[i] = new PVector();
                }
                debouncingTimer = new Timer(0.1f, true, false);

                recordDAO = new RecordDAO();
                record = recordDAO.getLastForExercise(userId, exerciseId);
                if (record.getRecord_id() != -1) {
                        String date = String.valueOf(record.getDateDone());
                        int Year=int(date.substring(0, 4));
                        int Month=int(date.substring(4, 6));
                        int Day=int(date.substring(6, 8));
                        PVector pos = new PVector(10, 100);
                        message = new Message(280, 400, pos, "Hi " + user.getFirst_name() + ",\nWelcome to the " + e.getName()  +  " exercise. \nWhich was last done on : " + Day +" / " + Month + " / "+ Year + "\nOn 5, raise you right leg away from your body as high as you comfortably can.");
                        message.create("g", "l");
                }
                else {
                        PVector pos = new PVector(10, 100);
                        message = new Message(280, 400, pos, "Hi " + user.getFirst_name() + ",\nWelcome to the " + e.getName()  +  " exercise. \nYou have not attempted this exercise yet. \nOn 5, raise you right hand away from your body as high as you comfortably can.");
                        message.create("g", "l");
                }

                lastTime = (float)millis()/1000.f;
                start = false;
                cp5.setAutoDraw(false);

                exerciseGroup3 = cp5.addGroup("exerciseGroup3")
                        .setPosition(0, 0)
                                .hideBar()
                                        ;

                buttons = new Button[2];

                buttons[0] = cp5.addButton("menuBackExercise3")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(exerciseGroup3)
                                                        ;

                buttons[1] = cp5.addButton("logoutExercise3")
                        .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(exerciseGroup3)
                                                        ;
        }

        public void startExercise() {

                IntVector userList = new IntVector();
                kinect.getUsers(userList);

                if (userList.size() > 0) {
                        trackingUserId = userList.get(0);
                        if (kinect.isTrackingSkeleton(trackingUserId)) {

                                if (startPoint == null) {
                                        text(timeLeft, 40, 40, 0);

                                        if (startExercise == false) {
                                                startExercise = true;
                                                timerCountDown = millis();
                                        }

                                        if (checkExerciseTimer()) {
                                                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, startPos);
                                                startTime = System.currentTimeMillis();
                                                startPoint = startPos;
                                        }
                                }


                                if (startPoint != null) {
                                        pushMatrix();
                                        translate(width/2, height/2, 0);
                                        rotateX(radians(180));  
                                        pushMatrix();
                                        target.play();
                                        translate(startPoint.x, startPoint.y, startPoint.z);            
                                        image(target, -125, -125, 250, 250);
                                        popMatrix();
                                        popMatrix();
                                        setPoints();

                                }
                        }
                }
        }


        public boolean checkExerciseTimer() {
                int totalTime = 5000;
                boolean check = false;
                if (startExercise) {
                        countDownIcon.play();
                        image(countDownIcon, 300, 200, 300, 300);
                        int passedTime = millis() - timerCountDown;
                        timeLeft = passedTime/1000;
                        if (passedTime > totalTime) {
                                check = true;
                        }
                        else {
                                check = false;
                        }
                }
                return check;
        }


        float distance = 0.f;
        public void setPoints() {
                pushMatrix();
                translate(width/2, height/2, 0);
                rotateX(radians(180));
                message.destroy();
                PVector pos = new PVector(10, 100);
                message = new Message(280, 400, pos, "Target Repetitions: " + MAX_REPS + "\nCurrent Repetition: " + reps + "\nPercent Complete: " + (int)Math.round(100.0 / MAX_REPS * reps) + "%" + "\nTime: " + ((System.currentTimeMillis() - startTime) / 1000) +"s");
                message.create("pg", "pl");
                //draw
                if (currentPos != new PVector()) {
                        pushMatrix();
                        fill(0, 255, 0);
                        translate(currentPos.x, currentPos.y, currentPos.z);
                        sphere(40);
                        popMatrix();
                }
                for ( int i = 0 ; i < reps ; i++ ) {
                        pushMatrix();
                        translate(highestPoint[i].x, highestPoint[i].y, highestPoint[i].z);            
                        image(target, -125, -125, 250, 250);
                        popMatrix();
                       }
                popMatrix();
                //update
                if ( finished ) {
                        stopExercise();
                        return;
                }
                pushMatrix();
                translate(width/2, height/2, 0);
                rotateX(radians(180));
                float curTime = (float)millis()/1000.f;
                if ( firstTime ) {
                        debouncingTimer.reset();
                }
                if ( debouncingTimer.update(curTime - lastTime) ) {
                        currentPos = new PVector();
                        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, currentPos);
                }
                if ( firstTime ) {
                        firstTime = false;
                        highestPoint[reps].set(currentPos);
                }

                if ( currentPos.y > highestPoint[reps].y && PVector.dist(startPoint, currentPos) > MIN_DIST ) {
                        highestPoint[reps].set(currentPos);
                        distance = 0.33f * PVector.dist(highestPoint[reps], startPoint);
                }
                if ( PVector.dist(startPoint, currentPos) < distance ) {
                        println("Reps " + reps + highestPoint[reps].x + " : " + highestPoint[reps].y + " : " + highestPoint[reps].z);
                        reps++;
                        if ( reps >= MAX_REPS ) {
                                finished = true;
                        } 
                        else {
                                highestPoint[reps].set(currentPos);
                                distance = 0.f;
                        }
                }
                lastTime = curTime;
                popMatrix();
        }

        public void stopExercise() {
                timeCompleted = int(((System.currentTimeMillis() - startTime)/1000));
                float average = 0;
                for ( int i = 0 ; i < reps ; i++ ) {
                        average  = average +  highestPoint[i].y;
                }
                float temp_score  = (int) average / reps;
                score = int(((startPoint.y - temp_score)*-1));
                message.destroy();                                        
                message = new Message(400, 400, new PVector(400, 100), "Well Done."  + "\nTime to Complete: " + timeCompleted + " seconds" + "\nScore: " + score + " points");
                message.create("eg", "el");
                addToRecords();
        }

        public void addToRecords() {
                DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
                Date currentDate = new Date();
                int date = int(dateFormat.format(currentDate));
                if (enterData) {
                        Record newRecord = new Record(0, userId, exerciseId, date, timeCompleted , reps, score, "Error");
                        recordDAO.setRecord(newRecord);
                        enterData = false;
                }
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
                }
                else if (leftHand.x > (978/2.5) && leftHand.x < (1190/2.5) && leftHand.y > (10/2.5) && leftHand.y < (85/2.5))
                {
                        if (start == false) {
                                println("Over logout");
                                start = true;
                                timer = millis();
                                loaderOn();
                        }
                        if (checkTimer() == 1) {
                                println("Log out called");
                                makeLogout();
                        }
                }
                else {
                        start = false;
                        loaderOff();
                        //println("Over Nothing");
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
                //cp5.draw();
                message.drawUI();
        }

        void destroy() {
                for ( int i = 0 ; i < buttons.length ; i++ ) {
                        buttons[i].remove();
                        buttons[i] = null;
                }
                
                cp5.getGroup("exerciseGroup3").remove();
                message.destroy();
        }



        ////////////////////////////////////////////////////////////////////////////
        //SKELETON DRAWING
        void trackSkeleton(SimpleOpenNI kinect) {

                // update the cam
                kinect.update();

                IntVector userList = new IntVector();
                kinect.getUsers(userList);
                if (userList.size() > 0) {
                        int trackingUserId = userList.get(0);

                        if (kinect.isTrackingSkeleton(trackingUserId)) {
                                drawSkeleton(trackingUserId);
                        }
                }
        }


        // draw the skeleton with the selected joints
        void drawSkeleton(int trackingUserId) {
                pushMatrix();
                lights();
                noStroke();
                translate(width/2, height/2, 0);
                rotateX(radians(180));
                PVector p1 = new PVector();
                PVector p2 = new PVector();
                float radius;

                //println("left arm");
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_LEFT_SHOULDER, p1);
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_LEFT_ELBOW, p2);
                Limb testLimb = new Limb(p1, p2, 0.3f, 0.3f);
                radius = testLimb.draw();
                Joint joint = new Joint(p1, radius);
                joint.draw();
                joint = new Joint(p2, radius);
                joint.draw();

                p1.set(p2);
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_LEFT_HAND, p2);
                testLimb = new Limb(p1, p2, 0.3f, 0.3f);
                radius = testLimb.draw();
                joint = new Joint(p2, radius);
                joint.draw();

                //println("right arm");
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, p1);
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_RIGHT_ELBOW, p2);
                testLimb = new Limb(p1, p2, 0.3f, 0.3f);
                radius = testLimb.draw();
                joint = new Joint(p1, radius);
                joint.draw();
                joint = new Joint(p2, radius);
                joint.draw();
                p1.set(p2);
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_RIGHT_HAND, p2);
                testLimb = new Limb(p1, p2, 0.3f, 0.3f);
                radius = testLimb.draw();
                joint = new Joint(p2, radius);
                joint.draw();

                //println("left leg");
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_LEFT_HIP, p1);
                joint = new Joint(p1, radius);
                joint.draw();
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_LEFT_KNEE, p2);
                testLimb = new Limb(p1, p2, 0.3f, 0.3f);
                radius = testLimb.draw();
                joint = new Joint(p2, radius);
                joint.draw();
                p1.set(p2);
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_LEFT_FOOT, p2);
                testLimb = new Limb(p1, p2, 0.3f, 0.3f);
                radius = testLimb.draw();
                joint = new Joint(p2, radius);
                joint.draw();


                //println("right leg");
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_RIGHT_HIP, p1);
                joint = new Joint(p1, radius);
                joint.draw();
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_RIGHT_KNEE, p2);
                testLimb = new Limb(p1, p2, 0.3f, 0.3f);
                radius = testLimb.draw();
                joint = new Joint(p2, radius);
                joint.draw();
                p1.set(p2);
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_RIGHT_FOOT, p2);
                testLimb = new Limb(p1, p2, 0.3f, 0.3f);
                radius = testLimb.draw();
                joint = new Joint(p2, radius);
                joint.draw();

                //println("torso");
                PVector p3 = new PVector();
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_NECK, p1);
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_LEFT_HIP, p2);
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_RIGHT_HIP, p3);
                // fiddle with offset here
                testLimb = new Limb(p1, new PVector((p2.x+p3.x)/2.f, (p2.y+p3.y)/2.f, (p2.z+p3.z)/2.f), 0.7f, 0.7f );
                testLimb.draw();

                //println("head");
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_NECK, p1);
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_HEAD, p2);
                //p1.add(0,100,0);
                p2.add(0, 100, 0);
                testLimb = new Limb(p1, p2, 0.7f, 0.5f);
                radius = testLimb.draw();
                joint = new Joint(p1, radius);
                joint.draw();
                kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_RIGHT_FOOT, currentPos);
                popMatrix();
        }
}

