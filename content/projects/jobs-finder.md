---
title: "Jobs Finder — AI-Powered Job Search Pipeline"
date: 2026-05-06
description: "Multi-source job scraper with AI ranking — aggregates Telegram, LinkedIn, and HH.ru vacancies and scores them against your CV using local Ollama"
technologies: ["Python", "Ollama", "Selenium", "Telegram API", "SQLite", "Qwen3.5"]
categories: ["Product", "AI/ML", "Automation"]
tags: ["Job Search", "Web Scraping", "AI Ranking", "Local LLM", "Automation", "Privacy-First"]
client: "Internal Tool"
duration: "1 month"
team_size: "1"
metrics:
  - "3 data sources"
  - "100+ jobs/day processed"
  - "$0 API costs"
  - "Multi-profile support"
---

# Jobs Finder — AI-Powered Job Search Pipeline

## Challenge
Job searching across multiple platforms is time-consuming. Telegram channels post hundreds of vacancies daily, LinkedIn requires manual browsing, and HH.ru (Russia's Indeed) needs separate attention. Manually reviewing all postings and assessing fit is inefficient.

Build a pipeline that:
- Aggregates jobs from Telegram, LinkedIn, and HH.ru
- Ranks every posting against your CV using AI
- Runs entirely locally (no cloud API costs, no data leakage)
- Supports multiple job search profiles (DevSecOps, Data Analyst, PM)

## Solution Architecture

### Pipeline Flow
```
┌─────────────────────────────────────────────────────────────┐
│                    Data Sources                              │
├──────────────┬──────────────────┬───────────────────────────┤
│   Telegram   │     LinkedIn     │          HH.ru            │
│ (13 channels)│ (keyword matrix) │    (public REST API)      │
└──────┬───────┴────────┬─────────┴───────────────┬───────────┘
       │                │                          │
       └────────────────┼──────────────────────────┘
                        ▼
              ┌─────────────────────┐
              │    Deduplication    │
              │  (cross-source)     │
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │    AI Ranking       │
              │ Ollama qwen3.5:35b  │
              │ (batch mode: 10/call)│
              └──────────┬──────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │    Filter & Report  │
              │  (threshold: 78+)   │
              └─────────────────────┘
                         │
                         ▼
              outputs/<date>/ranked/report.md
```

### Multi-Profile Support
```yaml
# profiles/devsecops.yaml
cv_path: "info/CV/devsecops/gantman_2026_compact.md"
linkedin:
  keywords: ["DevSecOps", "Security Architect", "SRE", "CISO"]
  geo: ["Worldwide", "European Union", "Israel"]
telegram:
  channels: ["devops_jobs", "sre_jobs", "security_jobs"]
filters:
  min_salary_usd: 9000
  rank_threshold: 78
```

## Key Features

### 1. Telegram Channel Scraping
- Public channel scraping (no bot token needed)
- 13 default DevOps/Security channels
- Configurable per profile
- Rate-limited with polite delays

### 2. LinkedIn Job Search
- Selenium with persistent Chrome profile
- Keyword × geo matrix search
- Handles pagination (up to 40 pages)
- Extracts: title, company, salary, location, description

### 3. HH.ru Integration
- Public REST API (no auth)
- Area-based search (Russia, Belarus, Georgia, Israel)
- Experience level filtering
- Structured vacancy data

### 4. AI Ranking (Batch Mode)
```python
# Batch processing: 10 jobs per LLM call
prompt = f"""
CV: {cv_markdown}

Jobs: {json.dumps(batch_of_10_jobs)}

Score each job 0-100 for fit. Return JSON:
{{"results": [{{"job_id": "...", "score": 85, "evidence_confidence": 0.9}}]}}
"""

# Amortizes model-load cost across batch
response = await ollama.generate(prompt, model="qwen3.5:35b")
```

### 5. State Management
```sql
-- ~/.cache/jobs-finder/state.sqlite3
CREATE TABLE seen_jobs (
    job_id TEXT PRIMARY KEY,
    source TEXT,
    first_seen TIMESTAMP,
    score INTEGER,
    evidence_confidence REAL
);
```
- Cross-run deduplication
- Score history tracking
- Prevents re-ranking known jobs

## Configuration

### Environment Variables
```bash
# Ollama
JOBS_OLLAMA_HOST=http://192.168.2.2:11434
JOBS_OLLAMA_MODEL=qwen3.5:35b
JOBS_OLLAMA_NUM_CTX=16384

# Filters
JOBS_MIN_SALARY_USD=9000
JOBS_RANK_THRESHOLD=78
JOBS_REPORT_TOP_N=10
JOBS_MAX_POSTING_AGE_DAYS=21

# Sources
JOBS_TELEGRAM_MAX_MESSAGES=500
JOBS_LINKEDIN_HEADLESS=false
JOBS_HH_MAX_PAGES_PER_AREA=20
```

## Usage

### Run Full Pipeline
```bash
# Using profile
python -m jobs_finder pipeline --profile devsecops -v

# Skip specific sources
python -m jobs_finder pipeline --skip-linkedin --skip-hh -v

# Force re-rank everything
python -m jobs_finder pipeline --no-state
```

### Output
```
outputs/2026-05-15/
├── telegram.jsonl      # Raw scraped posts
├── linkedin.jsonl      # Raw scraped jobs
├── hh.jsonl           # Raw vacancies
└── ranked/
    ├── ranked.jsonl   # All jobs with scores
    └── report.md      # Top-N markdown report
```

## Results & Benefits

### Efficiency Gains
```
Manual Search:
├── Telegram: ~30 min/day reading channels
├── LinkedIn: ~45 min/day browsing + filtering
├── HH.ru: ~20 min/day
└── Total: ~95 min/day

Automated Pipeline:
├── Scraping: ~5 min (background)
├── Ranking: ~10 min (batch AI)
├── Review: ~10 min (top 10 only)
└── Total: ~25 min/day

Savings: 70 min/day, 70%+ reduction
```

### Privacy Benefits
- No job data sent to cloud APIs
- CV stays local
- LinkedIn profile not exposed to third-party services
- Full control over data retention

## Architecture Decisions

- **Ollama batch mode:** 10 jobs per call amortizes model-load latency
- **SQLite state DB:** Simple, portable, no server needed
- **Chrome persistent profile:** Maintains LinkedIn login across runs
- **Multi-profile YAML:** Easy to switch between job searches
- **Confidence scoring:** Filter out low-evidence matches (< 0.5)
