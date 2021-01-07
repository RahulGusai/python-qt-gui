import random
import sys
from time import sleep
from os.path import abspath, dirname, join
import serial

from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QUrl
from PySide2.QtWidgets import QApplication, QLabel
from PySide2.QtQuick import QQuickView
from PySide2.QtCore import QObject, Signal, Slot, Property


START_RX_CMD = "Y"

class UI(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.__input_text = "" #Property to bind with label value     
        self.__count = ""
        self.serialObject = serialTransfer()     

    @Slot(int, result=str)
    def invokeHandler(self,val):
        self.__number = "{0:d}".format(val)
        print ( self.__number )
        return self.__number


    @Slot(str,result=str)
    def appendText(self,key):
        self.set_text(key,True)
    
    @Slot()
    def backSpace(self):
        self.set_text(None,False)

    sendCount= Signal(str)

    @Slot()
    def startProcessing(self):
        self.serialObject.sendCmd()
        
        sleep(28)

        count = self.serialObject.readCount()
        print( "Count received is" + count )

        self.sendCount.emit(count)

        return




    textChanged = Signal(int)

    def set_text(self, val,appendFlag):
        if appendFlag==True:
            self.__input_text = self.__input_text + val
        else:
            self.__input_text = self.__input_text[ 0:len(self.__input_text)-1 ]
        
        self.textChanged.emit(self.__input_text)
    
    def get_text(self):
        return self.__input_text
    
    inputText = Property(str, get_text,set_text, notify=textChanged)


class serialTransfer(object):
    def __init__(self):
        self.receive = serial.Serial("/dev/ttyUSB0",115200)
        self.receive.timeout=None

        return

    def sendCmd(self):
        self.receive.write(START_RX_CMD.encode('utf-8'))

    def readCount(self):
        countStr = ""
        byte = self.receive.read(size=1)
        byte = byte.decode('utf-8')
        while( byte!='\n' ):
            countStr = countStr + byte
            byte= self.receive.read(size=1)
            byte = byte.decode('utf-8')    

        return countStr


if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    # Instance of the Python object
    uiObject = UI()

    # Expose the Python object to QML
    context = engine.rootContext()
    context.setContextProperty("con", uiObject)

    # Get the path of the current directory, and then add the name
    # of the QML file, to load it.
    qmlFile = join(dirname(__file__), 'ui.qml')
    engine.load(abspath(qmlFile))

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())