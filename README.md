# Cybersecurity Portfolio – Yemi Oluwadare

Final-year Cyber Security student at the University of Warwick specialising in malware analysis, digital forensics, detection engineering, and machine learning for security.

This repository contains selected technical projects demonstrating practical security analysis, defensive engineering, and security data science.

---

## Projects

### Machine Learning Intrusion Detection Pipeline

Designed and implemented a machine learning intrusion detection pipeline using the CIC IDS 2017 dataset.

The system performs streamed preprocessing of network flow telemetry and trains multiple models to detect malicious traffic under realistic temporal distribution shift.

Key components:

- Streaming preprocessing pipeline for large-scale network telemetry
- Binary intrusion detection (Benign vs DDoS)
- Comparison of SGD logistic regression and random forest models
- Evaluation using macro-F1, ROC-AUC, and confusion matrices
- Feature importance analysis and robustness testing

Tools:
Python, scikit-learn, pandas, matplotlib

[View Project →](./intrusion-detection-ml-pipeline)
