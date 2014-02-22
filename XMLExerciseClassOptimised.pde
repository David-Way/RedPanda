
//import peasy.*;

class XMLExerciseClassOptimised {
  //PeasyCam cam;
  RedPanda parent;
  SimpleOpenNI context;
  User user;
  Exercise e;
  int [] jointID;
  int userID;
  ArrayList<ArrayList<PVector>> framesGroup = new ArrayList<ArrayList<PVector>>(3);
  ArrayList<PVector> framesOne;
  ArrayList<PVector> framesTwo;
  ArrayList<PVector> framesThree;

  private PImage[] menuBack = new PImage[3];
  private PImage[] logout = new PImage[3];
  private PImage[] cancel = new PImage[3];
  private Button []buttons;
  private Group exerciseGroup2;

  long startTime = 0;
  Message message;
  Message timerMessage;
  Message directionMessage;
  Message continueMessage;
  String exerciseName;
  float c = (float)0.0;
  float offByDistance = (float)0.0;
  int currentFrame = 0;
  int numberOfFrames = 0;
  int numberOfReps = 5;
  int currentRep = 0;
  boolean paused = false;
  boolean recording = false;
  boolean exerciseStarted = false;
  boolean exerciseComplete = false;
  Gif target;
  final int FONT_30 = 30;
  final int FONT_24 = 24;
  //set colours for user avatar
  color userColourRed = color(255, 0, 0);
  color userColourGreen = color(0, 255, 0);
  color userColourBlue = color(0, 0, 255);
  color userColourGrey = color(155, 155, 155);
  color userColourWhite = color(255, 255, 255);
  color currentUserColour = userColourWhite;

  boolean finishedTimerStarted = false;
  long finishStartTime = 0;

  PVector messagePosition = new PVector(10, 100);
  IntVector userList;

  XMLExerciseClassOptimised(RedPanda parent) {
    this.parent = parent;
    this.jointID = new int[3]; //holds the selected joints  

    //readXML("default");

    //create camera , arguments set point to look at and distance from that point
    //cam = new PeasyCam(parent, (double)0, (double)0, (double)0, (double)1000);
  }

  void create(SimpleOpenNI tempContext, User user, int tempJointIDOne, int tempJointIDTwo, int tempJointIDThree, Exercise ex) {
    target = new Gif(parent, "images/target.gif");
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

    exerciseGroup2 = cp5.addGroup("exerciseGroup2")
      .setPosition(0, 0)
        .hideBar()
          ;

    buttons = new Button[3];

    buttons[0] = cp5.addButton("menuBackExercises2")
      .setPosition(10, 10)
        .setImages(menuBack)
          .updateSize()
            .setGroup(exerciseGroup2)
              ;


    buttons[1] = cp5.addButton("logoutExercise2")
      .setPosition(978, 10)
        .setImages(logout)
          .updateSize()
            .setGroup(exerciseGroup2)
              ;

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
    //background(255, 255, 255);

    context.update();
    //message.drawUI();
    directionMessage.drawUI();
    //println(currentRep);

    if (drawHUD) {
      drawHeadsUpDisplay();
    }

    lights();
    noStroke();
    translate(width/2, height/2, 0);
    rotateX(radians(180));


    context.getUsers(userList);

    if (userList.size() > 0 && !exerciseComplete) {
      int userId = userList.get(0);
      setUser(userId);
      if ( context.isTrackingSkeleton(userId)) {
        if (!exerciseStarted) {
          startTime  = System.currentTimeMillis();
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

          drawExerciseSkeleton(userId);
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

  boolean checkUserCompliance(int userId) {
    boolean result = false;
    ArrayList<PVector> exercisePointsForCurrentFrame = getAdjustedPositions(new PVector(0, 0, 0));

    PVector c1 = new PVector();
    PVector c2 = new PVector();
    PVector c3 = new PVector();


    context.getJointPositionSkeleton(userId, jointID[2], c1);
    context.getJointPositionSkeleton(userId, jointID[1], c2);
    context.getJointPositionSkeleton(userId, jointID[0], c3);

    PVector p1 = exercisePointsForCurrentFrame.get(2);
    PVector p2 = exercisePointsForCurrentFrame.get(1);
    //PVector p3 = exercisePointsForCurrentFrame.get(0);

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



    PVector added1 = PVector.add(p1, c3);
    PVector added2 =  PVector.add(p2, c3);
    PVector flat1 = new PVector(added1.x, added1.y);
    PVector flat2 = new PVector(added2.x, added2.y);
    PVector flatA = new PVector(c1.x, c1.y);
    PVector flatB = new PVector(c2.x, c2.y);
    //c1.sub(added1);
    //c2.sub(added2);

    //if the distance between the points is less than 200 or the x and y is close but the z isnt.
    if ((flatA.dist(flat1) < 200  && flatB.dist(flat2) < 200)) { 
      result = true;
    } 
    return result;
  }

  void setUserColour(color c) {
    currentUserColour = c;
  }

  void setUser(int tempUserID) { 
    userID = tempUserID;
  }

  PVector getPosition(int joint) {
    return framesGroup.get(joint).get(currentFrame);
  }

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

    //record the torso joint position
    context.getJointPositionSkeleton(userID, jointID[0], positionAnchor);
    framesGroup.get(0).add(positionAnchor);

    for (int i = 1; i < 3; i++) {
      PVector positionPoint = new PVector();           
      context.getJointPositionSkeleton(userID, jointID[i], positionPoint);                        
      PVector differenceVector = PVector.sub( positionPoint, positionAnchor);
      framesGroup.get(i).add(differenceVector);
    }
  }

  void nextFrame() { 
    if (!paused) {
      currentFrame++;
      if (currentFrame == framesGroup.get(0).size()) { 
        currentFrame = 0;
        currentRep++;
        //PVector pos = new PVector(10, 100);
        if (currentRep < numberOfReps) {        
          message.destroy();                            
          message = new Message(209, 280, messagePosition, "Target Reps: " + e.getRepetitions() + "\n\nCurrent Rep: " + currentRep + "\n\nComplete: " + (int)Math.round(100.0 / numberOfReps * currentRep) + "%" +"\n\nDescription:\n" + e.getDescription());
          message.create("mgroup", "lname");
        } 
        else if (!exerciseComplete) { //on exercise complete
          long elapsedTime = (System.currentTimeMillis() - startTime) / 1000;
          int score = (int)(numberOfReps*100/elapsedTime*10);
          String scoreFeedback = "";
          String timeFeedback = "";

          if (score < 300) {
            scoreFeedback = "Your score isnt bad, but there is room for improvement, keep at it!";
          } 
          else if (score >= 300 &&  score < 650) {
            scoreFeedback = "Your score is very good. Nice work!";
          } 
          else {
            scoreFeedback = "Excellent score, you're really improving.";
          }

          if (elapsedTime < 15) {
            timeFeedback = "You completed the exercise very quickly.";
          } 
          else if (elapsedTime >= 15 &&  elapsedTime < 45) {
            timeFeedback = "You finished the exercise at a good pace.";
          } 
          else {
            timeFeedback = "Try to finish a little faster next time if you can.";
          }

          timerMessage.destroy();
          timerMessage = new Message(240, 0, new PVector(1950, 100), "");
          timerMessage.create("a", "b");
          directionMessage.destroy();
          directionMessage = new Message(240, 0, new PVector(1950, 400), "");
          directionMessage.create("c", "d");

          message.destroy();                                        
          message = new Message(550, 300, new PVector(325, 100), "Well Done!"  + "\n\nTime to Complete: " + elapsedTime + " seconds" + "\n\nScore: " + score/10 + " points \n\n" + scoreFeedback + "\n\n" + timeFeedback, FONT_24);
          message.create("mgroup", "lname");
          //message.destroy();
          exerciseComplete = true;
          DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
          Date currentDate = new Date();
          int date = int(dateFormat.format(currentDate));

          RecordDAO dao = new RecordDAO();
          dao.setRecord(new Record(0, user.getUser_id(), e.getExercise_id(), date, (int)elapsedTime, numberOfReps, score, "Error"));
          exerciseComplete = true;
        }
      }
    }
  }

  void drawHeadsUpDisplay() { //used for debugiing
    pushMatrix();
    // create hud
    fill(0);
    text("totalFrames: " + framesGroup.get(0).size(), 5, 10);
    text("recording: " + recording, 5, 24);
    text("currentFrame: " + currentFrame, 5, 38 );
    popMatrix();
  }

  void loadImages() {
    //load images  for buttons
    this.menuBack[0]  = loadImage("images/NewUI/menu.jpg");
    this.menuBack[1]  = loadImage("images/NewUI/menuOver.jpg");
    this.menuBack[2]  = loadImage("images/NewUI/menu.jpg");
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

  void savePressed() { //save the recordedexercise
    writeXML("right arm curl");
  }

  void readXML(String fileName) { //reads the xml docment of the given name
    currentFrame = 0;
    paused = true;
    framesGroup = null;
    framesGroup = new ArrayList<ArrayList<PVector>>(3);
    framesOne = new ArrayList<PVector>();
    framesTwo = new ArrayList<PVector>();
    framesThree = new ArrayList<PVector>();


    framesGroup.add(framesOne);
    framesGroup.add(framesTwo);
    framesGroup.add(framesThree);

    //String pathName = "C:\\Users\\David\\Documents\\Processing\\movementRecorderClass\\" + "xml-exercises\\" + fileName + ".xml";
    String pathName = sketchPath("xml-exercises") + "\\" + fileName  + ".xml";


    Document dom;
    // Make an  instance of the DocumentBuilderFactory
    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
    try {
      // use the factory to take an instance of the document builder
      DocumentBuilder db = dbf.newDocumentBuilder();
      // parse using the builder to get the DOM mapping of the    
      // XML file
      dom = db.parse(pathName);
      dom.getDocumentElement().normalize();
      NodeList joints = dom.getElementsByTagName("joint");

      System.out.println("Root element :"  
        + dom.getDocumentElement().getNodeName());

      for (int i = 0; i < joints.getLength(); i++) {

        Node joint = joints.item(i);
        NodeList frames = joint.getChildNodes();
        for (int j = 0; j < frames.getLength(); j++) {
          Node frameNode = frames.item(j);
          Element frame = (Element) frameNode; 
          framesGroup.get(i).add(new PVector(Integer.parseInt(frame.getAttribute("xpos").toString()), Integer.parseInt(frame.getAttribute("ypos")), Integer.parseInt(frame.getAttribute("zpos"))));
        }
      }

      Element doc = dom.getDocumentElement();

      currentFrame = 0;
      paused = false;
      System.out.println(fileName + " loaded.");
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }


  public void writeXML(String fileName) { //writes xml file of given name
    try {
      //String pathName =  "C:\\Users\\David\\Documents\\Processing\\movementRecorderClass\\" + "xml-exercises\\" + fileName;
      String pathName = sketchPath("xml-exercises") + "\\" + fileName + ".xml";
      DocumentBuilderFactory documentFactory = DocumentBuilderFactory
        .newInstance();
      DocumentBuilder documentBuilder = documentFactory
        .newDocumentBuilder();

      // define root elements
      Document document = documentBuilder.newDocument();
      Element rootElement = document.createElement("exercise");
      document.appendChild(rootElement);

      for (int j = 0; j < 3; j++) {
        Element joint = document.createElement("joint");
        rootElement.appendChild(joint);
        Attr jointNumber = document.createAttribute("jointnumber");
        jointNumber.setValue(Integer.toString(j));
        joint.setAttributeNode(jointNumber);

        for (int i = 0; i < framesGroup.get(j).size(); i++) {

          Element f = document.createElement("frame");
          joint.appendChild(f);

          // add attributes to school
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

      // creating and writing to xml file
      TransformerFactory transformerFactory = TransformerFactory
        .newInstance();
      Transformer transformer = transformerFactory.newTransformer();
      DOMSource domSource = new DOMSource(document);
      StreamResult streamResult = new StreamResult(new File(pathName));

      transformer.transform(domSource, streamResult);


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

  void destroy() {
    println("destroying xml exercise");
    for ( int i = 0 ; i < buttons.length ; i++ ) {
      buttons[i].remove();
      buttons[i] = null;
    }
    cp5.getGroup("exerciseGroup2").remove();
    message.destroy();
    timerMessage.destroy();
    directionMessage.destroy();
    continueMessage.destroy();
    //System.gc();
  }
}

