
from point import Point


class Circle:

    def __init__(self, point, rayon):

        self.center = point
        self.r = rayon

    def check_instance(self, circle, type_):
        return True if isinstance(circle, type_) else False

    def xmin(self, circle):

        if self.check_instance(circle, self.__class__):
            return min(circle.center.x - circle.r, self.center.x - self.r)

    def xmax(self, circle):

        if self.check_instance(circle, self.__class__):
            return max(circle.center.x + circle.r, self.center.x + self.r)

    def ymax(self, circle):
        if self.check_instance(circle, self.__class__):
            return max(circle.center.y + circle.r, self.center.y + self.r)

    def ymin(self, circle):
        if self.check_instance(circle, self.__class__):
            return min(circle.center.y - circle.r, self.center.y - self.r)

    def belongs(self, point):

        if self.check_instance(point, self.center.__class__):
            return (point.distance(self.center) <= self.r)

    def __repr__(self):
        return f"{self.__class__.__name__}({self.center}, {self.r})"


if __name__ == '__main__':

    circle1 = Circle(1, 2, 4)
    circle2 = Circle(5, 5, 7)
    point2 = Point(1, 1)
    point2_not_belong = Point(18, 18)

    print(circle1)

    print(circle1.xmin(circle2))
    print(circle1.xmax(circle2))

    print(f"{point2} belongs to circle {circle2} {circle2.belongs(point2)}")
    print(f"{point2_not_belong} belongs to circle {circle2} {circle2.belongs(point2_not_belong)}")
