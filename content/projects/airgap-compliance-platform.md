---
title: "Air-Gap Compliance Platform — Fully Offline Security"
date: 2026-05-07
description: "Zero-egress compliance automation with 356 pre-mirrored OCI images, offline vulnerability databases, and USB sneakernet delivery for regulated industries"
technologies: ["Kubernetes", "Harbor", "Trivy", "Kyverno", "Falco", "Wazuh", "Vault", "Python"]
categories: ["Product", "Compliance", "Security"]
tags: ["Air-Gapped", "Offline", "FedRAMP", "CMMC", "PCI DSS", "ISO 27001", "Defence", "Government"]
client: "Enterprise"
duration: "6-8 weeks"
team_size: "1"
metrics:
  - "$500K Y1 revenue target"
  - "356 OCI images bundled"
  - "Zero internet egress"
  - "10 compliance frameworks"
---

# Air-Gap Compliance Platform — Fully Offline Security

## Challenge
Enterprises in defence, government, healthcare, and finance operate isolated network segments with zero egress to the public internet. These environments require compliance automation (vulnerability scanning, policy enforcement, evidence collection) but cannot pull container images from public registries, download vulnerability databases, or send telemetry externally. Existing compliance tools assume internet connectivity.

Build a fully offline compliance platform delivered via USB sneakernet or internal mirror, with all dependencies pre-bundled.

## Solution Architecture

### Overview
```
┌─────────────────────────────────────────────────────────────────┐
│                    Air-Gapped Network Segment                    │
│                     (Zero Internet Egress)                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌──────────────┐     ┌──────────────┐     ┌──────────────┐   │
│   │   Harbor     │     │   Trivy      │     │   Kyverno    │   │
│   │  (Private    │     │  (Offline    │     │  (Policy     │   │
│   │   Registry)  │     │   DB Mode)   │     │   Engine)    │   │
│   │  356 images  │     │              │     │              │   │
│   └──────────────┘     └──────────────┘     └──────────────┘   │
│                                                                  │
│   ┌──────────────┐     ┌──────────────┐     ┌──────────────┐   │
│   │   Falco      │     │   Wazuh      │     │   Vault      │   │
│   │  (Runtime    │     │  (SIEM +     │     │  (HSM-sealed │   │
│   │   Security)  │     │   Audit)     │     │   Secrets)   │   │
│   └──────────────┘     └──────────────┘     └──────────────┘   │
│                                                                  │
│   ┌──────────────────────────────────────────────────────────┐ │
│   │              Compliance Control Plane                     │ │
│   │  Evidence Collector · OSCAL Exporter · Report Generator  │ │
│   └──────────────────────────────────────────────────────────┘ │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
                            ▲
                            │ USB / Internal Mirror
                            │
┌─────────────────────────────────────────────────────────────────┐
│                    Update Bundle (Sneakernet)                    │
│        OCI images · Vuln DB · Policy updates · Patches          │
└─────────────────────────────────────────────────────────────────┘
```

### Delivery Mechanism

```
Update Bundle Contents:
├── oci-images/           # 356 pre-mirrored container images
│   ├── harbor-2.10.tar
│   ├── trivy-0.49.tar
│   ├── kyverno-1.12.tar
│   └── ...
├── vuln-db/              # Offline vulnerability databases
│   ├── trivy-db.tar.gz   # NVD + GitHub Advisory
│   └── grype-db.tar.gz   # Anchore Grype DB
├── policy-bundles/       # Compliance policies
│   ├── pci-dss-4.0/
│   ├── fedramp-high/
│   └── cmmc-l3/
├── installer-tui         # Textual TUI installer
├── update-applier        # Incremental update tool
└── MANIFEST.sig          # Sigstore signature
```

## Key Features

### 1. Textual TUI Installer
```
┌─────────────────────────────────────────────────────────────────┐
│              Air-Gap Compliance Platform Installer               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Target K8s Distribution:                                        │
│    ○ k3s 1.28+                                                  │
│    ● RKE2 1.28+                                                 │
│    ○ OpenShift 4.14+                                            │
│                                                                  │
│  Compliance Profile:                                             │
│    [ ] PCI DSS 4.0                                              │
│    [x] FedRAMP High                                             │
│    [x] CMMC Level 3                                             │
│    [ ] ISO 27001:2022                                           │
│                                                                  │
│  HSM Configuration:                                              │
│    PKCS#11 Library: /usr/lib/softhsm/libsofthsm2.so            │
│    Slot: 0                                                       │
│                                                                  │
│                    [Install]  [Cancel]                           │
└─────────────────────────────────────────────────────────────────┘
```

### 2. Offline Vulnerability Scanning
```bash
# Trivy runs in offline DB mode
trivy image --offline-scan \
  --db-repository harbor.internal/trivy-db \
  myapp:v1.2.3

# No internet required — uses pre-loaded NVD + GitHub Advisory
```

### 3. HSM-Sealed Secrets
- **PKCS#11 transit seal** for Vault
- **HSM-backed encryption** for evidence at rest
- **Air-gapped key ceremony** documentation included

### 4. Evidence Collection & Export
```
Evidence Collector Output:
├── oscal/
│   ├── catalog.json          # Control catalog
│   ├── ssp.json              # System Security Plan
│   └── assessment-results.json
├── reports/
│   ├── vulnerability-scan.pdf
│   ├── policy-compliance.pdf
│   └── runtime-alerts.pdf
└── audit-export.tar.gz.sig   # Signed bundle for auditors
```

## Supported Frameworks

| Framework | Policies | Evidence Templates |
|-----------|----------|-------------------|
| PCI DSS 4.0 | 45 | Yes |
| ISO 27001:2022 | 38 | Yes |
| SOC 2 Type II | 30 | Yes |
| NIST 800-53 r5 | 50 | Yes |
| FedRAMP High | 55 | Yes |
| CMMC Level 3 | 40 | Yes |
| NIST CSF 2.0 | 40 | Yes |
| 152-FZ (Russia) | 25 | Yes |
| FSTEC 239 | 30 | Yes |
| UAE NESA | 35 | Yes |

## Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **OCI Registry** | Harbor 2.10+ / Zot 1.4+ | Private image storage |
| **Vuln Scanner** | Trivy 0.49+ (offline mode) | Container/IaC scanning |
| **Admission Control** | Kyverno 1.12+ | Policy enforcement |
| **Runtime Security** | Falco 0.38+ | Threat detection |
| **SIEM** | Wazuh 4.9.x | Log aggregation, audit |
| **Secrets** | Vault 1.16 (HSM seal) | Encryption, credentials |
| **Evidence DB** | PostgreSQL 15 (encrypted) | Compliance data |
| **Network Policy** | Calico 3.27+ | Micro-segmentation |
| **Installer** | Python + Textual | TUI-based setup |

## Supported K8s Distributions

| Distribution | Version | Status |
|--------------|---------|--------|
| k3s | 1.28+ | Supported |
| RKE2 | 1.28+ | Supported |
| OpenShift | 4.14+ | Supported |

## Results & Metrics

### Bundle Size
```
Full Install Bundle:   ~45 GB (356 images + DBs + policies)
Incremental Update:    ~2-5 GB (delta images + DB updates)
```

### Target Market
- **Defence contractors** (CMMC, ITAR)
- **Government agencies** (FedRAMP, FISMA)
- **Healthcare** (HIPAA, isolated PHI networks)
- **Finance** (PCI DSS, SOX, air-gapped trading)
- **Critical infrastructure** (NERC CIP)

### Revenue Target
- **$500K Year 1** (enterprise licenses + support)
- Per-cluster or organization-wide licensing

## Architecture Decisions

- **Harbor over Docker Registry**: Enterprise features, vulnerability scanning integration
- **Trivy offline mode**: NVD + GitHub Advisory without internet
- **Textual TUI over web UI**: Works in headless environments, no browser needed
- **USB sneakernet**: Standard delivery for classified networks
- **HSM transit seal**: Meets FedRAMP High / CMMC L3 key management requirements
- **OSCAL export**: Standard format for government auditors
