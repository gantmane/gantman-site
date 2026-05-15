---
title: "K8s Compliance Operator — One-Day Compliance Stack"
date: 2026-05-07
description: "Helm umbrella chart deploying Kyverno, Falco, Calico, Vault, Istio with ComplianceProfile CRD for PCI DSS, SOC 2, NIST CSF, ISO 27001, HIPAA, DORA"
technologies: ["Kubernetes", "Helm", "Kyverno", "Falco", "Calico", "Vault", "Istio", "Go"]
categories: ["Product", "Compliance", "Kubernetes"]
tags: ["Kubernetes Operator", "PCI DSS", "SOC 2", "NIST CSF", "ISO 27001", "Policy Enforcement", "Runtime Security"]
client: "Enterprise"
duration: "2 weeks"
team_size: "1"
metrics:
  - "$200K Y1 revenue target"
  - "6 compliance profiles"
  - "45+ Kyverno policies"
  - "30+ Falco rules"
---

# K8s Compliance Operator — One-Day Compliance Stack

## Challenge
Kubernetes teams in regulated industries spend 8-16 weeks integrating policy enforcement (Kyverno), runtime security (Falco), network isolation (Calico), secrets management (Vault), and service mesh (Istio) to meet compliance requirements. Each tool requires separate expertise, and maintaining policy coherence across tools is error-prone.

Build a single Helm chart that deploys the entire compliance stack, driven by a `ComplianceProfile` custom resource that automatically configures all components for the selected framework.

## Solution Architecture

### Overview
```
┌─────────────────────────────────────────────────────────────────┐
│                   ComplianceProfile CRD                          │
│              spec.profile: pci-dss-4.0                          │
│              spec.enforcementMode: audit → block                │
└───────────────────────────┬─────────────────────────────────────┘
                            │ reconcile
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│                 Compliance Operator Controller                   │
│                    (Go / kubebuilder)                           │
└───────────────────────────┬─────────────────────────────────────┘
                            │ configures
         ┌──────────────────┼──────────────────┐
         ▼                  ▼                  ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│   Kyverno    │   │    Falco     │   │   Calico     │
│  45 policies │   │  30+ rules   │   │  NetworkPol  │
└──────────────┘   └──────────────┘   └──────────────┘
         │                  │                  │
         └──────────────────┼──────────────────┘
                            ▼
                 ┌──────────────────┐
                 │ Policy-Reporter  │
                 │   Dashboard      │
                 └──────────────────┘
```

### Compliance Profiles

| Profile | Framework | Kyverno Policies | Falco Rules | Default Mode |
|---------|-----------|------------------|-------------|--------------|
| `pci-dss-4.0` | PCI DSS 4.0 | 45 | 30+ | Audit |
| `soc2-type2` | SOC 2 Type II | 30 | 30+ | Audit |
| `nist-csf-2.0` | NIST CSF 2.0 | 40 | 30+ | Audit |
| `iso-27001-2022` | ISO 27001:2022 | 38 | 30+ | Audit |
| `hipaa` | HIPAA | 32 | 30+ | Audit |
| `dora` | DORA | 35 | 30+ | Audit |

## Key Features

### 1. Single-Command Install
```bash
helm install compliance-operator k8s-compliance/compliance-operator \
  --set profile=pci-dss-4.0 \
  --namespace compliance-operator \
  --create-namespace
```

### 2. ComplianceProfile CRD
```yaml
apiVersion: compliance.k8s.io/v1
kind: ComplianceProfile
metadata:
  name: production
spec:
  profile: pci-dss-4.0
  enforcementMode: audit  # → block when ready
  excludeNamespaces:
    - kube-system
    - monitoring
  policyOverrides:
    - policy: require-resource-limits
      action: disable  # exception for legacy workloads
```

### 3. Coordinated Policy Bundles
Each profile deploys coherent policies across all tools:
- **Kyverno**: Admission policies (pod security, resource limits, labels)
- **Falco**: Runtime rules (shell spawning, sensitive file access)
- **Calico**: Network policies (namespace isolation, egress control)
- **Vault**: Secret injection (no plaintext secrets in pods)
- **Istio**: mTLS enforcement (zero-trust service mesh)

### 4. Audit-Ready Dashboard
Policy-Reporter aggregates violations from all tools into a single dashboard with:
- Violation trends over time
- Per-namespace compliance scores
- Export to OSCAL Assessment Results

## Tech Stack

| Component | Version | Purpose |
|-----------|---------|---------|
| **Kyverno** | 1.12+ | Admission control, policy enforcement |
| **Falco** | 0.38+ | Runtime security monitoring |
| **Calico** | 3.27+ | Network policy enforcement |
| **Vault** | 1.16+ | Secrets management, injection |
| **Istio** | 1.21+ | Service mesh, mTLS |
| **Policy-Reporter** | 2.x | Unified compliance dashboard |

## Installation

### Prerequisites
- Kubernetes 1.28+
- Helm 3.14+
- 8GB+ cluster memory available

### Quick Start
```bash
# Add Helm repo
helm repo add k8s-compliance https://charts.k8s-compliance-operator.io
helm repo update

# Install with PCI DSS profile
helm install compliance-operator k8s-compliance/compliance-operator \
  --set profile=pci-dss-4.0 \
  --namespace compliance-operator \
  --create-namespace

# Check status
kubectl get complianceprofiles -A
```

## Results & Metrics

### Deployment Time
```
Traditional multi-tool integration:  8-16 weeks
With K8s Compliance Operator:        1 day (install + validate)
```

### Coverage
- **45+ Kyverno policies** per profile (admission control)
- **30+ Falco rules** (runtime detection)
- **Namespace-scoped NetworkPolicies** (network isolation)
- **Vault Agent injection** (no plaintext secrets)

## Architecture Decisions

- **Helm umbrella over monolith**: Each sub-chart can be upgraded independently
- **CRD-driven configuration**: GitOps-friendly, declarative compliance posture
- **Audit-first enforcement**: All profiles start in audit mode; transition to block is operator-initiated
- **Policy-Reporter aggregation**: Single pane of glass for multi-tool violations
- **SLSA Level 3 supply chain**: Signed releases, provenance attestation
