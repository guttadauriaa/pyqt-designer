import cv2

# Ouvrir la webcam (0 = caméra par défaut)
cap = cv2.VideoCapture(0)
win_name = "Webcam (Press 'q' to quit.)"

if not cap.isOpened():
    print("Erreur : Impossible d'accéder à la webcam.")
else:
    print("Webcam accessible.")
    while True:
        ret, frame = cap.read()
        if not ret:
            print("Erreur : Impossible de lire le flux vidéo.")
            break
        cv2.imshow(win_name, frame)
        if cv2.waitKey(1) == ord('q'):  # Appuyez sur 'q' pour quitter
            break
        if cv2.getWindowProperty(win_name, cv2.WND_PROP_VISIBLE) < 1:
            break

cap.release()
cv2.destroyAllWindows()
