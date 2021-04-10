#!/usr/bin/env python3

"""
Script to test the fake news classifier model.
"""

import pickle
import pandas as pd


def main():
    """Test the pac model."""

    # Unpickle the pac model and tokenizer
    with open("./shiny-app/pac.pickle", "rb") as infile:
        pac = pickle.load(infile)

    with open("./shiny-app/tfidf-vectorizer.pickle", "rb") as infile:
        tfidf_vec = pickle.load(infile)

    # Fetch input articles (manually curated)
    article = pd.read_csv("./data/input-articles.csv")

    print(f'Input:\n{article.head()}')

    # Transfor input
    tfidf_test = tfidf_vec.transform(article["text"])

    # Predict
    y_pred = pac.predict(tfidf_test)

    # Report prediction
    print(f'\nPredictions: {y_pred}')

    # Prediction probs
    print(f'\nProbabilities for each prediction:\
    \n\tFAKE\tREAL\n{pac._predict_proba_lr(tfidf_test)}')


if __name__ == '__main__':
    main()
