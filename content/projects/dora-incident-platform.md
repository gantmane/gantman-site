---
title: "DORA Incident Platform — EU Financial Compliance"
date: 2026-05-07
description: "Real-time incident classification and three-stage report generation for 40,000 EU financial entities under Digital Operational Resilience Act"
technologies: ["Python", "FastAPI", "Kafka", "PostgreSQL", "Keycloak", "Claude API", "React"]
categories: ["Product", "Compliance", "Fintech"]
tags: ["DORA", "EU Compliance", "Incident Management", "EBA Reporting", "Financial Services", "AI Triage"]
client: "Enterprise"
duration: "4-6 weeks"
team_size: "1"
metrics:
  - "$300K Y1 revenue target"
  - "40K EU financial entities"
  - "4h/72h/1mo deadlines"
  - "EBA-standard reports"
---

# DORA Incident Platform — EU Financial Compliance

## Challenge
The Digital Operational Resilience Act (DORA, EU 2022/2554) requires 40,000 EU financial entities — banks, payment institutions, e-money providers, crypto exchanges (MiCA), and insurtech — to classify and report major ICT incidents within strict deadlines: 4 hours (initial notification), 72 hours (intermediate report), and 1 month (final report). Manual classification against EBA/ESMA/EIOPA criteria is slow and error-prone; missing deadlines triggers regulatory penalties.

Build a platform that automatically classifies incidents, generates EBA-standard reports, and ensures deadline compliance.

## Solution Architecture

### Overview
```
┌─────────────────────────────────────────────────────────────────┐
│                    Incident Sources                              │
│         SIEM · ServiceNow · PagerDuty · Manual Entry            │
└───────────────────────────┬─────────────────────────────────────┘
                            │ webhook / REST
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Ingestion Service                              │
│              Normalize · Dedupe · Enrich                        │
└───────────────────────────┬─────────────────────────────────────┘
                            │ Kafka
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│              Classification Service (DORA Rules)                 │
│         EBA/ESMA/EIOPA criteria → Major/Non-Major               │
└───────────────────────────┬─────────────────────────────────────┘
                            │
              ┌─────────────┴─────────────┐
              ▼                           ▼
┌──────────────────────┐     ┌──────────────────────┐
│   AI Triage Service  │     │  EBA Template Service │
│   Claude Sonnet +    │     │  JSON · XML · PDF     │
│   Circuit Breaker    │     │  EBA-standard format  │
└──────────────────────┘     └──────────────────────┘
                                        │
                                        ▼
                            ┌──────────────────────┐
                            │ NCA Submission Svc   │
                            │ Idempotent upload    │
                            └──────────────────────┘
```

### DORA Reporting Timeline

| Stage | Deadline | Output |
|-------|----------|--------|
| **Initial Notification** | 4 hours | Incident detected, major classification, preliminary impact |
| **Intermediate Report** | 72 hours | Root cause analysis, containment actions, affected services |
| **Final Report** | 1 month | Full timeline, remediation, lessons learned |

## Key Features

### 1. Automated Classification
```python
# DORA major incident criteria (EBA/ESMA/EIOPA)
criteria = [
    "affected_clients > 10% of total",
    "service_downtime > 2 hours",
    "financial_impact > €100K",
    "reputational_impact: high",
    "cross_border_impact: true",
    "data_breach: personal_data"
]
# Any 2+ criteria triggered = Major Incident
```

### 2. AI-Assisted Triage
- **Claude Sonnet** for incident summarization and root cause suggestion
- **Circuit breaker** for graceful degradation when AI unavailable
- **Human-in-the-loop** review queue for edge cases

### 3. EBA-Standard Reports
```
Report Formats:
├── JSON (machine-readable, API submission)
├── XML (legacy NCA portals)
└── PDF (human review, signature)
```

### 4. Multi-Tenant Architecture
- **Keycloak** OIDC/SAML2 with per-tenant realms
- **PostgreSQL RLS** for data isolation
- **Per-tenant Kafka topics** for event streaming

## Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Ingestion** | FastAPI + aiokafka | Incident intake, normalization |
| **Classification** | Python + DORA rules engine | Major/non-major determination |
| **AI Triage** | Claude Sonnet API | Summarization, root cause |
| **Templates** | FastAPI + WeasyPrint | EBA JSON/XML/PDF generation |
| **Submission** | FastAPI | Idempotent NCA portal upload |
| **Review UI** | React 18 + TypeScript | Human review queue |
| **Message Bus** | Kafka 3.7 (Strimzi) | Event streaming |
| **Database** | PostgreSQL 16 + RLS | Incident data, audit trail |
| **Auth** | Keycloak 24 | Multi-tenant SSO |
| **Secrets** | HashiCorp Vault | API keys, credentials |

## Compliance Coverage

| DORA Article | Requirement | Platform Feature |
|--------------|-------------|------------------|
| Art. 17 | ICT incident classification | Automated rule engine |
| Art. 19 | Reporting to competent authorities | NCA submission service |
| Art. 19(4) | Initial notification within 4h | Deadline tracker + alerts |
| Art. 19(6) | Final report within 1 month | Report generation workflow |
| Art. 20 | Harmonised reporting templates | EBA-standard formats |

## Results & Metrics

### Target Market
- **40,000 EU financial entities** subject to DORA
- Banks, payment institutions, e-money providers
- Crypto-asset service providers (MiCA)
- Insurance and reinsurance undertakings

### Revenue Target
- **$300K Year 1** (SaaS + enterprise licenses)
- Per-incident pricing or monthly subscription

## Architecture Decisions

- **Kafka over REST polling**: Real-time incident flow, replay capability
- **Claude Sonnet over GPT-4**: Better structured output, lower hallucination rate
- **Circuit breaker pattern**: AI failures don't block human workflow
- **Idempotent NCA submission**: Safe retries on network failures
- **Per-tenant Keycloak realms**: Full isolation for regulated entities
