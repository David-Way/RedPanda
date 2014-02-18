import processing.opengl.*;

import controlP5.*;
import SimpleOpenNI.*;
import gifAnimation.*;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;

import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.client.HttpClient;

import java.lang.reflect.Array;
import java.lang.reflect.GenericArrayType;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.lang.reflect.TypeVariable;

//initialise kinect
SimpleOpenNI kinect;

//initialise UI objects for the cp5 library
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
ErrorScreen errorScreen = new ErrorScreen(this);
LoginScreen loginScreen  = new LoginScreen(this);
MenuScreen menuScreen  = new MenuScreen(this);
ProgramsScreen programsScreen = new ProgramsScreen(this);
ProfileScreen profileScreen = new ProfileScreen(this);
ProgressScreen progressScreen = new ProgressScreen(this);
CommentsScreen commentsScreen = new CommentsScreen(this);
ExerciseScreenOne  exerciseScreenOne = new ExerciseScreenOne(this);
XMLExerciseClassOptimised xmlExercise = new XMLExerciseClassOptimised(this);
ExerciseScreenThree exerciseScreenThree = new ExerciseScreenThree(this);
//main objects
User user;
Programme programme;
Record record;
Message message;

//integer for swithching scenes/rooms
int currentScene;
//user tracking variables
boolean loading = false;
Gif loadingIcon;
PImage leftHandIcon;
PImage rightHandIcon;
PVector leftHand = new PVector();
PVector rightHand = new PVector();
PVector convertedLeftJoint = new PVector();
PVector convertedRightJoint = new PVector();
PImage backgroundImage;
PImage backgroundImage2;

//variables for removing screens on next frame
boolean deleteErrorScreen = false;
boolean deleteLoginScreen = false;
boolean deleteMenuScreen = false;
boolean deleteProfileScreen = false;
boolean deleteProgramsScreen = false;
boolean deleteProgressScreen = false;
boolean deleteExerciseScreenOne = false;
boolean deleteExerciseScreenTwo = false;
boolean deleteExerciseScreenThree = false;
boolean deleteCommentsScreen = false;

ArrayList<Exercise> e = new ArrayList<Exercise>();

void setup() {
        //basic sketch setup functions
        size(1200, 600, P3D);
        frameRate(30);
        //textMode(SHAPE);
        textAlign(CENTER, CENTER);
        //hand tracking image loading
        rightHandIcon = loadImage("images/righthand.png");
        leftHandIcon = loadImage("images/lefthand.png");
        loadingIcon = new Gif(this, "images/loading.gif");
        //animation = Gif.getPImages(this, "images/loading.gif");
        //load background image
        backgroundImage = loadImage("images/background.png");
        backgroundImage2 = loadImage("images/background2.png");
        cp5 = new ControlP5(this);
        
        //load screen assets
        errorScreen.loadImages();
        loginScreen.loadImages();
        menuScreen.loadImages();
        programsScreen.loadImages();
        profileScreen.loadImages();
        progressScreen.loadImages();
        commentsScreen.loadImages();
        exerciseScreenOne.loadImages();
        xmlExercise.loadImages();
        exerciseScreenThree.loadImages();
        //loginScreen.create();
        //loginScreen.drawUI();
        //errorScreen.create();
        currentScene = -1; //go to login scene
        //initialise the kinect using SimpleOpenNI library 
        kinect = new SimpleOpenNI(this);
        // enable depthMap generation
        kinect.enableDepth();
        // enable skeleton generation for all joints
        kinect.enableUser();
        //create and draw the login screen
        System.out.println("connected");
        //deleteLoginScreen = true;
}

void draw() {
        switch (currentScene) {
        case -1: //error screen
                if (kinect.isInit() == false) {
                        println("Can't init SimpleOpenNI, maybe the camera is not connected!");
                        //exit();
                        //return;
                        errorScreen.drawUI();
                } 
                else {
                        currentScene = 0;
                        deleteErrorScreen = true;
                        loginScreen.create();
                }
                break;

        case 0: //login screen
                checkForScreensToDelete();
                loginScreen.drawFade(); //fades out error messages   
                loginScreen.drawUI();             
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
                menuScreen.checkBtn(convertedLeftJoint, convertedRightJoint);
                profileScreen.checkBtn(convertedLeftJoint, convertedRightJoint);
                break;

        case 4: //progress screen
                checkForScreensToDelete(); 
                background(backgroundImage2);
                progressScreen.drawUI();
                //pushMatrix();
                //scale(2.5);
                //trackUser();
                //popMatrix();
                //progressScreen.checkBtn(convertedLeftJoint, convertedRightJoint);
                break;

        case 5: //comments screen
                checkForScreensToDelete(); 
                background(backgroundImage2);
                commentsScreen.drawUI();
                //pushMatrix();
                //scale(2.5);
                //trackUser();
                //popMatrix();
                //commentsScreen.checkBtn(convertedLeftJoint, convertedRightJoint);
                break;

        case 6: //exercise screen? or screens?
                checkForScreensToDelete();
                background(backgroundImage2);
                exerciseScreenOne.drawUI(); 
                exerciseScreenOne.startExercise(kinect);
                break;

        case 7://xml exercise
                checkForScreensToDelete();
                background(backgroundImage2);
                xmlExercise.drawUI(false); //parameter true to draw debug HUD
                break;

         case 8: //exercise screen? or screens?
                checkForScreensToDelete();
                background(backgroundImage2);
                exerciseScreenThree.drawUI(); 
                exerciseScreenThree.startExercise(kinect);
                break;
        }
}



//////////////////////////////////////////////////////////////////////
///BUTTONS PRESSED ACTIONS///////////////////////////////////////////

public void controlEvent(ControlEvent theEvent) {
        //tells you what controller was called
    
        println(">/>"+ theEvent.getController().getName());

        //Loop  to check if any of the dynamic buttons created in the comments screen have been clicked. 
        //If this was the event clicked, get the button value and send as parameter to buttonClicked function in
        //comments screen to do GET request for comments with that exercise id
        for( int i = 0; i < e.size(); i++){
            if(theEvent.controller().name().equals("button" + i)){
                 commentsScreen.buttonClicked(theEvent.controller().value());
            }
        }

        if (theEvent.getController().getName().equals("log in")) { //f the button was the log in button
                //get the values from the username and password fields
                loginUserName = cp5.get(Textfield.class, "userName").getText();
                loginPassword = cp5.get(Textfield.class, "password").getText();
                //create a new user connection object and try log in with the given details
                UserDAO userDAO = new UserDAO();
                user = userDAO.logIn(loginUserName, loginPassword);
                //println("dob: " +user.getDob() +  " -injury type: " + user.getInjury_type());
                if (user.getUser_id() != -1 && currentScene == 0) { //if the user is logged in and theyre in the loggin screen
                        println("Logged IN");
                        //get exercise programme
                        try{
                        ProgrammeDAO programmeDAO = new ProgrammeDAO(user.getUser_id());
                        programme = programmeDAO.getProgramme();
                        //println("create date: " + programme.getCreate_date());
                        //get the exercise objects and add them to the programme object.
                        }
                       catch (Exception ex) {
                                System.out.println("Programs not retrieved/set");
                        }
                        try {
                                ExerciseDAO exerciseDAO = new ExerciseDAO();
                                e = exerciseDAO.getExercises(programme.getProgramme_id());
                                programme.setExercises(e);    
                                //System.out.println(">/>" + programme.getExercises().get(0).getName());
                        } 
                        catch (Exception ex) {
                                System.out.println("exercises not retrieved/set");
                        }
                        deleteLoginScreen = true;
                        try{
                        RecordDAO recordDAO = new RecordDAO();
                        record = recordDAO.getLastDone(user.getUser_id());
                        }catch (Exception ex) {
                                System.out.println("exercises not retrieved/set");
                        }
                        menuScreen.create(user, record);
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

        if (theEvent.getController().getName().equals("exerciseTwo")) {
                makeExerciseTwo();
        }

         if (theEvent.getController().getName().equals("exerciseThree")) {
                makeExerciseThree();
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

        if (theEvent.getController().getName().equals("menuBackProgrammes") || theEvent.getController().getName().equals("menuBackExercises") || theEvent.getController().getName().equals("menuBackExercise3")  || theEvent.getController().getName().equals("menuBackExercises2") || theEvent.getController().getName().equals("menuBackProgress") || theEvent.getController().getName().equals("menuBackComments")) {
                menuBack();
        }

        if (theEvent.getController().getName().equals("logout") || theEvent.getController().getName().equals("logoutPrograms") || theEvent.getController().getName().equals("logoutProgress") || theEvent.getController().getName().equals("logoutComments") || theEvent.getController().getName().equals("logoutExercise") || theEvent.getController().getName().equals("logoutExercise2") || theEvent.getController().getName().equals("logoutExercise3") ) {
                makeLogout();
        }
        
        if (theEvent.getController().getName().equals("nextChart")) {
                progressScreen.nextChartPressed();
        }
        
        if (theEvent.getController().getName().equals("previousChart")) {
                progressScreen.previousChartPressed();
        }
}

void keyPressed() {

        if (key == 'r') {
                if (currentScene == 7) { //if during exercise 2
                        xmlExercise.toggleRecording();
                        System.out.println("r");
                }
        } 
        else if (key == 's') {
                if (currentScene == 7) { //if during exercise 2
                        xmlExercise.savePressed();
                }
        } 
        else if (key == 'l') {
                if (currentScene == 7) { //if during exercise 2
                        xmlExercise.loadPressed();
                }
        }
}

//////////////////////////////////////////////////////////////////////////
//BUTTON FUNCTIONS
void makeProgramme() {
        if (cp5.getGroup("profileGroup") != null) {
                deleteProfileScreen = true;
        }
        menuScreen.destroy(); 
        programsScreen.create();
        currentScene = 2;
}

void makeExerciseOne() {
        exerciseScreenOne = new ExerciseScreenOne(this);
        exerciseScreenOne.loadImages();
        deleteProgramsScreen = true;
        ArrayList<Exercise> e = new ArrayList<Exercise>();
        e = programme.getExercises();
        exerciseScreenOne.create(user, e.get(0));
        currentScene = 6;
}

void makeExerciseTwo() {
        deleteProgramsScreen = true;
        ArrayList<Exercise> e = new ArrayList<Exercise>();
        e = programme.getExercises();
        //load second exercise data
        xmlExercise = new XMLExerciseClassOptimised(this);
        xmlExercise.loadImages();
        xmlExercise.create(kinect, user, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND, e.get(1));
        xmlExercise.readXML(e.get(1).getName());
        currentScene = 7;
}

void makeExerciseThree() {
        exerciseScreenThree = new ExerciseScreenThree(this);
        exerciseScreenThree.loadImages();
        deleteProgramsScreen = true;
        ArrayList<Exercise> e = new ArrayList<Exercise>();
        e = programme.getExercises();
        exerciseScreenThree.create(user, e.get(2));
        currentScene = 8;
}

void makeProfile() {
        profileScreen.create();
        currentScene = 3;
}

void makeProfileClose() {
        deleteProfileScreen = true;
        menuScreen.create(user, record);
        currentScene = 1;
}

void makeProgress() {
        if (cp5.getGroup("profileGroup") != null) {
                deleteProfileScreen = true;
        }
        deleteMenuScreen = true;
        progressScreen.create(programme);
        currentScene = 4;
}

void makeComments() {
        if (cp5.getGroup("profileGroup") != null) {
                deleteProfileScreen = true;
        }
        deleteMenuScreen = true;
        commentsScreen.create(user, programme);
        currentScene = 5;
}


void menuBack() {
        //depending on where you go back from from delete the relavant screen
        if (currentScene == 2) { //programmes screen
                deleteProgramsScreen = true;
        }
        else if (currentScene == 4) { //progress screen
                deleteProgressScreen = true;
        }
        else if (currentScene == 5) { //comments screen
                deleteCommentsScreen = true;
        }
        else if (currentScene == 6) { //exercise screen
                deleteExerciseScreenOne = true;
        } 
       else if (currentScene == 7) { //exercise screen
                deleteExerciseScreenTwo = true;
        } 
        else if (currentScene == 8) { //exercise screen
                deleteExerciseScreenThree = true;
        }  
        //draw the lmenu screen again
        currentScene = 1;
        menuScreen.create(user, record);
        deleteMenuScreen = false;
}

void makeLogout() {
        //depending on where you log out from delete the relavant screen
        if (currentScene == 1) { //menu  screen
                deleteMenuScreen = true;
        } 
        else if (currentScene == 2) { //programmes screen
                deleteProgramsScreen = true;
        } 
        else if (currentScene == 3) { //profile screen
                deleteProfileScreen = true;
        } 
        else if (currentScene == 4) { //progress screen
                deleteProgressScreen = true;
        }  
        else if (currentScene == 5) { //comments screen
                deleteCommentsScreen = true;
        }  
        else if (currentScene == 6) { //exercise screen
                deleteExerciseScreenOne = true;
        }
        else if (currentScene == 7) { //exercise screen
                deleteExerciseScreenTwo = true;
        } 
        else if (currentScene == 8) { //exercise screen
                deleteExerciseScreenThree = true;
        } 
        //draw the login screen again
        currentScene = 0;
        //background(backgroundImage);
        loginScreen.create();
        deleteLoginScreen = false;
        //loginScreen.drawUI();   
        
}

void checkForScreensToDelete() {
        if (deleteErrorScreen == true) {
                errorScreen.destroy();
                deleteErrorScreen = false;
        } 
        else if (deleteLoginScreen == true) {
                loginScreen.destroy();
                deleteLoginScreen = false;
        } 
        else if (deleteMenuScreen == true) {
                menuScreen.destroy();
                deleteMenuScreen = false;
        } 
        else if (deleteProfileScreen == true) {
                profileScreen.destroy();
                deleteProfileScreen = false;
        } 
        else if (deleteProgramsScreen == true) {
                programsScreen.destroy();
                deleteProgramsScreen = false;
        } 
        else if (deleteProgressScreen == true) {
                progressScreen.destroy();
                deleteProgressScreen = false;
        } 
        else if (deleteExerciseScreenOne == true) {
                exerciseScreenOne.destroy();             
                deleteExerciseScreenOne = false;
        } 
        else if (deleteExerciseScreenTwo == true) {
                xmlExercise.destroy(); 
                deleteExerciseScreenTwo = false;
        }
        else if (deleteExerciseScreenThree == true) {
                exerciseScreenThree.destroy(); 
                deleteExerciseScreenThree = false;
        }        
        else if (deleteCommentsScreen == true) {
                commentsScreen.destroy();
                deleteCommentsScreen = false;
        }
}


///////////////////////////////////////////////////////////////////////////
//HAND TRACKING///////////////////////////////////////////////////////////

void trackUser() {
        // update the cam
        //kinect.update();
        if (kinect.enableUser() == true) { 
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
}

void drawLeftJoint(int userId, int jointID) {
        PVector leftJoint = new PVector();
        float confidence = kinect.getJointPositionSkeleton(userId, jointID, leftJoint);
        kinect.convertRealWorldToProjective(leftJoint, convertedLeftJoint);
        if (loading == true) {
                loadingIcon.play();
                image(loadingIcon, convertedLeftJoint.x-10, convertedLeftJoint.y-10, 20, 20);
        }
        else {
                loadingIcon.pause();
                image(leftHandIcon, convertedLeftJoint.x-10, convertedLeftJoint.y-10, 20, 20);
        }
}

void drawRightJoint(int userId, int jointID) {
        PVector rightJoint = new PVector();
        float confidence = kinect.getJointPositionSkeleton(userId, jointID, rightJoint);
        kinect.convertRealWorldToProjective(rightJoint, convertedRightJoint);
        if (loading == true) {
                loadingIcon.play();
                image(loadingIcon, convertedRightJoint.x-10, convertedRightJoint.y-10, 20, 20);
        }
        else {
                loadingIcon.pause();
                image(rightHandIcon, convertedRightJoint.x-10, convertedRightJoint.y-10, 20, 20);
        }
}


void loaderOn() {
        loading = true;
}

void loaderOff() {
        loading = false;
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

