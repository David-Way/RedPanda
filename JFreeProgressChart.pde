//this class uses the JFreeCharts library to create multi series charts
class JFreeProgressChart {

        //declare variable fo chart object
        JFreeChart chartObject;
        
        //constructor for the chart takes 3 int arrays ar data entry, and names for the chart and its axis
        public JFreeProgressChart(int[] date, int[] score, int[] time, String chartName, String xAxisName, String yAxisName, String altAxisName) {
                //create a new data series called scores
                XYSeries scoreSeries = new XYSeries("Scores", false); 
                for (int i = 0; i < date.length; i++) {  //loop through the given data
                        //add a data point for each date/score point
                        scoreSeries.add(date[i], score[i]);
                }
                
                //create a new time series 
                TimeSeries pop = new TimeSeries("Scores", Day.class);
                
                for (int i = 0; i < date.length; i++) { //loop through the given data
                        //012345678
                        //20140314
                        String d = new BigDecimal(date[i]).toPlainString(); //convert the date string into a usable date variables
                        int day = Integer.parseInt(d.substring(6, 8)); //parse each section out
                        int month = Integer.parseInt(d.substring(4, 6));
                        int year = Integer.parseInt(d.substring(0, 4));                        
                        pop.addOrUpdate(new Day(day, month, year), score[i]/10); //add the data and score to the series, divide score by 10 to scale better
                }

                //create a new series for Time to complete data
                TimeSeries pop2 = new TimeSeries("Time To Complete", Day.class);

                for (int i = 0; i < date.length; i++) { //loop through                        
                        String d = new BigDecimal(date[i]).toPlainString(); //convert the date string into a usable date variables
                        int day = Integer.parseInt(d.substring(6, 8));
                        int month = Integer.parseInt(d.substring(4, 6));
                        int year = Integer.parseInt(d.substring(0, 4));                        
                        pop2.addOrUpdate(new Day(day, month, year), time[i]); //add the day and time to complete data to the series
                }

                //Create a time series data set
                TimeSeriesCollection dataset = new TimeSeriesCollection();
                dataset.addSeries(pop); //add the series to the data set
                dataset.addSeries(pop2);

                //create a chart object, pass in the name, axis names, dataset as parameters
                chartObject = ChartFactory.createScatterPlot(
                chartName, xAxisName, yAxisName, dataset, PlotOrientation.VERTICAL, true, true, false);

                //get a plot from the chart object
                final XYPlot plot = chartObject.getXYPlot(); 

                //create a date axis
                DateAxis dAx = new DateAxis();
                //format the date axis
                dAx.setDateFormatOverride(new SimpleDateFormat("dd/MM"));
                dAx.setTickUnit(new DateTickUnit(DateTickUnitType.DAY, 1));
                //set the domain axis of the plot to this new date axis
                plot.setDomainAxis(dAx);

                /*NumberAxis rAx = new  NumberAxis();
                rAx.setLowerBound((double) 0);
                rAx.setUpperBound((double)200);
                plot.setRangeAxis(rAx);         */

                //get the reneder object from the plot
                XYItemRenderer renderer = plot.getRenderer();
                //format the chart using the reneder object
                renderer.setSeriesPaint(0, Color.blue);
                double size = 16.0;
                double delta = size / 2.0;
                //create shapes to be used as the series points
                Shape shape1 = new Rectangle2D.Double(-delta, -delta, size, size);
                Shape shape2 = new Ellipse2D.Double(-delta, -delta, size, size);
                renderer.setSeriesShape(0, shape1);
                renderer.setSeriesShape(1, shape2);
                
                //create a theme to style the chart
                String fontName = "Lucida Sans";
                StandardChartTheme theme = (StandardChartTheme)org.jfree.chart.StandardChartTheme.createJFreeTheme();
                theme.setTitlePaint( Color.decode( "#4572a7" ) );
                theme.setExtraLargeFont( new Font(fontName, Font.PLAIN, 34) ); //title
                theme.setLargeFont( new Font(fontName, Font.BOLD, 24)); //axis-title
                theme.setRegularFont( new Font(fontName, Font.PLAIN, 14));
                theme.setRangeGridlinePaint( Color.decode("#C0C0C0"));
                theme.setPlotBackgroundPaint( Color.white );
                theme.setChartBackgroundPaint( Color.white );
                theme.setGridBandPaint( Color.blue );
                theme.setAxisOffset( new RectangleInsets(0, 0, 0, 0) );
                theme.setBarPainter(new StandardBarPainter());
                theme.setAxisLabelPaint( Color.decode("#666666")  );
                theme.apply( chartObject );
                chartObject.setTextAntiAlias( true );
                chartObject.setAntiAlias( true );
                
                //this code sets the default colors to use for the first two series
                chartObject.getPlot().setDrawingSupplier(new DefaultDrawingSupplier(
                new Paint[] { 
                        Color.decode("#33C4F2"), Color.decode("#69c6b4")
                }
                , 
                DefaultDrawingSupplier.DEFAULT_OUTLINE_PAINT_SEQUENCE, 
                DefaultDrawingSupplier.DEFAULT_STROKE_SEQUENCE, 
                DefaultDrawingSupplier.DEFAULT_OUTLINE_STROKE_SEQUENCE, 
                DefaultDrawingSupplier.DEFAULT_SHAPE_SEQUENCE));
        }

        //this function returns a chart PImage generated from the chart object
        public PImage getChartImage() {
                return new PImage(chartObject.createBufferedImage(968, 400));
        }
}

