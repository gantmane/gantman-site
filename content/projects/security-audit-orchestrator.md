---
title: "SAO — Security Audit Orchestrator"
date: 2026-02-25
description: "Multi-cloud DevSecOps security analysis platform with SBOM generation, attack tree building, detection gap analysis, and AI-powered risk assessment"
technologies: ["Python", "MITRE ATT&CK", "NIST CSF", "Ollama", "SARIF", "CycloneDX", "Terraform"]
categories: ["Product", "Security", "DevSecOps"]
tags: ["Security Audit", "SBOM", "Attack Tree", "MITRE ATT&CK", "Detection Engineering", "Multi-Cloud"]
client: "Internal Tool"
duration: "2 months"
team_size: "1"
metrics:
  - "Multi-cloud (AWS, Yandex, On-Prem)"
  - "NIST CSF 2.0 aligned"
  - "MITRE ATT&CK v14 mapped"
  - "AI-powered analysis"
---

# SAO — Security Audit Orchestrator

## Challenge
Security teams struggle with fragmented tooling: separate tools for asset inventory, vulnerability scanning, attack path analysis, and detection engineering. Infrastructure state is scattered across Terraform backends, cloud APIs, and on-premise systems. Attack feasibility assessments require manual expert analysis.

Build a unified security audit platform that:
- Extracts infrastructure state from multiple clouds
- Generates comprehensive SBOMs
- Builds attack trees mapped to MITRE ATT&CK
- Identifies detection coverage gaps
- Provides AI-powered risk assessment

## Solution Architecture

### Overview
```
┌─────────────────────────────────────────────────────────────────────┐
│                     Security Audit Orchestrator                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────┐         │
│   │  Extractors  │    │   Parsers    │    │   Analyzers  │         │
│   │  - Terraform │    │  - Cloud API │    │  - Attack    │         │
│   │  - Docker    │    │  - SBOM      │    │  - Detection │         │
│   │  - Git       │    │  - IAM       │    │  - Risk      │         │
│   │  - OS Pkgs   │    │  - Network   │    │  - AI/LLM    │         │
│   └──────┬───────┘    └──────┬───────┘    └──────┬───────┘         │
│          │                   │                   │                  │
│          └───────────────────┼───────────────────┘                  │
│                              ▼                                      │
│                    ┌──────────────────┐                             │
│                    │   Audit Engine   │                             │
│                    │   NIST CSF 2.0   │                             │
│                    │   MITRE ATT&CK   │                             │
│                    └────────┬─────────┘                             │
│                             ▼                                       │
│          ┌─────────────────────────────────────┐                   │
│          │           Output Formats             │                   │
│          │  SARIF · CycloneDX · JSON · Markdown │                   │
│          └─────────────────────────────────────┘                   │
└─────────────────────────────────────────────────────────────────────┘
```

### NIST CSF 2.0 Alignment

| Function | Coverage | Key Capabilities |
|----------|----------|------------------|
| **GOVERN (GV)** | Strategic | Risk metrics, compliance mapping |
| **IDENTIFY (ID)** | Asset management | SBOM, dependency analysis, threat catalog |
| **PROTECT (PR)** | Preventive | IAM analysis, encryption audit, network segmentation |
| **DETECT (DE)** | Detection engineering | Rule coverage, gap analysis, SIEM correlation |
| **RESPOND (RS)** | Incident response | Attack paths, remediation plans |
| **RECOVER (RC)** | Business continuity | Impact analysis, recovery priorities |

## Key Features

### 1. Multi-Cloud Support
```bash
# AWS infrastructure audit
sao run --cloud aws --terraform-state s3://bucket/prod.tfstate

# Yandex Cloud audit
sao run --cloud yandex --terraform-state s3://bucket/yc-prod.tfstate

# On-premise (local state)
sao run --cloud onprem --terraform-state ./terraform.tfstate
```

### 2. SBOM Extraction
```bash
# Docker image SBOM
sao extract sbom --type docker --target nginx:1.25-alpine

# Git repository dependencies
sao extract sbom --type git --target ./my-app

# OS packages
sao extract sbom --type os --target ubuntu:22.04

# CI/CD build artifacts
sao extract sbom --type build --target ./build-manifest.json
```

Output formats: CycloneDX, SPDX, JSON.

### 3. Attack Tree Analysis
```bash
# Build attack tree with supply chain template
sao attack build \
  --state terraform.tfstate \
  --template supply_chain_attack \
  --output attack-tree.json

# Available templates:
# - supply_chain_attack
# - credential_theft
# - data_exfiltration
# - lateral_movement
# - privilege_escalation
```

Each attack tree node maps to MITRE ATT&CK techniques:
```json
{
  "node": "Compromise CI/CD Pipeline",
  "technique": "T1195.002",
  "tactic": "Initial Access",
  "feasibility": 0.7,
  "detection_coverage": 0.3,
  "remediation": "Implement signed commits, artifact verification"
}
```

### 4. Detection Gap Analysis
```bash
# Analyze Sigma rule coverage
sao audit detection \
  --rules /path/to/sigma-rules \
  --attack-tree attack-tree.json \
  --output gaps.json

# Output shows:
# - ATT&CK techniques with rules: 45/120 (37.5%)
# - Techniques without detection: 75
# - Recommended rules to add
```

### 5. AI-Powered Risk Assessment
```bash
# Use local Ollama for attack feasibility analysis
sao analyze risk \
  --attack-tree attack-tree.json \
  --model deepseek-r1:32b \
  --output risk-assessment.md

# AI analyzes:
# - Attack path feasibility
# - Required attacker capabilities
# - Time-to-compromise estimates
# - Prioritized remediation recommendations
```

## Output Formats

### SARIF (IDE Integration)
```json
{
  "$schema": "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/main/sarif-2.1/schema/sarif-schema-2.1.json",
  "runs": [{
    "tool": {"driver": {"name": "SAO"}},
    "results": [
      {
        "ruleId": "SAO-001",
        "level": "error",
        "message": {"text": "S3 bucket public access enabled"},
        "locations": [{"physicalLocation": {"artifactLocation": {"uri": "main.tf"}}}]
      }
    ]
  }]
}
```

### Audit Summary
```
┌───────────────────┐
│   Audit Summary   │
├──────────┬────────┤
│ Severity │ Count  │
├──────────┼────────┤
│ Critical │ 3      │
│ High     │ 12     │
│ Medium   │ 28     │
│ Low      │ 15     │
│ Total    │ 58     │
└──────────┴────────┘
```

## Project Structure

```
sao/
├── main.py              # CLI entry point
├── extractors/          # Cloud state extraction
│   ├── terraform.py     # Terraform state parser
│   ├── docker.py        # Container analysis
│   ├── git.py           # Repository scanning
│   └── os_packages.py   # System package audit
├── parsers/             # Data normalization
│   ├── aws.py
│   ├── yandex.py
│   └── onprem.py
├── attack_tree/         # Attack path analysis
│   ├── builder.py
│   ├── templates/
│   └── mitre_mapping.py
├── chains/              # LangChain integrations
├── agents/              # AI-powered analysis
├── integrations/        # External tool connectors
├── models/              # Data models
├── outputs/             # Format generators
└── tests/
```

## Results & Benefits

### Coverage Metrics
```
Analysis Capabilities:
├── Cloud providers: AWS, Yandex Cloud, On-Prem
├── SBOM sources: Docker, Git, OS, CI/CD builds
├── Output formats: SARIF, CycloneDX, JSON, Markdown
├── ATT&CK coverage: 200+ techniques mapped
└── Detection rules: Sigma, Wazuh, Suricata support
```

### Use Cases
1. **Pre-deployment audit**: Analyze infrastructure before production
2. **Compliance assessment**: Map findings to NIST CSF controls
3. **Red team prep**: Identify attack paths before adversaries
4. **Detection engineering**: Find coverage gaps, prioritize rule development
5. **Supply chain security**: Comprehensive SBOM for all dependencies

## Architecture Decisions

- **Multi-cloud over single-cloud**: Enterprises use multiple providers
- **Terraform state as truth**: Most reliable infrastructure inventory
- **MITRE ATT&CK mapping**: Industry-standard threat taxonomy
- **SARIF output**: IDE integration for developer feedback
- **Local LLM (Ollama)**: No cloud API costs, data stays local
