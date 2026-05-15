---
title: "BIMcore Engineer — Rust-First BIM Platform"
date: 2026-05-07
description: "Next-generation BIM authoring platform in Rust replacing Autodesk Revit for terabyte-scale federated models with 60 FPS GPU rendering"
technologies: ["Rust", "Vulkan 1.3", "PostgreSQL", "Redpanda", "Raft", "egui", "Tokio", "MinIO"]
categories: ["Product", "CAD/BIM", "Enterprise"]
tags: ["BIM", "Rust", "Vulkan", "Revit Alternative", "CAD", "Architecture", "Engineering"]
client: "BIMcore"
duration: "18 months (MVP Q3 2026)"
team_size: "1"
metrics:
  - "96 requirement documents"
  - "60 FPS on 100GB models"
  - "30 FPS on 1TB models"
  - "50+ ADRs"
---

# BIMcore Engineer — Rust-First BIM Platform

## Challenge
The AEC (Architecture, Engineering, Construction) industry is stuck with 30-year-old software architecture. Autodesk Revit struggles with models beyond 500MB, cannot handle true multi-user editing, and crashes when federated models exceed 1GB. Large industrial projects (power plants, factories, data centers) routinely hit 100GB-1TB — forcing teams into complex workarounds.

Build a ground-up BIM platform that treats terabyte models as first-class, editable objects.

## Solution Architecture

### Overview
```
┌──────────────────────────────────────────────────────────────────┐
│                    BIMcore Studio (Client)                        │
│     Rust + egui + Vulkan 1.3 | 60 FPS interactive editing        │
└────────────────────────┬─────────────────────────────────────────┘
                         │ gRPC + Protobuf
                         ▼
┌──────────────────────────────────────────────────────────────────┐
│                   BIMcore Nucleus (Server)                        │
│     Distributed: PostgreSQL + Redpanda + Raft Consensus          │
└────────────────────────┬─────────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┐
         ▼               ▼               ▼
   ┌──────────┐   ┌──────────┐   ┌──────────┐
   │PostgreSQL│   │ Redpanda │   │  MinIO   │
   │ + PostGIS│   │ (Events) │   │  (Blobs) │
   └──────────┘   └──────────┘   └──────────┘
```

### Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Client** | Rust + egui | Native thick client with GPU rendering |
| **Rendering** | Vulkan 1.3 | Cross-platform 60 FPS, on-demand geometry |
| **Server** | Rust + Tokio | Async distributed coordination |
| **Consensus** | openraft | Raft-based multi-node consistency |
| **Database** | PostgreSQL + PostGIS | Spatial indexing, durability |
| **Events** | Redpanda | Kafka-compatible streaming (2,048 partitions) |
| **Storage** | MinIO | S3-compatible blob storage for geometry |
| **Auth** | Keycloak | OIDC, SAML, enterprise SSO |
| **Secrets** | HashiCorp Vault | Encryption keys, API tokens |

### Canonical Parameters (from 00-SHARED-CONTEXT.md)

| Parameter | Value | Rationale |
|-----------|-------|-----------|
| **P-001** | ≥60 FPS at ≤100GB, ≥30 FPS at 1TB | Interactive editing requirement |
| **P-005** | JWT TTL = 5 minutes | Short-lived tokens for security |
| **P-012** | 2,048 Redpanda partitions | Scale for event streaming |
| **P-025** | AES-256-GCM at-rest encryption | Compliance requirement |

## Key Features

### 1. Terabyte-Scale Model Handling
- **On-demand geometry loading**: Only visible elements in GPU memory
- **Columnar bcx format**: Compressed, audit-hashed, open specification
- **Spatial indexing**: PostGIS R-tree for frustum culling
- **Delta snapshots**: Versioned changes without full model duplication

### 2. Native Import/Export
```
Import:
├── Revit 2020-2026 (.rvt) via ODA BimRv SDK
├── IFC 2x3 / 4 / 4.3 via IfcOpenShell
└── Point clouds (.las, .laz)

Export:
├── bcx (native columnar format)
├── IFC 4.3
└── glTF 2.0 (for web viewers)
```

### 3. Real-Time Collaboration (MVP-3+)
- **CRDT-based editing**: Conflict-free concurrent edits
- **Operational transforms**: Merge without locks
- **Presence awareness**: See other users' selections live

### 4. 3D Editing Operations
```rust
// Transactional edit with automatic undo
let tx = model.begin_transaction();
tx.select(element_ids);
tx.move_by(Vector3::new(0.0, 0.0, 1000.0));  // Move up 1m
tx.commit()?;  // Generates inverse operation for undo
```

## Roadmap

| Phase | Timeline | Deliverables |
|-------|----------|--------------|
| **MVP-1** | Q3 2026 | Import Revit/IFC, ≥60 FPS on ≤100GB |
| **MVP-2** | Q4 2026 | 3D edit (select, move, rotate), ≥30 FPS on 1TB |
| **MVP-3** | Q1 2027 | Save to bcx, IFC 4.3 export, GA |
| **Phase 2A** | Q3 2027 | Drawings, schedules, levels/grids edit |
| **Phase 2B** | Q4 2027 | Real-time multi-user, MEP sizing |
| **Phase 2C** | 2028 | Web editor, plugin SDK, mobile viewer |

## Documentation Coverage

```
requirements/          # 96 documents, 35K+ lines
├── 00-SHARED-CONTEXT.md    # Canonical parameters P-001..P-026
├── 01-business/            # Market analysis, business case
├── 02-product/             # PRD, features, personas, roadmap
├── 03-functional/          # 24 FSDs (import, edit, save, cluster)
├── 04-technical/           # Architecture, data model, 50+ ADRs
├── 05-quality/             # Test plan, acceptance scenarios
└── 06-security/            # Security architecture, threat model
```

## Build Targets

| Platform | Status | Notes |
|----------|--------|-------|
| Linux x86_64 (AVX2+) | ✓ Primary | Full support, CI on 16-core |
| macOS arm64 (M1+) | ✓ Secondary | Metal 3 via MoltenVK |
| Windows x86_64 | WIP | IOCP runtime, D3D12 compat |

## Architecture Decisions

### Why Rust?
- Memory safety without GC pauses (critical for 60 FPS)
- Zero-cost abstractions for geometry processing
- Excellent async ecosystem (Tokio) for distributed coordination
- Native Vulkan bindings (ash crate)

### Why Not Electron/Web?
- GPU-bound workloads need native Vulkan, not WebGL limitations
- Memory management must be deterministic, not JS GC
- CAD users expect desktop-class responsiveness

### Why columnar bcx format?
- 10-100x faster spatial queries vs row-based formats
- Columnar compression (zstd) yields 5-8x smaller files
- Append-only for audit trail (every change is versioned)

## Security Model

- **Zero-trust network**: mTLS between all components
- **Audit logging**: Every edit traceable to user + timestamp
- **GPL isolation**: GPL code (IfcOpenShell) runs in subprocess with IPC
- **SBOM**: CycloneDX generated each release

## License

Dual Apache-2.0 / MIT (your choice). Dependencies tracked via SBOM.
