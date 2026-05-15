---
title: "Agentic AI Governance — Control Plane for AI Agents"
date: 2026-05-07
description: "Authorization, logging, and audit overlay for autonomous AI agents — EU AI Act Art. 12-14, Singapore MGF, OWASP LLM Top 10 compliant"
technologies: ["Go", "Python", "FastAPI", "Kubernetes", "PostgreSQL", "Loki", "Grafana"]
categories: ["Product", "AI/ML", "Compliance"]
tags: ["AI Governance", "EU AI Act", "Agent Security", "OWASP LLM", "Human-in-the-Loop", "Audit Trail"]
client: "Enterprise"
duration: "4-6 weeks"
team_size: "1"
metrics:
  - "$150K Y1 revenue target"
  - "EU AI Act compliant"
  - "Singapore MGF ready"
  - "OWASP LLM Top 10"
---

# Agentic AI Governance — Control Plane for AI Agents

## Challenge
Autonomous AI agents are executing tool calls — database queries, API requests, file operations — with minimal human oversight. Enterprises deploying agents face regulatory requirements (EU AI Act Art. 12-14, Singapore MGF) for human oversight, audit trails, and authorization controls. Existing agent frameworks (LangChain, AutoGPT, CrewAI) have no built-in governance layer.

Build a control-plane overlay that intercepts, authorizes, logs, and audits every tool call made by an AI agent — without modifying the agent or tool code.

## Solution Architecture

### Overview
```
┌─────────────────────────────────────────────────────────────────┐
│                      AI Agent Runtime                            │
│              LangChain · AutoGPT · CrewAI · Custom              │
└───────────────────────────┬─────────────────────────────────────┘
                            │ tool call
                            ▼
┌─────────────────────────────────────────────────────────────────┐
│              Governance Intercept Layer                          │
│         SDK Middleware (in-process) OR Sidecar Proxy            │
└───────────────────────────┬─────────────────────────────────────┘
                            │
         ┌──────────────────┼──────────────────┐
         ▼                  ▼                  ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│ Policy Engine│   │   Approval   │   │   Audit Log  │
│  AgentPolicy │   │   Service    │   │    (Loki)    │
│     CRD      │   │  Human-in-   │   │              │
│              │   │   the-loop   │   │              │
└──────────────┘   └──────────────┘   └──────────────┘
                            │
                            ▼
                 ┌──────────────────┐
                 │  OSCAL Exporter  │
                 │ Assessment Results│
                 └──────────────────┘
```

### Governance Flow

```
1. Agent requests tool call (e.g., "execute SQL query")
2. Intercept layer captures: agent_id, tool_name, parameters, context
3. Policy Engine evaluates AgentPolicy rules:
   - Is this tool allowed for this agent?
   - Does parameter match allowlist (e.g., SELECT only, no DROP)?
   - Is human approval required for this action?
4. If approval required → route to Approval Service → Slack/Teams/email
5. Log decision + outcome to Loki (hot) + S3 WORM (cold)
6. Return allow/deny to agent runtime
```

## Key Features

### 1. AgentPolicy CRD
```yaml
apiVersion: governance.ai/v1
kind: AgentPolicy
metadata:
  name: analyst-agent
spec:
  agentSelector:
    matchLabels:
      team: analytics
  rules:
    - tool: sql_query
      action: allow
      conditions:
        - "query MATCHES '^SELECT'"
        - "tables IN ['reports', 'metrics']"
    - tool: sql_query
      action: require_approval
      conditions:
        - "query MATCHES 'DELETE|DROP|TRUNCATE'"
    - tool: file_write
      action: deny
```

### 2. Human-in-the-Loop Approval
- **Slack/Teams integration** for approval routing
- **Configurable timeout** (auto-deny after N minutes)
- **Approval audit trail** with approver identity

### 3. Comprehensive Audit
```json
{
  "timestamp": "2026-05-07T14:32:01Z",
  "agent_id": "analyst-agent-01",
  "tool": "sql_query",
  "parameters": {"query": "SELECT * FROM reports"},
  "policy_evaluated": "analyst-agent",
  "decision": "allow",
  "latency_ms": 12,
  "trace_id": "abc123"
}
```

### 4. OSCAL Export
- **Assessment Results** for auditors
- **Control mapping** to EU AI Act, Singapore MGF, OWASP LLM
- **Cryptographically signed** with Sigstore cosign

## Regulatory Alignment

| Regulation | Article | Requirement | Feature |
|------------|---------|-------------|---------|
| EU AI Act | Art. 12 | Record-keeping | Immutable audit log (S3 WORM) |
| EU AI Act | Art. 13 | Transparency | Tool call visibility dashboard |
| EU AI Act | Art. 14 | Human oversight | Approval service + HITL routing |
| Singapore MGF | Principle 2 | Human agency | AgentPolicy + approval workflow |
| OWASP LLM | LLM01 | Prompt injection | Input sanitization in intercept |
| OWASP LLM | LLM06 | Sensitive info | Parameter allowlisting |
| OWASP LLM | LLM08 | Excessive agency | Tool-level deny policies |

## Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Policy Engine** | Go + kubebuilder | AgentPolicy CRD controller |
| **Approval Service** | Python + FastAPI | Human-in-the-loop routing |
| **OSCAL Exporter** | Python + FastAPI | Assessment Results generation |
| **MCP Adapter** | Python + FastAPI | MCP server-side sidecar |
| **HTTP Proxy** | Python + FastAPI | HTTP forward proxy intercept |
| **Event Store (hot)** | Loki 2.9.x | Real-time log aggregation |
| **Event Archive (cold)** | S3/MinIO WORM | 7-year immutable retention |
| **Dashboard** | Grafana 11.x | Tool call visibility |
| **Secrets** | HashiCorp Vault | Short-lived AppRole tokens |

## Integration Modes

### SDK Middleware (In-Process)
```python
from governance import GovernanceMiddleware

agent = Agent(tools=[sql_tool, file_tool])
agent = GovernanceMiddleware.wrap(agent, policy="analyst-agent")
```

### Sidecar Proxy (Out-of-Process)
```yaml
# Kubernetes pod annotation
metadata:
  annotations:
    governance.ai/inject: "true"
    governance.ai/policy: "analyst-agent"
```

## Results & Metrics

### Compliance Coverage
- **EU AI Act Art. 12, 13, 14** — full coverage
- **Singapore MGF (Jan 2026)** — ready
- **OWASP LLM Top 10 v1.1** — LLM01, LLM06, LLM08, LLM10

### Revenue Target
- **$150K Year 1** (SaaS + enterprise licenses)
- Per-agent or per-organization pricing
