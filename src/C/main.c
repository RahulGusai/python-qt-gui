/**
   CC2500 Sample transceiver code
   This will send a packet containing the length and "Hello"
   Every 400ms, then go into receive mode.
   Adapted from https://github.com/yasiralijaved/Arduino-CC2500-Library
   Written by Zohan SonZohan@gmail.com

   Hardware SPI:
   MISO -> 12
   MOSI -> 11
   SCLK/SCK -> 13
   CSN/SS - > 1
*/
#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>
SoftwareSerial swSer(14, 12, false, 350);
#include <PubSubClient.h>

const char* ssid = "vacusdemo";
const char* password = "vacusdemo";

#define TOKEN "JpXVT8bmuNjN0Yl9qOti"
#define thingsboard_port 1885
char thingsboardServer[] = "34.93.68.23";
char topic[] = "tb/mqtt-integration-tutorial/sensors/SN-004/temperature";
WiFiClient wifiClient;
PubSubClient client (wifiClient);
int status;

#include "cc2500_REG.h"
#include "cc2500_VAL.h"
#include <SPI.h>
#include <UIPEthernet.h>


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_NO_OF_TAGS 100
#define TAG_DATA_LEN 4

/* Sync Packet Formation */
#define SYNC_BYTE_ADDR 0X07
#define SYNC_PKT_ADDR_L 0x06
#define SYNC_PKT_ADDR_M 0X05
#define SYNC_PKT_ADDR_H 0X04
#define SYNC_PKT_BATT_MSB 0X08
#define SYNC_PKT_BATT_LSB 0X09

#define RSSI_OFFSET 72

#define SYNC_PKT_LEN 13
#define ANT_PKT_LEN 3

#define LISTENING_INTERVAL 30000      //listening time from ZM

uint32_t  millisRxPkt, millisTagsData;



/******************************************************************
   User interface leds and IO
 ******************************************************************/
#define CC2500_RX_PIN 5    

#define ANT_PIN_1 0
#define ANT_PIN_2 2    

#define SS_CC 15
#define SS_enc 16

#define PACKET_LENGTH 64
#define No_of_times_packet_repeat 3

#define countIteration 3
#define data_channel 12

uint32_t currentMillis = 0;   

uint8_t recv;

boolean received;

#define RADIO_PKT_LEN_BYTE 0
#define RADIO_PKT_MAX_LEN 20
uint8_t radioPktBuffer[RADIO_PKT_MAX_LEN];

struct {
  uint8_t baseFreq;
  uint8_t channel;
} centerFreq;

uint8_t serial_data;
uint8_t baseFreq, channel;

uint8_t addrLowByte, addrHighByte, addrMiddleByte;
uint8_t battMsb,battLsb;
uint8_t tagCount=0;
uint8_t* tagData;
int8_t tagRssi;
char countBuffer[5];
char cmdRcvd;

/*Tag Registration - For ThingsBoard Only*/
int registered_tags[11] = {101,102,103,104,105,155, 156, 164, 165, 169, 170};
int event[11] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

void setup() {
  
  //CC2500 related initializations
  pinMode(ANT_PIN_1, OUTPUT);
  pinMode(ANT_PIN_2, OUTPUT);
  

  Serial.begin(115200);
  pinMode(CC2500_RX_PIN, INPUT);

  pinMode(SS_CC, OUTPUT);
  SPI.begin();
  digitalWrite(SS_CC, HIGH);

  //Connect To WiFi
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  Serial.print(F("\nConnecting to ")); Serial.println(ssid);

  Serial.println();
  Serial.println();
  Serial.print("Wait for WiFi... ");

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
    //blink_led(1);
  }
  /* Display WiFi Details */
  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
  
  /* Set the frequency and channel number for radio */
  centerFreq.baseFreq = 0, centerFreq.channel = 50;

   /* Setting up the Antenna */
  digitalWrite(ANT_PIN_1, HIGH);

  /* Configuring the radio before starting to receive the data from Tags */
  baseFreq = centerFreq.baseFreq, channel = centerFreq.channel;
  rfConfiguration(baseFreq,channel);

  client.setServer(thingsboardServer, 1885);
}

void loop() {
    /* Waiting for the command to start the reception */
    if ( Serial.available() > 0 )
    {
       cmdRcvd = Serial.read();    
        
       if( cmdRcvd == 'Y')
       {
          /* Allocating memory for the Tags Data */
          tagData = (uint8_t*)malloc( (sizeof(uint8_t)*TAG_DATA_LEN)*MAX_NO_OF_TAGS );

          /* Capture the data for distinctive Tags */
          fetchTagsData();

          /* Send the count to the main app */
          sendCount();          

          /* Send data to Thingsboard */
          sendEvent();
          for (int i = 0; i < 10; i++)
          {
            //Serial.println("Sending to Thingsboard");
            send_data_to_thingsboard();
            delay(5000);
          }
          
          /* Free the memory*/
          free(tagData);
          
          tagCount = 0;
       }

    }
}   

void sendCount()
{
  sprintf(countBuffer,"%d\n",tagCount);
  Serial.print(countBuffer);
}


/* Function to fetch the data from Tags */
void fetchTagsData() {
  //Serial.println("Starting to receive");
  
  received = false;
  
  currentMillis = millis();

  sendRxStrobe();

  while (millis() - currentMillis < LISTENING_INTERVAL)
  {
    yield();
     
    receivePacket();
    
    if (received)
    {
        received = false;
  
        /* Check if the sync packet is received from the Tag */
        if ((radioPktBuffer[SYNC_BYTE_ADDR] == 0xF5) || (radioPktBuffer[SYNC_BYTE_ADDR] == 0xF0))
        {
          
            addrHighByte = radioPktBuffer[SYNC_PKT_ADDR_H];      
            addrMiddleByte = radioPktBuffer[SYNC_PKT_ADDR_M];
            addrLowByte = radioPktBuffer[SYNC_PKT_ADDR_L];

            /* For debugging purpose*/ 
            //Serial.printf("%d %d %d\n",addrHighByte,addrMiddleByte,addrLowByte);  
            
            if( tagCount==0 )
            {
                appendTagData();          
            } 
      
            else
            {      
              if( isTagAlreadyPresent()==0 )
                 appendTagData();     
            }
        }

        sendRxStrobe();
     }
  }
}  
    
bool isTagAlreadyPresent()
{
  for( int i=0; i<tagCount; i++)
  {
      if( (tagData[ (i*TAG_DATA_LEN) + 0 ] == addrHighByte) && (tagData[ (i*TAG_DATA_LEN) + 1 ] == addrMiddleByte) && (tagData[ (i*TAG_DATA_LEN) + 2 ] == addrLowByte) )
          return 1;
  }
  return 0;
}


void appendTagData()
{
    /* Retreiving the TAG ID from he sync packet */
    tagData[ (tagCount*TAG_DATA_LEN ) + 0]  = addrHighByte;
    tagData[ (tagCount*TAG_DATA_LEN ) + 1] = addrMiddleByte;
    tagData[ (tagCount*TAG_DATA_LEN ) + 2] = addrLowByte;

    battMsb = radioPktBuffer[SYNC_PKT_BATT_MSB];
    battLsb = radioPktBuffer[SYNC_PKT_BATT_LSB];
    
    uint16_t tempBatt = ( battMsb << 8 ) | battLsb;
    tagData[ (tagCount*TAG_DATA_LEN ) + 3]= (uint8_t)(((float)(tempBatt >> 6) * 0.00722) * 10);    

    tagCount++;
}

   

void sendRxStrobe()
{
  memset(radioPktBuffer,0,RADIO_PKT_MAX_LEN);

  sendStrobe(CC2500_SIDLE);
  sendStrobe(CC2500_SFRX);
  sendStrobe(CC2500_SRX);
}


void rfConfiguration(uint8_t baseFreq, uint8_t inputChannel)
{
  radioConfigure(2,baseFreq);
  init_channel(inputChannel);
}

void sendEvent()
{
  for (int i = 0; i < 11; i++)// Check whether the registered tag is received or not
  {
    for (int j = 0; j < tagCount; j++)
    {
      if (registered_tags[i] == tagData[(j*4)+2])
      {
        event[i] = 1;
        break;
      }
    }
  }
}

