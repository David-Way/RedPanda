import org.gicentre.utils.stat.*;    // For chart classes
class ProgressChart {       

        RedPanda c;
        XYChart scatterplot;
        float [] dates, scores; 
        String labelOne, labelTwo;


        public ProgressChart(RedPanda _c, float[] _dates, float[] _scores, String _labelOne, String _labelTwo) {
                this.c = _c;
                this.scatterplot = new XYChart(c);
                this.dates = _dates;
                this.scores = _scores;
                this.labelOne = _labelOne;
                this.labelTwo = _labelTwo;

                // Both x and y data set here.  
                if (dates != null && scores != null) {
                        scatterplot.setData(dates, scores);
                } 
                else {
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
                scatterplot.setXAxisLabel(labelOne);
                scatterplot.setYAxisLabel(labelTwo);

                // Symbol styles
                scatterplot.setLineWidth(1);
                scatterplot.setLineColour(color(82, 139, 184));
                scatterplot.setPointColour(color(51, 196, 241));
                scatterplot.setPointSize(10);
        }

        public void drawUI() {   
                fill(51, 196, 241);                
                rect(764, 105, 319, 380);

                scatterplot.draw(116, 105, 638, 380);               

                //drawInfo();
        }

        
}

