---
title: "Universal Knowledge Extractor — LLM Training Data Pipeline"
date: 2026-04-16
description: "Python CLI that transforms diverse content sources into high-quality ChatML training data for LLM fine-tuning with automatic taxonomy discovery"
technologies: ["Python", "Ollama", "Pydantic", "YAML", "ChatML", "JSONL"]
categories: ["Product", "AI/ML", "Data Engineering"]
tags: ["LLM Fine-tuning", "Training Data", "ChatML", "Ollama", "Data Pipeline", "NLP"]
client: "Internal Tool"
duration: "1 month"
team_size: "1"
metrics:
  - "500+ samples/hour"
  - "<2% semantic duplicates"
  - "0 credential leaks"
  - "Zero-conversion Axolotl load"
---

# Universal Knowledge Extractor — LLM Training Data Pipeline

## Challenge
Fine-tuning LLMs on domain-specific knowledge requires structured, high-quality instruction-response pairs. Manual curation doesn't scale, and raw content from code repos, docs, and social media needs significant preprocessing before it's usable for training.

Build a pipeline that:
- Extracts knowledge from diverse sources (code, docs, Telegram, LinkedIn)
- Automatically discovers content taxonomy
- Produces ChatML-formatted JSONL ready for Axolotl/LLaMA-Factory
- Runs fully offline with local Ollama

## Solution Architecture

### Pipeline Flow
```
┌─────────────────────────────────────────────────────────────────┐
│                      Content Sources                             │
├────────────┬────────────┬────────────┬──────────────────────────┤
│ Filesystem │   GitHub   │  Telegram  │        LinkedIn          │
│  (.md, .py)│  (repos)   │ (channels) │       (exports)          │
└─────┬──────┴─────┬──────┴─────┬──────┴────────────┬─────────────┘
      │            │            │                   │
      └────────────┴────────────┴───────────────────┘
                            │
                            ▼
              ┌──────────────────────────┐
              │    Taxonomy Discovery    │
              │  (Unsupervised ML)       │
              └────────────┬─────────────┘
                           │
                           ▼
              ┌──────────────────────────┐
              │   LLM Extraction         │
              │  (Ollama qwen3.5:35b)    │
              │  → Instruction-Response  │
              └────────────┬─────────────┘
                           │
                           ▼
              ┌──────────────────────────┐
              │   Quality Assurance      │
              │  - Schema validation     │
              │  - Token length check    │
              │  - Language detection    │
              │  - Credential scanning   │
              │  - Semantic dedup        │
              └────────────┬─────────────┘
                           │
                           ▼
              ┌──────────────────────────┐
              │   Data Augmentation      │
              │  - Paraphrase            │
              │  - Reformulation         │
              └────────────┬─────────────┘
                           │
                           ▼
         output/training-data.jsonl (ChatML)
```

### Multi-Source Support

| Source | Adapter | Content Types |
|--------|---------|---------------|
| **Filesystem** | `fs` | Markdown, Python, YAML, JSON |
| **GitHub** | `github` | Repos, READMEs, code, issues |
| **Telegram** | `telegram` | Channel messages, media captions |
| **LinkedIn** | `linkedin` | Profile exports, posts, articles |

## Key Features

### 1. Automatic Taxonomy Discovery
```yaml
# No manual topic lists required
taxonomy:
  method: unsupervised
  algorithm: kmeans  # or hdbscan
  num_clusters: auto  # discovers optimal count
```
Uses embedding-based clustering to automatically categorize content into topics.

### 2. Multi-Layer Quality Assurance

| Check | Purpose | Action on Fail |
|-------|---------|----------------|
| Schema validation | Pydantic model | Reject sample |
| Token length | Fits context window | Truncate/split |
| Language detection | Match target lang | Filter out |
| Credential scan | No secrets in output | Reject sample |
| Semantic dedup | <2% duplicates | Filter out |

### 3. Checkpoint & Resume
```bash
# Pipeline crashed at sample 5000?
python -m uke resume --checkpoint output/checkpoint.json
# → Resumes from last complete batch in <5 seconds
```

### 4. Output Format Compatibility

```json
// ChatML JSONL — works with Axolotl, LLaMA-Factory, Unsloth
{
  "messages": [
    {"role": "system", "content": "You are a DevSecOps expert."},
    {"role": "user", "content": "How do I configure Wazuh rules?"},
    {"role": "assistant", "content": "To configure Wazuh rules..."}
  ]
}
```

Zero conversion needed — load directly into training frameworks.

### 5. Augmentation Pipeline

```yaml
augmentation:
  enabled: true
  methods:
    - paraphrase:
        model: qwen3.5:35b
        num_variants: 2
    - reformulation:
        styles: [concise, detailed, step-by-step]
```

Increases training set diversity without manual effort.

## Configuration

### Sample Config (YAML)
```yaml
# config/extract.yaml
sources:
  - type: filesystem
    path: ./docs
    extensions: [.md, .py]
  
  - type: telegram
    channels: [devops_jobs, security_alerts]
    max_messages: 1000

extraction:
  model: qwen3.5:35b
  ollama_host: http://192.168.2.2:11434
  batch_size: 10
  
quality:
  min_tokens: 50
  max_tokens: 2048
  language: en
  dedup_threshold: 0.85

output:
  format: chatml
  path: output/training-data.jsonl
  manifest: output/manifest.json
```

## Usage

### Basic Extraction
```bash
# Run full pipeline
python -m uke extract --config config/extract.yaml

# Resume from checkpoint
python -m uke resume --checkpoint output/checkpoint.json

# Validate output quality
python -m uke validate --input output/training-data.jsonl
```

### Output Structure
```
output/
├── training-data.jsonl    # ChatML samples
├── manifest.json          # Pipeline run metadata
├── checkpoint.json        # Resume state
├── taxonomy.json          # Discovered topics
└── quality-report.json    # QA metrics
```

## Results & Metrics

### Performance
```
Throughput:
├── Source ingestion: 10K docs/hour
├── LLM extraction: 500 samples/hour (local Ollama)
├── Quality filtering: 2K samples/hour
└── Augmentation: 300 samples/hour
```

### Quality Guarantees
| Metric | Target | Actual |
|--------|--------|--------|
| Semantic duplicates | <2% | 1.3% |
| Credential leaks | 0 | 0 |
| Schema validity | 100% | 100% |
| Resume latency | <5s | 2.8s |

## Use Cases

1. **Domain Fine-tuning**: Create training data from internal docs for custom LLM
2. **Knowledge Base Extraction**: Convert wiki/docs to Q&A format
3. **Social Curation**: Extract insights from Telegram/LinkedIn content
4. **Code Documentation**: Generate instruction-response pairs from codebases

## Architecture Decisions

- **Ollama over cloud APIs**: Zero cost, full privacy, no rate limits
- **Pydantic for config**: Type-safe, auto-validation at load time
- **ChatML format**: Widest compatibility with training frameworks
- **Checkpoint system**: Production-grade reliability for long-running pipelines
- **Pluggable adapters**: Easy to add new content sources

## Dependencies

- Python 3.12+
- Ollama (local) with qwen3.5:35b
- pydantic, pyyaml, tiktoken
- sentence-transformers (for dedup)
