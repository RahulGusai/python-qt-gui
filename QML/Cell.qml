import QtQuick.Controls 2.0
import QtQuick.Layouts 1.7
import QtQuick 2.0

Rectangle{
        id: rect        
        width: 60
        height: 40
        property alias keyName: keyLabel.text
        property alias keySize: keyLabel.font.pointSize
        property alias keyColor: keyLabel.color 
        color: "#565656"    
        signal click(string key)

           


        Text{
            id: keyLabel
            font.pointSize: 14
            color: "black"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        MouseArea{
             
            anchors.fill: parent
            onClicked: rect.click(keyName)
        }    

      
}


