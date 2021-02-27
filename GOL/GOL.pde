// **** rules at line 60 ********
/**`    line 321 has var sf - > resolution
 * conways game of life
 * 
 * @author (your name) 
 * @version (a version number or a date)
 */
import java.util.ArrayList;
public class Life
{
    // instance variables - replace the example below with your own
    public long GenerationCount;
    private byte[][] grid;
    private byte[][] nextGen;
    //private ArrayList<byte[][]> history;
    private String graphics = " 1";
    private boolean mode = true;
    
    private byte rule(int x, int y)
    {
        byte acc[] = {0,0,0,0,0,0,0,0};
        for (int i = -1; i < 2; i ++)
        {
            for (int j = -1; j < 2; j++)
            {
                byte add = grid[((i+y)%grid.length + grid.length)%grid.length][((j+x)%grid[0].length + grid[0].length)%grid[0].length];
                for (int b = 0; b < 8 ; b++)
                    acc[b] += (add>>b)%2;
            }
        }
       
        // born 3, survive 2,3 + 10 = 12,13
        //int[] rules = new int[]{3,6,12,14,16,15};
        //int[] rules = new int[]{3,6,12,13,17};
        /*/int[] rules = new int[]{3,6,12,14,15};
        int[][] rules = new int[][] {{3,1},{12,1},{13,1},{16,2},{23,27},{271,27},{272,27},{273,27},{274,27},{275,27},{276,27},{277,27},{278,27},{270,128},{1280,64},{128,8},{640,32},{320,16},{160,8},{80,4},{40,2},{20,1}};
        for (int i = 0; i < rules.length ; i++)
        {
            if (acc == rules[i][0])
                return (byte) (rules[i][1]);
        }
        return (byte)(0);
        */
        byte res = 0;
        /*int[][] layerRules = {{3,12,13},
                              {3,6,11,12,15},
                              {3,6,8,12,14,15},
                              {3,5,7,12,13,18},
                              {3,4,5,15},
                              {3,11,12,13,14,15},
                              {4,5,6,7,8,12,13,14,15},
                              {3,12,13}};
        int[][][] tLayerRules = {{{15,2}},
                                 {{15,4}},
                                 {{15,8}},
                                 {{15,16}},
                                 {{15,32}},
                                 {{15,64}},
                                 {{15,128}},
                                 {{15,1}}};*/
        //syntax : {{layer 1 rules},{layer 2}...} each rule is {born#1,born#2...,survive#1 + 10,survive#2 + 10...}
        int[][] layerRules = {{}, 
                              {},
                              {3,12,13},
                              {},
                              {4,6,12,15,16},
                              {3,11,12},
                              {5,15},
                              {}};
        //syntax: layers are same, each layer {{born/survive#,...(born/survive for layers going up(looping)), OR mask, XOR mask}...}
        int[][][] tLayerRules = {{{10,0,16}},
                                 {{10,0,1}},
                                 {{2,0,2}},
                                 {{1,0,64},{10,0,32}},
                                 {{10,0,8},{3,0,8}},
                                 {{15,0,64},{18,8,0,4},{18,0,4}},
                                 {{2,0,32}},
                                 {{9,0,0}}};//7:7,0,4 | 6:,{8,4,0,4}
        for (int l = 7; l >= 0 ; l--)
        {
          int lAcc = (int)(acc[l]);
          if ((grid[y][x] & (1<<l)) > 0)
              lAcc += 9;
          for (int i = 0; i < layerRules[l].length ; i++)
          {
            if (lAcc == layerRules[l][i])
            {
                res += (byte)(1<<l);
                break;
            }
          }
          
          for (int i = 0; i < tLayerRules[l].length ; i++)
          {
            boolean put = true;
            for (int p = 0; p < tLayerRules[l][i].length - 2;p++)
            {
              lAcc = (int)(acc[(l+p)%8]);
              if ((grid[y][x] & (1<<((l+p)%8))) > 0)
                lAcc += 9;
              if (lAcc != tLayerRules[l][i][p])
                {put = false; break;}
            }
            if (put)
            {
                res |= (byte)(tLayerRules[l][i][tLayerRules[l][i].length - 2]);
                res ^= (byte)(tLayerRules[l][i][tLayerRules[l][i].length - 1]);
                break;
            }
          }
        }
        
        
        
          
        return res;
        
    }
    
    
    
    /**
     * Constructor for objects of class Life
     */
    public Life()
    {
        // initialise instance variables
        grid = new byte[20][50];
        nextGen = new byte[20][50];
        GenerationCount = 0;
        //history = new ArrayList();
    }

    public Life(int dim)
    {
        grid = new byte[dim][dim];
        nextGen = new byte[dim][dim];
        GenerationCount = 0;
    }
    public Life(int x, int y)
    {
        grid = new byte[y][x];
        nextGen = new byte[y][x];
        GenerationCount = 0;
    }
    /**
     * An example of a method - replace this comment with your own
     * 
     * @param  y   a sample parameter for a method
     * @return     the sum of x and y 
     */
    public void doFrame()
    {
        for (int x  = 0; x < grid[0].length;x++)
        {
            for (int y = 0; y < grid.length;y++)
            {   
                nextGen[y][x] = rule(x,y);
            }
        }
        for (int x = 0; x < grid[0].length;x++)
        {
            for (int y = 0; y < grid.length;y++)
            {   
                
                grid[y][x] = nextGen[y][x];
            }
        }
        GenerationCount++;
    }
    public String toString()
    {
        String tmp = "";
        if (mode)
         for (int py = 0; py < grid.length;py+= 4)
         {
            for (int px = 0; px < grid[0].length;px+= 2)
            {   
                int chunk = 0;
                for (int x = 0; x < 2;x++)
                {
                    for (int y = 0; y < 4;y++)
                    {   
                        try{
                            if (grid[y+py][x+px] == 1)
                            {
                                if (y < 3)
                                    chunk += (1<< (y + 3*x));
                                else
                                    chunk += (1<< (6 + x));
                            }else{
                            }
                        }
                        catch(Throwable e){}
                    }
                }
                
                tmp += String.valueOf(Character.toChars(0x2800 +  chunk)) ;
                
            }
            tmp += "\n";
         }
        else
         for (int y = 0; y < grid.length;y++)
         {
            for (int x = 0; x < grid[0].length;x++)
            {   
                tmp += graphics.substring(grid[y][x],grid[y][x]+1);
            }
            tmp += "\n";
         }
        return tmp;
        
    }
    public void fillRand(double chance)
    {
        for (int x = 0; x < grid[0].length;x++)
        {
            for (int y = 0; y < grid.length;y++)
            {   
                if (Math.random() < chance)
                    grid[y][x] = 1;
                else
                    grid[y][x] = 0;
            }
        }
    }
    public void fillRand(double chance, int range)
    {
      for (int x = 0; x < grid[0].length;x++)
        {
            for (int y = 0; y < grid.length;y++)
            {   
                for (int b = 0; b < range ; b++)
                  if (Math.random() < chance)
                      grid[y][x] |= 1<<b;
                  
            }
        }
      
      
      
    }
    public byte getPt(int x, int y)
    {
      return grid[y%grid.length][x%grid[0].length];
    }
    public void setPt(int x, int y,byte v)
    {
      grid[y][x] = v;
    }
    public void togglePt(int x, int y)
    {
      grid[y][x] = (byte)(1 - grid[y][x]);
    }
    public void toggleBit(int x, int y,int bit)
    {
      grid[y][x] ^= (byte)(1<<bit);
    }
    public boolean empty()
    {
      for (byte[] r : grid)
        for (byte v : r)
          if (v != 0 )
            return false;
      return true;
    }
    
    
    
}
color colTransFunc(int r, int g, int b)
{
   return color(255-(255-r)*(255-r)/255,255-(255-g)*(255-g)/255,255-(255-b)*(255-b)/255); 
  
}
int show = -1;
void colFunc(byte val,int x, int y)
{
   if (show ==-1)
   {
   int g = ((val%8) *31)%256;
   int r = ((val/8)%4 * 63)%256;
   int b = 0;
   int w = 0;
   if (mX == x)
     w += 16;
   if (mY == y)
     w += 16;
   if (mX == x && mY == y)
     w += 16;
   b += ((val/32) * 63)%256; 
   color tmpCol = colTransFunc(min(r+w,255),min(g+w,255),min(b+w,255));
   for (int ax = 0; ax < sf ; ax++)
    for (int ay = 0; ay < sf ; ay++)
     set(sf*x+ax,sf*y+ay,tmpCol);
   }else{
     int g = (val / (byte)(1<<show))%2 *255;
   int r = 0;
   int b = 0;
   if (mX == x)
     r += 64;
   if (mY == y)
     b += 64;
   if (mX == x && mY == y)
   {
     b += 128+ 63;
     r += 128+ 63;
   }
   color tmpCol = colTransFunc(r,g,b);
   for (int ax = 0; ax < sf ; ax++)
    for (int ay = 0; ay < sf ; ay++)
     set(sf*x+ax,sf*y+ay,tmpCol);
   
     
   }
}
boolean fullscreen = true;

boolean pause = true;
int sf = 16;
void setup()
{
  //if (!fullscreen)
    //size(500,500);
  //else
    fullScreen();
  background(255,255,255);
  gWidth = width/sf;
  gHeight = height/sf;
  gol  = new Life(gWidth,gHeight);
  noCursor();
  frame.setResizable(true);
  gol.toggleBit(49,49,2);
  gol.toggleBit(50,49,2);
  gol.toggleBit(51,49,2);
  gol.toggleBit(51,50,2);
  gol.toggleBit(50,51,2);
  
}

int gWidth;
int gHeight;
Life gol;
final String INSTR = "Controls\n space - toggle pause\n p - place pixel\n r - fill random\n c - clear screen\n f - advance one frame\n - or = - change scale\n _ or + - change size\n 1 to 7 - change view layer\n 0 - view all\n # - show generation count";
String instr = INSTR;

boolean needResize = false;
boolean needResizeGol = false;

void draw()
{
 
  //if (gol.empty())
  //    gol.fillRand(0.13);
  //gol.togglePt((int)(Math.random()*100),(int)(Math.random()*100));
  for (int x = 0; x < width/sf ; x ++)
     for (int y = 0; y < height/sf ; y ++)
     {
        
        colFunc(gol.getPt(x,y),x,y);
     }
  if (!pause)
    gol.doFrame();
  if (mousePressed)
    gol.togglePt(mX,mY);
 if (needResize){
    frame.setSize(gWidth*sf,gHeight*sf);
    needResize = false;
  }
  if (needResizeGol)
  {
    gol = new Life(gWidth,gHeight);
    needResizeGol = false;
  }
  if (instr.length() > 0)
  {
    fill(64,255,64);
    textSize(12+3*sf);
    text(instr,5,5,width-5,height-5);
  }
  if (showGenCount)
  {
    fill(255,255,64);
    textSize(12+3*sf);
    text("" + gol.GenerationCount,width-30,5,width-5,height-5);
  }
}

import java.awt.AWTException;
import java.awt.Robot;

boolean showGenCount = false;
int mX = mouseX/sf;
int mY = mouseY/sf;
void keyPressed()
{
  if (key == '#')
  {
    showGenCount ^= true;
  }
  if ("-=_+".indexOf(key) >=0)
  {
    if (key == '-' && sf > 1)
      sf --;
    if (key == '=')
      sf ++;
    if ("_+".indexOf(key) >=0)
    {
      if (key == '_')
        {gWidth --; gHeight --;}
      else
        {gWidth ++; gHeight ++;}
      needResizeGol = true;
    }
    needResize = true;
  }
  
  if (key == 'c' || key == 'C')
    gol.fillRand(0);
  if (key == ' ')
    pause = ! pause;
  if (key == 'r')
    gol.fillRand(0.13,8);
  if (key == 'f')
    gol.doFrame();
  if (key == 'p')
    if (show > -1 )
      gol.toggleBit(mX,mY,show);
    else  
      gol.togglePt(mX,mY);
  if ("012345678".indexOf(key) >= 0)
    show = "012345678".indexOf(key) - 1;
  
  
    if(keyCode == UP)
      mY--;
    if(keyCode == DOWN)
      mY++;
    if(keyCode == LEFT)
      mX--;
    if(keyCode == RIGHT)
      mX++;
      
   if (instr.length() > 0 && keyPressed)
     instr = "";
   if (key == 'h')
     instr = INSTR;
}

void mouseMoved()
{
  mX = mouseX/sf;;
  mY = mouseY/sf;;
  
}

void mousePressed()
{
  
  
  
}