import java.awt.Color;
import java.awt.Font;
import java.awt.Paint;
import java.math.BigDecimal;
import java.awt.Shape;
import java.awt.geom.Rectangle2D;
import java.awt.geom.Ellipse2D;


class JFreeProgressChart {

        JFreeChart chartObject;

        public JFreeProgressChart(float[] date, float[] score, float[] time, String chartName, String xAxisName, String yAxisName, String altAxisName) {
                XYSeries scoreSeries = new XYSeries("Scores");
                for (int i = 0; i < date.length; i++) {
                        scoreSeries.add(date[i], score[i]);
                }

                //XYDataset dataset = new XYSeriesCollection(scoreSeries);

                TimeSeries pop = new TimeSeries("Scores", Day.class);

                for (int i = 0; i < date.length; i++) {
                        //012345678
                        //20140314
                        //String d = Float.toString(date[i]);
                        String d = new BigDecimal(date[i]).toPlainString();
                        println("d="+d);
                        int day = Integer.parseInt(d.substring(6, 8));
                        int month = Integer.parseInt(d.substring(4, 6));
                        int year = Integer.parseInt(d.substring(0, 4));                        
                        pop.addOrUpdate(new Day(day, month, year), score[i]/10);
                }


                TimeSeries pop2 = new TimeSeries("Time To Complete", Day.class);

                for (int i = 0; i < date.length; i++) {                        
                        String d = new BigDecimal(date[i]).toPlainString();
                        //println("d="+d);
                        int day = Integer.parseInt(d.substring(6, 8));
                        int month = Integer.parseInt(d.substring(4, 6));
                        int year = Integer.parseInt(d.substring(0, 4));                        
                        pop2.addOrUpdate(new Day(day, month, year), time[i]);
                }


                TimeSeriesCollection dataset = new TimeSeriesCollection();
                dataset.addSeries(pop);
                dataset.addSeries(pop2);



                //chartObject =  ChartFactory.createScatterPlot(chartName, xAxisName, yAxisName, dataset);



                chartObject = ChartFactory.createScatterPlot(
                chartName, xAxisName, yAxisName, dataset, PlotOrientation.VERTICAL, true, true, false);

                final XYPlot plot = chartObject.getXYPlot(); 

                //final DateAxis domainAxis = (DateAxis) plot.getDomainAxis();     
                DateAxis dAx = new DateAxis();

                dAx.setDateFormatOverride(new SimpleDateFormat("dd/MM"));
                plot.setDomainAxis(dAx);

                NumberAxis rAx = new  NumberAxis();
                rAx.setLowerBound((double) 0);
                rAx.setUpperBound((double)200);
                plot.setRangeAxis(rAx);         


                XYItemRenderer renderer = plot.getRenderer();
                renderer.setSeriesPaint(0, Color.blue);
                double size = 16.0;
                double delta = size / 2.0;
                Shape shape1 = new Rectangle2D.Double(-delta, -delta, size, size);
                Shape shape2 = new Ellipse2D.Double(-delta, -delta, size, size);
                renderer.setSeriesShape(0, shape1);
                renderer.setSeriesShape(1, shape2);

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


                /*chartObject.getCategoryPlot().setOutlineVisible( false );
                 chartObject.getCategoryPlot().getRangeAxis().setAxisLineVisible( false );
                 chartObject.getCategoryPlot().getRangeAxis().setTickMarksVisible( false );
                 //chartObject.getCategoryPlot().setRangeGridlineStroke( new BasicStroke() );
                 chartObject.getCategoryPlot().getRangeAxis().setTickLabelPaint( Color.decode("#666666") );
                 chartObject.getCategoryPlot().getDomainAxis().setTickLabelPaint( Color.decode("#666666") );*/
                chartObject.setTextAntiAlias( true );
                chartObject.setAntiAlias( true );
                //chartObject.getCategoryPlot().getRenderer().setSeriesPaint( 0, Color.decode( "#4572a7" ));
                //chartObject.setTitle(new org.jfree.chart.title.TextTitle("The title", new java.awt.Font("SansSerif", java.awt.Font.BOLD, 12));

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

        public PImage getChartImage() {
                return new PImage(chartObject.createBufferedImage(968, 400));
        }
}

