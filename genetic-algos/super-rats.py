#!/usr/bin/python3.6m

import time
import random
import statistics

#Target weight in grams
GOAL = 50000

#Total number of adult rats your lab can support
NUM_RATS = 20

#Minimum weight of adult rat, in initial population
INITIAL_MIN_WT = 200

#Maximum weight of adult rat, in initial population
INITIAL_MAX_WT = 600

#Most common adult rat weights, in initial population
INITIAL_MODE_WT = 600

#Probability of a mutation occuring in a rat
MUTATE_ODDS = 0.01

# Scalar on rat weight of least beneficial mutation
MUTATE_MIN = 0.5

# Scalar on rat weight of most beneficial mutation
MUTATE_MAX = 1.2

#Number of pups per pair of mating rats
LITTER_SIZE = 8

#Number of litters per year per pair of mating rats
LITTERS_PER_YEAR = 10

#Generational cutoff to stop breeding program
GENERATION_LIMIT = 500


if NUM_RATS %2 !=0:
    NUM_RATS += 1

def populate(num_rats, min_wt, max_wt, mode_wt):
    """Initialize a population with a triangular distribution of weights"""
    #We can generate population based on different distribution
    return [int(random.triangular(min_wt, max_wt, mode_wt)) for i in range(num_rats)]

#Measuring the fitness of the population

def fitness(population, goal):
    """Measure population fitness based on an attribute mean vs target"""
    average = statistics.mean(population)
    return average/goal

def select(population, to_retain):
    """Cull a population to retain only a specified number of members, down to the NUM_RATS values"""

    #Sort population (parent of each generation) ascending weights
    sorted_population = sorted(population)
    #Retain by sex
    to_retain_by_sex = to_retain//2

    #Because gays can't mate
    members_per_sex = len(sorted_population)//2

    #Generate males and females usuall males are heavier
    #The largest female rat is no heavier than the smallest male rat
    females = sorted_population[:members_per_sex]
    males = sorted_population[members_per_sex:]

    #Take the biggest rats from the end of each lists
    #These two lists contain the parents of the next generation
    selected_females = females[-to_retain_by_sex:]
    selected_males = males[-to_retain_by_sex:]

    return selected_males, selected_females


#Breeding a New Generation
#Assumption: the weight of every child will be greater than or equal to the weight of the mother
#and less than or equal to the weight of the father


def breed(males,females, litter_size):
    """Crossover genes among members (weights) of a population"""

    #Shuffles males, females
    random.shuffle(males)
    random.shuffle(females)

    children = []

    #Mate males/females
    for male, female in zip(males,females):
        for child in range(litter_size):
            #female wt < Child weight < male wt
            child = random.randint(female,male)
            children.append(child)

    return children


#Mutating the population
#TODO: Check fitness of the new population
#TODO: Start the loop over if the target weight hasn't been reached


def mutate(children, mutate_odds, mutate_min, mutate_max):
    """Randomly alter rat weights using input odds and fractional changes """
    for index, rat in enumerate(children):
        #Only modify weights randomly
        if mutate_odds >= random.random():
            #Modify children weight randomly in respects to mutation minimum or maximum
            children[index] = round(rat*random.uniform(mutate_min, mutate_max))

    return children


#Defining the main function


def main():
    """Initialize population, select, breed, and mutate, display results"""

    generations = 0

    #CREATE a population
    parents = populate(NUM_RATS, INITIAL_MIN_WT, INITIAL_MAX_WT, INITIAL_MODE_WT)

    #Print population
    print("Initial population weights = {}".format(parents))

    #Check if population is fitted
    popl_fitness = fitness(parents, GOAL)

    print("Initial population fitness = {}".format(popl_fitness))
    print("Number to retain = {}".format(NUM_RATS))

    ave_wt = []

    #If population fitness is > 1 indicate we attended population average goal
    #If we passed the number of limited generation then stop
    while popl_fitness < 1 and generations < GENERATION_LIMIT:
        selected_males, selected_females = select(parents, NUM_RATS)
        children = breed(selected_males, selected_females, LITTER_SIZE)
        children = mutate(children, MUTATE_ODDS, MUTATE_MIN, MUTATE_MAX)
        #New population
        parents = selected_males + selected_females + children
        popl_fitness = fitness(parents, GOAL)

        print("Generation {} fitness = {:.4f}".format(generations, popl_fitness))

        ave_wt.append(int(statistics.mean(parents)))
        generations +=1

        print("Average weight per generation = {}".format(ave_wt))
        print("\nNumber of generations = {}".format(generations))
        print("Number of years = {}".format(int(generations/LITTERS_PER_YEAR)))

if __name__ == "__main__":
    start_time = time.time()
    main()
    end_time = time.time()
    duration = end_time - start_time
    print("\nRuntime for this program was {} seconds".format(duration))


