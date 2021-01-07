void send_data_to_thingsboard()
{
  // sending data to things board
  if ( !client.connected()) {
    reconnect();
  }
  {

    //Create Json String
    String payload = "";
    payload += "{\"t\":";
    payload +=  String(1);
    payload +=",\"t1\":";
    payload +=  String(event[0]);
    payload +=",\"t2\":";
    payload +=  String(event[1]);
    payload +=",\"t3\":";
    payload +=  String(event[2]);
    payload +=",\"t4\":";
    payload +=  String(event[3]);
    payload +=",\"t5\":";
    payload +=  String(event[4]);
    payload +=",\"t6\":";
    payload +=  String(event[5]);
    payload +=",\"t7\":";
    payload +=  String(event[6]);
    payload +=",\"t8\":";
    payload +=  String(event[7]);
    payload +=",\"t9\":";
    payload +=  String(event[8]);
    payload +=",\"t10\":";
    payload +=  String(event[9]);
    payload +=",\"t11\":";
    payload +=  String(event[10]);
    payload += "}";
    
    uint8_t str_len =  payload.length() + 1;
    char attributes[str_len];
    payload.toCharArray( attributes, str_len);
    if (client.publish(topic, attributes))
    {
    }
    else
    {
      client.disconnect();
      reconnect();
    }
    client.loop();
  }
}

void reconnect() {
  // Loop until we're reconnected
  client.setServer( thingsboardServer, 1885);
  while (!client.connected()) {
    status = WiFi.status();
    if ( status != WL_CONNECTED) {
     
      WiFi.begin(ssid, password);
      while (WiFi.status() != WL_CONNECTED) {
        delay(500);
      }
    }
    if ( client.connect("ESP8266-110", TOKEN, NULL) ) {
    } 
    else {
      delay(5000);
    }
  }
}

