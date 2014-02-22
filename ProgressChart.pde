//This class is used to create a scatter chart using the giUtilities libraries
//it IS no longer used JFreeProgressChart has replaced it
class ProgressChart {       

  //declare variables 
  RedPanda c;
  XYChart scatterplot;
  float [] dates, scores; 
  String labelOne, labelTwo;

  //contructor takes reference to the RedPanda class, two float arrays containing the data to be plotted and the names of the axis
  public ProgressChart(RedPanda _c, float[] _dates, float[] _scores, String _labelOne, String _labelTwo) {
    //initialise variable
    this.c = _c;
    this.scatterplot = new XYChart(c); //create chart object
    this.dates = _dates;
    this.scores = _scores;
    this.labelOne = _labelOne;
    this.labelTwo = _labelTwo;

    // Both x and y data set here.  
    if (dates != null && scores != null) { //i fthe data isnt null
      scatterplot.setData(dates, scores); //set the chart data
    } 
    else { //set default values
      scatterplot.setData(new float[] {
        1900, 1910, 1920, 1930, 1940, 1950, 
        1960, 1970, 1980, 1990, 2000
      }
      , 
      new float[] { 
        6322, 6489, 6401, 7657, 9649, 9767, 
        12167, 15154, 18200, 23124, 28645
      }
      );
    }

    // Axis formatting and labels.
    scatterplot.showXAxis(true); 
    scatterplot.showYAxis(true); 
    //scatterplot.setXFormat("$###,###");
    //SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
    //scatterplot.setXFormat("0000");
    scatterplot.setXAxisLabel(labelOne);
    scatterplot.setYAxisLabel(labelTwo);
    scatterplot.setMinY(6);

    // Symbol styles
    scatterplot.setLineWidth(1);
    scatterplot.setLineColour(color(82, 139, 184));
    scatterplot.setPointColour(color(51, 196, 241));
    scatterplot.setPointSize(10);
  }

  public void drawUI() {   
    //draw translucent white square over background
    fill(51, 196, 241);                
    rect(764, 105, 319, 380);

    //draw the scatter plot chart object
    scatterplot.draw(116, 105, 800, 380);
  }
}

