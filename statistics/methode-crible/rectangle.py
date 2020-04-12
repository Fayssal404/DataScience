
from point import Point
from circle import Circle

from numpy.random import uniform


class Rectangle:

    def __init__(self, xmin, ymin, xmax, ymax):

        # Add seter property for conditioning
        self.pointmin = Point(xmin, ymin)
        self.pointmax = Point(xmax, ymax)

    def check_instance(self, rectangle, type_):
        return True if isinstance(rectangle, type_) else False

    def framing_rectangle(self, circle1, circle2):

        empty_circ = Circle(*[None] * 2)
        if all((self.check_instance(circle1, empty_circ.__class__), self.check_instance(circle2, empty_circ.__class__))):
            return [[circle1.xmin(circle2), circle1.ymin(circle2)],
                    [circle1.xmax(circle2), circle1.ymax(circle2)]]

    def surface(self):
        return (self.pointmax.x - self.pointmin.x) * (self.pointmax.y - self.pointmin.y)

    def randomness(self, min, max):

        return round(uniform(min, max), 5)

    def random_point(self):

        return Point(self.randomness(self.pointmin.x, self.pointmax.x), self.randomness(self.pointmin.y, self.pointmax.y))


if __name__ == '__main__':

    rectangle = Rectangle(1, 5, 5, 10)
    circle1 = Circle(1, 2, 4)
    circle2 = Circle(5, 5, 7)

    print(f"Circle 1: {circle1}\nCircle 2: {circle2}\nFraming Rectangle : {rectangle.framing_rectangle(circle1, circle2)}")

    print(f"{rectangle.random_point()}")
