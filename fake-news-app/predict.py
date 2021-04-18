#!/usr/bin/env python3

"""
Helper function to run the model in the R shiny app.
"""

import pickle
import pandas as pd


def main():
    """Run the predict_results func."""

    predict_results()


def predict_results():
    """Predicts whether a article's body text is fake or not."""

    # Unpickle the model and tokenizer
    with open("./pac.pickle", "rb") as infile:
        pac = pickle.load(infile)

    with open("./tfidf-vectorizer.pickle", "rb") as infile:
        tfidf_vec = pickle.load(infile)

    # Fetch input article
    article = pd.read_csv("./article.csv")

    # Transfor input
    tfidf_test = tfidf_vec.transform(article["text"])

    # Predict
    prediction = pac.predict(tfidf_test)

    # Report probabilities
    probs = pac._predict_proba_lr(tfidf_test)
    fake_prob, real_prob = probs.item(0), probs.item(1)

    data = {
        "prediction": prediction.item(0),
        "fake": fake_prob,
        "real": real_prob
    }

    return data


if __name__ == "__main__":
    main()
