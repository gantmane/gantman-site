---
title: "AWS PCI-DSS Platform — Multi-Tenant Compliance SaaS"
date: 2026-01-21
description: "Enterprise security compliance platform with 34+ API endpoints, multi-tenant RLS, and real-time WebSocket alerts for PCI-DSS, NIST CSF, ISO 27001, SOC 2"
technologies: ["FastAPI", "PostgreSQL", "SQLAlchemy", "JWT", "WebSocket", "Pydantic", "RBAC"]
categories: ["Product", "Security", "SaaS"]
tags: ["PCI-DSS", "NIST CSF", "Compliance", "Multi-tenant", "GRC", "Vulnerability Management"]
client: "Enterprise"
duration: "3 months"
team_size: "1"
metrics:
  - "34+ API endpoints"
  - "15+ security models"
  - "4 compliance frameworks"
  - "Row-Level Security"
---

# AWS PCI-DSS Platform — Multi-Tenant Compliance SaaS

## Challenge
Enterprise security teams need a unified platform to manage compliance assessments, track vulnerabilities, handle incidents, and maintain asset inventories — all with proper multi-tenant isolation for managed service providers. Off-the-shelf GRC tools are expensive, inflexible, and don't integrate well with cloud-native infrastructure.

Build a production-ready compliance platform with:
- Multi-tenant architecture with Row-Level Security
- Real-time alerts via WebSocket
- Comprehensive REST API for automation
- Multiple compliance framework support

## Solution Architecture

### Overview
```
┌─────────────────────────────────────────────────────────────────┐
│                      Frontend (React)                            │
│           Dashboard · Assessments · Incidents · Assets          │
└────────────────────────┬────────────────────────────────────────┘
                         │ HTTPS / WSS
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FastAPI Backend                               │
│     34+ Endpoints · JWT Auth · RBAC · Multi-tenant Middleware   │
└────────────────────────┬────────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         ▼               ▼               ▼
┌────────────────┐ ┌──────────┐ ┌─────────────────┐
│  PostgreSQL    │ │ WebSocket│ │  Audit Logging  │
│  + RLS Policies│ │  Manager │ │  (Immutable)    │
└────────────────┘ └──────────┘ └─────────────────┘
```

### API Endpoints (34+)

| Domain | Count | Key Operations |
|--------|-------|----------------|
| **Authentication** | 6 | Login, register, refresh, password change, MFA |
| **Compliance** | 7 | Framework list, assessments, reports, gap analysis |
| **Threats** | 4 | Catalog, risk matrix, statistics, trends |
| **Vulnerabilities** | 6 | List, scan, remediate, severity trends |
| **Assets** | 5 | Inventory, topology, tagging, relationships |
| **Incidents** | 5 | Lifecycle, actions, timeline, metrics |
| **WebSocket** | 1 | Real-time security alerts |

### Compliance Frameworks

| Framework | Controls | Use Case |
|-----------|----------|----------|
| **PCI-DSS 4.0** | 270+ | Payment card processing |
| **NIST CSF 2.0** | 6 functions | General cybersecurity |
| **ISO 27001:2022** | 93 controls | Information security |
| **SOC 2 Type II** | 5 trust criteria | Service organization |

## Key Features

### 1. Multi-Tenant Architecture
```python
# Row-Level Security enforced at database level
class TenantMiddleware:
    async def __call__(self, request, call_next):
        tenant_id = extract_tenant(request)
        # All queries automatically filtered by tenant
        set_tenant_context(tenant_id)
        return await call_next(request)
```
- Automatic tenant isolation on every query
- No cross-tenant data leakage possible
- Efficient index usage with RLS policies

### 2. Real-Time Alerts
```javascript
// WebSocket connection for live security events
const ws = new WebSocket('wss://api.example.com/ws/alerts');
ws.onmessage = (event) => {
    const alert = JSON.parse(event.data);
    // Severity: critical, high, medium, low
    if (alert.severity === 'critical') {
        showNotification(alert);
    }
};
```

### 3. Compliance Assessment Workflow
```
Assessment Lifecycle:
├── Draft → Configure scope, select controls
├── In Progress → Evidence collection, control testing
├── Review → Findings validation, risk rating
├── Complete → Report generation, remediation tracking
└── Archived → Historical reference
```

### 4. Vulnerability Management
```python
# Comprehensive vulnerability tracking
class Vulnerability(Base):
    cve_id: str              # CVE-2024-XXXXX
    severity: SeverityEnum   # CRITICAL, HIGH, MEDIUM, LOW
    cvss_score: float        # 0.0 - 10.0
    affected_assets: List[Asset]
    remediation_status: RemediationStatus
    due_date: datetime
    sla_breach: bool         # Computed from severity + age
```

## Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **API Framework** | FastAPI 0.109 | Async REST API |
| **ORM** | SQLAlchemy (async) | Database abstraction |
| **Validation** | Pydantic | Request/response schemas |
| **Auth** | JWT + RBAC | Authentication & authorization |
| **Database** | PostgreSQL | Primary data store + RLS |
| **Real-time** | WebSocket | Live alert streaming |
| **Testing** | pytest + coverage | Quality assurance |

## Security Features

### OWASP Top 10 Protections

| Threat | Mitigation |
|--------|------------|
| Injection | Parameterized queries via SQLAlchemy |
| Broken Auth | JWT with short TTL, refresh tokens |
| Sensitive Data | AES-256 encryption at rest |
| XXE | JSON-only APIs, no XML parsing |
| Broken Access | RLS + RBAC enforcement |
| Security Misconfig | Security headers middleware |
| XSS | Output encoding, CSP headers |
| Insecure Deserialization | Pydantic schema validation |
| Vulnerable Components | Dependabot, SBOM tracking |
| Insufficient Logging | Comprehensive audit trail |

### Audit Logging
```python
# Every state-changing operation logged
@audit_log
async def create_finding(finding: FindingCreate):
    # Automatically captures:
    # - User ID, tenant ID
    # - Timestamp, IP address
    # - Before/after state
    # - Operation type
    return await finding_service.create(finding)
```

## Project Structure

```
src/api/
├── main.py                # FastAPI app factory
├── config.py              # Environment config
├── middleware/            # Auth, tenant, security
├── routers/               # 34+ endpoint handlers
│   ├── auth.py
│   ├── compliance.py
│   ├── threats.py
│   ├── vulnerabilities.py
│   ├── assets.py
│   └── incidents.py
├── models/                # 15+ SQLAlchemy models
├── services/              # Business logic layer
├── schemas/               # Pydantic validation
└── websocket/             # Real-time alerts
```

## Results & Benefits

### Technical Achievements
- **Zero SQL injection risk**: ORM-only queries with parameterization
- **Complete tenant isolation**: RLS policies at database level
- **Sub-100ms API latency**: Async throughout, optimized queries
- **100% type coverage**: Pydantic schemas + Python type hints

### Business Value
1. **MSP-Ready**: Multi-tenant architecture for managed services
2. **Automation-First**: Every operation accessible via API
3. **Compliance-Mapped**: Built-in framework alignment
4. **Audit-Ready**: Immutable logging for regulators
