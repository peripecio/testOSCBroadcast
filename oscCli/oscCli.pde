/**
 * oscP5broadcastClient by andreas schlegel
 * an osc broadcast client.
 * an example for broadcast server is located in the oscP5broadcaster exmaple.
 * oscP5 website at http://www.sojamo.de/oscP5
 
 *
 * Modificación Guillermo casado - sept 2015
 * The server stores IP and ports of connected clients, 
 * so each cli can have a diferent listening port, 
 * and a unique computer several diferent clients. 
 *
 * Clis send the connection message with listening Port
 *
 
 */

import oscP5.*;
import netP5.*;


OscP5 oscP5;

/* a NetAddress contains the ip address and port number of a remote location in the network. */
NetAddress myBroadcastLocation; 

String nombreCli = "cli1";
int nDataCli = 200;

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";

int myListeningPort =  12000+nDataCli+1;;
int myBroadcastPort = 32000;

PFont font;

ArrayList<String> lastMessages;

color cBckgnd;

void setup() {
  size(300,300);
  frameRate(25);
  
  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  oscP5 = new OscP5(this,myListeningPort);
  
  /* create a new NetAddress. a NetAddress is used when sending osc messages
   * with the oscP5.send method.
   */
  
  /* the address of the osc broadcast server */
  myBroadcastLocation = new NetAddress("127.0.0.1",myBroadcastPort);

  lastMessages = new ArrayList();  
  
  font = createFont("Courier New", 14, true);

  // color fondo
  colorMode(HSB, 100);
  cBckgnd = color(random(100), 80, 40);
  colorMode(RGB,255);
  
}


void draw() {
//  background(0,0,160);
  background(cBckgnd);

  fill(255);
    
  int yLin = 25;
  int hLin = 15; 
  textFont(font);
  text("OSC Broadcast Client", 10, yLin); yLin += hLin;
  text("c:connect; d:disconn", 10, yLin); yLin += hLin;
  text("====================", 10, yLin); yLin += hLin;
  text(">>> "+nombreCli, 10, yLin); yLin += hLin;

  for(int i=lastMessages.size()-1; i>=0; i--) {
    if(hLin<height) {
      text((String)lastMessages.get(i), 10, yLin); yLin += hLin;
    }
    else break;
  }
  
}


void mousePressed() {
  /* create a new OscMessage with an address pattern, in this case /test. */
  OscMessage myOscMessage = new OscMessage("/test1");
  /* add a value (an integer) to the OscMessage */
  myOscMessage.add(nombreCli);
  float numData = nDataCli+random(5);
  myOscMessage.add(numData);
  /* send the OscMessage to a remote location specified in myNetAddress */
  oscP5.send(myOscMessage, myBroadcastLocation);
}


void keyPressed() {
  OscMessage m;
  switch(key) {
    case('c'):
      /* connect to the broadcaster */
//      m = new OscMessage(myConnectPattern, new Object[0]);
//      oscP5.flush(m,myBroadcastLocation);  
      m = new OscMessage(myConnectPattern);
      m.add(myListeningPort);
      oscP5.flush(m,myBroadcastLocation);  
      break;
    case('d'):
      /* disconnect from the broadcaster */
      m = new OscMessage(myDisconnectPattern, new Object[0]);
      oscP5.flush(m,myBroadcastLocation);  
      break;

  }  
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* get and print the address pattern and the typetag of the received OscMessage */
//  println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
//  theOscMessage.print();
  
  // coger data
  String nombreCli = theOscMessage.get(0).stringValue(); 
  float data = theOscMessage.get(1).floatValue(); 
  
  // formatear datos y meterlo en lastMessages
  lastMessages.add(nombreCli+": "+data);
  
  
  
}

