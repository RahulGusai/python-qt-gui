import QtQuick.Controls 2.0
import QtQuick.Layouts 1.7
import QtQuick 2.0
import QtQuick.Window 2.2
import QtQml 2.2

ApplicationWindow{
    
    id: mainWindow
    height:480
    width: 800
    visible: true
    
    background: Image{
        source: "background.png"
        width: 800
        height: 480
    }

    signal fetchTagsCount(string number)
    Component.onCompleted: {
        mainWindow.showFullScreen();
        con.sendCount.connect(fetchTagsCount);
    }

    StackLayout{
        id: appStack 
        currentIndex: 0

        /* Stack Item 0 */
        Page{
            id: page0
            anchors.fill: mainWindow.fill

            Rectangle{
                anchors.fill : parent.fill  
                color: "white"
        
                Image{
                    x: 240
                    y: 125
                    source: "logo.png" 
                    width: 275
                    height: 70
                }

                Cell{
                    id: clickHere
                    x: 230  
                    y: 350
                    opacity: 0.8
                    width: 300
                    height: 40
                    keySize: 18.0
                    keyName: "Click here to start"
                    keyColor: "white"    
                    onClick: {
                        appStack.currentIndex = 1
                    }
                }
            }
        }

        /* Stack Item 1 */
        Page{
            id: page1
            anchors.fill: mainWindow.fill

            Image{
                x:5
                y:445
                width: 125
                height: 30
                source: "logo.png"
            }

            Cell{
                x:320; y: 455;
                width: 100
                height: 30

                keyName: "Go to home"   
                keySize: 12.0
                onClick:{
                    appStack.currentIndex = 0
                }
            }

            Slider {
                id: control
                value: 7
                from: 1
                to: 15
                x: 150
                y: 250
                snapMode: Slider.SnapOnRelease    

                onMoved:  {
                    distanceVal.text = con.invokeHandler(control.value);
                } 

                background: Rectangle {
                    x: control.leftPadding 
                    y: control.topPadding + control.availableHeight / 2 - height / 2 
                    color : "white"
                    implicitWidth: 500
                    implicitHeight: 15
                    width: control.availableWidth
                    height: implicitHeight
                    radius: 2
                    
                }

                handle: Rectangle {
                    x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
                    y: control.topPadding + control.availableHeight / 2 - height / 2 
                    implicitWidth: 55
                    implicitHeight: 45
                    radius: 10
                    color: control.pressed ? "grey" : "brown"
                }
            }

            Label{
                id: distanceText
                x: 280
                y: 125
                text: "Distance- "
                font.pointSize: 25.0
                font.bold: false
                color: "white"
            }

            Label {
                id: distanceVal
                x: 430  
                y: 125
                text: "7"
                color: "white"
                font.pointSize: 25.0
                font.bold: false
            }
            
            Label {
                x: 340  
                y: 165
                text: "(in mts)"
                color: "white"
                font.pointSize: 13.0
                font.bold: false
            }

            Cell {
                x: 300
                y: 320
                height: 40
                width: 140
                keyName: "Ok"
                keySize: 14.0
                onClick:{
                    appStack.currentIndex = 2;
                }
            }      
        }

        /* Stack Item 2 */
        Page{
            id: page2    
            anchors.fill: mainWindow.fill    

            Rectangle{
                id: inputRect
                x: 200
                y: 100
                color: "white"     
                width: 350
                height: 40   
                
                TextInput{
                    id: inputLabel
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    cursorVisible: true
                    font.pointSize: 14
                    color: "black"
                    text: con.inputText
                }
            }

            Cell{
                id: backButton
                x: 265
                y: 160
                width: 100
                height: 40
                keyName: "Back"
                onClick: {
                    appStack.currentIndex = 1
                }
            }

            Cell{
                id: processButton
                x: 375
                y: 160
                width: 100
                height: 40
                keyName: "Start"
                onClick:{ 
                    appStack.currentIndex = 3;
                    processingPage.startTimer = true

                } 
            }

            Grid{
                id: keyboardGrid1
                rows: 4
                columns: 1
                rowSpacing: 8 
                width: parent.width
                visible: true
                x: 8 
                y: 285

                Row{
                    spacing: 8    

                    Cell{
                        width: 85
                        keyName: "Tab"     
                    }

                    Cell{
                        id: q
                        keyName: "q"     
                        onClick: con.appendText(key)
                    }       
                   
                    Cell{
                        id: w
                        keyName: "w"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: e
                        keyName: "e"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: r
                        keyName: "r"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: t    
                        keyName: "t"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: y
                        keyName: "y"     
                        onClick: con.appendText(key)
                    }    

                    Cell{
                        id: u
                        keyName: "u"     
                        onClick: con.appendText(key)
                    }    

                    Cell{
                        id: i
                        keyName: "i"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: o
                        keyName: "i"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: p
                        width : 70
                        keyName: "p"     
                        onClick: con.appendText(key)
                    }
                }

                Row{
                    spacing: 8    

                    Cell{
                        width: 105
                        keyName: "Caps Lock"     
                        onClick:{
                                if( a.keyName == "A") 
                                { 
                                    color = "#565656"
                                    a.keyName = "a"
                                    b.keyName = "b"
                                    c.keyName = "c"
                                    d.keyName = "d"
                                    e.keyName = "e"
                                    f.keyName = "f"
                                    g.keyName = "g"
                                    h.keyName = "h"
                                    i.keyName = "i"
                                    j.keyName = "j"
                                    k.keyName = "k"   
                                    l.keyName = "l"
                                    m.keyName = "m"
                                    n.keyName = "n"
                                    o.keyName = "o"
                                    p.keyName = "p"
                                    q.keyName = "q"
                                    r.keyName = "r"
                                    s.keyName = "s" 
                                    t.keyName = "t"
                                    u.keyName = "u"
                                    v.keyName = "v"
                                    w.keyName = "w"
                                    x.keyName = "x"
                                    y.keyName = "y"
                                    z.keyName = "z"
                                }       
                    
                                else
                                {
                                    color = "#262626"
                                    a.keyName = "A"
                                    b.keyName = "B"
                                    c.keyName = "C"
                                    d.keyName = "D"
                                    e.keyName = "E"
                                    f.keyName = "F"
                                    g.keyName = "G"
                                    h.keyName = "H"
                                    i.keyName = "I"
                                    j.keyName = "J"   
                                    k.keyName = "K"
                                    l.keyName = "L"
                                    m.keyName = "M"
                                    n.keyName = "N"
                                    o.keyName = "O"
                                    p.keyName = "P"
                                    q.keyName = "Q"
                                    r.keyName = "R" 
                                    s.keyName = "S"
                                    t.keyName = "T"
                                    u.keyName = "U"
                                    v.keyName = "V"
                                    w.keyName = "W"
                                    x.keyName = "X"
                                    y.keyName = "Y"
                                    z.keyName = "Z"     
                                }
                            }
                    }

                    Cell{
                        id: a
                        keyName: "a"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: s    
                        keyName: "s"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: d
                        keyName: "d"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: f
                        keyName: "f"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: g
                        keyName: "g"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: h
                        keyName: "h"     
                        onClick: con.appendText(key)
                    }    

                    Cell{
                        id: j
                        keyName: "j"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: k
                        keyName: "k"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: l
                        keyName: "l"     
                        onClick: con.appendText(key)
                    }
                
                    Cell{
                        width: 50
                        keyName: ":"     
                        onClick: con.appendText(key)
                    }
                }
    

                Row{
                    spacing: 8    

                    Cell{
                        width: 115
                        keyName: "Shift"     
                    }

                    Cell{
                        id: z
                        keyName: "z"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: x
                        keyName: "x"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: c
                        keyName: "c"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id : v
                        keyName: "v"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: b
                        keyName: "b"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        id: n
                        keyName: "n"     
                        onClick: con.appendText(key)
                    }    

                    Cell{
                        id: m
                        keyName: "m"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        keyName: ";"     
                        onClick: con.appendText(key)
                    }    

                    Cell{
                        width: 110
                        keyName: "Backspace"     
                        onClick: con.backSpace()
                    }
                }

                Row{
                    spacing: 8    

                    Cell{
                        width: 90
                        Image{
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            source: "icon.png"
                            width: 35
                            height: 35
                        }     
                    }

                    Cell{
                        width: 100    
                        keyName: "123-@%!"     
                        onClick:{
                            keyboardGrid1.visible = false
                            keyboardGrid2.visible = true
                        }
                    }

                    Cell{
                        width: 275    
                        keyName: "Space"     
                        onClick: con.appendText(" ")
                    }

                    Cell{
                        keyName: "."     
                    }

                    Cell{
                        keyName: ","     
                    }

                    Cell{
                        keyName: "/"     
                    }

                    Cell{
                        width: 85
                        Image{
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            source: "icon.png"
                            width: 35
                            height: 35
                        }     
                    }
                }
            }

            Grid{
                id: keyboardGrid2
                visible: false
                rows: 4
                columns: 1
                rowSpacing: 8 
                width: parent.width
                x: 8 
                y: 285

                Row{
                    spacing: 8    

                    Cell{
                        width: 70
                        keyName: "1"     
                        onClick: con.appendText(key)
                    }       
                   
                    Cell{
                        width: 70    
                        keyName: "2"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "3"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "4"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "5"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70    
                        keyName: "6"     
                        onClick: con.appendText(key)
                    }    

                    Cell{
                        width: 70    
                        keyName: "7"     
                        onClick: con.appendText(key)
                    }    


                    Cell{
                        width: 70
                        keyName: "8"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70    
                        keyName: "9"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70    
                        keyName: "0"     
                        onClick: con.appendText(key)
                    }
                }

                Row{
                    spacing: 8    

                    Cell{
                        width: 70    
                        keyName: "@"     
                    }

                    Cell{
                        width: 70    
                        keyName: "#"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70    
                        keyName: "$"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "&"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "_"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70    
                        keyName: "-"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70    
                        keyName: "("     
                        onClick: con.appendText(key)
                    }    

                    Cell{
                        width: 70    
                        keyName: ")"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70    
                        keyName: "="     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70    
                        keyName: "%"     
                        onClick: con.appendText(key)
                    }
                }
    
                Row{
                    spacing: 8    

                    Cell{
                        width: 70    
                        keyName: "~"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70    
                        keyName: "*"
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "'"   
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "\""     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "|"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "/"     
                        onClick: con.appendText(key)
                    }    

                    Cell{
                        width: 70
                        keyName: "!"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "?"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "+"     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 70
                        keyName: "\\"     
                        onClick: con.appendText(key)
                    }    
                }

               Row{
                    spacing: 8    

                    Cell{
                        width: 70
                        keyName: "abc"     
                        onClick:{
                            keyboardGrid2.visible = false
                            keyboardGrid1.visible = true
                        }
                    }

                    Cell{
                        width: 70    
                        keyName: "."     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 390
                        keyName: "Space"     
                        onClick: con.appendText(" " )
                    }

                    Cell{
                        keyName: ","     
                        onClick: con.appendText(key)
                    }

                    Cell{
                        width: 150    
                        keyName: "BackSpace"     
                        onClick: con.backSpace()
                    }    
                }
            }
        } 

        /* Stack Item 3 */
        Rectangle{
                id: processingPage
                property alias startTimer: startProcessTimer.running
                
                Image{
                    x:5
                    y:445
                    width: 125
                    height: 30
                    source: "logo.png"
                } 
                
                Label{
                    x: 225
                    y: 200
                    color: "white"
                    font.pointSize: 40.0
                    text: "Processing..." 
                }

                Timer{
                    id: startProcessTimer
                    interval: 2000; running: false; repeat:false
                    onTriggered: con.startProcessing()
                }
        }   

        /* Stack Item 4 */
        Rectangle{
                id: countDisplayPage
                property alias startTimer: startProcessTimer.running
                   
                Image{
                    x:5
                    y:445
                    width: 125
                    height: 30
                    source: "logo.png"
                }

                Cell{
                    x:320; y: 455;
                    width: 100
                    height: 30
                    keyName: "Go to home"   
                    keySize: 12.0
                    onClick:{
                        appStack.currentIndex = 0
                    }
                }
            
                Label{
                    x: 150
                    y: 200
                    color: "white"
                    font.pointSize: 35.0
                    text: "Number of Tags -" 
                }

                Label{
                    id: countLabel
                    x: 520  
                    y: 200
                    color: "white"
                    font.pointSize: 35.0
                }

                Connections {
                    target: mainWindow
                    onFetchTagsCount:{ 
                        appStack.currentIndex = 4;
                        countLabel.text = number;    
                    }
                }    
        }   
    }
}
