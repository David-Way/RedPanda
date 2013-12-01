import controlP5.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;
ControlP5 cp5;
//login text fields
Textfield userNameTextField;
Textfield passwordTextField;
//login stored user name and password
String loginUserName = "";
String loginPassword = "";

User user;

//integer for swithching scenes/rooms
int currentScene;

void setup() {
  size(1200, 600);
  textAlign(CENTER, CENTER);

  //create and draw the logn screen  
  LoginScreen loginScreen = new LoginScreen(this);
  loginScreen.drawScreen();
  
  //create but DONT draw (yet) the menu screen
  MenuScreen menuScreen = new MenuScreen(this);
  
  currentScene = 0; //go to login scene
}

void draw() {
  switch (currentScene) { 
      
      case 0: //login scene
        //println(loadedUserString);
        /*if (USER IS LOGGED IN) {
          currentScene = 1; //go to menu screen
        }*/
      break;
      
      case 1: //menu
        println("menu");
//        rect(0,0,1200,600);
        //menuScreen.drawScreen(); //put drawing code for the menu screen in the draw function inside the MenuScreen class
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
      
      if (user.getUser_id() != -1 && currentScene == 0) {
          currentScene = 1;
      }

  }
}

