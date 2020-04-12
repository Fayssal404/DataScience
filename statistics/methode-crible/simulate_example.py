

from point import Point
from circle import Circle
from rectangle import Rectangle


def estimation(rectangle, point1, point2, rayon1, rayon2, num_p=100000):

    p1 = point1
    p2 = point2

    c1 = Circle(p1, rayon1)
    c2 = Circle(p2, rayon2)
    frame = rectangle.framing_rectangle(c1, c2)

    cpt = 0

    for i in range(num_p + 1):
        p = rectangle.random_point()
        # print(f"Does Point: {p} belongs to Circle :{c1} & Circle :{c2}")
        #print((c1.belongs(p) and c2.belongs(p)))
        if (c1.belongs(p) & c2.belongs(p)):
            cpt += 1
    return (cpt / num_p) * r.surface()


if __name__ == '__main__':

    p1 = Point(2., 2.)
    p2 = Point(2., 3.)
    c1 = Circle(p1, 2.)
    c2 = Circle(p2, 2.)

    r = Rectangle(xmin=2, ymin=4, xmax=4, ymax=6)

    print(f"Intersection ares estimation {estimation(r, p1,p2, 2,2)}")
