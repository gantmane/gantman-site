---
title: "Developer Tools Portal — tools.gantman.biz"
date: 2026-05-04
description: "Freemium developer tool suite with 30+ launch tools, no signup required, self-hosted on k3s with global CDN delivery and three-tier monetization"
technologies: ["React", "TypeScript", "k3s", "Keycloak", "ArgoCD", "Redis", "G-Core CDN", "Helm"]
categories: ["Product", "SaaS", "Developer Tools"]
tags: ["Developer Tools", "SaaS", "Freemium", "Self-Hosted", "CyberChef", "API Testing", "DevSecOps"]
client: "Public Product"
duration: "4 months (MVP Q3 2026)"
team_size: "1"
metrics:
  - "30+ MVP tools"
  - "16 tool categories"
  - "No signup required"
  - "$0 cloud hosting"
---

# Developer Tools Portal — tools.gantman.biz

## Challenge
DevSecOps practitioners juggle six to ten web tools daily: JSON formatters, JWT decoders, hash generators, API clients, network calculators. These tools live at different URLs, require separate bookmarks, and offer inconsistent UX. No single public interface provides all common developer utilities in one place with immediate access — no signup walls, no cookie consent popups blocking tool use.

Build a unified developer tool suite that:
- Provides 30+ curated tools at launch, growing to 100+
- Requires no registration — instant access
- Self-hosts all tools with zero data leaving the operator's infrastructure
- Evolves into sustainable SaaS with dedicated resources for paying teams

## Solution Architecture

### Overview
```
┌─────────────────────────────────────────────────────────────────┐
│                   tools.gantman.biz Portal                       │
│           React 18 + TypeScript + Tailwind CSS                  │
└───────────────────────────┬─────────────────────────────────────┘
                            │ HTTPS / G-Core CDN
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                       k3s Cluster (Belarus HTP)                  │
│          ArgoCD GitOps · Nginx Ingress · cert-manager           │
└───────────────────────────┬─────────────────────────────────────┘
                            │
         ┌──────────────────┼──────────────────┐
         ▼                  ▼                  ▼
┌──────────────────┐ ┌──────────────┐ ┌──────────────────┐
│   Tool Pods      │ │   Keycloak   │ │   Analytics      │
│   (per-tool k8s  │ │   (Phase 3)  │ │   Plausible CE   │
│    deployment)   │ │              │ │   (cookieless)   │
└──────────────────┘ └──────────────┘ └──────────────────┘
```

### Three-Phase Rollout

| Phase | Name | Auth | Goal |
|-------|------|------|------|
| **1** | Free Launch | None (public) | Traffic, awareness, 30+ tools |
| **2** | Beta | Optional account | Feedback, analytics, NPS |
| **3** | Monetization | Keycloak SSO | Revenue (Free/Pro/Team tiers) |

### 16 Tool Categories

| ID | Category | Examples |
|----|----------|----------|
| CAT-01 | Crypto | Hash generators, UUID, BCrypt, RSA keygen |
| CAT-02 | Converters | JSON/YAML/TOML/XML, Base64, color |
| CAT-03 | Web | URL encoder, JWT decoder, HTTP status |
| CAT-04 | Development | Formatters, regex, cron, chmod |
| CAT-05 | Network | CIDR calculator, DNS, WHOIS |
| CAT-06 | Text | Lorem ipsum, diff, case converter |
| CAT-07 | DevSecOps | CyberChef, testssl.sh, PrivateBin |
| CAT-08 | API | Hoppscotch, Swagger UI, httpbin |
| CAT-09 | PDF & Documents | Stirling-PDF, Gotenberg, Tabula |
| CAT-10 | Diagrams | Excalidraw, draw.io, Mermaid |
| CAT-11 | Monitoring | Uptime Kuma, Gatus, Healthchecks |
| CAT-12 | Database Admin | Adminer, CloudBeaver, RedisInsight |
| CAT-13 | AI/LLM Tools | Open WebUI, LocalAI |
| CAT-14 | Workflow | n8n (lab subdomain), Node-RED |
| CAT-15 | Infrastructure | Portainer, ttyd (internal-only) |
| CAT-16 | Collaboration | StackEdit, linkding |

## Key Features

### 1. No Signup Required (Phase 1)
```
Day-1 User Journey:
├── User searches "json to yaml online"
├── Lands on tools.gantman.biz — no login prompt
├── Tool grid visible immediately
├── Clicks "JSON to YAML" — tool opens inline
├── Pastes input, gets output — 30 seconds total
└── No registration, no cookies required
```

### 2. Tool Embedding Strategy
```javascript
// Inline (iframe) — it-tools, CyberChef, PrivateBin
<iframe src="/tool/cyberchef" sandbox="allow-scripts" />

// New Tab — Hoppscotch, complex tools
<a href="/launch/hoppscotch" target="_blank">Launch</a>

// Web UI wrapper — Trivy, testssl.sh
<TriviyScanForm onSubmit={submitToBackendQueue} />
```

### 3. Subscription Tiers (Phase 3)

| Tier | Price | Resource Pool | Rate Limit |
|------|-------|--------------|------------|
| **Free** | $0 | Shared pods | 200 req/min |
| **Pro** | $9/mo | Priority queue | 500 req/min |
| **Team** | $49/mo | Dedicated namespace | Unlimited |

### 4. Self-Hosted Economics
```
Monthly Operating Cost (Phase 1):
├── Electricity (~150W avg)    $30/mo
├── Domain registration        $1.25/mo
├── Backup S3 (50 GiB)        $5/mo
├── G-Core CDN                 $0 (free tier)
├── Hardware amortization      $56/mo
└── Total                      ~$92/mo

Revenue (Phase 3 projection):
├── Carbon Ads (50K MAU)       $1,500/mo
├── Pro tier (200 × $9)        $1,800/mo
└── MRR target                 $3,300/mo
```

## Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Frontend** | React 18 + TypeScript | Portal SPA |
| **Styling** | Tailwind CSS | Responsive dark/light themes |
| **Hosting** | k3s cluster | Multi-tool Kubernetes deployment |
| **Auth** | Keycloak 24 | OIDC/PKCE SSO (Phase 3) |
| **Deployment** | ArgoCD | GitOps from Helm charts |
| **CDN** | G-Core CDN | Global edge delivery |
| **Rate Limiting** | Redis + Nginx | Per-IP/per-account buckets |
| **Analytics** | Plausible CE | Cookieless, privacy-first |
| **TLS** | cert-manager | Let's Encrypt automation |

## Competitive Positioning

| Dimension | it-tools.tech | tools.gantman.biz |
|-----------|--------------|-------------------|
| Tool count | 87 | 30+ MVP → 100+ Phase 3 |
| DevSecOps tools | None | CyberChef, Trivy, testssl.sh |
| API testing | None | Hoppscotch |
| Secure paste | None | PrivateBin (E2E encrypted) |
| Rate limits | None | Tiered (Free/Pro/Team) |
| SLA | None | Pro 99.0%, Team 99.5% |
| Revenue model | None | Freemium + ads |

## Hosting Advantage

Deployed from **Belarus High-Tech Park (HTP)**:
- 0% IT income tax through 2049
- G-Core CDN edge nodes (CIS, EU, Asia)
- No US cloud dependency (OFAC-safe)
- No AWS/GCP/Azure vendor lock-in
- Data stays on-premises — privacy advantage for security tools

## Results & Roadmap

### MVP (Phase 1) Success Criteria
```
Metrics:
├── 30+ tools at launch (MVP-30 list)
├── 1,000+ monthly unique visitors
├── 40%+ engagement (≥2 tools/session)
├── 99.5% uptime
├── <2s global page load via CDN
└── Zero blocking auth prompts
```

### Phase 3 Revenue Targets
```
Month 9:   $950/mo MRR (50 Pro + 15 Team seats)
Month 12:  $3,300/mo MRR (150 Pro + 60 Team seats)
Month 18:  $8,500/mo MRR (400 Pro + 150 Team seats)
```

## Architecture Decisions

- **No signup required (Phase 1)**: Maximizes top-of-funnel; day-1 abuse controls (100 req/min/IP, captcha-on-spike) run transparently
- **Per-tool k8s deployments**: Fault isolation — one tool crash doesn't affect others
- **ArgoCD GitOps**: Zero manual `kubectl apply`; all deployments from Helm charts
- **G-Core CDN over Cloudflare**: CIS-friendly edge coverage; no OFAC risk
- **Self-hosted analytics**: No data to third-party SaaS; GDPR-simple
- **Belarus HTP hosting**: 0% IT tax = sustainable $0 cloud-hosting model
