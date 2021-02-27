
/**
 * Write a description of class Cannonball here.
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */

import java.awt.*; // where is point?
import java.util.*;
public class Cannonball
{
    // instance variables - replace the example below with your own
    public static final double G= -9.81;
    public double x;
    public double y;
    public double vx;
    public double vy;

    /**
     * Constructor for objects of class Cannonball
     */
    public Cannonball(double xpos)
    {
        // initialise instance variables
        x = xpos;
        y=0;
        vx=0;
        vy=0;
    }

    /**
     * An example of a method - replace this comment with your own
     * 
     * @param  y   a sample parameter for a method
     * @return     the sum of x and y 
     */
    public Point getLocation()
    {
        // put your code here
        return new Point((int)(x),(int)(y));
    }
    
    public void move(double dsec)
    {
        x += vx*dsec;
        y += vy*dsec;
        vy += G*dsec;
    }
    
    public ArrayList<Point> shoot(double theta, double v, double dsec)
    {
        ArrayList<Point> points = new ArrayList<Point>();
        vy = v * Math.sin(theta);
        vx = v*Math.cos(theta); 
        do {
        
            points.add(this.getLocation());
            this.move(dsec);
        
        } while ( y > 0 );
    
        points.add(this.getLocation());
        return points;
    }
    
    public void draw()
    {
      ellipse((float)x,(float)(height-y),10,10); 
    }
}