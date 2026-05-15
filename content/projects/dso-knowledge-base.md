---
title: "DSO Knowledge Base — 3,163 DevSecOps Documents"
date: 2026-04-27
description: "Comprehensive DevSecOps knowledge base organized by NIST CSF 2.0 with 3,163 documents across 102 categories — agent-queryable via Claude Code"
technologies: ["Markdown", "NIST CSF", "Obsidian", "Claude Code", "Python"]
categories: ["Product", "Knowledge Management", "Security"]
tags: ["DevSecOps", "NIST CSF", "Knowledge Base", "Security Operations", "Agent-Queryable"]
client: "Internal Tool"
duration: "Ongoing"
team_size: "1"
metrics:
  - "3,163 documents"
  - "102 categories"
  - "6 NIST CSF functions"
  - "Agent-queryable"
---

# DSO Knowledge Base — 3,163 DevSecOps Documents

## Challenge
Security practitioners need quick access to tool guidance, best practices, and framework mappings. Information is scattered across vendor docs, GitHub READMEs, and blog posts. There's no unified, queryable knowledge base that covers the full DevSecOps lifecycle.

Build a comprehensive knowledge base that:
- Covers all security functions (NIST CSF 2.0)
- Is queryable by AI agents (Claude Code integration)
- Maintains source traceability
- Supports both human browsing and programmatic access

## Solution Architecture

### NIST CSF 2.0 Organization
```
DSO Knowledge Base
├── 00-governance/      (126 docs) — Policy, GRC, compliance
├── 01-identify/        (77 docs)  — Asset discovery, threat intel
├── 02-protect/         (631 docs) — AppSec, container security
├── 03-detect/          (130 docs) — Detection engineering, SIEM
├── 04-respond/         (74 docs)  — Incident response, forensics
├── 05-recover/         (46 docs)  — Disaster recovery, BCP
├── 06-implement/       (118 docs) — Secure SDLC, gates
├── 07-platform/        (191 docs) — Infrastructure hardening
├── 08-offensive/       (106 docs) — Red team, adversary emulation
├── 09-automation/      (143 docs) — GitOps, agent orchestration
├── 10-compliance/      (61 docs)  — OSCAL, SOC CMM, kube-bench
└── 11-96: Supporting domains (algorithms, ML, finance, etc.)
```

### Document Structure
Each document follows a consistent format:
```markdown
# Tool/Concept Name

## Overview
Brief description and primary use case.

## Key Features
- Feature 1: Description
- Feature 2: Description

## Use Cases
- Use case 1
- Use case 2

## Integration Points
How it connects with other tools/frameworks.

## References
- Official docs link
- GitHub repository
- Related KB documents
```

## Key Categories

### Security Operations (NIST CSF Core)

| Function | Docs | Key Topics |
|----------|------|------------|
| **Govern** | 126 | Policy-as-code, OPA, OSCAL, GRC platforms |
| **Identify** | 77 | Asset inventory (NetBox, Fleet), OSINT, threat intel (MISP) |
| **Protect** | 631 | AppSec, SAST/DAST, container security (Falco, Trivy), supply chain |
| **Detect** | 130 | Sigma rules, Wazuh, Suricata, threat hunting (Hayabusa) |
| **Respond** | 74 | DFIR (Velociraptor), incident management, forensics |
| **Recover** | 46 | DR automation (Velero), business continuity |

### Implementation & Platform

| Category | Docs | Key Topics |
|----------|------|------------|
| **Implement** | 118 | OWASP SAMM, security gates, progressive delivery |
| **Platform** | 191 | CIS benchmarks, Kubernetes hardening, cloud security |
| **Offensive** | 106 | Atomic Red Team, MITRE Caldera, adversary emulation |
| **Automation** | 143 | LangGraph, CrewAI, ArgoCD, GitOps patterns |
| **Compliance** | 61 | OSCAL, SOC-CMM, kube-bench, compliance automation |

### Supporting Domains

| Range | Categories | Examples |
|-------|------------|----------|
| 11-40 | CS Fundamentals | Data structures, algorithms, complexity |
| 41-70 | Science/Engineering | Physics, chemistry, materials, aerospace |
| 71-87 | Applied Domains | Health, sports, economics, marketing |
| 88-98 | AI/ML & LLM | AI security, agents, RAG, prompt engineering |
| 99 | Software Engineering | Design patterns, architecture, testing |
| 100-101 | Linux & Kubernetes | System administration, container orchestration |

## Agent Integration

### Claude Code Query Interface
```bash
# User-invocable skill
/kb <query>

# Example queries
/kb "Sigma rule authoring best practices"
/kb "Container runtime security Falco vs Tetragon"
/kb "DORA compliance automation"
```

### Programmatic Search
```bash
# Search by category
grep -r "Falco\|Tetragon" 03-detect/

# Find tool-specific guidance
find . -name "*.md" -exec grep -l "ArgoCD" {} \;

# Search across framework
grep -r "OSCAL\|SOC-CMM" .
```

## Key Reference Documents

### Priority Reading (Cross-Cutting)
| Document | Topic |
|----------|-------|
| `02-protect/0302` | AI/ML security tools (Promptfoo, MITRE ATLAS) |
| `02-protect/0310` | Container runtime (Falco, Tetragon, Trivy) |
| `03-detect/0307` | Detection engineering (Sigma, Hayabusa) |
| `04-respond/0308` | DFIR platforms (Velociraptor, DFIR-IRIS) |
| `06-implement/0312` | Secure SDLC (OWASP SAMM, Flagger) |
| `09-automation/0303` | Agent orchestration (LangGraph, CrewAI) |
| `10-compliance/0314` | Compliance automation (OSCAL, SOC-CMM) |

## Results & Benefits

### Coverage Metrics
```
Total Documents: 3,163
├── Security Operations: ~1,200 docs
├── Implementation/Platform: ~500 docs
├── Supporting Domains: ~1,400 docs
└── Cross-References: 5,000+ internal links
```

### Use Cases
1. **Security Architecture:** Quick reference for tool selection
2. **Incident Response:** Runbook and procedure lookup
3. **Compliance:** Control mapping and evidence guidance
4. **AI Agents:** Claude Code knowledge grounding
5. **Training:** Onboarding material for security teams

## Maintenance

### Update Cadence
- **Weekly:** New tool summaries from GitHub trending
- **Monthly:** Framework updates (NIST, CIS, OWASP)
- **Quarterly:** Comprehensive review and gap analysis

### Quality Gates
- Source traceability (GitHub refs)
- Cross-reference validation
- NIST CSF mapping verification
- Broken link detection
