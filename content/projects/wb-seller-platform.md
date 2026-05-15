---
title: "WB-SMP — Wildberries Seller Management Platform"
date: 2026-05-08
description: "B2B SaaS platform for Wildberries marketplace sellers with unit economics dashboards, automated bid optimization, and inventory forecasting"
technologies: ["FastAPI", "React", "PostgreSQL", "TimescaleDB", "Celery", "Vault", "Terraform", "Kubernetes"]
categories: ["Product", "SaaS", "E-commerce"]
tags: ["Wildberries", "E-commerce", "Unit Economics", "Advertising", "Russia", "B2B SaaS"]
client: "WB Sellers"
duration: "6 months"
team_size: "1"
metrics:
  - "262 API endpoints integrated"
  - "14 Wildberries API hosts"
  - "9 bounded contexts"
  - "48 requirement documents"
---

# WB-SMP — Wildberries Seller Management Platform

## Challenge
Wildberries sellers face 34.5–38% commission rates with limited visibility into true unit economics. They need:
- Real-time margin per SKU after all fees
- Automated advertising bid optimization
- Inventory forecasting to prevent stockouts
- Competitive intelligence

Build a unified command center integrating 262 API endpoints across 14 Wildberries hosts.

## Solution Architecture

### Platform Overview
Modular monolith with 9 bounded contexts serving growing sellers (10–50 SKUs, 100K–1M RUB/month revenue).

```
┌─────────────────────────────────────────────────────────────────┐
│                       React SPA (Frontend)                       │
└────────────────────────┬────────────────────────────────────────┘
                         │ HTTPS
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Nginx Ingress (k3s)                           │
└────────────────────────┬────────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│  FastAPI App │ │ Celery Beat  │ │ Celery Tasks │
│ (8 routes)   │ │ Scheduler    │ │ (workers)    │
└──────┬───────┘ └──────┬───────┘ └──────┬───────┘
       │                │                 │
       ├────────────────┼─────────────────┤
       │                │                 │
       ▼                ▼                 ▼
┌─────────────────────────────────────────────────────┐
│         Bounded Contexts (9 modules)                │
│  Auth | Catalog | Pricing | Fulfillment |          │
│  Advertising | Analytics | Intelligence |          │
│  Inventory | Support                               │
└─────────────────────────────────────────────────────┘
       │
       ├── PostgreSQL + TimescaleDB (time-series)
       ├── Redis Sentinel (caching)
       └── Vault HSM (API key management)
```

### Core Features

**1. Unit Economics Dashboard**
Real-time margin visibility per SKU:
```
Revenue:     100,000 RUB
├── WB Commission:    -35,000 (35%)
├── Logistics:         -8,000
├── Storage:           -2,500
├── Advertising:       -5,000
├── Returns:           -3,000
└── Net Margin:       46,500 RUB (46.5%)
```

**2. Auto-Bid Optimizer**
Automated advertising bid management targeting ROAS:
- Hourly bid adjustments based on conversion data
- A/B testing for keyword bids
- Budget pacing to prevent overspend
- Reduces manual bid management by ~3 hrs/week

**3. Inventory Forecasting**
14-day horizon predictions:
- Stockout alerts before Amazon-style penalties
- Overstock warnings for slow-moving SKUs
- Reorder point calculations
- FBS/FBW split recommendations

**4. Competitive Intelligence**
Public API monitoring:
- Competitor price tracking
- Category trend analysis
- Search ranking intelligence
- Card quality scoring

## Tech Stack

| Layer | Technology | Purpose |
|-------|------------|---------|
| **Backend** | FastAPI, SQLAlchemy | API + business logic |
| **Time Series** | TimescaleDB | Historical analytics |
| **Scheduler** | Celery Beat | Periodic data sync |
| **Secrets** | Vault (HSM, Shamir) | WB API key management |
| **Infrastructure** | K3s, Terragrunt | Self-hosted deployment |
| **Monitoring** | Prometheus, Loki, Tempo | Full observability |

## Wildberries API Integration

### 14 API Hosts Integrated
```
Content API:     catalog, media, cards
Prices API:      pricing, discounts
Marketplace API: orders, supplies, returns
Statistics API:  sales, stocks, income
Advert API:      campaigns, bids, budgets
Feedbacks API:   reviews, questions
Recommendations: category rankings
```

### Rate Limit Management
- Token bucket per API host
- Automatic backoff on 429s
- Priority queue for critical operations
- Webhook handlers for real-time events

## Security Architecture

### API Key Management
```
Vault KV v2:
└── secret/wb-smp/
    ├── sellers/{id}/api_token  (encrypted)
    ├── sellers/{id}/refresh_token
    └── rotation_schedule
```

- Shamir unseal (3-of-5 threshold)
- 90-day automatic rotation
- Audit logging for all access
- Zero plaintext storage

### Compliance (152-FZ)
Russian data protection law alignment:
- Data localization (Russia-hosted)
- Consent management
- Data retention policies
- Audit trail for personal data access

## Results & Metrics

### Documentation Coverage
```
Requirements:
├── Business: BRD, market analysis, glossary
├── Product: PRD, user personas, flows
├── Functional: 8 FSDs (analytics, ads, inventory, etc.)
├── Technical: SRS (6 docs), ADRs (10+)
├── Quality: Test strategy, SLO/SLA, observability
└── Security: Threat model, compliance, token mgmt
```

### Target Outcomes
1. **Time Savings:** 3+ hours/week on bid management
2. **Margin Visibility:** Real-time unit economics
3. **Stockout Prevention:** 14-day forecasting
4. **Competitive Edge:** Public API intelligence

## Architecture Decisions

- **Modular monolith over microservices:** Single deployment, easier debugging, DDD boundaries
- **TimescaleDB over ClickHouse:** Better PostgreSQL integration, sufficient scale
- **Vault HSM over AWS KMS:** Self-hosted, 152-FZ compliant, no cloud dependency
- **Feature-slice frontend:** Scalable React architecture with code splitting
