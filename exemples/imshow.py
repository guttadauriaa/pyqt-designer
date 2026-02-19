import cv2

img = cv2.imread('exemples/dog_bike_car.jpg')
cv2.imshow('Dog Bike & Car', img)
cv2.waitKey(0)
cv2.destroyAllWindows()

