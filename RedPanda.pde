import controlP5.*;
import SimpleOpenNI.*;
import gifAnimation.*;

//initialise kinect
SimpleOpenNI kinect;

ControlP5 cp5;
Group g1;
Group g2;
//login text fields
Textfield userNameTextField;
Textfield passwordTextField;
//login stored user name and password
String loginUserName = "";
String loginPassword = "";
//create screens
LoginScreen loginScreen  = new LoginScreen(this);
MenuScreen menuScreen  = new MenuScreen(this);
ProgramsScreen programsScreen = new ProgramsScreen(this);
ProfileScreen profileScreen = new ProfileScreen(this);
ProgressScreen progressScreen = new ProgressScreen(this);
CommentsScreen commentsScreen = new CommentsScreen(this);
ExerciseScreen exerciseScreen = new ExerciseScreen(this);
//main objects
User user;
Programme programme;

//integer for swithching scenes/rooms
int currentScene;
//user tracking variables
boolean loading = false;
//PImage[] animation;
Gif loadingIcon;
PImage leftHandIcon;
PImage rightHandIcon;
PVector leftHand = new PVector();
PVector rightHand = new PVector();
PVector convertedLeftJoint = new PVector();
PVector convertedRightJoint = new PVector();
PImage backgroundImage;

//boolean deleteScreen = false;
boolean deleteLoginScreen = false;
boolean deleteMenuScreen = false;
boolean deleteProfileScreen = false;
boolean deleteProgramsScreen = false;
boolean deleteProgressScreen = false;
boolean deleteExerciseScreen = false;
boolean deleteCommentsScreen = false;

void setup() {
        size(1200, 600);
        textAlign(CENTER, CENTER);
        rightHandIcon = loadImage("images/righthand.png");
        leftHandIcon = loadImage("images/lefthand.png");
        loadingIcon = new Gif(this, "images/loading.gif");
        //animation = Gif.getPImages(this, "images/loading.gif");
        //load background image
        backgroundImage = loadImage("images/background.png");
        cp5 = new ControlP5(this);

        kinect = new SimpleOpenNI(this);
        if (kinect.isInit() == false)
        {
                println("Can't init SimpleOpenNI, maybe the camera is not connected!");
                exit();
                return;
        }

        // enable depthMap generation
        kinect.enableDepth();

        // enable skeleton generation for all joints
        kinect.enableUser();
        //create and draw the login screen
        loginScreen.loadImages();
        menuScreen.loadImages();
        programsScreen.loadImages();
        profileScreen.loadImages();
        progressScreen.loadImages();
        commentsScreen.loadImages();
        exerciseScreen.loadImages();
        loginScreen.drawScreen();
        currentScene = 0; //go to login scene
}

void draw() {
        switch (currentScene) {

        case 0: //login screen
                checkForScreensToDelete();   
                loginScreen.drawFade(); //fades out error messeges                
                break;

        case 1: //menu screen
                checkForScreensToDelete();                
                background(backgroundImage);
                menuScreen.drawUI();
                pushMatrix();
                scale(2.5);
                trackUser();
                popMatrix();
                menuScreen.checkBtn(convertedLeftJoint, convertedRightJoint);
                break;

        case 2: //programmes screen
                checkForScreensToDelete(); 
                background(backgroundImage);
                programsScreen.drawUI();
                pushMatrix();
                scale(2.5);
                trackUser();
                popMatrix();
                programsScreen.checkBtn(convertedLeftJoint, convertedRightJoint);
                break;

        case 3: //profile screen
                checkForScreensToDelete(); 
                background(backgroundImage);
                menuScreen.drawUI();
                profileScreen.drawUI();
                pushMatrix();
                scale(2.5);
                trackUser();
                popMatrix();
                break;

        case 4: //progress screen
                checkForScreensToDelete(); 
                background(backgroundImage);
                progressScreen.drawUI();
                pushMatrix();
                scale(2.5);
                trackUser();
                popMatrix();
                progressScreen.checkBtn(convertedLeftJoint, convertedRightJoint);
                break;

        case 5: //comments screen
                checkForScreensToDelete(); 
                background(backgroundImage);
                commentsScreen.drawUI();
                pushMatrix();
                scale(2.5);
                trackUser();
                popMatrix();
                commentsScreen.checkBtn(convertedLeftJoint, convertedRightJoint);
                break;

        case 6: //exercise screen? or screens?
                checkForScreensToDelete(); 
                background(backgroundImage);
                exerciseScreen.drawUI();
                trackUser();
                trackSkeleton();
                exerciseScreen.checkBtn(convertedLeftJoint, convertedRightJoint);
                break;
        }
}



//////////////////////////////////////////////////////////////////////
///BUTTONS PRESSED ACTIONS///////////////////////////////////////////

public void controlEvent(ControlEvent theEvent) {
        //tells you what controller was called
        println(theEvent.getController().getName());

        if (theEvent.getController().getName().equals("log in")) { //f the button was the log in button
                //get the values from the username and password fields
                loginUserName = cp5.get(Textfield.class, "userName").getText();
                loginPassword = cp5.get(Textfield.class, "password").getText();
                //create a new user connection object and try log in with the given details
                UserDAO userDAO = new UserDAO();
                user = userDAO.logIn(loginUserName, loginPassword);

                if (user.getUser_id() != -1 && currentScene == 0) { //if the user is logged in and theyre in the loggin screen
                        println("Logged IN");
                        //get exercise programme
                        ProgrammeDAO programmeDAO = new ProgrammeDAO(user.getUser_id());
                        programme = programmeDAO.getProgramme();
                        //println("create date: " + programme.getCreate_date());
                        //get the exercise objects and add them to the programme object.
                        //ExerciseDAO exerciseDAO = new ExerciseDAO(programme.getProgramme_id());
                        //programme.setExercises(exerciseDAO.getExercisesByProgrammeID);
                        
                        //loginScreen.destroy();
                        deleteLoginScreen = true;
                        menuScreen.create();
                        currentScene = 1;
                } 
                else { //user is not logged in
                        loginScreen.displayError("Incorrect login details");
                }
        }

        if (theEvent.getController().getName().equals("programme")) {
                makeProgramme();
        }

        if (theEvent.getController().getName().equals("exerciseOne")) {
                makeExerciseOne();
        }

        if (theEvent.getController().getName().equals("profile")) {
                makeProfile();
        }

        if (theEvent.getController().getName().equals("profileClose")) {
                makeProfileClose();
        }

        if (theEvent.getController().getName().equals("progress")) {
                makeProgress();
        }

        if (theEvent.getController().getName().equals("comments")) {
                makeComments();
        }

        if (theEvent.getController().getName().equals("menuBackProgrammes") || theEvent.getController().getName().equals("menuBackExercises") || theEvent.getController().getName().equals("menuBackProgress") || theEvent.getController().getName().equals("menuBackComments")) {
               menuBack();
        }

        if (theEvent.getController().getName().equals("logout") || theEvent.getController().getName().equals("logoutPrograms") || theEvent.getController().getName().equals("logoutProgress") || theEvent.getController().getName().equals("logoutComments") || theEvent.getController().getName().equals("logoutExercise")) {
                makeLogout();
        }
}

//////////////////////////////////////////////////////////////////////////
//BUTTON FUNCTIONS
void makeProgramme() {
        menuScreen.destroy(); 
        programsScreen.create();
        currentScene = 2;
}

void makeExerciseOne() {
        //programsScreen.destroy();
        deleteProgramsScreen = true;
        exerciseScreen.create();
        currentScene = 6;
}

void makeProfile() {
        profileScreen.create();
        currentScene = 3;
}

void makeProfileClose() {
        deleteProfileScreen = true;
        menuScreen.create();
        currentScene = 1;
}

void makeProgress() {
        deleteMenuScreen = true;
        progressScreen.create();
        currentScene = 4;
}

void makeComments() {
        deleteMenuScreen = true;
        commentsScreen.create();
        currentScene = 5;
}


void menuBack() {
        //depending on where you go back from from delete the relavant screen
        if (currentScene == 2) { //programmes screen
                deleteProgramsScreen = true;
        }else if (currentScene == 4) { //progress screen
                deleteProgressScreen = true;
        }else if (currentScene == 5) { //comments screen
                deleteCommentsScreen = true;
        }else if (currentScene == 6) { //exercise screen
                deleteExerciseScreen = true;
        }  
        //draw the lmenu screen again
        currentScene = 1;
        menuScreen.create();
        deleteMenuScreen = false;
        
}

void makeLogout() {
        //depending on where you log out from delete the relavant screen
        if (currentScene == 1) { //menu  screen
                deleteMenuScreen = true;
        } else if (currentScene == 2) { //programmes screen
                deleteProgramsScreen = true;
        } else if (currentScene == 3) { //profile screen
                deleteProfileScreen = true;
        } else if (currentScene == 4) { //progress screen
                deleteProgressScreen = true;
        }  else if (currentScene == 5) { //comments screen
                deleteCommentsScreen = true;
        }  else if (currentScene == 6) { //exercise screen
                deleteExerciseScreen = true;
        }  
        //draw the login screen again
        loginScreen.drawScreen();
        currentScene = 0;
}

void checkForScreensToDelete() {
        if (deleteLoginScreen == true) {
                loginScreen.destroy();
                deleteLoginScreen = false;
        } else if (deleteMenuScreen == true){
                menuScreen.destroy();
                deleteMenuScreen = false;
        } else if (deleteProfileScreen == true) {
                profileScreen.destroy();
                deleteProfileScreen = false;
        } else if (deleteProgramsScreen == true) {
                programsScreen.destroy();
                deleteProgramsScreen = false;
        } else if (deleteProgressScreen == true) {
                progressScreen.destroy();
                deleteProgressScreen = false;
        } else if (deleteExerciseScreen == true) {
                exerciseScreen.destroy();
                deleteExerciseScreen = false;
        } else if (deleteCommentsScreen == true) {
                commentsScreen.destroy();
                deleteCommentsScreen = false;
        }
}


///////////////////////////////////////////////////////////////////////////
//HAND TRACKING///////////////////////////////////////////////////////////

void trackUser() {

        // update the cam
        kinect.update();

        IntVector userList = new IntVector();
        kinect.getUsers(userList);
        if (userList.size() > 0) {
                int userId = userList.get(0);

                if (kinect.isTrackingSkeleton(userId)) {

                        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
                        kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
                        drawLeftJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
                        drawRightJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
                }
        }
}

void drawLeftJoint(int userId, int jointID) {
        PVector leftJoint = new PVector();
        float confidence = kinect.getJointPositionSkeleton(userId, jointID, leftJoint);
        kinect.convertRealWorldToProjective(leftJoint, convertedLeftJoint);
        if(loading == true){
        loadingIcon.play();
        image(loadingIcon, convertedLeftJoint.x-10, convertedLeftJoint.y-10, 20, 20);    
        }else{
        loadingIcon.pause();
        image(leftHandIcon, convertedLeftJoint.x-10, convertedLeftJoint.y-10, 20, 20);
        }
}

void drawRightJoint(int userId, int jointID) {
        PVector rightJoint = new PVector();
        float confidence = kinect.getJointPositionSkeleton(userId, jointID, rightJoint);
         kinect.convertRealWorldToProjective(rightJoint, convertedRightJoint);
        if(loading == true){
        loadingIcon.play();
        image(loadingIcon, convertedRightJoint.x-10, convertedRightJoint.y-10, 20, 20);  
        }else{
        loadingIcon.pause();
        image(rightHandIcon, convertedRightJoint.x-10, convertedRightJoint.y-10, 20, 20);
        }
}


void loaderOn(){
   loading = true;
}

void loaderOff(){
    loading = false;
}
////////////////////////////////////////////////////////////////////////////
//SKELETON DRAWING
void trackSkeleton() {

        // update the cam
        kinect.update();

        IntVector userList = new IntVector();
        kinect.getUsers(userList);
        if (userList.size() > 0) {
                int userId = userList.get(0);

                if (kinect.isTrackingSkeleton(userId)) {

                        strokeWeight(5);
                        stroke(255, 0, 0);
                        println("tracoking user");
                        drawSkeleton(userId);
                }
        }
}


// draw the skeleton with the selected joints
void drawSkeleton(int userId) {
        println("drawing skeleton");

        kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

        kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

        kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

        kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

        kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
        kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
}

//////////////////////////////////////////////////////////////////////////
        //USER TRACKING functions
        void onNewUser(SimpleOpenNI curContext, int userId)
        {
            println("onNewUser - userId: " + userId);
            println("\tstart tracking skeleton");
            
            curContext.startTrackingSkeleton(userId);
        }
        
        void onLostUser(SimpleOpenNI curContext, int userId)
        {
            println("onLostUser - userId: " + userId);
        }
        
        void onVisibleUser(SimpleOpenNI curContext, int userId)
        {
            //println("onVisibleUser - userId: " + userId);
        }

