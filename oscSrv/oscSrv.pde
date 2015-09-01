/**
 * oscP5broadcaster by andreas schlegel
 * an osc broadcast server.
 * osc clients can connect to the server by sending a connect and
 * disconnect osc message as defined below to the server.
 * incoming messages at the server will then be broadcasted to
 * all connected clients. 
 * an example for a client is located in the oscP5broadcastClient exmaple.
 * oscP5 website at http://www.sojamo.de/oscP5
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


void setup() {
  oscP5 = new OscP5(this, myListeningPort);
  frameRate(25);
}

void draw() {
  background(0);
  
  text(myNetAddressList.size(),10,20);
}

void oscEvent(OscMessage theOscMessage) {
  /* check if the address pattern fits any of our patterns */
  if (theOscMessage.addrPattern().equals(myConnectPattern)) {
    // modificar connect para conectar (address, port)
    // port se conseguiria via el mensaje de conexion
        
    connect(theOscMessage.netAddress().address(), myBroadcastPort);

  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) {
    disconnect(theOscMessage.netAddress().address(), myBroadcastPort);
  }
  /**
   * if pattern matching was not successful, then broadcast the incoming
   * message to all addresses in the netAddresList. 
   */
  else {
    
    // Esta no me interesa denmasiado
    
    oscP5.send(theOscMessage, myNetAddressList);
  }
}


 private void connect(String theIPaddress) {
     if (!myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
       myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
       println("### adding "+theIPaddress+" to the list.");
     } else {
       println("### "+theIPaddress+" is already connected.");
     }
     println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
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



private void disconnect(String theIPaddress) {
if (myNetAddressList.contains(theIPaddress, myBroadcastPort)) {
		myNetAddressList.remove(theIPaddress, myBroadcastPort);
       println("### removing "+theIPaddress+" from the list.");
     } else {
       println("### "+theIPaddress+" is not connected.");
     }
       println("### currently there are "+myNetAddressList.list().size());
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
