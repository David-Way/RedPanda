import java.awt.Color;
import java.awt.Font;
import java.awt.Paint;
import java.math.BigDecimal;


class JFreeProgressChart {

        JFreeChart chartObject;

        public JFreeProgressChart(float[] date, float[] score, String chartName, String xAxisName, String yAxisName) {
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
                        int day = Integer.parseInt(d.substring(6,8));
                        int month = Integer.parseInt(d.substring(4, 6));
                        int year = Integer.parseInt(d.substring(0, 4));                        
                        pop.addOrUpdate(new Day(day, month, year), score[i]);
                }
                
                TimeSeriesCollection dataset = new TimeSeriesCollection();
                dataset.addSeries(pop);



                //chartObject =  ChartFactory.createScatterPlot(chartName, xAxisName, yAxisName, dataset);



                chartObject = ChartFactory.createScatterPlot(
                chartName, xAxisName, yAxisName, dataset, PlotOrientation.VERTICAL, true, true, false);

                final XYPlot plot = chartObject.getXYPlot(); 
                //final DateAxis domainAxis = (DateAxis) plot.getDomainAxis();     
                DateAxis dAx = new DateAxis();
                dAx.setDateFormatOverride(new SimpleDateFormat("dd/MM/yy"));
                plot.setDomainAxis(dAx);
          
                String fontName = "Lucida Sans";
                StandardChartTheme theme = (StandardChartTheme)org.jfree.chart.StandardChartTheme.createJFreeTheme();

                theme.setTitlePaint( Color.decode( "#4572a7" ) );
                theme.setExtraLargeFont( new Font(fontName, Font.PLAIN, 16) ); //title
                theme.setLargeFont( new Font(fontName, Font.BOLD, 15)); //axis-title
                theme.setRegularFont( new Font(fontName, Font.PLAIN, 11));
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
                chartObject.getPlot().setDrawingSupplier(new DefaultDrawingSupplier(
                new Paint[] { 
                        Color.decode("#33C4F2")
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

