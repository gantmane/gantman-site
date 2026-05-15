---
title: "Multi-Framework Evidence Graph — One Evidence, Many Frameworks"
date: 2026-05-07
description: "Compliance evidence repository mapping single artifacts to SOC 2, PCI DSS, ISO 27001, DORA, NIS2 simultaneously with OSCAL export and Merkle-tree integrity"
technologies: ["Python", "FastAPI", "PostgreSQL", "React", "S3 WORM", "Sigstore", "OSCAL"]
categories: ["Product", "Compliance", "GRC"]
tags: ["Evidence Management", "SOC 2", "PCI DSS", "ISO 27001", "DORA", "NIS2", "OSCAL", "Audit"]
client: "Enterprise"
duration: "8-12 weeks"
team_size: "1"
metrics:
  - "$100K Y1 revenue target"
  - "6 frameworks mapped"
  - "500+ controls"
  - "OSCAL-compliant export"
---

# Multi-Framework Evidence Graph — One Evidence, Many Frameworks

## Challenge
Compliance teams managing multiple frameworks (SOC 2, PCI DSS, ISO 27001, DORA, NIS2, AI Act) collect redundant evidence for overlapping controls. A single penetration test report might satisfy requirements in 4 different frameworks, but each auditor receives a separate package. Manual mapping is error-prone, and proving evidence integrity during audits requires custom tooling.

Build an evidence repository where one artifact maps to multiple frameworks, with cryptographic integrity proofs and OSCAL-compliant audit package generation.

## Solution Architecture

### Overview
```
┌─────────────────────────────────────────────────────────────────┐
│                     Evidence Upload                              │
│         Pentest report · Policy doc · Screenshot · Log          │
└───────────────────────────┬─────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Mapping Engine                                 │
│       NLP-assisted control suggestion + human confirmation      │
└───────────────────────────┬─────────────────────────────────────┘
                            │
         ┌──────────────────┴──────────────────┐
         ▼                                     ▼
┌──────────────────────┐          ┌──────────────────────┐
│   Control Library    │          │   Merkle Tree        │
│   500+ controls      │          │   Integrity Graph    │
│   6 frameworks       │          │                      │
└──────────────────────┘          └──────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                    OSCAL Exporter                                │
│   Catalog · Profile · Component-Definition · SSP · AR           │
└───────────────────────────┬─────────────────────────────────────┘
                            │ Sigstore cosign
                            ▼
                 ┌──────────────────┐
                 │  Signed Audit    │
                 │    Package       │
                 └──────────────────┘
```

### Control Mapping Example

One penetration test report satisfies:

| Framework | Control ID | Requirement |
|-----------|------------|-------------|
| PCI DSS 4.0 | 11.3.1 | External penetration testing |
| SOC 2 | CC7.1 | Security testing |
| ISO 27001 | A.12.6.1 | Technical vulnerability management |
| DORA | Art. 24 | ICT resilience testing |
| NIS2 | Art. 21(2)(e) | Security testing |

**Result:** 5 audit requirements satisfied with 1 evidence artifact.

## Key Features

### 1. Evidence Upload with Auto-Tagging
```python
# Upload evidence with automatic control suggestion
evidence = repository.upload(
    file="pentest-report-2026-q1.pdf",
    title="Q1 External Penetration Test",
    date="2026-03-15",
    provider="SecureAudit Inc."
)

# NLP suggests applicable controls
suggestions = mapping_engine.suggest_controls(evidence)
# Returns: [PCI-11.3.1, SOC2-CC7.1, ISO-A.12.6.1, DORA-Art24, NIS2-Art21.2.e]
```

### 2. Merkle Tree Integrity
```
                    [Root Hash]
                    /          \
            [Hash AB]          [Hash CD]
            /      \            /      \
        [Hash A]  [Hash B]  [Hash C]  [Hash D]
           |         |         |         |
        Pentest   Policy    Config    Access
        Report    Doc       Backup    Review
```

- **Tamper-evident**: Any modification invalidates the tree
- **Partial verification**: Prove single evidence without revealing others
- **Audit trail**: Every mapping change creates new tree version

### 3. OSCAL Export Suite

| OSCAL Model | Content |
|-------------|---------|
| **Catalog** | All 500+ controls from 6 frameworks |
| **Profile** | Framework-specific control selection |
| **Component-Definition** | System components with implemented controls |
| **SSP** | System Security Plan with evidence mapping |
| **Assessment Results** | Audit findings with evidence links |

### 4. Compliance Matrix Dashboard
```
┌─────────────────────────────────────────────────────────────┐
│                 Compliance Coverage Matrix                   │
├──────────┬─────────┬─────────┬─────────┬─────────┬─────────┤
│ Control  │ PCI DSS │  SOC 2  │ISO 27001│  DORA   │  NIS2   │
├──────────┼─────────┼─────────┼─────────┼─────────┼─────────┤
│ Access   │  ████   │  ████   │  ███░   │  ████   │  ██░░   │
│ Encrypt  │  ████   │  ███░   │  ████   │  ██░░   │  ███░   │
│ Testing  │  ████   │  ████   │  ████   │  ████   │  ████   │
│ Incident │  ███░   │  ██░░   │  ███░   │  ████   │  ████   │
└──────────┴─────────┴─────────┴─────────┴─────────┴─────────┘
  Coverage: ████ 100%  ███░ 75%  ██░░ 50%  █░░░ 25%
```

## Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **API Service** | FastAPI | Evidence CRUD + OSCAL export |
| **Mapping Engine** | Python + NLP | Control suggestion |
| **OSCAL Service** | Python + OSCAL libraries | Standards-compliant export |
| **Evidence Store** | S3 WORM + Object Lock | Immutable artifact storage |
| **Database** | PostgreSQL 16 | Control library, mappings |
| **Dashboard UI** | React 18 + TypeScript | Compliance matrix |
| **Signing** | Sigstore cosign keyless | Audit package signatures |

## Supported Frameworks

| Framework | Controls | Status |
|-----------|----------|--------|
| SOC 2 Type II | 64 | Full |
| PCI DSS 4.0 | 270+ | Full |
| ISO 27001:2022 | 93 | Full |
| DORA | 45 | Full |
| NIS2 | 30 | Full |
| EU AI Act | 25 | Full |

**Total:** 500+ controls with cross-framework mapping

## Results & Metrics

### Evidence Reduction
```
Before: 5 frameworks × 50 evidence artifacts = 250 files
After:  ~80 unique artifacts mapped to all frameworks
Reduction: 68% fewer files to manage
```

### Audit Prep Time
```
Traditional manual mapping: 40-80 hours per framework
With Evidence Graph:        8-16 hours per framework
Savings: 60-80%
```

### Revenue Target
- **$100K Year 1** (SaaS + enterprise licenses)
- Per-framework or organization-wide pricing

## Architecture Decisions

- **Merkle tree over simple hashing**: Enables partial proofs, efficient updates
- **OSCAL as export format**: Industry standard, auditor-friendly
- **Sigstore keyless signing**: No PKI infrastructure required
- **S3 WORM over database BLOBs**: Meets retention requirements, cost-effective
- **NLP-assisted mapping**: Reduces manual work, human confirms suggestions
