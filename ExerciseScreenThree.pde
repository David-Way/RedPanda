class ExerciseScreenThree {

  private RedPanda context;

  //UI ELEMENTS///////////////////////////
  //Arrays to store button images. 
  private PImage[] menuBack = new PImage[3];
  private PImage[] logout = new PImage[3];
  private PImage[] cancel = new PImage[3];
  //Gifs for target and countdown timer.
  Gif countDownIcon;
  Gif target;
  //Array to store buttons added to screen.
  private Button []buttons;
  //ControlP5 elements group and messages.
  private Group exerciseGroup3;
  Message message;
  Message messageTwo;
  Message messageThree;
  Message continueMessage;

  //Variables for stabilising skeleton streaming data.
  Timer debouncingTimer;
  float lastTime;

  //Variables for exercise
  int MAX_REPS = 5;
  float MIN_DIST = 100;
  int exerciseId;
  int reps = 0;
  int timeLeft = 0;
  int score;
  //Count down timer for start of exercise;
  int timerCountDown;
  //Start time of exercise.
  long startTime;
  //Time out incase of exercise left running.
  long timeOut;
  //Time exercise completed in. 
  int timeCompleted;

  //USER TRACKING VARIABLES
  //PVectors of start and current point exercise
  PVector startPoint = new PVector();
  PVector startPos = new PVector(); 
  PVector currentPos = new PVector();
  //Tracking user id, differenct from userId.
  int trackingUserId;
  IntVector userList;
  //Array of hightestpoint per rep
  PVector  highestPoint[];

  //Booleans for first time, finished, stop timer and enter new record data
  boolean startExercise = false;
  boolean firstTime = true;
  boolean finished = false;
  boolean stopTime = true;
  boolean enterData = true;

  //Main program objects
  RecordDAO recordDAO;
  Record record;
  User user;
  Exercise exercise;
  //Record date;
  int Year;
  int Month;
  int Day;

  //UserId refers to User object. Not user tracked.
  int userId;

  //Timer to move to next screen.
  boolean finishedTimerStarted = false;
  long finishStartTime = 0;


  // constructor takes reference to the main class, sets it to context. Use
  // "context" instead of "this" when drawing
  public ExerciseScreenThree(RedPanda c) {
    this.context = c;
  }

  void loadImages() {
    //load images for UI
    this.menuBack[0]  = loadImage("images/NewUI/menu.jpg");
    this.menuBack[1]  = loadImage("images/NewUI/menuOver.jpg");
    this.menuBack[2]  = menuBack[0];
    this.logout[0] = loadImage("images/NewUI/logout.jpg");
    this.logout[1] =loadImage("images/NewUI/logoutOver.jpg");
    this.logout[2] = logout[0];
    this.cancel[0] = loadImage("images/NewUI/cancel.jpg");
    this.cancel[1] = loadImage("images/NewUI/cancelOver.jpg");
    this.cancel[2] = cancel[0];
  }

  public void create(User u, Exercise e) {
    //initialise user and exercise objects
    user = u;
    exercise = e;
    //Set time out for exercise
    timeOut = System.currentTimeMillis();
    //Create gifs for countdown and target
    countDownIcon = new Gif(context, "images/countdown.gif");
    target = new Gif(context, "images/target.gif");
    //Initial userlist, exercise id, userid, MAX_REPS,highest point array size and startpoint 
    exerciseId = e.getExercise_id();
    userId = user.getUser_id();
    userList = new IntVector();
    MAX_REPS = e.getRepetitions();
    highestPoint = new PVector[MAX_REPS];
    startPoint = null;
    //Create an empty PVector for each index in highestPoint array
    for ( int i = 0 ; i < MAX_REPS ; i++ ) {
      highestPoint[i] = new PVector();
    }
    //create new instance of Timer, set to looping and not running
    debouncingTimer = new Timer(0.1f, true, false);

    //Create new instance of RecordDAO
    //Make HTTP request to get the last done record for this user and exercise
    recordDAO = new RecordDAO();
    record = recordDAO.getLastForExercise(userId, exerciseId);
    //If the HTTP request returns a valid record display a message for the user
    if (record.getRecord_id() != -1) {
      //Parse record date
      String date = String.valueOf(record.getDateDone());
      Year=int(date.substring(0, 4));
      Month=int(date.substring(4, 6));
      Day=int(date.substring(6, 8));
      PVector pos = new PVector(10, 100);
      //Create new Message object, with GroupName and Label to avoid conflicts
      message = new Message(208, 450, pos, "Hi " + user.getFirst_name() + ",\n\nWelcome to the " + exercise.getName()  +  " exercise. \n\nWhich was last done on :\n " + Day +" / " + Month + " / "+ Year + "\n\nDirections : \n\nOn 5, raise you right leg away from your body as high as you comfortably can.");
      message.create("x", "y");
    }
    //If there is no record for this user and exercise display a different message
    else {
      PVector pos = new PVector(10, 100);
      message = new Message(208, 450, pos, "Hi " + user.getFirst_name() + ",\nWelcome to the " + exercise.getName()  +  " exercise. \n\nYou have not attempted this exercise yet. \n\n Directions : \n\nOn 5, raise you right leg away from your body as high as you comfortably can.");
      message.create("x", "y");
    }
    //Create blank messages to be used later for user feedback. These need to be created here as they are destroyed and recreated
    //on every frame of the main draw() function.
    messageTwo = new Message(0, 0, new PVector(10, 978), "");
    messageTwo.create("pi", "pt");
    messageThree = new Message(0, 0, new PVector(70, 978), "");
    messageThree.create("pr", "ps");
    continueMessage = new Message(10, 10, new PVector(1900, 0), "", 24);
    continueMessage.create("s", "q");

    //Set last time for debouncing timer
    lastTime = (float)millis()/1000.f;

    //Set cp5 autodraw to false to create the UI and draw on demand.
    cp5.setAutoDraw(false);

    //Add exercise group to cp5 element
    exerciseGroup3 = cp5.addGroup("exerciseGroup3")
      .setPosition(0, 0)
        .hideBar()
          ;

    //Initialise button array for cp5 buttons
    //This is for easy removal
    buttons = new Button[3];

    //Set menu back button
    buttons[0] = cp5.addButton("menuBackExercise3")
      .setPosition(10, 10)
        .setImages(menuBack)
          .updateSize()
            .setGroup(exerciseGroup3)
              ;

    //Set logout back button
    buttons[1] = cp5.addButton("logoutExercise3")
      .setPosition(978, 10)
        .setImages(logout)
          .updateSize()
            .setGroup(exerciseGroup3)
              ;

    //Set cancel back button
    buttons[2] = cp5.addButton("cancelProgramme3")
      .setPosition(494, 515)
        .setImages(cancel)
          .updateSize()
            .setVisible(false)
              .setGroup(exerciseGroup3)
                ;
  }

  //Start exercise called by case change main file.
  //SimpleOpenNI reference passed in.
  public void startExercise(SimpleOpenNI kinect) {

    //Call track user function.
    trackSkeleton(kinect);
    //Kinect functions getting user list.
    kinect.getUsers(userList);

    if (userList.size() > 0) {
      //set trackingUserId to userlist index 0
      trackingUserId = userList.get(0);

      //If kinect is tracking user of that id continue with the exercise set up
      if (kinect.isTrackingSkeleton(trackingUserId)) {

        //Start point is null, this function will run only once. 
        if (startPoint == null) {

          //Startexercise is false, timer is set to current time
          //startExercise to true. Called once only
          if (startExercise == false) {
            startExercise = true;
            timerCountDown = millis();
          }

          //If checkTimer is true, which is set to true when the timer is up
          //Set start point to current right hand position.
          if (checkExerciseTimer()) {
            kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, startPos);
            startTime = System.currentTimeMillis();
            //Start point is initialised.
            startPoint = startPos;
          }
        }

        //If start point has been set to the right hand position
        //Draw a target gif at that position
        if (startPoint != null && startPoint.x != 0 && startPoint.y != 0 && startPoint.z != 0 ) {
          //Push matrix saves current state of transformation matrix.
          pushMatrix();
          //Tranlate and rotate x so things appear drawn in the centre of the screen.
          translate(width/2, height/2, 0);
          rotateX(radians(180));  
          pushMatrix();
          //Set target gif to play
          //Draw gif at start point position
          target.play();
          translate(startPoint.x, startPoint.y, startPoint.z);            
          image(target, -125, -125, 250, 250);
          popMatrix();
          popMatrix();
          //Pop restores previous state of transformation matrix.
          setPoints();
        }
      }
    }
  }


  //Check Exercise Timer called from startExercise function
  //if startExercise is true, play countdown timer gif
  //Once the passedTime is greather than total time return true
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

  //Set Points is used to set the current point and the highest point of each rep. 
  //It is also used to calulate the repeitions, display messages and finish the exercise.
  float distance = 0.f;
  public void setPoints() {
    //Push, translate and Pop Matrix for correct representation of points.
    pushMatrix();
    translate(width/2, height/2, 0);
    rotateX(radians(180));
    //destroy previous welcome message
    //Create new message containing exercise statistics on each frame
    message.destroy();
    PVector pos = new PVector(10, 100);
    message = new Message(209, 400, new PVector(10, 100), "Hi " + user.getFirst_name() +
      ",\n\nWelcome to the " + exercise.getName()  +  
      " exercise. \n\nWhich was last done on :\n " + Day +" / " + Month + " / "+ Year + 
      "\n\nTarget Reps: " + MAX_REPS + "\n\nCurrent Reps: " + reps + "\n\nComplete: " +
      (int)Math.round(100.0 / MAX_REPS * reps) + "%");
    message.create("gp", "lp");
    //Destroy message two and redraw on each frame with timer shown.
    messageTwo.destroy();
    messageTwo = new Message(209, 50, new PVector(978, 100), "Time: " + ((System.currentTimeMillis() - startTime) / 1000) +"s");
    messageTwo.create("fp3", "hp3");
    //Destroy message three and redraw on each frame with directions shown.
    messageThree.destroy();
    messageThree = new Message(209, 150, new PVector(978, 170), "Raise you right leg away from your body as high as you comfortably can.");
    messageThree.create("jp", "kp");
    //draw target for current position
    if (currentPos != new PVector()) {
      pushMatrix();
      translate(currentPos.x, currentPos.y, currentPos.z);
      image(target, -125, -125, 250, 250);
      popMatrix();
    }
    //draw target for highest point reached per repetition.
    if (reps > 0 && reps <= MAX_REPS) {
      pushMatrix();
      translate(highestPoint[reps -1].x, highestPoint[reps -1].y, highestPoint[reps - 1].z);            
      image(target, -125, -125, 250, 250);
      popMatrix();
    }
    popMatrix();
    //PopMatrix to not effect anything inside stopExercise function.
    //If finished call stopExercise and return. Finished is only true is reps have been completled.
    if ( finished ) {
      stopExercise();
      return;
    }
    //Translate again to avoid affecting anything drawn inside stopExercise
    pushMatrix();
    translate(width/2, height/2, 0);
    rotateX(radians(180));
    //Set current time
    float curTime = (float)millis()/1000.f;
    if ( firstTime ) {
      debouncingTimer.reset();
    }
    //Update debouncing timer
    //Set current posiiton, this slows down the updating speed, meaning you get less bouncing of the current point
    if ( debouncingTimer.update(curTime - lastTime) ) {
      currentPos = new PVector();
      kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, currentPos);
    }
    //If first time set highestPoint to current pos to calculate the distance used later
    if ( firstTime ) {
      firstTime = false;
      highestPoint[reps].set(currentPos);
    }
    //Check for current position being greater than current highest point and out of the minimum distance from start point.
    //If true this means the current point is the new highest point
    //Distance is set dynamically for each rep 
    if ( currentPos.y > highestPoint[reps].y && PVector.dist(startPoint, currentPos) > MIN_DIST ) {
      highestPoint[reps].set(currentPos);
      distance = 0.33f * PVector.dist(highestPoint[reps], startPoint);
    }
    //Check if the distance between the current point and the start point is less than distance 
    //If true this means the current point is close enough to the start point to set a new repetition
    if ( PVector.dist(startPoint, currentPos) < distance ) {
      println("Reps " + reps + highestPoint[reps].x + " : " + highestPoint[reps].y + " : " + highestPoint[reps].z);
      reps++;
      //If repitions are equal or greater than max reps set finished to true
      if ( reps >= MAX_REPS ) {
        finished = true;
      } 
      //Else reset highest point and distance, this means the current point wil be going back up towards the last 
      //highest point and distance will be reset once the current point starts coming back down.
      else {
        highestPoint[reps].set(currentPos);
        distance = 0.f;
      }
    }
    //Set last time to curTime to be used on the next loop.
    lastTime = curTime;
    popMatrix();
  }

  //Called when reps >= Max reps set from exercise information from database.
  public void stopExercise() {
    //If stopTime is true set time completed. 
    //stopTime then set to flase so this is only run once.
    if (stopTime) {
      timeCompleted = int(((System.currentTimeMillis() - startTime)/1000));
      stopTime = false;
    }
    //Loop through highestpoints y values and create an average highestpoint to use as score
    float average = 0;
    for ( int i = 0 ; i < reps ; i++ ) {
      average  = average +  highestPoint[i].y;
    }
    //Calculate score by taking average away from start point and changing to + number
    //Because this is a leg exercise and the center of the screen is 0,0 the current 
    //point would usually return a minus number
    float temp_score  = (int) average / reps;
    score = int(((startPoint.y - temp_score)*-1));
    //Destroy message and create a final message.
    message.destroy();                                        
    message = new Message(550, 300, new PVector(325, 100), "Well Done."  + "\n\nTime to Complete: " + timeCompleted + " seconds" + "\n\nScore: " + score/10 + " points", 24);
    message.create("eg", "el");
    messageTwo.destroy();
    messageTwo = new Message(0, 0, new PVector(10, 978), "");
    messageTwo.create("z2", "x2");
    messageThree.destroy();
    messageThree = new Message(0, 0, new PVector(70, 978), "");
    messageThree.create("w", "y");
    //Call add to records. 
    addToRecords();
  }

  //Function to add exercise data to records tables in database
  public void addToRecords() {
    //Get current date in correct format for database
    DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
    Date currentDate = new Date();
    int date = int(dateFormat.format(currentDate));
    //If enterData is true, create new instance of RecordDAO, call HTTP POST request to database
    //Insert new record, set enterData to true so function is only called once. 
    if (enterData) {
      Record newRecord = new Record(0, userId, exerciseId, date, timeCompleted, reps, score, "Error");
      recordDAO.setRecord(newRecord);
      enterData = false;
    }
  }

  //Draws UI 
  void drawUI() {
    //Message drawUI called cp5 drawUI, all cp5 elements are drawn.
    message.drawUI();
    //Timer to cancel exercise incase user have left.
    //Set deleteExerciseScreenOne to true in main file, used in function checkForScreensToDelete
    //Call menu back
    if (((System.currentTimeMillis() - timeOut) / 1000) > 120) {
      println(((System.currentTimeMillis()/1000) - startTime));
      context.deleteExerciseScreenThree = true;
      menuBack();
    }
  }

  //this function returns true if the exercise is complete
  public boolean checkForComplete() {
    return finished;
  }

  //this function is called by the RedPanda file when the check for complete returns true
  public void startFinishTimer() {
    //if the timer hasnt been started already, finishedTimeStarted is not true
    if (!finishedTimerStarted) { //create timer
      println("started");
      finishStartTime = System.currentTimeMillis() /1000; //get the current time
      finishedTimerStarted = true; //set the finishedTimeStarted variable to true so the finishStart time is not set on next check
    } 
    else { //if timer started is true check timer
      println(10 -((System.currentTimeMillis()/1000) - finishStartTime) );
      if ((System.currentTimeMillis()/1000) - finishStartTime > 10) { //if 10 seconds has passed
        context.autoMoveToExerciseScreen(); //call this function in the RedPanda class to advance to the next exercise
      }

      //draw cancel button
      buttons[2].setVisible(true);
      //destroy the previous continue message
      continueMessage.destroy(); 
      //create a new message showing the current time left until the autoMoveToScreenThree function is going to be called                                                             
      continueMessage = new Message(550, 50, new PVector(325, 410), "Next exercise in "+ (10 -((System.currentTimeMillis()/1000) - finishStartTime)) + " seconds, use Cancel to quit.", 24);
      continueMessage.create("zz", "tt");
    }
  }

  //Detroy called when moving to new screen.
  void destroy() {
    //Remove all buttons from buttons array
    for ( int i = 0 ; i < buttons.length ; i++ ) {
      buttons[i].remove();
      buttons[i] = null;
    }

    //Remove exerciseGroup from cp5 element.
    //Destroy all messages.
    cp5.getGroup("exerciseGroup3").remove();
    message.destroy();
    messageTwo.destroy();
    messageThree.destroy();
    continueMessage.destroy();
  }



  ////////////////////////////////////////////////////////////////////////////
  //SKELETON DRAWING
  void trackSkeleton(SimpleOpenNI kinect) {

    // update the camera
    kinect.update();
    //get user list
    kinect.getUsers(userList);
    if (userList.size() > 0) {
      //Get user id of first user
      int trackingUserId = userList.get(0);
      //If is tracking, draw user
      if (kinect.isTrackingSkeleton(trackingUserId)) {
        drawSkeleton(trackingUserId);
      }
    }
  }


  // draw the skeleton with the selected joints
  void drawSkeleton(int trackingUserId) {
    //Push Matrix, translations to draw objects in the centre of the sceen.
    pushMatrix();
    lights();
    noStroke();
    translate(width/2, height/2, 0);
    rotateX(radians(180));
    PVector p1 = new PVector();
    PVector p2 = new PVector();
    float radius;

    //Get Vector points for left shoulder and left elbow
    kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_LEFT_SHOULDER, p1);
    kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_LEFT_ELBOW, p2);
    //Create new limb instance, send in left shoulder and left elbow joints
    Limb testLimb = new Limb(p1, p2, 0.3f, 0.3f);
    //limb.draw() draws the limb and returns the radius of the shpere used to draw the limb
    //That value is used as the radius for the joint sphere
    radius = testLimb.draw();
    //Create new Joint instance, send in left shoulder and radius returned.
    Joint joint = new Joint(p1, radius);
    //draw joint
    joint.draw();
    //Reset joint to send in left elbow and radius
    joint = new Joint(p2, radius);
    //draw joint
    joint.draw();

    p1.set(p2);
    kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_LEFT_HAND, p2);
    testLimb = new Limb(p1, p2, 0.3f, 0.3f);
    radius = testLimb.draw();
    joint = new Joint(p2, radius);
    joint.draw();

    //right arm
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

    //left leg
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


    //right leg
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

    //torso
    PVector p3 = new PVector();
    kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_NECK, p1);
    kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_LEFT_HIP, p2);
    kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_RIGHT_HIP, p3);
    // fiddle with offset here
    testLimb = new Limb(p1, new PVector((p2.x+p3.x)/2.f, (p2.y+p3.y)/2.f, (p2.z+p3.z)/2.f), 0.7f, 0.7f );
    testLimb.draw();

    //head
    kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_NECK, p1);
    kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_HEAD, p2);

    p2.add(0, 100, 0);
    testLimb = new Limb(p1, p2, 0.7f, 0.5f);
    radius = testLimb.draw();
    joint = new Joint(p1, radius);
    joint.draw();
    kinect.getJointPositionSkeleton(trackingUserId, SimpleOpenNI.SKEL_RIGHT_FOOT, currentPos);
    popMatrix();
  }
}

