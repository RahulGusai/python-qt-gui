void receivePacket() {

  if (digitalRead(CC2500_RX_PIN) == HIGH)
  {
    millisRxPkt = millis();
    while ((digitalRead(CC2500_RX_PIN) == HIGH) && (millis() - millisRxPkt < 10));     //wait till receiption is completed

    digitalWrite(SS_CC, LOW);
    
    millisRxPkt = millis();
    while ((digitalRead(CC2500_RX_PIN) == HIGH) && (millis() - millisRxPkt < 10));

    SPI.transfer(0xFF);  
    radioPktBuffer[RADIO_PKT_LEN_BYTE] = SPI.transfer(0x3D);

    if (radioPktBuffer[RADIO_PKT_LEN_BYTE] < RADIO_PKT_MAX_LEN)
    {
      for (uint8_t i = 1; i <= (radioPktBuffer[RADIO_PKT_LEN_BYTE] + 2) ; i++)
        radioPktBuffer[i] = SPI.transfer(0x3D);

      /* For debugging */ 
//      for (uint8_t i = 0; i <= (radioPktBuffer[RADIO_PKT_LEN_BYTE] + 2) ; i++)
//        Serial.printf("%d ",radioPktBuffer[i]);
//      Serial.println();  
//    
      digitalWrite(SS_CC, HIGH);

      if ((radioPktBuffer[radioPktBuffer[RADIO_PKT_LEN_BYTE] + 2] & 0x80) == 0x80)
      {
  
        received = true;
        }
      else
      {
        sendRxStrobe();
      }
    }
    else
    {
      digitalWrite(SS_CC, HIGH);
      sendRxStrobe();
    }
  }
}
