---
title: "Trade — Zero-Tolerance Cryptocurrency Trading Platform"
date: 2026-05-08
description: "Production-grade crypto trading platform with independent risk breakers, FIDO2-authenticated kill-switches, and real-time audit logging"
technologies: ["Python", "Freqtrade", "Kubernetes", "Vault", "FIDO2/Yubikey", "Wazuh", "Grafana", "Helm"]
categories: ["Product", "Security", "Trading"]
tags: ["Cryptocurrency", "Risk Management", "FIDO2", "Kill Switch", "NIST CSF", "Zero Trust"]
client: "Personal"
duration: "3 months"
team_size: "1"
metrics:
  - "Zero unauthorized trades"
  - "<60s key revocation"
  - "4-tier drawdown ladder"
  - "100% audit trail coverage"
---

# Trade — Zero-Tolerance Cryptocurrency Trading Platform

## Challenge
Build a cryptocurrency trading platform where the primary design goal is **preventing catastrophic loss** — not maximizing returns. The platform must survive compromised credentials, rogue orders, and operator error with multiple independent safety layers.

## Solution Architecture

### Defense-in-Depth Design
Five independent components, each with separate credentials and failure domains:

```
┌─────────────────────────────────────────────────────────────┐
│ Bybit Exchange (Testnet / Live)                              │
└────────────────┬────────────────────────────────────────────┘
                 │ WebSocket + REST
                 ▼
      ┌──────────────────────┐
      │    Freqtrade Pod     │ ◄── API key: Orders only, no transfers
      │ Strategy execution   │
      └──────┬───────────────┘
             │
      ┌──────┴──────────────────────────────────────────────┐
      │      Shared PVC: trade.db (OLTP) + journal.db       │
      └──────────────────────────────────────────────────────┘
             ↑                      ↑
      ┌──────┴──────┐        ┌─────┴───────┐
      │Risk Breaker │        │Journal Shim │ ◄── Read-only monitoring
      │Circuit break│        │Audit sidecar│
      └─────────────┘        └─────────────┘
             │
             ▼
      Wazuh SIEM (anomaly detection) + Grafana (dashboards)
```

### Drawdown Ladder (Automatic Kill)
```
Capital Allocation: $4K per subaccount
├── -5% daily    → Alert + position review
├── -8% weekly   → Auto-reduce position size
├── -15% monthly → Scale to zero, require manual restart
└── -18% HWM     → Full kill-switch, key revocation
```

### FIDO2-Authenticated Kill Switch
Emergency response in under 60 seconds:

```bash
# Requires physical Yubikey touch
python src/kill-switch/main.py --revoke

# Actions executed:
# 1. Scale freqtrade deployment to zero
# 2. Revoke all Bybit API keys via API
# 3. Clean Vault secrets
# 4. Send alert to Telegram
# 5. Log to immutable audit trail
```

## Security Architecture

### Threat Model & Controls

| Threat | Risk | Control |
|--------|------|---------|
| Unauthorized API key access | $4K + compound losses | Vault + ESO, read-only FS, RBAC (CTRL-101..104) |
| Workstation compromise | Key exfiltration, rogue orders | Yubikey/FIDO2, dedicated profile, zero extensions |
| Rogue order placement | 100%+ drawdown | Risk-breaker daemon, maker-only, drawdown ladder |
| Root token exfiltration | Account takeover | Cryptosteel offline, audit logs, zero online copy |

### API Key Scoping (Least Privilege)
```
Subaccount 1 (Trading):
├── Freqtrade key:    Orders only, no transfers
├── Risk-breaker key: Read-only balance check
└── Skim key:         Master→subaccount transfer only

Rotation: 90-day automated via cronjob + overdue alerts
```

### Audit Trail (Immutable)
```sql
-- journal.db (SQLite, append-only)
swing_trades(trade_id, pair, entry, exit, thesis, lesson)
capital_movements(direction, amount, status, confirm_txn)
halt_events(reason, trigger_value, resolved_at)
config_changes(service, field, old_value, new_value)
incidents(type, severity, mitigated_at)
```

## Tech Stack

| Component | Technology | Security Control |
|-----------|------------|------------------|
| Strategy Engine | Freqtrade | Read-only filesystem, non-root |
| Secret Management | HashiCorp Vault | Shamir unseal, short-TTL tokens |
| Authentication | FIDO2/Yubikey 5 | Phishing-resistant MFA |
| Orchestration | K3s + Helm | NetworkPolicy, RBAC, Kyverno |
| Monitoring | Wazuh + Grafana | Geo-anomaly, rate-anomaly detection |
| Backup | MinIO | Encrypted journal backups |

## Results & Metrics

### Security Outcomes
```
Incident Prevention:
├── Unauthorized trades: 0
├── Key revocation time: <60 seconds
├── Audit coverage: 100% of trades and capital movements
├── False positive rate: <5% on anomaly detection
└── NIST CSF alignment: Full coverage
```

### Operational Benefits
1. **Sleep Well:** Multiple independent circuit breakers prevent catastrophic loss
2. **Auditability:** Every trade has thesis/lesson documentation
3. **Portability:** Entire platform runs on k3s homelab
4. **Compliance:** NIST CSF framework, ready for institutional requirements

## Architecture Decisions

- **Independent risk-breaker:** Separate process, separate credentials — cannot be disabled by compromised trading bot
- **FIDO2 over TOTP:** Phishing-resistant, no shared secrets, hardware-bound
- **Maker-only orders:** Reduced fees, predictable fills, harder to exploit
- **Cryptosteel for root token:** Cold storage for break-glass scenarios only
