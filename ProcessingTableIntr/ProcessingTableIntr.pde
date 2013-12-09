/*
 * Squeeze me not! 
 * ---------------------- 
 *
 * Draws a squeeze me not amiley on the screen. Size, position of eyes, curvature of the smile,
 * angry brows, color and the descriptive text are controlled by a device on a serial port.  
 * Press space bar to clear screen, or any 
 * other key to generate fixed-size random balls.
 *
 * Receives an ASCII number over the serial port, 
 * terminated with a carriage return (ascii 13) then newline (10).
 * 
 * This matches what Arduino's " Serial.println(val)" function
 * puts out.
 *
 * Created 08 October 2013
 * Sonali Sharma
 */
import processing.serial.*;

//Initialising variables
//String portname1 = "/dev/tty.usbmodem1411"; 
String portname1 = "/dev/tty.HC-06-DevB";
String portname2 =  "/dev/tty.HC-06-DevB-1";

/*[0] "/dev/tty.Bluetooth-PDA-Sync"
[1] "/dev/cu.Bluetooth-PDA-Sync"
[5] "/dev/cu.JAMBOXbyJawbone-SPPDev"
[6] "/dev/tty.HC-06-DevB"
[7] "/dev/cu.HC-06-DevB"
[8] "/dev/tty.HC-06-DevB-1"
[9] "/dev/cu.HC-06-DevB-1"
[2] "/dev/tty.Bluetooth-Modem"
[3] "/dev/cu.Bluetooth-Modem"
[4] "/dev/tty.JAMBOXbyJawbone-SPPDev"
[5] "/dev/cu.JAMBOXbyJawbone-SPPDev"
[6] "/dev/tty.HC-06-DevB"
[7] "/dev/cu.HC-06-DevB"
[8] "/dev/tty.HC-06-DevB-1"
[9] "/dev/cu.HC-06-DevB-1"
*/


String[] temp;
Serial port1;
Serial port2;
String buf1="";
String buf2="";
int preval1 = 0;
int preval2 = 0;

int cr = 13;  // ASCII return   == 13
int lf = 10;  // ASCII linefeed == 10
PFont f;
int quesloc = -2;
String newques="";
int val1 = 0;
int val2 = 0;
boolean flag = true;
String[] questions = {
  "##### is hiding _____ from me",

"##### can’t buy me love, but it can buy me _____",

"For my next trick, I will pull ##### out of _____",

"I learned that you cannot cheer up ##### with _____",

"Before I kill you #####, I must show you _____",

"Every Christmas, my ##### gets drunk & tells stories about _____",

"My gym teacher got fired for adding ##### to _____"

    };
    
int prevquesloc = int(random(questions.length));
    
 String[] answers1 = {
            "Ugly Naked Guy",
            "a cooler full of organs",
            "Money",
            "Flying Robots",
            "friend"

    };
 String[] answers2 = {
    "Grandma",
    "a marriage proposal",
    "an obstacle course",
    "poorly timed jokes",
    "Mr. Bond"

    };
    
 int[] pins = {0,1,2,3,4};
  
//Basic Setup
void setup() {
  size(800,800);
  frameRate(10);
  noStroke();
  background(40,40,40);
  port1 = new Serial(this, portname1, 9600);
  port2 = new Serial(this, portname2, 9600);
  println(Serial.list());
}

void draw() {
  
  if(val1 == 0 && val2 == 0)
    {
      if(quesloc!=-2)
      {
        prevquesloc = quesloc;
      }
     quesloc = -2;
     //flag = true;
    }
    else
    {
      flag = true;
    }
  textdisplay(val1,val2);
  
  
  //text(newques,width/3,40);  
}

int GetNewVal(int val)
{
  if(val == 1) 
  {
    return 2;
  }
  else if(val == 2)
  {
    return 1;
  }
  
  else if(val == 3)
  {
    return 4;
  }
  
  else if(val == 4)
  {
    return 3;
  }
  
  return val;

}

void clearScreen(int val1, int val2) {
  //if ((val1!=1 || val1!=2 || val1!=3 || val1!=4 || val1!= 0 ) && (val2!=1 || val2!=2 || val2!=3 || val2!=4 || val2!= 0)) {
  //  background(40,40,40);  // erase screen
  //}
  background(40,40,40);
}
//Display the text. Font size and the headline text controlled by the values passed from serial port.
int textdisplay(int val1, int val2)
{
  println("This is  inside rthe text method, just reached here:"+val1);
  val1 = GetNewVal(val1);
  val2 = GetNewVal(val2);
  
  if(true)
  {
      //int size = (int)(((20.0/225.0)*(float)val)+20.0);
      //println("SIZE:"+size);
      String ans1 = "";
      String ans2 = "";
      int size = 32;
      f = createFont("Arial",size,true); 
      textFont(f);       
      fill(255);
      //textAlign(CENTER);    
      //Queston display
      String newques = "";       
      fill(251);
      if (quesloc ==-2 && flag==true)
       {
        quesloc = int(random(questions.length)); //int(random(50)%7);
        flag = false;

       }
       else
       {
         quesloc = prevquesloc;
       }
       newques = questions[quesloc];//.replace("#####","_____");
       
  
       //clearScreen(val1,val2);
      background(40,40,40);
      //Calculating index to display the text
      //int index = (int)((float)(6.0/255.0)*(float)val);
      int index1 = 0;
      int index2=0;
      for (int i =0; i<pins.length; i++)
      {
        if (val1 == pins[i])
        {
          index1 = i;
          break;
        }
        println("This is inside the loop:"+val1);
      }
      
      for (int i =0; i<pins.length; i++)
      {
        if (val2 == pins[i])
        {
          index2 = i;
          break;
        }  
      }     
      //background(40,40,40);
      println("index1:"+index1);
      println("index2:"+index2);
      //text(newques,width/3,40);  
      temp = newques.split("\\s+");
     //  temp = questions[quesloc].split("\\s+");
      float xinit = 100.0;
      float buffer = 0.0;
      int initloc = 150;
      int transloc = 0;
      //questions[quesloc].replace("_____",answers[index]);
      
      for (int z=0; z<temp.length;z++)
      {
        if (z%3==0 && z!=0)
        {    
          resetMatrix(); 
          initloc = initloc+50;
          //float tmpxinit = xinit;
          xinit = 100.0;
          translate(xinit,initloc);
          
        }
        //initloc = initloc+50;
        if (z==0)
        {
          translate(xinit,initloc);
        }
        if (temp[z].equals("#####"))
        {
          //println("initloc="+initloc);
          fill(0,255,0);
          stroke(5);
          println("this is " + answers1[index1]);
          //text(answers1[index1],width/3,initloc);
          
          if(val1 != 0)
          {
           //text(answers1[index1],width/3,initloc);
           //translate(textWidth(answers1[index1]),transloc); 
           xinit = xinit + textWidth(answers1[index1]) + buffer;
           //text(answers1[index1],xinit,initloc );
           text(answers1[index1],0,0);
           translate(xinit,0);
           
           //translate(textWidth(answers1[index1]),initloc);
          }
          else
          {
            //text("_____",width/3,initloc);
            
            //translate(textWidth("_____"),transloc);
            xinit = xinit + textWidth("_____") + buffer;
            
            text("_____",0,0);
            translate(xinit,0);
            
            
          }
          
//          else
//          {
//             text("@@@@@",width/3,initloc);
//          }
          //initloc = initloc+10+answers[index].length()*5;
        }
        
        else if(temp[z].equals("_____"))
        {
         fill(0,255,0);
          stroke(5);
          if(val2 != 0)
          {
            //text(answers2[index2],width/3,initloc);
            //translate(textWidth(answers2[index2]),transloc);
            xinit = xinit + textWidth(answers2[index2]) + buffer;
            text(answers2[index2],0,0);
            translate(xinit,0);
          
          }
          else
          {
            //text(temp[z],width/3,initloc);
            //translate(textWidth("_____"),transloc);
            xinit= xinit + textWidth("_____") + buffer;
            text("_____",0,0);
            translate(xinit,0);
          }
        }
        
        else
        {
          fill(255,0,0);
          //translate(textWidth(temp[z]),transloc);
          xinit = xinit + textWidth(temp[z]) + buffer;
          text(temp[z],0,0);
          translate(xinit,0);
          //initloc = initloc+10+temp[z].length()*5;
        }
      } 
      //popMatrix();
  
      return 1;
  }
  
  else
  {
    background(255);
    noStroke();
    return 0;
  }
}

// called whenever serial data arrives
void serialEvent(Serial p) {
  int c2 = port2.read();
  int c1 = port1.read();
 
  if (c1 != lf && c1 != cr) {
    buf1 += char(c1);
  }
  if (c1 == lf) {
     val1 = int(buf1);
    println("val1="+val1); 
    buf1 = "";
  }
  if (c2 != lf && c2 != cr) {
    buf2 += char(c2);
  }
  
  if (c2 == lf) {
    val2 = int(buf2);
    println("val2="+val2); 
    buf2 = "";
    
    println("Just before textdisplay:"+val1);
    println("Text width:"+textWidth("i"));

    //textdisplay(val1,val2);
  }
}
