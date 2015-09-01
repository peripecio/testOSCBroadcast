/**
 * oscP5broadcaster by andreas schlegel
 * an osc broadcast server.
 * osc clients can connect to the server by sending a connect and
 * disconnect osc message as defined below to the server.
 * incoming messages at the server will then be broadcasted to
 * all connected clients. 
 * an example for a client is located in the oscP5broadcastClient exmaple.
 * oscP5 website at http://www.sojamo.de/oscP5
 
 *
 * Modificación Guillermo casado - sept 2015
 * The server stores IP and ports of connected clients, 
 * so each cli can have a diferent listening port, 
 * and a unique computer several diferent clients.  
 *
 
 */
 
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
/* listeningPort is the port the server is listening for incoming messages */
int myListeningPort = 32000;
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
int myBroadcastPort = 12000;

String myConnectPattern = "/server/connect";
String myDisconnectPattern = "/server/disconnect";

PFont font;

void setup() {
  size(300,400);
  oscP5 = new OscP5(this, myListeningPort);
  frameRate(25);
  
  font = createFont("Courier New", 14, true);
  
}

void draw() {
  background(0);
  
  int yLin = 25;
  int hLin = 15; 
  textFont(font);
  text("OSC Broadcast Server", 10, yLin); yLin += hLin;
  text("====================", 10, yLin); yLin += hLin;
  text(">>>> d borrar CLIs", 10, yLin); yLin += hLin;
  
  text("# clis: " + myNetAddressList.size(),10,yLin); yLin += hLin;
  for(int i=0; i<myNetAddressList.size(); i++) {
    NetAddress cli = (NetAddress) myNetAddressList.get(i);
    text(" · "+cli.address()+":"+cli.port(), 10, yLin); yLin += hLin;
    
  }
  
  
}

void keyPressed() {
  
  if(key=='d') {
//    for(int i=myNetAddressList.size()-1; i==0; i--) {
//      myNetAddressList.remove(myNetAddressList.get(i));
//    }
    while(myNetAddressList.size()>0) {
      myNetAddressList.remove(myNetAddressList.get(0));
    }
  }
  
}



void oscEvent(OscMessage theOscMessage) {
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals(myConnectPattern)) {
    // modificar connect para conectar (address, port)
    // port se consegue en el mensaje de conexion, en la posición 0
    // porque el puerto que viene en netAddress es uno temporal.
    int pCli = theOscMessage.get(0).intValue();
    
//    connect(theOscMessage.netAddress().address(), myBroadcastPort);
//    connect(theOscMessage.netAddress().address(), theOscMessage.netAddress().port());
    connect(theOscMessage.netAddress().address(), pCli);

  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) {
//    disconnect(theOscMessage.netAddress().address(), myBroadcastPort);
    disconnect(theOscMessage.netAddress().address(), theOscMessage.netAddress().port());
  }
  /**
   * if pattern matching was not successful, then broadcast the incoming
   * message to all addresses in the netAddresList. 
   */
  else {
    
    // Esta no me interesa demasiado
    
    oscP5.send(theOscMessage, myNetAddressList);
  }
}



 private void connect(String theIPaddress, int portCli) {
     if (!myNetAddressList.contains(theIPaddress, portCli)) {
       myNetAddressList.add(new NetAddress(theIPaddress, portCli));
       println("### adding "+theIPaddress+":"+portCli+" to the list.");
     } else {
       println("### "+theIPaddress+":"+portCli+" is already connected.");
     }
     println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
 }



private void disconnect(String theIPaddress, int portCli) {
  if (myNetAddressList.contains(theIPaddress, portCli)) {
    myNetAddressList.remove(theIPaddress, portCli);
       println("### removing "+theIPaddress+":"+portCli+" from the list.");
     } else {
       println("### "+theIPaddress+":"+portCli+" is not connected.");
     }
  println("### currently there are "+myNetAddressList.list().size());
}


