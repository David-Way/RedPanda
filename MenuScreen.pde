class MenuScreen {
  
  private RedPanda context;
  
  private PImage[] program = new PImage[3];
  private PImage[] profile = new PImage[3];
  private PImage[] progress = new PImage[3];
  private PImage[] comments = new PImage[3];
  private PImage[] logout = new PImage[3];
  private PImage loginBackgroundImage;
  
  public MenuScreen(RedPanda c) {
      this.context = c;
  }
  
  void loadImages(){
    
      //load images  for login button
       this.program[0]  = loadImage("images/program.png");
    this. program[1]  =loadImage("images/programover.png");
      this.program[2]  =loadImage("images/program.png");
      this.profile[0] = loadImage("images/profile.png");
     this.profile[1] =loadImage("images/profileover.png");
      this.profile[2] =loadImage("images/profile.png");
      this.progress[0] = loadImage("images/progress.png");
      this.progress[1] = loadImage("images/progressover.png");
      this.progress[2] = loadImage("images/progress.png");
      this.comments[0] = loadImage("images/comments.png");
      this.comments[1] =loadImage("images/commentsover.png");
      this.comments[2] =loadImage("images/comments.png");
      this.logout[0] = loadImage("images/logout.png");
      this.logout[1] =loadImage("images/logoutover.png");
      this.logout[2] =loadImage("images/logout.png");
      //load background image
      this.loginBackgroundImage = loadImage("images/background.png"); 
  }
  
  public void create() {
    
      //draw background image
      image(loginBackgroundImage, 0, 0, 1200, 600);
        
      g1 = cp5.addGroup("g1")
      .setPosition(0,0);

  
    cp5.addButton("program")
       .setPosition(10,10)
       .setImages(program)
       .updateSize()
       .setGroup(g1);
    
    cp5.addButton("profile")
       .setPosition(465,10)
       .setImages(profile)
       .updateSize()
       .setGroup(g1) ;
       
  
    cp5.addButton("progress")
       .setPosition(10,238)
       .setImages(progress)
       .updateSize()
       .setGroup(g1);
    
    
    cp5.addButton("comments")
       .setPosition(465,238)
       .setImages(comments)
       .updateSize()
       .setGroup(g1);
       
  
    cp5.addButton("logout")
       .setPosition(1054,10)
       .setImages(logout)
      .updateSize()
       .setGroup(g1);
       
  }
  
 void destroy(){
      g1.remove();
  }
}
