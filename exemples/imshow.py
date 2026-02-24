import cv2

img = cv2.imread('exemples/dog_bike_car.jpg')
win_name = 'Dog Bike & Car'
if img is not None:
    cv2.imshow(win_name, img)

    while True:
        key = cv2.waitKey(100) & 0xFF

        # if key is Escape or 'q', we break
        if key == 27 or key == ord('q'):
            break

        # if window is closed, WND_PROP_VISIBLE will be False (0)
        if cv2.getWindowProperty(win_name, cv2.WND_PROP_VISIBLE) < 1:
            break

    cv2.destroyAllWindows()
else:
    print("Image non trouvée.")

