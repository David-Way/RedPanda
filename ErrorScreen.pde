class ErrorScreen {
        
        private RedPanda context;
        private PImage kinectImage;
        
        public ErrorScreen(RedPanda c) {
                this.context = c;                
        }
        
        public void loadImages() {
                this.kinectImage = loadImage("images/kinect.png");
        }
       
       public void destroy() {
       
       }

        public void drawUI() {
                background(255);
                image(kinectImage, width/2 - 330, height/2 - 128);
                textSize(32);
                text("Camera Not Connected!", width/2, height/2 + 100);
                text("Please Connect Camera and Restart Application", width/2, height/2 + 140); 
                fill(0, 102, 153);
        }
}

