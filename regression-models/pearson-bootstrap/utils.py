def pow_(x, n):
    """ X a la puissance n """
    if n == 0:
        return 1
    else:
        return x * pow(x, n - 1)


def factoriel(n):
    """ Fonction pour calculer factoriel n: n! """
    if n == 0:
        return 1
    else:
        return n * factoriel(n - 1)


def exponentiel(x, p):
    """ Approche polynomial de degré p de la fonction exponentielle """
    if p <= 0:
        return 1
    else:
        # Approche recursive
        return pow(x, p) / factoriel(p) + exponentiel(x, p - 1)
