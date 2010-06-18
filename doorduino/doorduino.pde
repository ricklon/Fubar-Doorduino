/*
 * Web Server
 *
 * A simple web server that shows the value of the analog input pins.
 */

#include <Ethernet.h>

byte mac[] = { 0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED };
byte ip[] = { 192, 168, 1, 3 };

Server server(80);

int pinSpeaker = 9;
int doorPin=8;
int lockPin=7;
int doorState=HIGH;
int lockState=HIGH;
int door=HIGH;
int lock=HIGH;
double lockTimer = 0;
double doorTimer = 0;
int lockBounce = 20;
int doorBounce = 20;

void setup()
{
  Ethernet.begin(mac, ip);
  server.begin();
  pinMode(pinSpeaker, OUTPUT);
  pinMode(doorPin, INPUT);
  pinMode(lockPin, OUTPUT);
}

void loop()
{
  Client client = server.available();
  servPage(client);
  lock=digitalRead(lockPin);
  if (lock!=lockState && (millis() - lockTimer) > lockBounce)
  {
    lockState=lock;
    lockTimer=millis();
    if (lock==HIGH)
    {
      //locked
    }
    else
    {
      //unlocked
    }  
  }
  door=digitalRead(doorPin);
  if (door!=doorState && (millis() - doorTimer) > doorBounce)
  {
    doorState=door;
    doorTimer = millis();
    if (door==HIGH)
    {
      //closed
    }
    else
    {
      //open
    }  
  }
}

void servPage(Client client) {
   if (client) {
    // an http request ends with a blank line
    boolean current_line_is_blank = true;
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        // if we've gotten to the end of the line (received a newline
        // character) and the line is blank, the http request has ended,
        // so we can send a reply
        if (c == '\n' && current_line_is_blank) {
          // send a standard http response header
          client.println("HTTP/1.1 200 OK");
          client.println("Content-Type: text/html");
          client.println();
          
          client.print("lock: ");
          client.print(lockState);
          client.println("<br />");
          client.print("door: ");
          client.print(doorState);
          client.println("<br />");
          
          break;
        }
        if (c == '\n') {
          // we're starting a new line
          current_line_is_blank = true;
        } else if (c != '\r') {
          // we've gotten a character on the current line
          current_line_is_blank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(1);
    client.stop();
  }
}
