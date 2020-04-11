import pandas as pd
from collections import defaultdict
from transactor import TransactionPreprocessor
import sys


class Apriori:

    def __init__(self, train_df, min_support=50):
        self.min_support = min_support
        self.trainTrans = train_df
        
    def favorable_reviews_by_user(self):
        """ Return rows with faverote reviews by users """
        # Select only favorable reviews
        return self.trainTrans[self.trainTrans['favorable']]
    
    def favorable_items_by_user(self):
        favorable_reviews_by_user_ = self.favorable_reviews_by_user()
        
        # User_id: set of chosen Categories by user
        return dict((uid, frozenset(fav_item.values))\
                    for uid, fav_item in favorable_reviews_by_user_.groupby('UID')['TID'])

    def count_favorable_by_item(self):
        """ Return count of favorable review associated with each item """
        # Category: number of time considered favorable
        return self.trainTrans[['TID', 'favorable']].groupby('TID').sum()

    def frequent_itemsets_1_len(self):
        """ Return frequent favorable reviewed item more then minimim support """
        count_favorable_by_item_ = self.count_favorable_by_item()
        # Favorable Itemset length 1
        return dict((frozenset((item_id,)), row['favorable'])
                    for item_id, row in count_favorable_by_item_.iterrows()
                    if row['favorable'] > self.min_support)

    def search_frequent_itemsets(self, favorable_item_by_user_, k_1_itemsets):
        """ Return frequency of appearance of an itemset """
        counts = defaultdict(int)
        for user, rates in favorable_item_by_user_.items():  # Iterate over user-rate
        
            for itemset in k_1_itemsets: # Frequent itesemt of length Apriori-Step + 1

                if itemset.issubset(rates):  # Item is favorable ?

                    for other_reviewed_items in rates - itemset:
                        
                        current_superset = itemset | frozenset((other_reviewed_items,))
                        counts[current_superset] += 1

        return dict([(itemset, frequency)
                     for itemset, frequency in counts.items()
                     if frequency >= self.min_support])

    def search_all_frequent_itemsets(self, min_len, max_len):
        """ Return all frequent itemsets in the range of min max """
        frequent_itemsets = {}
        # Frequent itemset with 1 element
        frequent_itemsets[1] = self.frequent_itemsets_1_len()

        favorable_reviews_by_user = self.favorable_reviews_by_user()
        favorable_item_by_user = self.favorable_items_by_user()

        # Set Length range
        set_len = range(
            min_len, max_len) if min_len < max_len else range(max_len, min_len)

        for len_ in set_len:
            
            cur_frequent_itemsets = self.search_frequent_itemsets(favorable_item_by_user,\
                                                                  frequent_itemsets[len_ - 1])

            frequent_itemsets[len_] = cur_frequent_itemsets

            # Replace By matplotlib Graph
            if len(cur_frequent_itemsets) == 0:
                break

        return frequent_itemsets  # yield frequent_itemsets

    
    
class AssociationMeasures:
    
    def __init__(self, apriori):
        self.apriori = apriori
    
    def rules_generator(self, frequent_itemsets):
        """ Simple Rules Generator """
        for itemset_length, itemset_counts in frequent_itemsets.items():

            for itemset in itemset_counts.keys():
                for conclusion in itemset:
                    premise = itemset - set((conclusion,))
                    yield (premise, conclusion)
    
    def rule_confidence(self, frequent_itemsets):
        
        rules = self.rules_generator(frequent_itemsets)
        correct_counts = defaultdict(int)
        incorrect_counts = defaultdict(int)
        
        favorable_reviews_by_user = self.apriori.favorable_reviews_by_user()
        favorable_item_by_user = self.apriori.favorable_items_by_user()

        for user, reviews in favorable_reviews_by_user.items():
            for premise, conclusion in rules:
                if premise.issubset(reviews):  # Premises Apply?
                        if conclusion in reviews:  # Conclusion movie also favorable?
                            correct_counts[(premise,conclusion)] += 1
                        else:
                            incorrect_counts[(premise,conclusion)] += 1
        
        rules = self.rules_generator(frequent_itemsets)
        return {(premise,conclusion): correct_counts[(premise,conclusion)] / float(
            correct_counts[(premise,conclusion)] + incorrect_counts[(premise, conclusion)]) for premise, conclusion in rules}
