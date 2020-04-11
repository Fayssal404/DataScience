import pandas as pd
from collections import defaultdict
from transactor import TransactionPreprocessor
import sys


class Apriori(TransactionPreprocessor):

    def __init__(self, df, fav_tresh, min_support=50):

        self.trainTrans, self.testTrans = self.train_test_split(
            df=df, threshold=fav_tresh)
        self.min_support = min_support
        self.frequent_itemsets = {}

    def favorable_items_by_user(self):
        # Select only favorable reviews
        favorable_reviews_by_user = self.trainTrans[self.trainTrans['favorable']]

        # User_id: set of chosen Categories by user
        favorable_items_by_user_ = dict((user, frozenset(fav_cat.values)) for
                                        user, fav_cat in favorable_reviews_by_user.groupby('UID')['TID'])

        return favorable_reviews_by_user, favorable_items_by_user_

    def count_favorable_by_item(self):
        #


        # Category: number of time considered favorable
        return self.trainTrans[['TID', 'favorable']].groupby('TID').sum()

    def frequent_itemsets_1_len(self):

        count_favorable_by_item_ = self.count_favorable_by_item()
        # Favorable Itemset length 1
        return dict((frozenset((item_id,)), row['favorable'])
                    for item_id, row in count_favorable_by_item_.iterrows()
                    if row['favorable'] > self.min_support)

    def search_frequent_itemsets(self, favorable_item_by_user_, k_1_itemsets):

        counts = defaultdict(int)
        for user, rates in favorable_item_by_user_.items():  # Iterate over user & their reviews
            for itemset in k_1_itemsets:
                # print(f'Item {itemset} , Rates {rates}')
                if itemset.issubset(rates):  # Compare is item rates is favorable

                    for other_reviewed_items in rates - itemset:
                        current_superset = itemset | frozenset(
                            (other_reviewed_items,))
                        counts[current_superset] += 1

        return dict([(itemset, frequency)
                     for itemset, frequency in counts.items()
                     if frequency >= self.min_support])

    def search_all_frequent_itemsets(self, min_len, max_len):

        frequent_itemsets = {}
        # Frequent itemset with 1 element
        frequent_itemsets[1] = self.frequent_itemsets_1_len()

        favorable_reviews_by_user, favorable_item_by_user = self.favorable_items_by_user()

        # Set Itemsets Length range
        length_range = range(
            min_len, max_len) if min_len < max_len else range(max_len, min_len)

        for len_ in length_range:
            cur_frequent_itemsets = self.search_frequent_itemsets(
                favorable_item_by_user, frequent_itemsets[len_ - 1])

            frequent_itemsets[len_] = cur_frequent_itemsets

            # Replace By matplotlib Graph
            if len(cur_frequent_itemsets) == 0:
                print("Did not find any frequent itemsets of length {}".format(len_))
                sys.stdout.flush()
                break

            # If no frequent itemset found
            else:
                print("I found {} frequent itemsets of length {} ".format(
                    len(cur_frequent_itemsets), len_))
                sys.stdout.flush()

        return frequent_itemsets  # yield frequent_itemsets

    def premise_conclusion(self, frequent_itemsets):
        """ Output canddate rules """
        candidate_rules = []
        for itemset_length, itemset_counts in frequent_itemsets.items():

            for itemset in itemset_counts.keys():
                for conclusion in itemset:
                    premise = itemset - set((conclusion,))
                    candidate_rules.append((premise, conclusion))

        return candidate_rules

    def confidence(self, rules):

        correct_counts = defaultdict(int)
        incorrect_counts = defaultdict(int)
        favorable_reviews_by_user, favorable_item_by_user = self.favorable_items_by_user()

        # iterate over users favorable reviews
        for user, reviews in favorable_reviews_by_user.items():
            #print(user, reviews)
            for candidate_rule in rules:
                # print(candidate_rule)
                premise, conclusion = candidate_rule

                if premise.issubset(reviews):  # Premises Apply?
                    if conclusion in reviews:  # Conclusion movie also favorable?
                        correct_counts[candidate_rule] += 1
                    else:
                        incorrect_counts[candidate_rule] += 1

                # Compute confidence for each rule by dividing
                # the correct counts / total number of times the rule was seen

        rule_confidence = {candidate_rule: correct_counts[candidate_rule] / float(
            correct_counts[candidate_rule] + incorrect_counts[candidate_rule]) for candidate_rule in rules}

        return rule_confidence
