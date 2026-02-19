from PyQt5 import QtWidgets, QtGui, QtCore
from PyQt5.QtCore import QThread, pyqtSignal
import cv2
import sys

class VideoThread(QThread):
    change_pixmap_signal = pyqtSignal(QtGui.QImage)

    def run(self):
        cap = cv2.VideoCapture(0)
        while True:
            ret, frame = cap.read()
            if ret:
                rgb_image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                h, w, ch = rgb_image.shape
                bytes_per_line = ch * w
                qt_image = QtGui.QImage(rgb_image.data, w, h, bytes_per_line, QtGui.QImage.Format_RGB888)
                self.change_pixmap_signal.emit(qt_image)

class MainWindow(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("OpenCV + PyQt5")
        self.setGeometry(100, 100, 800, 600)

        self.image_label = QtWidgets.QLabel(self)
        self.image_label.resize(640, 480)

        self.thread = VideoThread()
        self.thread.change_pixmap_signal.connect(self.update_image)
        self.thread.start()

    @QtCore.pyqtSlot(QtGui.QImage)
    def update_image(self, qt_image):
        self.image_label.setPixmap(QtGui.QPixmap.fromImage(qt_image))

if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())

