---
title: "Enterprise SIEM Implementation with Wazuh"
date: 2024-09-15
description: "Comprehensive security monitoring and PCI DSS compliance through Wazuh SIEM deployment"
technologies: ["Wazuh", "OpenSearch", "AWS", "Kubernetes", "Python", "CloudTrail", "GuardDuty"]
categories: ["Security", "Compliance", "Monitoring"]
tags: ["SIEM", "Wazuh", "PCI DSS", "Threat Detection", "SOC", "Incident Response"]
client: "Payler.com"
duration: "4 months"
team_size: "2"
metrics:
  - "200+ agents deployed"
  - "500+ custom security rules"
  - "85% reduction in security incidents"
  - "10,000+ files under FIM"
  - "150+ automated PCI DSS checks"
---

# Enterprise SIEM Implementation with Wazuh

## Challenge

Implement a comprehensive Security Information and Event Management (SIEM) solution for a fintech payment processing platform to:
- **Achieve PCI DSS Compliance:** Meet Requirements 10 (logging) and 11 (monitoring)
- **Threat Detection:** Identify security incidents in real-time across 200+ nodes
- **Compliance Automation:** Automate evidence collection for audits
- **Incident Response:** Enable rapid investigation and response to security events
- **Visibility:** Centralize security monitoring across AWS and Kubernetes

## Architecture Overview

### High-Level Design

```yaml
Wazuh Architecture:

Management Layer:
  Wazuh Manager Cluster (HA):
    - 3 manager nodes (active-active)
    - Load balancing for agent connections
    - Shared configuration via cluster sync
    - Deployed on AWS EC2 (m5.xlarge)

Data Storage Layer:
  OpenSearch Cluster:
    - 5 data nodes (m5.2xlarge)
    - 2 master nodes (m5.xlarge)
    - S3 for snapshot backups
    - 90-day hot retention
    - 1-year cold storage (S3 Glacier)

Agent Layer:
  200+ Wazuh Agents:
    - EKS worker nodes (100+)
    - EC2 instances (80+)
    - RDS/Aurora monitoring (indirect via CloudWatch)
    - Container-based agents (DaemonSet)

Integration Layer:
  AWS Services:
    - CloudTrail → S3 → Wazuh ingestion
    - VPC Flow Logs → S3 → Wazuh processing
    - GuardDuty → EventBridge → Wazuh
    - Security Hub → aggregation
    - Config → compliance data
    - ALB/WAF logs → S3 → analysis
```

## Implementation Details

### 1. Wazuh Infrastructure Deployment

#### Manager Cluster (High Availability)
```yaml
Deployment:
  Platform: AWS EC2 (Auto Scaling Group)
  Instance Type: m5.xlarge (4 vCPU, 16 GB RAM)
  Count: 3 nodes (active-active cluster)
  OS: Ubuntu 22.04 LTS (CIS hardened)

Configuration:
  Cluster Communication:
    - Wazuh cluster protocol (port 1516)
    - Shared configuration synchronization
    - Automatic failover
    - Load balanced agent connections

  Agent Communication:
    - Port 1514: Agent data ingestion
    - Port 1515: Agent enrollment
    - TLS encryption enforced
    - Certificate-based authentication

  API:
    - RESTful API (port 55000)
    - JWT token authentication
    - Integration with automation tools
    - Rate limiting enabled

Storage:
  - 500 GB EBS gp3 for local buffer
  - S3 for long-term archive
  - Daily snapshots to S3
```

#### OpenSearch Cluster
```yaml
Cluster Design:
  Data Nodes:
    - Count: 5 nodes
    - Instance: m5.2xlarge (8 vCPU, 32 GB RAM)
    - Storage: 2 TB EBS gp3 per node
    - Purpose: Index and search operations

  Master Nodes:
    - Count: 2 nodes (quorum)
    - Instance: m5.xlarge (4 vCPU, 16 GB RAM)
    - Purpose: Cluster state management

Index Management:
  Hot Tier (0-30 days):
    - SSD storage (gp3)
    - High IOPS for real-time queries
    - Daily index rotation
    - Replica count: 1

  Warm Tier (31-90 days):
    - SSD storage (gp3)
    - Reduced replica count
    - Force merge for optimization

  Cold Tier (91-365 days):
    - S3 storage via snapshots
    - Searchable snapshots
    - Minimal compute cost

Security:
  - TLS 1.3 for all connections
  - OpenSearch Security plugin
  - Role-based access control (RBAC)
  - Audit logging enabled
  - VPC private subnet deployment
  - Security group restrictions
```

### 2. Agent Deployment Strategy

#### Kubernetes (EKS) Agents
```yaml
Deployment Method: DaemonSet
  Purpose: One agent per node
  Resource Limits:
    CPU: 200m request, 500m limit
    Memory: 256Mi request, 512Mi limit

Container Configuration:
  Image: wazuh/wazuh-agent:4.8.0
  Security Context:
    - Privileged: true (for host monitoring)
    - hostPID: true
    - hostNetwork: true

  Volumes:
    - /var/log → container logs
    - /var/ossec → agent data
    - /etc/os-release → OS detection
    - /var/run/docker.sock → container monitoring

Monitoring Capabilities:
  - Container lifecycle events
  - Kubernetes audit logs
  - Pod security violations
  - Node system logs
  - File integrity monitoring
  - Rootkit detection
```

#### EC2 Agents
```yaml
Installation:
  Method: Ansible playbook automation
  OS Support:
    - Amazon Linux 2 / 2023
    - Ubuntu 20.04 / 22.04
    - CentOS 7 / 8

  Enrollment:
    - Automated via API
    - Certificate-based authentication
    - Group assignment by tags

Configuration Profile by Role:
  Web Servers:
    - Apache/Nginx log monitoring
    - Web attack detection
    - SSL/TLS monitoring

  Database Servers:
    - PostgreSQL audit logs
    - Failed authentication attempts
    - Privilege escalation detection

  Application Servers:
    - Application log parsing
    - API abuse detection
    - Performance metrics
```

### 3. Security Detection & Rules

#### Custom Rule Development (500+ Rules)
```yaml
Payment-Specific Threats:
  PAN Data Access Detection:
    - Regex patterns for credit card numbers
    - Unauthorized database queries
    - File access to cardholder data
    - Network transmission of sensitive data
    - Alert severity: CRITICAL

  Transaction Anomalies:
    - Unusual transaction amounts
    - Rapid transaction frequency
    - Geographic anomalies
    - Velocity checks (same card, multiple locations)
    - ML-based anomaly detection

Authentication & Access:
  Brute Force Detection:
    - Failed SSH attempts (5+ in 1 min)
    - Failed API authentication (10+ in 5 min)
    - Account lockout monitoring
    - Distributed brute force detection

  Privilege Escalation:
    - Sudo usage monitoring
    - IAM permission changes
    - Role assumption tracking
    - Unauthorized service account usage

Web Attacks:
  OWASP Top 10 Detection:
    - SQL injection attempts
    - Cross-Site Scripting (XSS)
    - Command injection
    - Path traversal
    - Insecure deserialization
    - XML External Entities (XXE)

  API Abuse:
    - Rate limiting violations
    - Invalid API token usage
    - Unusual API endpoints
    - Parameter tampering

Data Exfiltration:
  Indicators:
    - Large data transfers (>100MB)
    - Unusual outbound connections
    - Database dumps
    - SSH/SCP file transfers
    - S3 bucket data access anomalies
```

#### Integration Rules
```yaml
AWS CloudTrail:
  High-Risk Events:
    - IAM policy changes
    - Security group modifications
    - S3 bucket policy changes
    - Root account usage
    - KMS key deletion attempts
    - CloudTrail logging disabled

  Compliance Events:
    - Encryption disabled on resources
    - Public access enabled
    - Unencrypted snapshots
    - Cross-region resource access

GuardDuty Findings:
  - Malware detection
  - Cryptocurrency mining
  - Backdoor detection
  - Unusual API calls
  - Compromised credentials
  - Data exfiltration attempts

VPC Flow Logs:
  - Port scanning detection
  - DDoS indicators
  - Unusual traffic patterns
  - Blocked connection attempts
  - Internal lateral movement
```

### 4. File Integrity Monitoring (FIM)

```yaml
Monitored Files (10,000+):

System Files:
  Linux:
    - /etc/passwd, /etc/shadow
    - /etc/ssh/sshd_config
    - /etc/sudoers
    - /boot/grub/grub.cfg
    - Systemd service files

  Frequency: Real-time
  Actions: Alert + snapshot

Configuration Files:
  Application:
    - Nginx/Apache configs
    - Application .env files
    - Database configuration
    - SSL certificates

  Kubernetes:
    - Pod manifests
    - ConfigMaps
    - Secrets (metadata only)
    - Service definitions

  Frequency: Real-time
  Actions: Alert + backup + change review

Code Directories:
  - /var/www/html
  - /opt/applications
  - Container image layers

  Frequency: Scheduled (daily)
  Actions: Alert on unauthorized changes

Logs & Audit:
  - /var/log/*
  - Application log directories
  - Audit logs

  Frequency: Real-time
  Actions: Detect log tampering

FIM Capabilities:
  - Real-time change detection
  - File checksum (SHA256)
  - File attributes (permissions, owner)
  - Who-data (who made the change)
  - Baseline comparison
  - Automated restoration (critical files)
```

### 5. Vulnerability Management

```yaml
Vulnerability Detection:
  Methods:
    - Agent-based scanning
    - Package manager integration (apt, yum)
    - CVE database correlation
    - OVAL definitions

  Scan Frequency:
    - Critical systems: Daily
    - Production servers: Daily
    - Non-production: Weekly
    - Containers: On image push

Risk-Based Prioritization:
  Scoring:
    - CVSS base score
    - Exploitability (EPSS)
    - Asset criticality
    - Network exposure
    - Data sensitivity

  SLA by Severity:
    - Critical: 24 hours
    - High: 7 days
    - Medium: 30 days
    - Low: 90 days

Integration:
  - Jira ticket creation
  - Slack notifications
  - Email alerts to teams
  - Dashboard for management
  - Monthly vulnerability reports

Remediation Tracking:
  - Patch deployment via Ansible
  - Verification scanning
  - Exception management
  - Compliance reporting
```

### 6. Compliance Automation (PCI DSS)

```yaml
PCI DSS Dashboard (150+ Checks):

Requirement 1 & 2: Network & Configuration:
  Checks:
    - Firewall rules in place
    - Default passwords changed
    - Unnecessary services disabled
    - Configuration standards enforced

Requirement 3 & 4: Data Protection:
  Checks:
    - Encryption at rest enabled
    - TLS version compliance (1.2+)
    - Key rotation schedules
    - Sensitive data masking

Requirement 5 & 6: Malware & Development:
  Checks:
    - Anti-malware running
    - Malware signature updates
    - Secure coding practices
    - Change management process

Requirement 7 & 8: Access Control:
  Checks:
    - Least privilege enforcement
    - User access reviews
    - MFA enabled
    - Password complexity

Requirement 10: Logging & Monitoring:
  Checks:
    - Log collection enabled
    - Log retention (1 year)
    - Clock synchronization (NTP)
    - Log integrity protection
    - Audit trail completeness

Requirement 11: Security Testing:
  Checks:
    - Vulnerability scans completed
    - Penetration test schedule
    - IDS/IPS operational
    - File integrity monitoring

Automated Evidence Collection:
  - Daily compliance snapshots
  - Configuration backups
  - Change logs
  - Access reports
  - Exception documentation
  - Quarterly audit packages
```

### 7. Incident Response Integration

```yaml
Active Response:
  Automated Actions:
    IP Blocking:
      - Trigger: 5+ failed SSH attempts
      - Action: iptables block for 30 minutes
      - Scope: Source IP

    Account Lockout:
      - Trigger: 10+ failed logins
      - Action: Disable account
      - Notification: Security team + manager

    Container Quarantine:
      - Trigger: Malware detected in container
      - Action: Kill pod, taint node
      - Notification: DevOps + Security

    Process Kill:
      - Trigger: Cryptocurrency miner detected
      - Action: Kill process, block binary
      - Forensics: Memory dump

Incident Management:
  PagerDuty Integration:
    - Critical alerts → immediate page
    - High severity → notification
    - Escalation after 15 minutes
    - 24/7 SOC coverage

  Workflow:
    1. Alert triggered in Wazuh
    2. PagerDuty incident created
    3. On-call engineer notified
    4. Investigation in OpenSearch
    5. Response action (manual/automated)
    6. Incident documentation
    7. Post-incident review

Playbooks:
  - Brute force attack response
  - Malware infection containment
  - Data breach procedure
  - DDoS mitigation
  - Insider threat investigation
  - Compromised credentials
```

### 8. Monitoring & Alerting

```yaml
Alert Channels:
  Email:
    - Daily summary reports
    - Critical alerts (immediate)
    - Weekly compliance reports

  Slack:
    - Real-time alerts (high+)
    - Compliance violations
    - System health issues

  PagerDuty:
    - Critical security events
    - System outages
    - Escalation after 15 min

Custom Dashboards:
  Security Operations Center (SOC):
    - Real-time event stream
    - Alert count by severity
    - Top attacked assets
    - Geographic threat map
    - MITRE ATT&CK mapping

  Executive Dashboard:
    - Security posture score
    - Compliance status (%)
    - Incident trends
    - Vulnerability metrics
    - Cost of incidents

  Compliance Dashboard:
    - PCI DSS requirement status
    - Failed compliance checks
    - Remediation progress
    - Audit readiness score
```

## Results & Metrics

### Security Improvements
```
Threat Detection:
├── Security Incidents: 85% reduction (20/month → 3/month)
├── MTTD (Mean Time To Detect): 5 minutes average
├── MTTR (Mean Time To Respond): 30 minutes average
└── False Positive Rate: <10% (continuous tuning)

Visibility:
├── Monitored Nodes: 200+ agents
├── Events Per Day: 500K+ security events
├── Log Sources: 15+ integrated sources
└── Coverage: 100% of CDE infrastructure
```

### Compliance Achievement
```
PCI DSS Level 1 Certification:
├── Audit Result: Zero findings
├── Requirement 10: PASS (Logging & Monitoring)
├── Requirement 11: PASS (Security Testing & Monitoring)
└── Automated Evidence: 150+ compliance checks

Operational Benefits:
├── Audit Preparation: Reduced from 2 weeks to 2 days
├── Evidence Collection: 90% automated
├── Compliance Reporting: Real-time dashboard
└── Audit Cost: Reduced by 60%
```

### Operational Efficiency
- **Alert Investigation:** 70% faster with centralized SIEM
- **Incident Response:** 50% faster MTTR
- **Compliance Effort:** 90% reduction in manual checks
- **Security Team Productivity:** 3x improvement

## Technologies Used

### Core SIEM Stack
- **Wazuh:** 4.8.x (SIEM platform)
- **OpenSearch:** 2.11.x (data storage and search)
- **OpenSearch Dashboards:** Visualization and reporting

### Integration & Automation
- **AWS Services:** CloudTrail, GuardDuty, VPC Flow Logs, Config, Security Hub
- **Python:** Custom integrations and scripts
- **Ansible:** Agent deployment automation
- **PagerDuty:** Incident management
- **Slack:** Real-time notifications

### Infrastructure
- **AWS EC2:** Wazuh managers and OpenSearch nodes
- **Kubernetes:** Agent deployment via DaemonSet
- **S3:** Long-term log archive
- **EBS:** High-performance storage

## Key Learnings

### Best Practices
1. **Rule Tuning is Critical:** Started with 1000+ alerts/day, tuned to 50/day
2. **Agent Performance:** Proper resource limits prevent node impact
3. **Data Retention:** Balance compliance requirements with storage costs
4. **Integration First:** AWS service integration provides deeper visibility
5. **Automation:** Active response reduces MTTR significantly

### Challenges Overcome
- **OpenSearch Scaling:** Tuned cluster for 500K events/day ingestion
- **Agent Overhead:** Optimized configuration to <5% CPU usage
- **Alert Fatigue:** Implemented severity-based routing and aggregation
- **Custom Rules:** Iterative development with security team feedback

### Future Enhancements
- **SOAR Integration:** Security Orchestration and Automation
- **Threat Intelligence:** Integrate external threat feeds
- **User Behavior Analytics (UBA):** ML-based anomaly detection
- **MITRE ATT&CK Mapping:** Automated attack technique identification
- **Red Team Integration:** Automated detection testing
