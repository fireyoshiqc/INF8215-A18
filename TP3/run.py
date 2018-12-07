import pandas as pd

PATH = "data/"
X_train = pd.read_csv(PATH + "train.csv")
X_test = pd.read_csv(PATH + "test.csv")

# Suppression de colonnes inutiles

X_train = X_train.drop(columns = ["OutcomeSubtype","AnimalID"])
X_test = X_test.drop(columns = ["ID"])
X_train, y_train = X_train.drop(columns = ["OutcomeType"]),X_train["OutcomeType"]

# Lecture des parties pretraitees
X_train1 = pd.read_csv("data/train_preprocessed.csv")
X_test1 = pd.read_csv("data/test_preprocessed.csv")

X_train = X_train.drop(columns = ["Color","Name","DateTime"])
X_test = X_test.drop(columns = ["Color","Name","DateTime"])

# Pipeline

from preprocessing import TransformationWrapper
from preprocessing import LabelEncoderP
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import OneHotEncoder
from sklearn.impute import SimpleImputer
from sklearn.pipeline import Pipeline, FeatureUnion
from sklearn.compose import ColumnTransformer

def parse_age(text):
    time = 0.0
    multiplier, timeframe = text.split(" ")
    multiplier = float(multiplier)
    if "day" in timeframe:
        time = multiplier
    elif "week" in timeframe:
        time = multiplier * 7.0
    elif "month" in timeframe:
        time = multiplier * (365.25/12.0)
    elif "year" in timeframe:
        time = multiplier * 365.25
    return time

def parse_state(text):
    if "Unknown" in text:
        return "Neutered"
    state, _ = text.split(" ")
    if "Spayed" in state:
        state = "Neutered"
    return state

def parse_sex(text):
    if "Unknown" in text:
        return "Male"
    _, sex = text.split(" ")
    return sex

pipeline_age = Pipeline([
    ('fillnan', SimpleImputer(strategy = 'constant', fill_value = '1 year')),
    ('age', TransformationWrapper(transformation = parse_age)),
    ('scaler', StandardScaler())
])

pipeline_animal = Pipeline([
    ('encode', LabelEncoderP())
])

pipeline_state = Pipeline([
    ('state', TransformationWrapper(transformation = parse_state)),
    ('encode', LabelEncoderP())
])

pipeline_sex = Pipeline([
    ('sex', TransformationWrapper(transformation = parse_sex)),
    ('encode', LabelEncoderP())
])

pipeline_sexuponoutcome = Pipeline([
    ('fillnan', SimpleImputer(strategy = 'constant', fill_value = 'Unknown')),
    ('feats', FeatureUnion([
        ('state', pipeline_state),
        ('sex', pipeline_sex)
    ]))
])

# BREED pipeline goes here

full_pipeline = ColumnTransformer([
    ('AgeuponOutcome', pipeline_age, ["AgeuponOutcome"]),
    ('AnimalType', pipeline_animal, ["AnimalType"]),
    ('SexuponOutcome', pipeline_sexuponoutcome, ["SexuponOutcome"]),
    # BREED
    
])

# Lancer la pipeline

columns = ["age", "isDog", "state", "sex"]
X_train_prepared = pd.DataFrame(full_pipeline.fit_transform(X_train),columns = columns)
X_test_prepared = pd.DataFrame(full_pipeline.fit_transform(X_test),columns = columns)

X_train = pd.concat([X_train1,X_train_prepared], axis = 1)
X_test = pd.concat([X_test1,X_test_prepared], axis = 1)

# Model selection

from sklearn.preprocessing import LabelEncoder
target_label = LabelEncoder()
y_train_label = target_label.fit_transform(y_train)
print(target_label.classes_)
print(y_train_label)

from sklearn.model_selection import cross_validate
import numpy as np

def compare(models,X_train,y_train,nb_runs, scoring):
    losses = []
    for model in models:
        scores = cross_validate(model, X_train, y_train, cv=nb_runs, scoring=scoring, return_train_score=False)
        avg_log_loss = np.mean(-scores['test_neg_log_loss'])
        std_log_loss = np.std(-scores['test_neg_log_loss'])
        avg_precision = np.mean(scores['test_precision_macro'])
        std_precision = np.std(scores['test_precision_macro'])
        avg_recall = np.mean(scores['test_recall_macro'])
        std_recall = np.std(scores['test_recall_macro'])
        avg_fscore = np.mean(scores['test_f1_macro'])
        std_fscore = np.std(scores['test_f1_macro'])
        losses += [{'model' : model,
                   'avg_log_loss' : avg_log_loss,
                   'std_log_loss' : std_log_loss,
                   'avg_precision' : avg_precision,
                   'std_precision' : std_precision,
                   'avg_recall' : avg_recall,
                   'std_recall' : std_recall,
                   'avg_fscore' : avg_fscore,
                   'std_fscore' : std_fscore}]
        
    """
    skf = StratifiedKFold(n_splits = nb_runs)
    for train_index, test_index in skf.split(X_train, y_train):
        for model in models:
            X_train_cross, X_test = X_train[train_index], X_train[test_index]
            Y_train_cross, Y_test = y_train[train_index], y_train[test_index]
            model.fit(X_train_cross, Y_train_cross)
            score = clf.score(X_test, Y_test)
            print(score)
    """
    return losses

from SoftmaxClassifier import SoftmaxClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.neural_network import MLPClassifier

nb_run = 3

models = [
    SoftmaxClassifier(use_zero_indexed_classes=True),
    RandomForestClassifier(n_estimators = 100, max_depth=2, random_state=69),
    MLPClassifier(alpha=1)
]

print(models[0].n_epochs)

scoring = ['neg_log_loss', 'precision_macro','recall_macro','f1_macro']

compare(models,X_train,y_train_label,nb_run,scoring)
