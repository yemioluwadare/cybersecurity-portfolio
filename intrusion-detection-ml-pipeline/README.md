# Machine Learning Intrusion Detection Pipeline

## Overview

This project implements a reproducible machine learning pipeline for network intrusion detection using flow-level telemetry from the CIC IDS 2017 dataset.

The objective is to detect Distributed Denial of Service (DDoS) attacks from network flow statistics while evaluating how models behave under temporal distribution shift.

Unlike many academic experiments that use random dataset splits, this pipeline evaluates generalisation by training on earlier network traffic and testing on a temporally separated capture window.

---

## Problem

Intrusion detection systems must detect malicious activity while limiting false positives that can overwhelm analysts.

Traditional signature-based detection struggles with novel attacks, motivating data-driven approaches that learn behavioural patterns directly from network telemetry.

This project frames intrusion detection as a **binary classification problem**:

Benign traffic → 0  
DDoS attack traffic → 1

---

## Dataset

Dataset used:

CIC IDS 2017 network intrusion dataset.

This dataset contains labelled network flows representing benign user activity and multiple attack scenarios in a simulated enterprise environment.

Features include:

- packet statistics
- flow duration
- timing characteristics
- protocol attributes

To better simulate deployment conditions, a **temporal split** was used:

Training and validation → Monday–Thursday  
Test set → Friday traffic

This design evaluates how well models generalise to new traffic conditions.

---

## Pipeline Architecture

The pipeline follows a structured workflow:

1. Raw CSV ingestion from CIC IDS dataset
2. Column standardisation and identifier removal
3. Streaming preprocessing to handle large datasets
4. Feature scaling and numeric transformation
5. Model training
6. Evaluation and metric export
7. Artefact generation (figures, metrics, trained models)

---

## Models Evaluated

Two machine learning models were compared:

### SGD Logistic Regression

- Incremental learning using stochastic gradient descent
- Supports streamed training with partial_fit
- Computationally efficient for large datasets

### Random Forest

- Non-linear ensemble model
- Captures complex feature interactions
- Higher computational cost

A dummy baseline classifier was also used to establish minimum expected performance.

---

## Evaluation Metrics

Models were evaluated using:

- Accuracy
- Macro F1 score
- ROC-AUC
- Confusion matrices

Macro-F1 was prioritised due to class imbalance in the dataset.

---

## Key Results

Both models achieved strong detection performance.

Random forest achieved extremely high validation performance but experienced some degradation under temporal distribution shift.

The SGD logistic regression model showed slightly lower validation accuracy but more stable performance on the temporally separated test set.

This highlights a common issue in security ML:

**Models that perform best on validation data do not always generalise best under changing network conditions.**

---

## Feature Analysis

Feature importance analysis revealed that several of the most influential variables relate to:

- packet length statistics
- packet length variance
- inter-arrival time metrics
- timing behaviour of flows

These behavioural features are consistent with known characteristics of volumetric DDoS traffic.

---

## Limitations

Several limitations apply:

- CIC IDS 2017 is a simulated dataset
- network behaviour may differ from real enterprise traffic
- attackers may manipulate certain features
- distribution shift can degrade model performance over time

Future work would include evaluation on additional capture windows and robustness testing against adversarial traffic shaping.

---

## Technologies

Python  
scikit-learn  
pandas  
NumPy  
matplotlib  

---

## Repository Contents
