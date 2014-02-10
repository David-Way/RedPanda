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
import peasy.*;

class XMLExerciseClassOptimised {
        PeasyCam cam;
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
        private Button []buttons;
        private Group exerciseGroup;

        long startTime;
        Message message;
        String exerciseName;
        float c = (float)0.0;
        float offByDistance = (float)0.0;
        int currentFrame = 0;
        int numberOfFrames = 0;
        int numberOfReps = 5;
        int currentRep = 0;
        boolean paused = false;
        boolean recording = false;
        boolean exerciseComplete = false;
        Gif target;
        //set colours for user avatar
        color userColourRed = color(255, 0, 0);
        color userColourGreen = color(0, 255, 0);
        color userColourBlue = color(0, 0, 255);
        color userColourGrey = color(155, 155, 155);
        color currentUserColour = userColourGrey;

        PVector messagePosition = new PVector(10, 100);

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

                this.e = ex;
                this.exerciseName = e.getName();
                this.numberOfReps = e.getRepetitions();

                cp5.setAutoDraw(false);

                exerciseGroup = cp5.addGroup("exerciseGroup")
                        .setPosition(0, 0)
                                .hideBar()
                                        ;

                buttons = new Button[2];

                buttons[0] = cp5.addButton("menuBackExercises")
                        .setPosition(10, 10)
                                .setImages(menuBack)
                                        .updateSize()
                                                .setGroup(exerciseGroup)
                                                        ;


                buttons[1] = cp5.addButton("logoutExcercises")
                        .setPosition(978, 10)
                                .setImages(logout)
                                        .updateSize()
                                                .setGroup(exerciseGroup)
                                                        ;

                message = new Message(280, 200, messagePosition, "Hi " + user.getFirst_name() + ",\nWelcome to the " + e.getName()  +  " exercise " + "\nTarget Repetitions: " + e.getRepetitions() + "\nCurrent Repetition: " + currentRep + "\nPercent Complete: " + (int)Math.round(100.0 / numberOfReps * currentRep) + "%");
                message.create();
                startTime  = System.currentTimeMillis();
        }

        void drawUI(boolean drawHUD) {
                background(255, 255, 255);
                context.update();
                message.drawUI();
                //println(currentRep);

                if (drawHUD) {
                        drawHeadsUpDisplay();
                }

                lights();
                noStroke();
                translate(width/2, height/2, 0);
                rotateX(radians(180));

                IntVector userList = new IntVector();
                context.getUsers(userList);

                if (userList.size() > 0) {
                        int userId = userList.get(0);
                        setUser(userId);
                        if ( context.isTrackingSkeleton(userId)) {
                                drawSkeleton(userId);
                                // if we're recording tell the recorder to capture this frame
                                if (recording) {
                                        setUserColour(userColourRed);
                                        if (numberOfFrames%30 == 0) {
                                                recordFrame();
                                        }
                                        numberOfFrames++;
                                } 
                                else {
                                        setUserColour(userColourGrey);
                                        //display exercise
                                        drawExerciseSkeleton(userId);

                                        //if user is close to points
                                        if (checkUserCompliance(userId)) {
                                                nextFrame();
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

                //println(p3.x);

                PVector added1 = PVector.add(p1, c3);
                PVector added2 =  PVector.add(p2, c3);
                c1.sub(added1);
                c2.sub(added2);

                //println(">" + c1.mag());
                //println(">>" + c2.mag());
                //println(result + " " + c1.mag() + " " + c2.mag());

                if (c1.mag() < 220 && c2.mag() <220) {
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
                image(target, -50, -50, 100, 100);


                pushMatrix();
                translate(p1.x, p1.y, p1.z);

                //sphere(50);
                image(target, -50, -50, 100, 100);
                popMatrix();

                pushMatrix();
                translate(p2.x, p2.y, p2.z);

                //sphere(50);
                image(target, -50, -50, 100, 100);
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
        void drawSkeleton2(int userId) {
                pushStyle();
                pushMatrix();
                //rotateX(radians(-180));
                //translate(-320,-240, 0);
                scale(0.8f);
                PVector p1 = new PVector();
                PVector p2 = new PVector();

                // left arm
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, p1);
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, p2);
                Limb2 testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                testLimb2.draw();
                p1.set(p2);
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HAND, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                testLimb2.draw();

                // right arm
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, p1);
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                testLimb2.draw();
                p1.set(p2);
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HAND, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                testLimb2.draw();

                // left leg
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, p1);
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_KNEE, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                testLimb2.draw();
                p1.set(p2);
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_FOOT, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                testLimb2.draw();

                // right leg
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, p1);
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                testLimb2.draw();
                p1.set(p2);
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_FOOT, p2);
                testLimb2 = new Limb2(p1, p2, 0.3f, 0.3f, currentUserColour);
                testLimb2.draw();

                // torso
                PVector p3 = new PVector();
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, p1);
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_LEFT_HIP, p2);
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_RIGHT_HIP, p3);
                // fiddle with offset here
                testLimb2 = new Limb2(p1, new PVector((p2.x+p3.x)/2.f, (p2.y+p3.y)/2.f, (p2.z+p3.z)/2.f), 0.6f, 0.6f, currentUserColour);
                testLimb2.draw();

                // head
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_NECK, p1);
                context.getJointPositionSkeleton(userId, SimpleOpenNI.SKEL_HEAD, p2);
                p1.add(0, 100, 0);
                p2.add(0, 100, 0);
                testLimb2 = new Limb2(p1, p2, 0.5f, 0.5f, currentUserColour);
                testLimb2.draw();

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
                                        message = new Message(200, 200, messagePosition, "Target Repetitions: " + e.getRepetitions() + "\nCurrent Repetition: " + currentRep + "\nPercent Complete: " + (int)Math.round(100.0 / numberOfReps * currentRep) + "%" + "\nTime: " + ((System.currentTimeMillis() - startTime) / 1000) +"s");
                                        message.create();
                                } 
                                else if (!exerciseComplete) { //on exercise complete
                                        long elapsedTime = (System.currentTimeMillis() - startTime) / 1000;
                                        int score = (int)(numberOfReps*100/elapsedTime*10);
                                        message.destroy();
                                        message = new Message(200, 200, messagePosition, "Well Done."  + "\nTime to Complete: \n" + elapsedTime + " seconds" + "\nScore: " + score + " points");
                                        message.create();

                                        DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
                                        Date currentDate = new Date();
                                        int date = int(dateFormat.format(currentDate));

                                        RecordDAO dao = new RecordDAO();
                                        dao.setRecord(new Record(0, user.getUser_id(), e.getExercise_id(), date, (int)elapsedTime, numberOfReps, score , "Error"));
                                        exerciseComplete = true;
                                }
                        }
                }
        }

        void drawHeadsUpDisplay() {
                pushMatrix();
                // create hud
                fill(0);
                text("totalFrames: " + framesGroup.get(0).size(), 5, 10);
                text("recording: " + recording, 5, 24);
                text("currentFrame: " + currentFrame, 5, 38 );

                // set text color as a gradient from red to green
                // based on distance between hands
                //c = map(offByDistance, 0, 1000, 0, 255); 
                //fill(c, 255-c, 0);
                //text("joint 1 off by: " + offByDistance, 5, 52);
                popMatrix();
        }

        void loadImages() {

                //load images  for login button
                this.menuBack[0]  = loadImage("images/menu.jpg");
                this.menuBack[1]  = loadImage("images/menuOver.jpg");
                this.menuBack[2]  = loadImage("images/menu.jpg");
                this.logout[0] = loadImage("images/logout.jpg");
                this.logout[1] =loadImage("images/logoutOver.jpg");
                this.logout[2] =loadImage("images/logout.jpg");
        }

        void toggleRecording() {
                recording = !recording;
                System.out.println("recording state: " + recording);
        }

        void loadPressed() {
                readXML("default");
        }

        void savePressed() {
                writeXML("left-arm-three-joint");
        }

        void readXML(String fileName) {
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


        public void writeXML(String fileName) {
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
}

