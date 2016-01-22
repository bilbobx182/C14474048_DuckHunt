/*C14474048 ASSIGNMENT 2, FUNDAMENTAL IDEA. DUCK HUNT. */
int alt;
int hellmod;
PFont font2;
PFont font;
int px, py;
int menu;

import ddf.minim.*;
Minim minim;//for audio later

Crosshair crosshair;//crosshair and terrain
Text text;//displaying text
Duck duck;//basic duck
Duck d2; //menu duck
Bear bear;//laughing bear
Stats[] stats =  new Stats [1];

void setup ()
{
  size(700, 700);
  minim = new Minim(this);
  alt=1;
  hellmod=20;
  font2=loadFont("CoolveticaRg-Regular-15.vlw");

  //GAME BGM
  AudioPlayer BGM;
  BGM = minim.loadFile("wolfpack.mp3");
  BGM.play();
  BGM.loop();

  //functions that need to be called.
  loaddata();
  setupobjects();
  stats[0].plays++;
  output();
  noCursor();//hides cursor.
}

//-----Objects-------------
void setupobjects()
{
  crosshair = new Crosshair();
  text = new Text();
  duck= new Duck();
  d2=new Duck();
  bear=new Bear();
  d2.w = d2.w * 3 ;
  d2.x=width-d2.w;
  d2.y=height-d2.w;
}
//-------------INTRO------
void Intro()
{
  String I1="TORRAÍOCHT NA LACHA";
  String I2=" Brú anseo chun tosaigh!";
  PFont font;
  font = loadFont("Aniron-24.vlw");
  font2=loadFont("CoolveticaRg-Regular-15.vlw");

  textFont(font);
  //INTRO SCREEN
  background(#7ec0ee);

  rectMode(CENTER);
  strokeWeight(9);
  stroke(#996515);
  fill(#ccac00);
  rect(width/2, 0, textWidth(I1), height/3);
  fill(0);
  noStroke();
  rectMode(CORNER);

  textAlign(CENTER);
  text(I1, width/2, height/8);
  text(I2, width/2, height/4);


  text("Brú anseo le haghaide d'uas-scór", width/2, height-(height/3));
  textAlign(LEFT);
  textFont(font2);
  strokeWeight(2);
  d2.render();
}
//---------LOAD DATA-------------
void loaddata()
{

  stats[0]=new Stats();

  String[] s2 = loadStrings("stats.csv");
  int i=0;

  i=0;
  for (String line : s2)
  {
    String[] splitter=line.split(",");
    stats[0].kills=Integer.parseInt(splitter[0]);
    stats[0].shots=Integer.parseInt(splitter[1]);
    stats[0].plays=Integer.parseInt(splitter[2]);
    i++;
  }
}

//------------FILES-------------------
//CREATING PERSISTANT DATA, so that it can read in and write out high scores.
PrintWriter output2;
void output()
{
  // output1 = createWriter("highscore.csv"); 

  //writes the stats to the folder of "data" so that it saves to the same place it read in.
  output2 = createWriter("data/stats.csv"); 
  output2.print(stats[0].kills);
  output2.print(",");
  output2.print(stats[0].shots);
  output2.print(",");
  output2.print(stats[0].plays);

  output2.flush();  // Writes the data
  output2.close();
}

//-----------DRAW--------------
void draw()
{
  switch (alt)
  { 
  case 1:
    menu=1;
    Intro();
    break;

  case 2:
    menu=0;

    bgm();
    crosshair.ch();

    duck.bound();
    duck.sound();
    duck.bound();
    duck.render();
    crosshair.render();
    crosshair.rc();
    text.render();
    duck.movement();

    bear.render();
    bear.sound();
    break;

  case 3:
    menu=0;
    Paused();
    break;

  case 4:
    menu=0;
    stats();
    break;

    //reset everything for when they want to play again
  case 9:
    menu=0;
    setupobjects();
    break;

  default:
    alt=1;
    break;
  }
}

void bgm()
{
  if (text.kills>-1 && text.kills<hellmod)

  {
    background(#7ec0ee);
  } else
  {
    background(#8B0000 );
    //makes the duck faster if it's in hellmode
    duck.mod=4;
  }
}


//------Mouseclicked---------
void mouseReleased()
{
  crosshair.bang();
  if (text.bullets>0)
  {
    if (duck.mo == true)
    {
      text.kills++; 
      duck.x=(int)random(width);
      duck.y=height-height/7;
      text.points=text.points+30;
      text.combo++;
    } else
    {
      text.bullets--;
      text.points=text.points-50;
      text.combo=0;
    }
    //combo bonus
    if (text.combo % 10 == 0)
    {
      text.points=text.points + 50;
    }
  }

  if (menu==1)
  {
    if (mouseY<height/2)
    {
      alt=2;
    } else
    {
      alt=4;
    }
  }
}

void keyPressed()
{
  if (key >= '0' && key <='9' )
  {
    alt = key - '0';
  }
}

void Paused()
{
  textAlign(CENTER);
  text("PAUSED THE GAME", width/2, height/2);
  textAlign(LEFT);
}

void stats()
{
  textAlign(CENTER);
  text("D'Uas scór " + stats[0].shots, width/2, height/2);
  text("Do dhreas buillí is mó"+stats[0].kills, width/2, height/2 +20);
  text("am imeartha"+stats[0].plays, width/2, height/2+50);
  textAlign(LEFT);
}

