---
title: "EU AI Act Doc Generator — Automated Compliance Artifacts"
date: 2026-05-07
description: "Automated Annex IV documentation generation for AI system providers — risk classification, model cards, conformity checklists, 7-year audit trail"
technologies: ["Python", "FastAPI", "PostgreSQL", "React", "S3 WORM", "Vault"]
categories: ["Product", "AI/ML", "Compliance"]
tags: ["EU AI Act", "AI Documentation", "Model Cards", "Risk Assessment", "Conformity Assessment", "Regulatory Compliance"]
client: "Enterprise"
duration: "6-8 weeks"
team_size: "1"
metrics:
  - "$200K Y1 revenue target"
  - "Annex III classification"
  - "Annex IV artifacts"
  - "7-year retention"
---

# EU AI Act Doc Generator — Automated Compliance Artifacts

## Challenge
The EU AI Act (Regulation 2024/1689) requires AI system providers to produce extensive documentation: risk classification per Annex III, technical documentation per Annex IV (model cards, risk assessments, data governance records, human oversight procedures), and conformity assessment evidence. Manual documentation is time-consuming, inconsistent, and difficult to maintain over the 7-year retention period.

Build a platform that automates the generation of EU AI Act-compliant documentation artifacts.

## Solution Architecture

### Overview
```
┌─────────────────────────────────────────────────────────────────┐
│                    AI System Registry                            │
│         Model metadata · Training data · Deployment info        │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                  Classifier Service                              │
│           Annex III risk level determination                    │
│      Prohibited · High-Risk · Limited · Minimal                 │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                Doc Generator Service                             │
│                                                                  │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│   │ Model Card  │  │    Risk     │  │   Data      │            │
│   │  Generator  │  │ Assessment  │  │ Governance  │            │
│   └─────────────┘  └─────────────┘  └─────────────┘            │
│                                                                  │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐            │
│   │   Human     │  │ Conformity  │  │   Change    │            │
│   │  Oversight  │  │  Checklist  │  │    Log      │            │
│   └─────────────┘  └─────────────┘  └─────────────┘            │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
                 ┌──────────────────┐
                 │   S3 WORM Store  │
                 │  7-year retention │
                 └──────────────────┘
```

### Risk Classification (Annex III)

| Risk Level | Examples | Documentation Required |
|------------|----------|----------------------|
| **Prohibited** | Social scoring, real-time biometric (public) | Cannot deploy in EU |
| **High-Risk** | Credit scoring, CV screening, medical diagnosis | Full Annex IV suite |
| **Limited Risk** | Chatbots, emotion recognition | Transparency notice |
| **Minimal Risk** | Spam filters, game AI | Voluntary best practices |

## Key Features

### 1. Annex III Risk Classifier
```python
# Automated risk classification based on AI system characteristics
classification = classifier.evaluate(
    domain="employment",
    use_case="cv_screening",
    biometric_data=False,
    decision_impact="significant"
)
# Result: HIGH_RISK (Annex III, Category 4)
```

### 2. Annex IV Documentation Suite

| Document | EU AI Act Reference | Auto-Generated |
|----------|---------------------|----------------|
| **Model Card** | Art. 11, Annex IV §1 | Yes |
| **Risk Assessment** | Art. 9, Annex IV §2 | Yes |
| **Data Governance** | Art. 10, Annex IV §3 | Yes |
| **Human Oversight** | Art. 14, Annex IV §4 | Yes |
| **Accuracy Metrics** | Art. 15, Annex IV §5 | Yes |
| **Conformity Checklist** | Art. 43 | Yes |

### 3. Model Card Generator
```markdown
# Model Card: CV Screening Assistant v2.1

## Model Details
- **Developer:** Acme Corp
- **Model Type:** Transformer-based classifier
- **Version:** 2.1.0
- **License:** Proprietary

## Intended Use
- **Primary Use:** Automated CV screening for job applications
- **Users:** HR departments, recruitment agencies
- **Out-of-Scope:** Final hiring decisions (human required)

## Training Data
- **Source:** Historical hiring decisions (2020-2024)
- **Size:** 1.2M CVs, 50K positive outcomes
- **Bias Mitigation:** Gender/age debiasing applied

## Performance Metrics
- **Accuracy:** 87% (test set)
- **False Positive Rate:** 8%
- **Fairness:** Demographic parity within 5%

## Limitations
- Performance degrades for non-English CVs
- Limited to structured job categories
```

### 4. Immutable Audit Trail
- **S3 WORM** (Object Lock) for 7-year retention
- **Version history** for all document changes
- **Cryptographic signatures** (Sigstore cosign)
- **Export** for notified body assessment

## Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **API Service** | FastAPI | REST API gateway |
| **Classifier** | Python + rule engine | Annex III risk classification |
| **Doc Generator** | Python + Jinja2 | Artifact generation |
| **Web UI** | React 18 + TypeScript | Model registry + workflow |
| **Database** | PostgreSQL 14+ | Model metadata, audit trail |
| **Storage** | S3-compatible WORM | Artifact retention (7 years) |
| **Secrets** | HashiCorp Vault | API keys, credentials |

## Compliance Coverage

| EU AI Act Article | Requirement | Platform Feature |
|-------------------|-------------|------------------|
| Art. 9 | Risk management system | Risk assessment generator |
| Art. 10 | Data governance | Data governance doc generator |
| Art. 11 | Technical documentation | Full Annex IV suite |
| Art. 12 | Record-keeping | Immutable audit trail (7 years) |
| Art. 13 | Transparency | Model card generator |
| Art. 14 | Human oversight | Oversight procedure doc |
| Art. 15 | Accuracy, robustness | Performance metrics doc |
| Art. 43 | Conformity assessment | Conformity checklist |

## Results & Metrics

### Target Market
- AI system providers deploying in EU
- High-risk system operators (Annex III)
- Notified bodies performing conformity assessments

### Revenue Target
- **$200K Year 1** (SaaS + enterprise licenses)
- Per-model or organization-wide pricing

## Architecture Decisions

- **Template-based generation**: Jinja2 templates for consistent, auditable output
- **S3 WORM over database**: Meets 7-year immutability requirement
- **Sigstore keyless signing**: Tamper-evident without key management burden
- **React wizard UI**: Guided input reduces user errors
- **Version pinning**: Each artifact version is immutable once generated
