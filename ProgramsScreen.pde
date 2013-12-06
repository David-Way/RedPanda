class ProgramsScreen {
  
  private RedPanda context;
  
  private PImage[] menuBack = new PImage[3];
   private PImage[] exerciseOne = new PImage[3];
  private PImage[] exerciseTwo = new PImage[3];
  private PImage[] exerciseThree = new PImage[3];
     private PImage[] logout = new PImage[3];
  private PImage loginBackgroundImage;
  
  public ProgramsScreen(RedPanda c) {
    this.context = c;
  }
  
void loadImages(){
    
         //load images  for login button
          this.menuBack[0]  = loadImage("images/menu.png");
          this.menuBack[1]  = loadImage("images/menuover.png");
          this.menuBack[2]  = loadImage("images/menuover.png");
       this.exerciseOne[0]  = loadImage("images/exercise1.png");
    this. exerciseOne[1]  =loadImage("images/exercise1over.png");
      this.exerciseOne[2]  =loadImage("images/exercise1over.png");
      this.exerciseTwo[0] = loadImage("images/exercise2.png");
     this.exerciseTwo[1] =loadImage("images/exercise2over.png");
      this.exerciseTwo[2] =loadImage("images/exercise2over.png");
      this.exerciseThree[0] = loadImage("images/exercise3.png");
      this.exerciseThree[1] = loadImage("images/exercise3over.png");
      this.exerciseThree[2] = loadImage("images/exercise3over.png");
       this.logout[0] = loadImage("images/logout.png");
      this.logout[1] =loadImage("images/logoutover.png");
      this.logout[2] =loadImage("images/logoutover.png");
      //load background image
      this.loginBackgroundImage = loadImage("images/background.png"); 
  }
  
  public void create() {
     //draw background image
     image(loginBackgroundImage, 0, 0, 1200, 600);
        
 g1 = cp5.addGroup("g1")
.setPosition(0,0)
                ;
                
cp5.addButton("menuBack")
     .setPosition(10,10)
     .setImages(menuBack)
     .updateSize()
     .setGroup(g1)
     ;

cp5.addButton("exerciseOne")
     .setPosition(10,70)
     .setImages(exerciseOne)
     .updateSize()
     .setGroup(g1)
     ;
  
  cp5.addButton("exerciseTwo")
     .setPosition(242,70)
     .setImages(exerciseTwo)
     .updateSize()
     .setGroup(g1)
     ;
     

  cp5.addButton("exerciseThree")
     .setPosition(482,70)
     .setImages(exerciseThree)
     .updateSize()
     .setGroup(g1)
     ;
  


  cp5.addButton("logout")
     .setPosition(1054,10)
     .setImages(logout)
     .updateSize()
     .setGroup(g1)
     ;
 
    
  }
  
 void destroy(){
   cp5.getGroup("g1").remove();
  }
}
