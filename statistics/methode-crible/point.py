
from math import sqrt


class Point:

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def distance(self, point):
        dx = self.x - point.x
        dy = self.y - point.y

        return sqrt(dx * dx + dy * dy)

    def __repr__(self):
        return f"{self.__class__.__name__}({self.x}, {self.y})"


if __name__ == '__main__':

    point1 = Point(1, 2)
    point2 = Point(2, 4)

    print(point2.distance(point1))

    print(point1.min(2, 1))
