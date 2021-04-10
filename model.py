#!/usr/bin/env python3

"""
Model to detect fake news using term frequency, inverse document frequency,
and a passive aggressive classifier based on the tutorial from
https://data-flair.training/blogs/advanced-python-project-detecting-fake-news/
"""

import pickle
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import PassiveAggressiveClassifier
from sklearn.metrics import classification_report, accuracy_score


def main():
    """Train and pickle the model/tokenizer."""

    # Load the data
    df = pd.read_csv("./data/data.csv")

    # Get the labels
    labels = df.label

    # Split into training and testing sets
    x_train, x_test, y_train, y_test = train_test_split(
        df["text"], labels, test_size=0.3, random_state=7
    )

    # Initialize a TfidfVectorizer with stop words and max doc freq of 0.7
    tfidf_vec = TfidfVectorizer(stop_words="english", max_df=0.7)

    # Fit and transform train set
    tfidf_train = tfidf_vec.fit_transform(x_train)

    # Transform test set
    tfidf_test = tfidf_vec.transform(x_test)

    # Initialize a PassiveAggressiveClassifier and fit tfidf_train and y_train
    pac = PassiveAggressiveClassifier(max_iter=50)
    pac.fit(tfidf_train, y_train)

    # Predict on the test set and calc accuracy
    y_pred = pac.predict(tfidf_test)
    score = accuracy_score(y_test, y_pred)

    # Report metrics
    print(f"Done training model.\n\nAccuracy: {round(score*100, 2)}%")
    print(
        f"\nClassification Report:\n\n{classification_report(y_test, y_pred)}")

    # Pickle the classifier
    pickle.dump(pac, open("./shiny-app/pac.pickle", "wb"))

    # Pickle the TfidfVectorizer
    pickle.dump(tfidf_vec, open("./shiny-app/tfidf-vectorizer.pickle", "wb"))


if __name__ == "__main__":
    main()
