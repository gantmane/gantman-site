---
title: "Security Journey"
date: 2025-03-21
description: "My progression from System Administrator to CISO-level Security Architect"
---

# My Security Journey

A 15+ year evolution from infrastructure management to strategic security architecture, spanning bare-metal data centers, multi-cloud environments, and enterprise-grade payment processing platforms.

## Timeline

### 2025 - Present: DevSecOps + CISO Cybersecurity Architect
**Payler.com** - *Strategic Security Leadership & Governance*

```yaml
Security Strategy & Governance:
  - Developed NIST CSF and CIS Controls framework
  - Established Security Metrics & Reporting Program for C-suite
  - Chaired Cloud Security Governance Board
  - Implemented Third-Party Risk Management (TPRM) program

Advanced Threat Management:
  - Architected dual-SIEM strategy (Wazuh + Security Onion)
  - Established Purple Team exercise program
  - Integrated threat intelligence feeds (STIX/TAXII)
  - Evolved SOC capability with advanced analytics

Zero Trust Architecture:
  - Implemented micro-segmentation with network visibility
  - Designed Data Loss Prevention (DLP) strategy with AWS Macie
  - Enhanced multi-account SCPs with granular restrictions
  - Achieved 90% automated remediation for misconfigurations

Compliance & Risk:
  - Primary security advisor for PCI DSS Level 1 audits
  - Expanded compliance to SOC 2 Type II and ISO 27001
  - Instituted formal Risk Acceptance process
  - Directed continuous compliance monitoring
```

### 2024 - 2025: DevSecOps Cloud Security Architect
**Payler.com** - *PCI DSS 4.0 Compliance Implementation*

```yaml
PCI DSS Requirements Implementation:
  - Req 1&2: Network segmentation + CIS-hardened AMIs
  - Req 3&4: KMS CMK encryption + TLS 1.3 + Tokenization (60% scope reduction)
  - Req 5&6: Wazuh EDR + GuardDuty + Secure SDLC
  - Req 7&8: IAM least privilege + MFA + JIT access
  - Req 9&10: CloudTrail + VPC Flow + centralized logging
  - Req 11&12: ASV scans + pentests + IDS/IPS

Wazuh SIEM Deployment:
  - HA cluster across 200+ EKS/EC2 nodes
  - 500+ custom security rules for payment threats
  - File Integrity Monitoring on 10,000+ critical files
  - PCI DSS dashboard with 150+ automated checks
  - Active response: IP blocking, container quarantine
  - 24/7 SOC integration with PagerDuty

Kubernetes (EKS) Security:
  - Pod Security Standards enforcement
  - OPA Gatekeeper policies
  - Istio service mesh for mTLS
  - ECR with Trivy/Clair scanning + Cosign signing
  - Runtime security with Falco

CI/CD Security Pipeline:
  - SAST, DAST, SCA, secret detection
  - Automated security gates in GitLab CI/CD
  - Centralized security dashboard
```

### 2023: DevOps Cloud Architect
**Payler.com** - *AWS Foundation & Infrastructure Design*

```yaml
AWS Organization & Multi-Account:
  - Architected 15+ account structure using Control Tower
  - Hub-and-spoke network topology with Transit Gateway
  - Multi-region DR (eu-west-1/2) with 99.95% SLA
  - Centralized logging, security findings, governance

Kubernetes (EKS) Operations:
  - Deployed production EKS clusters across AZs
  - Implemented GitOps with ArgoCD for 80+ microservices
  - Blue-green/canary deployments with Argo Rollouts
  - Managed node groups, Fargate, IRSA

Infrastructure as Code:
  - Managed 1000+ AWS resources with Terraform/OpenTofu
  - Integrated Checkov, tfsec, Terrascan for IaC security
  - Ansible AWX for configuration management
  - 200+ CIS-based OS hardening tasks

Cost Optimization & FinOps:
  - 45% AWS cost reduction ($180K → $99K monthly)
  - Rightsizing, Reserved Instances, Savings Plans
  - Kubernetes optimization with autoscalers + Kubecost

Observability & SRE:
  - Prometheus/Thanos/Grafana stack
  - OpenSearch/Vector/Kibana (ELK) + Loki
  - Distributed tracing with Jaeger + OpenTelemetry
  - SLI/SLO definitions, error budgets, blameless postmortems

Database & Secrets Management:
  - Aurora PostgreSQL, MongoDB Atlas, Redis, Kafka
  - HashiCorp Vault on EKS for dynamic secrets
  - KeyCloak for centralized IAM (SAML/OIDC)
```

### 2021 - 2023: Senior DevOps Engineer / SRE
**VebTech.by** - *Multi-Cloud Fintech Infrastructure*

```yaml
Multi-Cloud Infrastructure:
  - On-Premise: 50 servers, VMware, Ceph 200TB in colocation
  - Hetzner Cloud: Dedicated servers with Ansible automation
  - Google Cloud: GCP infrastructure for crypto exchange (GKE, Cloud SQL)

Kubernetes & Container Orchestration:
  - Managed GKE, K3s (bare metal), Rancher
  - Nexus container registry with vulnerability scanning
  - 100+ Helm charts for application deployment

CI/CD & Development:
  - Jenkins on K8s, self-managed GitLab
  - Comprehensive CI/CD pipelines
  - Trivy vulnerability scanning + SonarQube

Storage & Observability:
  - Storage: Ceph, Linstor, PortWorx, MinIO, NFS
  - Monitoring: Zabbix, ELK, Prometheus/Grafana, Jaeger

Cryptocurrency & Payment:
  - Crypto trading infrastructure (hot/cold wallets, blockchain nodes)
  - Handled 10K orders/sec with high availability
  - Payment gateway with PCI DSS controls
  - WebRTC video platform for 1000+ concurrent users

Security:
  - OPNsense firewall/IDS
  - Network security architecture
```

### 2014 - 2021: BIM Coordinator
**Gazprom** - *Infrastructure & Automation*

```yaml
Project: 260,000 m² multifunctional complex

Responsibilities:
  - Managed BIM server infrastructure (Autodesk Revit Server)
  - Supported 50+ concurrent users
  - Developed automation scripts (Dynamo, Python)
  - Reduced manual design work by 80%
  - Contributed to data center infrastructure design
  - Coordinated 20+ design disciplines

Skills Developed:
  - Large-scale infrastructure management
  - Automation and scripting
  - Cross-team coordination
  - Technical documentation
```

### 2011 - 2014: Software Engineer
**Freelance** - *Full-Stack Development*

```yaml
Projects:
  - E-commerce platforms
  - Travel and real estate portals
  - Accounting systems

Technologies:
  - PHP, MySQL, JavaScript
  - Desktop application development
  - Database design and optimization

Skills Developed:
  - Full software development lifecycle
  - Client requirements analysis
  - Database architecture
```

### 2008 - 2012: Lead System Administrator
**Freelance** - *IT Infrastructure Management*

```yaml
Infrastructure Management:
  - Managed IT for multiple offices
  - Deployed server infrastructure (Active Directory, VMware)
  - Network infrastructure design and implementation
  - VoIP systems deployment
  - Operated hosting service for 200+ customers

Services Provided:
  - Shared hosting (Apache, MySQL, PHP)
  - Email hosting (Postfix, Dovecot)
  - DNS management
  - Backup and disaster recovery
  - 24/7 customer support

Skills Developed:
  - Enterprise infrastructure design
  - Virtualization (VMware ESXi)
  - Network security (firewalls, VPNs)
  - Service reliability and uptime
  - Customer service and support
```

### 2001 - 2008: Junior System Administrator
**Freelance** - *Foundational IT Skills*

```yaml
Responsibilities:
  - Desktop and hardware support
  - Windows and Linux administration
  - Network troubleshooting
  - Basic scripting and automation

Learning Journey:
  - Self-directed learning in Linux
  - Networking fundamentals (TCP/IP, routing, switching)
  - Shell scripting and automation
  - Database basics (MySQL, PostgreSQL)

Foundation Built:
  - Strong troubleshooting methodology
  - Systems thinking approach
  - Continuous learning mindset
  - Customer service skills
```

## Key Milestones & Achievements

### Security & Compliance
- **2024:** Achieved PCI DSS Level 1 compliance with zero audit findings
- **2024-2025:** Reduced security incidents by 85% via comprehensive SIEM deployment
- **2025:** Expanded compliance to SOC 2 Type II and ISO 27001
- **15+ years:** Zero security breach track record

### Infrastructure & Reliability
- **2023:** Designed infrastructure with 99.95% uptime for payment processing
- **2023:** Implemented multi-region DR with 4-hour RTO
- **2021-2023:** Built cryptocurrency exchange handling 10K orders/sec
- **2023:** Scaled platform to support 1M+ daily transactions

### Efficiency & Cost Optimization
- **2023:** Automated 90% of infrastructure provisioning
- **2023:** Reduced deployment time from 4 hours to 15 minutes
- **2023:** Reduced AWS costs by 45% ($180K → $99K monthly)
- **2023:** Optimized database p95 latency from 500ms to 80ms

### Career Progression
- **2001-2008:** Junior System Administrator → learned fundamentals
- **2008-2012:** Lead System Administrator → managed enterprise infrastructure
- **2011-2014:** Software Engineer → developed full-stack applications
- **2014-2021:** BIM Coordinator → infrastructure automation at scale
- **2021-2023:** Senior DevOps/SRE → multi-cloud expertise
- **2023:** DevOps Cloud Architect → AWS foundation design
- **2024-2025:** DevSecOps Cloud Security Architect → PCI DSS implementation
- **2025-Present:** DevSecOps + CISO → strategic security leadership

## Philosophy & Approach

**Security-First Mindset:**
Security is not a feature to be added later—it's a foundational principle that must be embedded from day one.

**Automation & Scale:**
Manual processes don't scale. Every repeated task is an opportunity for automation and improvement.

**Continuous Learning:**
Technology evolves rapidly. Staying current requires dedicated learning and experimentation.

**Business Alignment:**
Security and infrastructure decisions must align with business objectives and enable growth, not hinder it.

**Zero Trust:**
Trust nothing, verify everything. Assume breach and design accordingly.
