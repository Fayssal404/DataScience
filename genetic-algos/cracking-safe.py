#!/usr/bin/python3.6m

"""Brute force program, to brute force its way to the right combination"""

import time
from itertools import product
from random import randint, randrange


def brute_force_cracker(combo):
    """Brute force function to get the right combination"""
    start_time = time.time()
    #Use cartesian product to generate permutations with repetition
    #repeat: size of combination
    for perm in product(list(range(10)), repeat=len(combo)):
        if perm == combo:
            print("Cracked: {}{}".format(combo,perm))

    end_time = time.time()

    print("Run time for this program was {} seconds".format(end_time-start_time))



"""Use genetic algorithm to quickly find a safe's combination in a large space"""

def fitness(combo, attemp):
    """Compare items in two lists and count number of matches"""

    grade = 0

    for i,j in zip(combo, attemp):
        if i == j:
            grade +=1

    return grade

def main():
    """Use hill-climbing algorithm to solve lock combination"""
    combination ="2"
    print("Combination={}".format(combination))

    #convert combination to a list
    list_combo = [int(s) for s in combination] 

    #Generate guess & grade fintess
    best_attempt = [0]*len(list_combo)

    best_attempt_grade = fitness(list_combo,best_attempt)

    #How many attempts to crack the code
    count = 0

    #evolve guess
    while best_attempt_grade != len(list_combo):
        #crossover, copy list
        next_try = best_attempt[:]

        #mutate, random index
        lock_wheel = randrange(0,len(list_combo))
        next_try[lock_wheel]= randint(0,len(list_combo)-1)

        #Grade & select
        next_try_grade = fitness(list_combo, next_try)
        if next_try_grade > best_attempt_grade:
            best_attempt = next_try[:]
            best_attempt_grade = next_try_grade
            
        print(next_try, best_attempt)
        
        count +=1

    print()
    print("Cracked!{}".format(best_attempt))
    print("In {} tries".format(count))

if __name__ == "__main__":
    start_time = time.time()
    main()
    end_time = time.time()
    print("Safe cracked in {} seconds".format(end_time-start_time))
