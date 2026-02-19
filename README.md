# pyqt-designer





## Test des images Docker

Il y a plusieurs petits programmes de test dans le dossier exemples.

Le script run-designer.sh permet de lancer le conteneur de manière universelle sur Linux, macOS et Windows.

Malgré tout, lorsque l'on utilise cv2.imshow() avec Wayland, il y a des adaptations à faire pour obtenir un affichage de l'application.


### Affichage avec PyQt5 :

* **exemples/app.py** : Programme PyQt5 basique avec 4 boutons cliquables *(interface.ui)*
* **exemples/fenetre.py** : Programme PyQt5 basique avec 1 bouton et 4 checkbox. *(fenetre.ui)* 
* **exemples/webcam-pyqt5.py** : Affiche le flux vidéo de la webcam dans une interface Qt5.

Pour lancer ces exemples :

```bash
$ ./run-designer.sh python exemples/imshow.py
$ ./run-designer.sh python exemples/webcam-pyqt5.py
```


### Affichage avec cv2.imshow() :


* **exemples/imshow.py** : Affiche une image avec la fonction imshow() d'OpenCV. 
* **exemples/webcam-imshow.py** : Affiche le flux vidéo de la webcam avec la fonction imshow() d'OpenCV.

Pour que l'affichage fonctionne avec imshow(), il faut changer la valeur de la variable QT_QPA_PLATFORM à xcb (avec Wayland) :

```bash
$ ./run-designer.sh bash -c "QT_QPA_PLATFORM=xcb python exemples/webcam-imshow.py"
```
