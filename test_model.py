#!/usr/bin/env python3

"""
Script to test the fake news classifier model.
Prints an accuracy score and other test metrics.
Outputs a csv of labels, predictions, and sources.
"""

import pickle
import pandas as pd
from sklearn.metrics import classification_report, accuracy_score


def main():
    """Test the pac model."""

    # Unpickle the pac model and tokenizer
    with open("./fake-news-app/pac.pickle", "rb") as infile:
        pac = pickle.load(infile)

    with open("./fake-news-app/tfidf-vectorizer.pickle", "rb") as infile:
        tfidf_vec = pickle.load(infile)

    # Fetch input articles (manually curated)
    article = pd.read_csv("./data/test-articles.csv")

    # Extract testing labels
    y_test = pd.Series(data=article["label"])

    # Transfor input
    tfidf_test = tfidf_vec.transform(article["text"])

    # Predict
    y_pred = pac.predict(tfidf_test)

    # Report testing metrics
    score = accuracy_score(y_test, y_pred)
    print(f"\nAccuracy: {round(score*100, 2)}%")
    print(
        f"\nClassification Report:\n\n{classification_report(y_test, y_pred)}")

    test_df = pd.DataFrame({
        "label": article["label"],
        "prediction": y_pred,
        "source": article["source"]
    })

    test_df.to_csv("./fake-news-app/model-test-results.csv", index=False)


if __name__ == '__main__':
    main()
