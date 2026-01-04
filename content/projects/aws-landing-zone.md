---
title: "AWS Multi-Account Landing Zone"
date: 2023-12-15
description: "Enterprise-grade AWS foundation with Control Tower, multi-account architecture, and comprehensive security controls"
technologies: ["AWS Control Tower", "Transit Gateway", "Terraform", "Terragrunt", "EKS", "ArgoCD"]
categories: ["Cloud Architecture", "Security", "Infrastructure"]
tags: ["AWS", "Landing Zone", "Multi-Account", "Security", "Governance", "Fintech"]
client: "Payler.com"
duration: "6 months"
team_size: "3"
metrics:
  - "15+ AWS accounts architected"
  - "1000+ resources managed via IaC"
  - "99.95% infrastructure uptime"
  - "45% cost reduction ($180K → $99K/month)"
---

# AWS Multi-Account Landing Zone

## Challenge

Design and implement a secure, scalable, and compliant AWS foundation for a fintech payment processing platform from scratch, supporting:
- **PCI DSS Compliance:** Prepare for Level 1 certification
- **High Availability:** 99.95% SLA for payment processing
- **Multi-Region DR:** Active-passive disaster recovery across EU regions
- **Security First:** Zero-trust principles and defense in depth
- **Cost Efficiency:** Optimize for FinOps best practices
- **Scalability:** Support 1M+ daily transactions

## Architecture Overview

### Multi-Account Strategy

```yaml
Organization Structure (15+ Accounts):

Management OU:
  - management: Root account, Control Tower, Organizations
  - logging: Centralized logging (CloudTrail, Config, Flow Logs)
  - security: Security Hub, GuardDuty findings aggregation
  - audit: Read-only audit access for compliance

Infrastructure OU:
  - network: Transit Gateway, shared networking
  - shared-services: DNS, Active Directory, central repositories

Workloads OU:
  Production:
    - prod-cde: PCI DSS Cardholder Data Environment
    - prod-non-cde: Non-CDE production workloads

  Non-Production:
    - staging: Pre-production testing environment
    - dev: Development environment
    - sandbox: Experimentation and POCs

Security OU:
  - security-tooling: Security tools and scanning
  - incident-response: IR automation and forensics
```

### Network Architecture

#### Hub-and-Spoke Topology
```yaml
Transit Gateway (TGW) Hub:
  Purpose: Central routing for all VPCs
  Regions:
    - Primary: eu-west-1 (Ireland)
    - DR: eu-west-2 (London)

  Routing:
    - Centralized egress via NAT Gateways
    - Inter-VPC communication controls
    - On-premise connectivity (future VPN/Direct Connect)
    - Route table segmentation for CDE isolation

VPC Design per Account:
  Subnets:
    - Public: NAT GW, ALB, bastion (jump hosts)
    - Private: Application tier, EKS nodes
    - Data: Databases, ElastiCache, MSK
    - Management: Systems Manager endpoints

  CIDR Strategy:
    - Non-overlapping ranges across all accounts
    - /16 for production, /20 for non-production
    - Reserved ranges for future expansion
```

#### Security Controls
```yaml
Network Firewall:
  - Centralized in network account
  - Deep packet inspection
  - Intrusion prevention (IPS)
  - Domain filtering for egress
  - Threat intelligence integration

Multi-Layer Protection:
  1. NACLs: Subnet-level stateless filtering
  2. Security Groups: Instance-level stateful filtering
  3. WAF: Application layer protection (ALB/CloudFront)
  4. Shield Standard: DDoS protection (all accounts)
  5. VPC Flow Logs: Network traffic analysis
```

## Implementation Details

### 1. Infrastructure as Code

#### Terraform/OpenTofu Architecture
```yaml
Repository Structure:
  terraform-live/
    ├── management/
    ├── production/
    │   ├── eu-west-1/
    │   │   ├── vpc/
    │   │   ├── eks/
    │   │   ├── rds/
    │   │   └── security/
    │   └── eu-west-2/
    ├── staging/
    └── modules/
        ├── vpc/
        ├── eks/
        ├── rds-aurora/
        └── security-baseline/

Terraform Stack:
  - 1000+ AWS resources managed
  - Terragrunt for DRY configuration
  - Remote state: S3 + DynamoDB locking
  - State encryption with KMS
  - Module versioning and testing

Security Scanning:
  - Checkov: Compliance and security checks
  - tfsec: Terraform security scanning
  - Terrascan: Policy as code enforcement
  - Automated in CI/CD before apply
  - Drift detection and remediation
```

#### GitLab CI/CD Integration
```yaml
Pipeline Stages:
  1. Validate:
     - terraform validate
     - terraform fmt check
     - Module version verification

  2. Security Scan:
     - Checkov (CIS, PCI DSS policies)
     - tfsec (AWS security best practices)
     - Secret detection (gitleaks)

  3. Plan:
     - terraform plan
     - Cost estimation (Infracost)
     - Plan review and approval

  4. Apply:
     - Manual approval gate
     - terraform apply
     - Drift detection scheduling
```

### 2. AWS Control Tower Setup

```yaml
Landing Zone Features:
  Account Factory:
    - Automated account provisioning
    - Baseline security configuration
    - IAM Identity Center (SSO) integration
    - CloudTrail and Config enabled by default

  Guardrails (SCPs):
    Mandatory:
      - Deny disabling CloudTrail
      - Deny modifying Config rules
      - Deny root user access keys
      - Enforce MFA for root user

    Strongly Recommended:
      - Deny leaving organization
      - Deny disabling EBS encryption
      - Deny public S3 buckets
      - Enforce encrypted volumes

    Custom (PCI DSS):
      - Deny non-approved regions
      - Enforce KMS encryption
      - Restrict instance types
      - Deny IMDSv1 (require IMDSv2)

Account Baseline:
  - VPC with private subnets
  - NAT Gateway for outbound
  - VPC endpoints for AWS services
  - CloudWatch log groups
  - SNS topics for alerts
  - Systems Manager access
```

### 3. Kubernetes (EKS) Platform

#### Cluster Architecture
```yaml
Production EKS Clusters:
  Primary (eu-west-1):
    - 3 Availability Zones
    - Managed node groups (on-demand)
    - Spot instances for batch jobs
    - Fargate for serverless workloads

  DR (eu-west-2):
    - Pilot-light configuration
    - Minimal capacity (cost-optimized)
    - Automated scale-up on failover

Node Configuration:
  - Instance types: m5.xlarge, r5.xlarge
  - Auto Scaling: Cluster Autoscaler
  - OS: Amazon Linux 2
  - Container runtime: containerd
  - IRSA for pod-level IAM permissions

Control Plane:
  - Control plane logging to CloudWatch
  - Private endpoint (VPC-only access)
  - Kubernetes version: 1.27+
  - Encryption: KMS for secrets
```

#### GitOps with ArgoCD
```yaml
Deployment Strategy:
  - ArgoCD deployed in EKS
  - Git as single source of truth
  - 80+ microservices managed
  - Application-per-repo pattern
  - Automated sync (with approval for prod)

Progressive Delivery (Argo Rollouts):
  Strategies:
    - Blue-Green deployments
    - Canary releases (10% → 50% → 100%)
    - Automated rollback on metrics

  Analysis:
    - Prometheus metrics integration
    - Success rate, latency, error rate
    - Automated promotion or rollback
```

### 4. Observability Stack

#### Prometheus & Grafana
```yaml
Prometheus Architecture:
  - Thanos for long-term storage (S3)
  - Multi-cluster monitoring
  - 7-day local retention
  - 1-year Thanos retention
  - AlertManager for notifications

Grafana Dashboards:
  Infrastructure:
    - EKS cluster health
    - Node and pod metrics
    - Network performance
    - Storage utilization

  Application:
    - Service-level metrics
    - Payment processing metrics
    - API response times
    - Error rates and SLIs

  Security:
    - GuardDuty findings
    - WAF blocked requests
    - Failed authentication attempts
    - Compliance posture

  Cost:
    - Per-service costs (Kubecost)
    - AWS Cost Explorer integration
    - Budget vs actual tracking
```

#### Logging (ELK + Loki)
```yaml
OpenSearch (ELK):
  - Centralized log aggregation
  - 30-day retention in hot tier
  - 1-year retention in S3 (cold tier)
  - Vector for log collection
  - Kibana for visualization

Loki + Promtail:
  - Kubernetes-native logging
  - Label-based log queries
  - Grafana integration
  - Lower storage costs vs ELK
  - Real-time log streaming

Log Sources:
  - Application logs (stdout/stderr)
  - AWS CloudTrail (API calls)
  - VPC Flow Logs (network traffic)
  - EKS control plane logs
  - Load balancer access logs
  - WAF logs
```

### 5. Security Architecture

#### IAM Identity Center (AWS SSO)
```yaml
Configuration:
  - Centralized user management
  - Azure AD integration (SAML)
  - MFA enforcement
  - Permission sets per role:
    * Admin: Full access (break-glass only)
    * DevOps: Infrastructure management
    * Developer: Application deployment
    * ReadOnly: Audit and compliance
    * Security: Security tools access

  Access Patterns:
    - Time-limited sessions (8 hours)
    - JIT access for production
    - Approval workflow for sensitive accounts
    - Audit logging of all access
```

#### Secrets Management
```yaml
HashiCorp Vault:
  Deployment:
    - HA cluster on EKS
    - Auto-unseal with AWS KMS
    - Consul storage backend
    - Cross-region replication

  Use Cases:
    - Database credentials (dynamic)
    - API keys and tokens
    - TLS certificates (PKI engine)
    - Encryption as a service

  Authentication:
    - Kubernetes auth for pods
    - AWS IAM for services
    - OIDC for users

AWS Secrets Manager:
  - RDS password rotation
  - Cross-account secret sharing
  - Lambda rotation functions
  - Backup to Vault for redundancy
```

### 6. Database Platform

```yaml
Amazon Aurora PostgreSQL:
  Configuration:
    - Multi-AZ deployment
    - Read replicas (3x)
    - Cross-region read replica (DR)
    - Performance Insights enabled

  Security:
    - Encryption at rest (KMS)
    - Encryption in transit (TLS 1.3)
    - IAM database authentication
    - Private subnet deployment
    - Security group restrictions

  Backup:
    - Automated daily snapshots
    - 35-day retention
    - Cross-region snapshot copy
    - Point-in-time recovery (PITR)

MongoDB Atlas:
  - Managed service (AWS VPC peering)
  - Replica set configuration
  - Automated backups
  - Performance monitoring

ElastiCache Redis:
  - Cluster mode enabled
  - Multi-AZ automatic failover
  - Encryption in-transit and at-rest
  - Session storage and caching
```

### 7. Disaster Recovery

```yaml
Multi-Region Strategy:
  Primary: eu-west-1 (Ireland)
  DR: eu-west-2 (London)

  Approach: Pilot Light
    - Network infrastructure pre-deployed
    - EKS cluster in standby (minimal nodes)
    - Database read replica in DR region
    - S3 cross-region replication
    - Route 53 health checks and failover

Automation:
  - Lambda-based failover orchestration
  - Automated DNS cutover (Route 53)
  - EKS cluster scale-up automation
  - Database promotion scripts
  - Runbooks in Confluence

Testing:
  - Quarterly DR drills
  - Documented runbooks
  - Automated validation scripts
  - RTO: 4 hours
  - RPO: 15 minutes

Backup Strategy:
  - Velero for EKS (daily)
  - RDS automated snapshots
  - S3 versioning enabled
  - Configuration backups in Git
  - 3-2-1 backup rule adherence
```

## Results & Metrics

### Reliability & Performance
```
Uptime & Availability:
├── Infrastructure Uptime: 99.95%
├── API Availability: 99.98%
├── Payment Processing: 1M+ daily transactions
└── Database Latency: p95 80ms (optimized from 500ms)

Disaster Recovery:
├── RTO (Recovery Time Objective): 4 hours
├── RPO (Recovery Point Objective): 15 minutes
├── DR Tests: Quarterly (100% success rate)
└── Failover Time: <30 minutes (automated)
```

### Cost Optimization (FinOps)
```
Monthly Cost Reduction: 45%
├── Before: $180,000/month
└── After: $99,000/month

Optimization Strategies:
├── Reserved Instances: 30% compute savings
├── Savings Plans: Additional 15% savings
├── Spot Instances: 50-70% savings for batch jobs
├── Rightsizing: Reduced over-provisioned instances
├── S3 Lifecycle: Automated tiering to Glacier
└── EBS Optimization: gp3 vs gp2, volume cleanup
```

### Security Posture
- **GuardDuty Findings:** <5 medium+ findings/month
- **Security Hub Score:** 95+ compliance score
- **Config Compliance:** 98% compliant resources
- **IAM Access Analyzer:** Zero external exposure findings
- **Vulnerability Management:** <24h MTTR for critical CVEs

### Automation & Efficiency
- **Infrastructure Provisioning:** 90% automated
- **Deployment Frequency:** 10+ deployments/day
- **Deployment Time:** Reduced from 4 hours to 15 minutes
- **MTTR (Mean Time To Recovery):** <30 minutes
- **Change Failure Rate:** <5%

## Technologies Used

### AWS Services
- **Governance:** Organizations, Control Tower, SSO (Identity Center)
- **Networking:** VPC, Transit Gateway, Route 53, Network Firewall
- **Compute:** EKS, EC2, Fargate, Lambda
- **Storage:** S3, EBS, EFS
- **Database:** Aurora PostgreSQL, ElastiCache Redis, DynamoDB
- **Security:** KMS, Secrets Manager, GuardDuty, Security Hub, Config, WAF, Shield
- **Monitoring:** CloudWatch, CloudTrail, VPC Flow Logs

### Infrastructure as Code
- **Terraform/OpenTofu:** Infrastructure provisioning
- **Terragrunt:** DRY configuration management
- **Ansible AWX:** Configuration management, OS hardening

### Kubernetes Ecosystem
- **EKS:** Managed Kubernetes
- **ArgoCD:** GitOps continuous delivery
- **Argo Rollouts:** Progressive delivery
- **Istio:** Service mesh
- **Helm:** Package management

### Observability
- **Prometheus/Thanos:** Metrics and monitoring
- **Grafana:** Visualization and dashboards
- **OpenSearch (ELK):** Log aggregation and analysis
- **Loki:** Kubernetes-native logging
- **Jaeger:** Distributed tracing

### Security
- **HashiCorp Vault:** Secrets management
- **Checkov:** IaC compliance scanning
- **tfsec:** Terraform security scanning
- **Wazuh:** SIEM (added in 2024)

## Key Learnings

### Architectural Decisions
1. **Multi-Account Strategy:** Critical for security, compliance, and blast radius reduction
2. **Transit Gateway:** Simplified network architecture vs VPC peering
3. **GitOps:** ArgoCD provided excellent deployment visibility and rollback capability
4. **Terraform Modules:** Reusable modules accelerated account provisioning

### Best Practices Established
- Infrastructure as Code for all resources (100%)
- Security scanning in CI/CD before deployment
- Automated compliance monitoring (AWS Config)
- Cost allocation tags on all resources
- Documentation as code (README in every Terraform module)

### Challenges Overcome
- **Service Quotas:** Proactive quota increases for production
- **Cross-Account Networking:** TGW routing and DNS resolution
- **EKS Upgrades:** Blue-green cluster strategy for zero downtime
- **Cost Control:** Implemented budget alerts and cost anomaly detection

### Future Enhancements
- AWS Network Firewall for advanced threat protection ✅ (Completed)
- Service mesh (Istio) for zero-trust networking ✅ (Completed)
- Automated security remediation (Security Hub + Lambda)
- FinOps automation with cost recommendations
- Infrastructure drift detection and auto-remediation
