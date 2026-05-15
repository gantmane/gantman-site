---
title: "Esla — AI-Powered Real Estate Platform"
date: 2026-04-15
description: "Full-stack real estate platform for Belarus with NLP property search, automated valuation, and Telegram Mini-App integration"
technologies: ["FastAPI", "React", "PostgreSQL", "Ollama", "Keycloak", "Vault", "Docker Compose", "Telegram Bot API"]
categories: ["Product", "AI/ML", "Full-Stack"]
tags: ["Real Estate", "NLP", "AVM", "Telegram Mini-App", "Local LLM", "Zero API Costs"]
client: "Esla.by"
duration: "4 months"
team_size: "1"
metrics:
  - "22 microservices"
  - "14 active API modules"
  - "$0 cloud API costs"
  - "10 Grafana dashboards"
---

# Esla — AI-Powered Real Estate Platform

## Challenge
Build a complete real estate platform for the Belarusian market that enables property search via natural language (Russian/Belarusian), provides automated property valuations, connects buyers with verified realtors, and runs entirely as a Telegram Mini-App — all without recurring cloud API costs.

## Solution Architecture

### Platform Overview
A modular monolith deployed via Docker Compose with 22 services covering the full real estate lifecycle: search, valuation, listings, realtor marketplace, and admin operations.

```
Frontend (React/Vite)
       │
       ▼
Backend (FastAPI) ──► PostgreSQL (PostGIS + pgvector)
       │                    │
       ├──► Keycloak (Auth) │
       ├──► Vault (Secrets) │
       ├──► RabbitMQ ───────┴──► Celery Workers ──► Ollama
       └──► MinIO (S3 Storage)
```

### AI/ML Pipeline — Zero External Costs
All inference runs on a local Ollama server (RTX 5090, 32GB VRAM):

| Model | Use Case |
|-------|----------|
| **Qwen3-Coder-30B** | NLP search parsing, listing text generation, Russian language processing |
| **DeepSeek-R1-32B** | Property valuation reasoning, security analysis |
| **LightGBM** | Automated Valuation Model (AVM) with SHAP explainability |

**Result:** Full AI capabilities with zero OpenAI/Anthropic API costs.

### Key Features

**1. Natural Language Property Search**
```
User: "двушка в центре минска до 80к с балконом"
→ Parsed: {rooms: 2, district: "center", city: "minsk", max_price: 80000, features: ["balcony"]}
→ Vector similarity + PostgreSQL full-text search
→ Ranked results with explanation
```

**2. Automated Valuation Model (AVM)**
- LightGBM ensemble trained on Realt.by historical data
- SHAP explanations for transparency
- Comparable Market Analysis (CMA) integration

**3. Realtor Marketplace**
- KYC/AML verification flow
- Lead distribution algorithm
- Agency management
- AI-generated listing descriptions

**4. Full Observability**
10 pre-provisioned Grafana dashboards covering API performance, infrastructure, business metrics, and SLOs.

## Tech Stack Deep Dive

| Layer | Technology |
|-------|-----------|
| **Backend** | Python 3.11, FastAPI, SQLAlchemy (async), Celery |
| **Frontend** | React 18, TypeScript, Vite, Tailwind CSS, Zustand |
| **Database** | PostgreSQL 15 (PostGIS, pgvector, pg_trgm), MongoDB 7 |
| **Auth** | Keycloak 24 (OIDC, PKCE, Telegram IdP) |
| **Secrets** | HashiCorp Vault (KV v2, AppRole) |
| **Monitoring** | Prometheus, Grafana, Loki, Vector, Tempo |

## Results & Metrics

### Technical Outcomes
```
Platform Status:
├── Active API Modules: 14 (auth, search, valuations, listings, etc.)
├── Database Models: 22 SQLAlchemy entities
├── Celery Tasks: 11 async task modules
├── Test Coverage: Unit, integration, E2E, security, performance
└── Documentation: 36 requirement documents (BRD, PRD, FSD, SRS)
```

### Business Benefits
1. **Cost Efficiency:** Zero recurring AI/ML API costs via local Ollama
2. **Data Sovereignty:** All data stays in-region (Belarus compliance)
3. **User Experience:** Telegram-native interface, no app download required
4. **Scalability:** Modular architecture ready for multi-region expansion

## Architecture Decisions

- **Telegram Mini-App over native mobile:** Lower friction, instant access, built-in auth
- **Ollama over OpenAI:** Zero marginal cost per request, data privacy, no rate limits
- **PostgreSQL + pgvector over Pinecone:** Self-hosted, full control, cost-effective
- **Keycloak over Auth0:** Self-hosted, GDPR-compliant, Telegram IdP integration
