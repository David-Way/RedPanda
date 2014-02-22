//Red Panda is a physiotherapy application created using the 
//processing language and the OpenNI libraries for the Microsoft Kinect
//Contributors: Emer Mooney and David Way
//Supervisors: Joachim Pietsch and Andrew Errity

//program imports
import processing.opengl.*;

import controlP5.*;
import SimpleOpenNI.*;
import gifAnimation.*;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.text.SimpleDateFormat; 

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

import java.text.DateFormat;
import java.util.Date;
import java.awt.Color;
import java.awt.Font;
import java.awt.Paint;
import java.math.BigDecimal;
import java.awt.Shape;
import java.awt.geom.Rectangle2D;
import java.awt.geom.Ellipse2D;

import org.gicentre.utils.stat.*;    // For chart classes
import java.io.UnsupportedEncodingException; 
import java.util.ArrayList;
import java.io.File;
import processing.opengl.*;
import SimpleOpenNI.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;
import org.xml.sax.*;
import org.w3c.dom.*;
import gifAnimation.*;

import java.util.ArrayList;

import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;        

import javax.xml.transform.stream.*;
import org.xml.sax.*;
import org.w3c.dom.*;

import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

//initialise kinect using SImppleOpenNi library
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
//create screens  that will be required
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
//declare variables for main program objects
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

//variable for automatic programme
boolean currentExerciseComplete = false;

//declare variable used to store the users prescibed exercises
ArrayList<Exercise> e = new ArrayList<Exercise>();

void setup() {
        //basic sketch setup functions, sets size, framerate, text mode and renderer
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
        backgroundImage = loadImage("images/background1.png");
        backgroundImage2 = loadImage("images/background2.png");
        //creat main object for UI elements created using the ControlP5 library
        cp5 = new ControlP5(this);
        cp5.setFont(createFont("", 10));//memory leak semi-fix
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
        //enable depthMap generation
        kinect.enableDepth();
        // enable skeleton generation for all joints
        kinect.enableUser();
        //create and draw the login screen
        System.out.println("connected");
        //deleteLoginScreen = true;
}

//This function is called repeatedly by the application
void draw() {
        //this switch statement is used to change the programs state
        //each screen is a different state that has its own scene number
        switch (currentScene) {
        case -1: //error screen
                if (kinect.isInit() == false) { //if the kinect cannot be initilised
                        //print console error
                        println("Can't init SimpleOpenNI, maybe the camera is not connected!");
                        //go to the error screen
                        errorScreen.drawUI();
                } 
                else { //if the kinect can be initialised
                        currentScene = 0; //set the current scene to 0, the login screen
                        deleteErrorScreen = true; //set the error screen to be deleted in the next draw loop
                        loginScreen.create(); //create the login screen
                }
                break;

        case 0: //login screen
                checkForScreensToDelete(); //checks for screens to be deleted
                loginScreen.drawFade(); //fades out error messages   
                loginScreen.drawUI(); //draws the UI for this scene
                break;

        case 1: //menu screen
                checkForScreensToDelete(); //checks for screens to be deleted             
                background(backgroundImage); //draws the background image for this scene
                menuScreen.drawUI(); //draws the UI for this scene
                pushMatrix();
                scale(2.5);
                trackUser();
                popMatrix();
                menuScreen.checkBtn(convertedLeftJoint, convertedRightJoint);
                break;

        case 2: //programmes screen
                checkForScreensToDelete(); //checks for screens to be deleted
                background(backgroundImage); //draws the background image for this scene
                programsScreen.drawUI(); //draws the UI for this scene
                pushMatrix();
                scale(2.5);
                trackUser();
                popMatrix();
                programsScreen.checkBtn(convertedLeftJoint, convertedRightJoint);
                break;

        case 3: //profile screen
                checkForScreensToDelete(); //checks for screens to be deleted
                background(backgroundImage); //draws the background image for this scene
                menuScreen.drawUI(); //draws the UI for this scene
                profileScreen.drawUI(); //draws the UI for this scene
                pushMatrix();// pushes the current transformation matrix onto the matrix stack, saving it
                scale(2.5); //scale the scene up so the kinect 640x480 range covers the screens 1200x600 area
                trackUser(); //set the hand tracking for this screen
                popMatrix();  	//pops the current transformation matrix off the matrix stack. restoring the application to the previous transformation state
                menuScreen.checkBtn(convertedLeftJoint, convertedRightJoint); //check to see if this button is being selected/hovered over
                profileScreen.checkBtn(convertedLeftJoint, convertedRightJoint); //check to see if this button is being selected/hovered over
                break;

        case 4: //progress screen
                checkForScreensToDelete(); //checks for screens to be deleted
                background(backgroundImage2); //draws the faded background image for this scene
                progressScreen.drawUI(); //draws the UI elements for this scene
                trackUserNoHands();//Continues to tracks users hands with no visual representation
                break;

        case 5: //comments screen
                checkForScreensToDelete(); //checks for screens to be deleted
                background(backgroundImage2); //draws the second faded background
                commentsScreen.drawUI(); //draws the UI elements for this scene
                trackUserNoHands();//Continues to tracks users hands with no visual representation
                break;

        case 6: //exercise one
                checkForScreensToDelete(); //checks for screens to be deleted
                background(backgroundImage2); //draws the faded background image for this scene
                exerciseScreenOne.drawUI(); //draws the UI elements for this scene
                exerciseScreenOne.startExercise(kinect); //function for tracking and directing the user throuh the exercise
                currentExerciseComplete = exerciseScreenOne.checkForComplete(); //check if current exercise is finished, set global variable to result
                checkIfExerciseComplete(); //checks to see if any exercises are completed
                break;

        case 7://xml exercise 2
                checkForScreensToDelete(); //checks for screens to be deleted
                background(backgroundImage2); //draws the faded background image for this scene
                xmlExercise.drawUI(false); //draws the UI for this scene, parameter true to draw debug HUD
                currentExerciseComplete = xmlExercise.checkForComplete(); //check if current exercise is finished
                checkIfExerciseComplete(); //checks to see if any exercises are completed
                break;

        case 8: //exercise three
                checkForScreensToDelete(); //checks for screens to be deleted
                background(backgroundImage2); //draws the faded background image for this scene
                exerciseScreenThree.drawUI(); //draws the UI for this scene
                exerciseScreenThree.startExercise(kinect); //function for tracking and directing the user throuh the exercise
                currentExerciseComplete = exerciseScreenThree.checkForComplete(); //check if current exercise is finished
                checkIfExerciseComplete(); //checks to see if any exercises are completed
                break;
        }
}

//this function checks if any exercises are complete, if the one is complete
//a function within the exercise is called to begin a timer that when complete will advance to the next exercise
public void checkIfExerciseComplete() {
        if (currentExerciseComplete) {
                if (currentScene == 6) {
                        exerciseScreenOne.startFinishTimer();
                } 
                else if (currentScene == 7) {
                        xmlExercise.startFinishTimer();
                } 
                else if (currentScene == 8) {
                        exerciseScreenThree.startFinishTimer();
                }
                //reset the current exercise complete boolean so it doesnt keep restarting
                currentExerciseComplete = false;
        }
}

//this function is called by the first exercise when it has completed and its finish timer has elapsed
void autoMoveToScreenTwo() {
        deleteExerciseScreenOne = true;
        ArrayList<Exercise> e = new ArrayList<Exercise>();
        e = programme.getExercises();
        //load second exercise data, images, XML instructions and pass in the joints to be tracked in a given exercise
        xmlExercise = new XMLExerciseClassOptimised(this);
        xmlExercise.loadImages();
        xmlExercise.create(kinect, user, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND, e.get(1));
        xmlExercise.readXML(e.get(1).getName());
        //set the current scene to 7, the second exercise
        currentScene = 7;
}

//this function is called by the second exercise when it has completed and its finish timer has elapsed
void autoMoveToScreenThree () {
        //create exercise 3, load its assets
        exerciseScreenThree = new ExerciseScreenThree(this);
        exerciseScreenThree.loadImages();
        //set the previous exercise to delete on the next draw loop
        deleteExerciseScreenTwo = true;
        //get the exercises from the users programme
        ArrayList<Exercise> e = new ArrayList<Exercise>();
        e = programme.getExercises();
        //create the exercise screen, pass it the third exercise object 
        exerciseScreenThree.create(user, e.get(2));
        //set the current scene to 8, the third exercise
        currentScene = 8;
}

//when the last exercise is completed exit out to the programmes screen
void autoMoveToExerciseScreen() {
        programsScreen.create(); // create the programmes screne
        deleteExerciseScreenThree = true; //set this screen to be deleted on the next draw loop
        currentScene = 2; //go to the exercises/programmes screen
}

//////////////////////////////////////////////////////////////////////
///BUTTONS PRESSED ACTIONS///////////////////////////////////////////
//This function is listenning for control events made by clicks inside the program
public void controlEvent(ControlEvent theEvent) {
        //tells you what controller was called
        println(">/>"+ theEvent.getController().getName());

        //Loop  to check if any of the dynamic buttons created in the comments screen have been clicked. 
        //If this was the event clicked, get the button value and send as parameter to buttonClicked function in
        //comments screen to do GET request for comments with that exercise id
        for ( int i = 0; i < e.size(); i++) {
                if (theEvent.controller().name().equals(e.get(i).getName())) {
                        //if (theEvent.controller().value() == e.get(i).getExercise_id()) {
                        commentsScreen.buttonClicked(theEvent.controller().value());
                }
        }

        //login process
        if (theEvent.getController().getName().equals("log in")) { //f the button was the log in button
                println("Logging in..");
                //get the values from the username and password fields
                loginUserName = cp5.get(Textfield.class, "userName").getText();
                loginPassword = cp5.get(Textfield.class, "password").getText();
                //create a new user connection object and try log in with the given details
                UserDAO userDAO = new UserDAO();
                user = userDAO.logIn(loginUserName, loginPassword);
                if (user.getUser_id() != -1 && currentScene == 0) { //if the user is logged in and theyre still in the loggin screen
                        println("Success!");
                        //get exercise programme
                        try {
                                ProgrammeDAO programmeDAO = new ProgrammeDAO(user.getUser_id());
                                //get the exercise objects and add them to the programme object.
                                programme = programmeDAO.getProgramme();
                        }
                        catch (Exception ex) {
                                System.out.println("Programs not retrieved/set");
                        }
                        try {
                                //create an Exercise DAO and retrieve the exercises for the users programme
                                ExerciseDAO exerciseDAO = new ExerciseDAO();
                                e = exerciseDAO.getExercises(programme.getProgramme_id());
                                //stro the exercises in the programme object
                                programme.setExercises(e);
                        } 
                        catch (Exception ex) {
                                System.out.println("exercises not retrieved/set");
                        }
                        //delete the login screen on the next draw loop
                        deleteLoginScreen = true;
                        try {
                                //Get the record for the last completed exercise
                                RecordDAO recordDAO = new RecordDAO();
                                record = recordDAO.getLastDone(user.getUser_id());
                        }
                        catch (Exception ex) {
                                System.out.println("exercises not retrieved/set");
                        }
                        //create  the menu screen and pass the last completed record in to be displayed
                        menuScreen.create(user, record);
                        currentScene = 1;
                } 
                else { //user is not logged in
                        loginScreen.displayError("Incorrect login details"); //do not log in, display error message
                }
        }

        //if the programme button is clicked
        if (theEvent.getController().getName().equals("programme")) {
                makeProgramme(); //call this function
        }

        //if the exercise one button is clicked
        if (theEvent.getController().getName().equals("exerciseOne")) {
                makeExerciseOne(); //call this function
        }

        //if the exercise two button is clicked
        if (theEvent.getController().getName().equals("exerciseTwo")) {
                makeExerciseTwo(); //call this function
        }

        //if the exercise three button is clicked
        if (theEvent.getController().getName().equals("exerciseThree")) {
                makeExerciseThree(); //call this function
        }

        //if the profile button is clicked
        if (theEvent.getController().getName().equals("profile")) {
                makeProfile(); //call this function
        }

        //if the profile close button is clicked
        if (theEvent.getController().getName().equals("profileClose")) {
                makeProfileClose(); //call this function
        }

        //if the progress button is clicked
        if (theEvent.getController().getName().equals("progress")) {
                makeProgress(); //call this function
        }

        //if the comments button is clicked
        if (theEvent.getController().getName().equals("comments")) {
                makeComments(); //call this function
        }

        //if the menu back button is pressed from the other screens
        if (theEvent.getController().getName().equals("menuBackProgrammes") || theEvent.getController().getName().equals("menuBackExercises") || theEvent.getController().getName().equals("menuBackExercise3")  || theEvent.getController().getName().equals("menuBackExercises2") || theEvent.getController().getName().equals("menuBackProgress") || theEvent.getController().getName().equals("menuBackComments") || theEvent.getController().getName().equals("cancelProgramme1") || theEvent.getController().getName().equals("cancelProgramme2") || theEvent.getController().getName().equals("cancelProgramme3") ) {
                menuBack(); //call this function
        }

        //if the logout button is pressed from the other screens
        if (theEvent.getController().getName().equals("logout") || theEvent.getController().getName().equals("logoutPrograms") || theEvent.getController().getName().equals("logoutProgress") || theEvent.getController().getName().equals("logoutComments") || theEvent.getController().getName().equals("logoutExercise") || theEvent.getController().getName().equals("logoutExercise2") || theEvent.getController().getName().equals("logoutExercise3") ) {
                makeLogout(); //call this function
        }

        //if the next chart button (in the progress screen) is pressed
        if (theEvent.getController().getName().equals("nextChart")) {
                progressScreen.nextChartPressed(); //call this function in the procress screen
        }

        //if the previous chart (in the progress screen) is pressed
        if (theEvent.getController().getName().equals("previousChart")) {
                progressScreen.previousChartPressed(); //call this function in the progress screen
        }
}

//keboard pressed listener
void keyPressed() {

        if (key == 'r') { //when the R key is pressed
                if (currentScene == 7) { //if during exercise 2
                        xmlExercise.toggleRecording(); //change the recording state, on/off
                }
        } 
        else if (key == 's') { //when the S key is pressed
                if (currentScene == 7) { //if during exercise 2
                        xmlExercise.savePressed(); //save the recorded XML exercise
                }
        } 
        else if (key == 'l') { //when the L key is pressed
                if (currentScene == 7) { //if during exercise 2
                        xmlExercise.loadPressed(); //load the XML exercise
                }
        }
}

//////////////////////////////////////////////////////////////////////////
//BUTTON FUNCTIONS
//called when UI elements are clicked 

void makeProgramme() {
        //if the profile button group hasnt been deleted
        if (cp5.getGroup("profileGroup") != null) {
                deleteProfileScreen = true; //set the screen for deletion on next draw loop
        }
        //destroy the menu screen and its UI elements
        menuScreen.destroy(); 
        //create the programmes screen
        programsScreen.create();
        currentScene = 2; //set current scene to 2, move to program screen switch case
}

void makeExerciseOne() {
        //create exercise screen one and load images 
        exerciseScreenOne = new ExerciseScreenOne(this);
        exerciseScreenOne.loadImages();
        deleteProgramsScreen = true; //delete the programmes screen on next draw loop
        ArrayList<Exercise> e = new ArrayList<Exercise>();
        e = programme.getExercises(); //get the exercises
        //create exercise screen
        exerciseScreenOne.create(user, e.get(0));
        currentScene = 6; //set the current scene to 6, move to exercise one state in draw switch case
}

void makeExerciseTwo() {
        deleteProgramsScreen = true; //set the programme screen to delete on next loop
        ArrayList<Exercise> e = new ArrayList<Exercise>();
        e = programme.getExercises();
        //load second exercise data
        xmlExercise = new XMLExerciseClassOptimised(this);
        xmlExercise.loadImages();
        //create xmlExercise object and pass in the user, the exercise and the joints to be tracked
        xmlExercise.create(kinect, user, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND, e.get(1));
        xmlExercise.readXML(e.get(1).getName());
        currentScene = 7; //set the current scene to 7, move to exercise one state in draw switch case
}

void makeExerciseThree() {
        //create the exercise three object, load its assets
        exerciseScreenThree = new ExerciseScreenThree(this);
        exerciseScreenThree.loadImages();
        deleteProgramsScreen = true; //set hte programmes screen to be deleted
        //get the exercise information
        ArrayList<Exercise> e = new ArrayList<Exercise>();
        e = programme.getExercises();
        //create the  exercise using the user object and the third exercise
        exerciseScreenThree.create(user, e.get(2));
        currentScene = 8; //set the current scene to 8, move to exercise one state in draw switch case
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
                deleteProgramsScreen = true; //set if for delete on next loop
        }
        else if (currentScene == 4) { //progress screen
                deleteProgressScreen = true; //set if for delete on next loop
        }
        else if (currentScene == 5) { //comments screen
                deleteCommentsScreen = true; //set if for delete on next loop
        }
        else if (currentScene == 6) { //exercise screen
                deleteExerciseScreenOne = true; //set if for delete on next loop
        } 
        else if (currentScene == 7) { //exercise screen
                deleteExerciseScreenTwo = true; //set if for delete on next loop
        } 
        else if (currentScene == 8) { //exercise screen
                deleteExerciseScreenThree = true; //set if for delete on next loop
        }  
        //create and draw the menu screen again
        currentScene = 1; 
        //create the menu screen object to be displayed
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
                //deleteProfileScreen = true;
                deleteMenuScreen = true;
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

//this function checks to see if any screens have priviously set for deletion
void checkForScreensToDelete() {
        if (deleteErrorScreen == true) { //if a screen is to be deteled its destroy function is called, removing its UI elements
                errorScreen.destroy();
                deleteErrorScreen = false; //its delete variable is then set back to false
        } 
        else if (deleteLoginScreen == true) { //if a screen is to be deteled its destroy function is called, removing its UI elements
                loginScreen.destroy();
                deleteLoginScreen = false;
        } 
        else if (deleteMenuScreen == true) { //if a screen is to be deteled its destroy function is called, removing its UI elements
                if (cp5.getGroup("profileGroup") != null) {
                        profileScreen.destroy();
                        deleteProfileScreen = false;
                }
                menuScreen.destroy();
                deleteMenuScreen = false;
        } 
        else if (deleteProfileScreen == true) { //if a screen is to be deteled its destroy function is called, removing its UI elements
                profileScreen.destroy();
                deleteProfileScreen = false;
        } 
        else if (deleteProgramsScreen == true) { //if a screen is to be deteled its destroy function is called, removing its UI elements
                programsScreen.destroy();
                deleteProgramsScreen = false;
        } 
        else if (deleteProgressScreen == true) { //if a screen is to be deteled its destroy function is called, removing its UI elements
                progressScreen.destroy();
                deleteProgressScreen = false;
        } 
        else if (deleteExerciseScreenOne == true) { //if a screen is to be deteled its destroy function is called, removing its UI elements
                exerciseScreenOne.destroy();             
                deleteExerciseScreenOne = false;
        } 
        else if (deleteExerciseScreenTwo == true) { //if a screen is to be deteled its destroy function is called, removing its UI elements
                xmlExercise.destroy(); 
                deleteExerciseScreenTwo = false;
        }
        else if (deleteExerciseScreenThree == true) { //if a screen is to be deteled its destroy function is called, removing its UI elements
                exerciseScreenThree.destroy(); 
                deleteExerciseScreenThree = false;
        }        
        else if (deleteCommentsScreen == true) { //if a screen is to be deteled its destroy function is called, removing its UI elements
                commentsScreen.destroy();
                deleteCommentsScreen = false;
        }
}


///////////////////////////////////////////////////////////////////////////
//HAND TRACKING///////////////////////////////////////////////////////////

void trackUser() {
        // update the cam
        //kinect.update();
        if (kinect.enableUser() == true) { //if the kinect can track the user
                kinect.update(); //update the current information from what the  camera is seeing

                IntVector userList = new IntVector();
                kinect.getUsers(userList); //get the user list from the data
                if (userList.size() > 0) { //if there is a user
                        int userId = userList.get(0); //get the first user

                        if (kinect.isTrackingSkeleton(userId)) { //if the kinect is tracking the first user
                                //get the points for the left and right hands
                                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
                                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
                                //draw the hand tracking icons at these posistions
                                drawLeftJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
                                drawRightJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
                        }
                }
        }
}

void trackUserNoHands() {
        // update the cam
        //kinect.update();
        if (kinect.enableUser() == true) { //if the kinect can track the user
                kinect.update(); //update the current information from what the  camera is seeing

                IntVector userList = new IntVector();
                kinect.getUsers(userList); //get the user list from the data
                if (userList.size() > 0) { //if there is a user
                        int userId = userList.get(0); //get the first user

                        if (kinect.isTrackingSkeleton(userId)) { //if the kinect is tracking the first user
                                //get the points for the left and right hands
                                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, leftHand);
                                kinect.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, rightHand);
                        }
                }
        }
}

//function for drawing the hand tracking icons
void drawLeftJoint(int userId, int jointID) {
        PVector leftJoint = new PVector(); 
        float confidence = kinect.getJointPositionSkeleton(userId, jointID, leftJoint); //get the position point confidence, not used
        kinect.convertRealWorldToProjective(leftJoint, convertedLeftJoint); //change the 3d perspective positioning of the joint into a flat plane
        if (loading == true) { //if loading is true
                loadingIcon.play(); //play the gif for loading icon at the tracked position
                image(loadingIcon, convertedLeftJoint.x-10, convertedLeftJoint.y-10, 20, 20);
        }
        else {
                //if not loading then pause the loading gif and draw the normal hand icon instead
                loadingIcon.pause();
                image(leftHandIcon, convertedLeftJoint.x-10, convertedLeftJoint.y-10, 20, 20);
        }
}

//function for drawing the hand tracking icons
void drawRightJoint(int userId, int jointID) {
        PVector rightJoint = new PVector();
        float confidence = kinect.getJointPositionSkeleton(userId, jointID, rightJoint); //get the position point confidence, not used
        kinect.convertRealWorldToProjective(rightJoint, convertedRightJoint); //change the 3d perspective positioning of the joint into a flat plane
        if (loading == true) { //if loading is true
                loadingIcon.play(); //play the gif for loading icon at the tracked position
                image(loadingIcon, convertedRightJoint.x-10, convertedRightJoint.y-10, 20, 20);
        }
        else {
                //if not loading then pause the loading gif and draw the normal hand icon instead
                loadingIcon.pause();
                image(rightHandIcon, convertedRightJoint.x-10, convertedRightJoint.y-10, 20, 20);
        }
}

//functions for changing the loading variable, used by the hand tracking
void loaderOn() {
        loading = true;
}

void loaderOff() {
        loading = false;
}

//////////////////////////////////////////////////////////////////////////
//USER TRACKING functions 
//events triggered by the kinect as it finds, looses and tracks users

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

