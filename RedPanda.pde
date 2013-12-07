import controlP5.*;
import SimpleOpenNI.*;

//initialise kinect
SimpleOpenNI kinect;

ControlP5 cp5;
Group g1 = null;
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
//main objects
User user;
Programme programme;

//integer for swithching scenes/rooms
int currentScene;

void setup() {
  size(1200, 600);
  textAlign(CENTER, CENTER);
  cp5 = new ControlP5(this);
   g1 = cp5.addGroup("g1")
        .setPosition(0,0);
  //create and draw the login screen  
   loginScreen.loadImages();
   menuScreen.loadImages();
   programsScreen.loadImages();
   loginScreen.drawScreen();
   currentScene = 0; //go to login scene
}

void draw() {
  switch (currentScene) { 
      
      case 0: //login screen
          loginScreen.drawFade(); //fades out error messeges
      break;
      
      case 1: //menu screen
     
      break;
      
  }
}

public void controlEvent(ControlEvent theEvent) {
  //tells you what controller was called
  println(theEvent.getController().getName());
  
  if (theEvent.getController().getName().equals("log in")){ //f the button was the log in button
      //get the values from the username and password fields
      loginUserName = cp5.get(Textfield.class,"userName").getText();
      loginPassword = cp5.get(Textfield.class,"password").getText();
      //create a new user connection object and try log in with the given details
      UserDAO userDAO = new UserDAO();
      user = userDAO.logIn(loginUserName, loginPassword);
      
      if (user.getUser_id() != -1 && currentScene == 0) { //if the user is logged in and theyre in the loggin screen 
         println("Logged IN");
         //get exercise programme
         //ProgrammeDAO programmeDAO = new ProgrammeDAO(user.getUser_id());
         //programme = programmeDAO.getProgramme();
         
         loginScreen.destroy();
         menuScreen.create();
      } else { //user is not logged in 
          loginScreen.displayError("Incorrect login details");
      }
     
  }

  if (theEvent.getController().getName().equals("program")){
     menuScreen.destroy();
     programsScreen.create();
  } 

}


