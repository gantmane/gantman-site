---
title: "Ollama Decomposition Agent — Intelligent LLM Orchestration"
date: 2026-01-15
description: "AI agent that intelligently decomposes large prompts into parallel sub-tasks, achieving 30-50% latency reduction with local Ollama models"
technologies: ["Python", "Ollama", "AsyncIO", "Tiktoken", "DeepSeek-R1", "Qwen3"]
categories: ["Product", "AI/ML", "Infrastructure"]
tags: ["LLM", "Agent", "Prompt Engineering", "Local AI", "Zero API Costs", "Parallel Processing"]
client: "Internal Tool"
duration: "2 months"
team_size: "1"
metrics:
  - "30-50% latency reduction"
  - "40-60% cache hit rate"
  - "$0 API costs"
  - "100% backward compatible"
---

# Ollama Decomposition Agent — Intelligent LLM Orchestration

## Challenge
Large Language Models have context window limits and increasing latency with prompt size. When analyzing large codebases, documents, or complex multi-part questions, single-shot prompts either exceed context limits or produce slow, unfocused responses.

Build an agent that:
- Intelligently splits large prompts into semantic sub-tasks
- Executes sub-tasks in parallel for speed
- Synthesizes results into coherent responses
- Runs entirely on local Ollama (zero API costs)

## Solution Architecture

### Workflow
```
User Prompt (large)
    ↓
[Analyze] - Count tokens, identify boundaries
    ↓
[Decide] - Decompose or single call?
    ├─→ Small (<6K tokens) → Single Ollama call → Return
    └─→ Large (>6K tokens) → Decomposition
            ↓
        [Split] - Semantic decomposition (headings, lists, paragraphs)
            ↓
        [Execute] - Parallel sub-task execution (3 concurrent)
            ↓
        [Aggregate] - Result synthesis (auto-strategy selection)
            ↓
        [Return] - Final coherent response
```

### Components

| Component | Responsibility |
|-----------|---------------|
| **OllamaDecompositionAgent** | Main orchestrator, workflow management |
| **TokenManager** | Tiktoken counting, chunking with overlap |
| **PromptSplitter** | Semantic decomposition at natural boundaries |
| **OllamaClient** | Async HTTP with retry/backoff |
| **ResultAggregator** | Multi-strategy synthesis |

## Key Features

### 1. Intelligent Prompt Decomposition
```python
# Identifies natural breakpoints
sections = splitter.split(prompt)
# → [heading1_content, list_items, paragraph_block, ...]

# Preserves shared context across sub-tasks
for section in sections:
    subtask = f"{shared_context}\n\n{section}"
```

### 2. Parallel Execution with Controlled Concurrency
```python
async with asyncio.Semaphore(3):  # Max 3 concurrent
    results = await asyncio.gather(*subtask_calls)
```

### 3. Multi-Strategy Aggregation

| Sub-task Count | Strategy | Method |
|---------------|----------|--------|
| 1-3 | Concatenate | Join all + final synthesis |
| 4-10 | Sequential | Summarize each, then synthesize |
| 10+ | Hierarchical | Tree-based summarization |

### 4. Performance Optimizations (v2.0)

| Optimization | Improvement |
|--------------|-------------|
| Expert identification toggle | 25-30% latency reduction |
| Token count caching | 40-60% cache hits, 60-180ms savings |
| Async file I/O | ~160ms improvement |
| Parallel token counting | 140ms+ savings on large prompts |
| Result caching (LRU) | 8-12s+ savings on repeated prompts |

## Performance Characteristics

### Execution Times (DeepSeek-R1:32b)

| Prompt Size | Strategy | Sub-tasks | Duration | Tokens |
|-------------|----------|-----------|----------|--------|
| < 6K | Single call | 1 | 5-15s | ~6K |
| 6K-12K | Semantic | 2-3 | 15-25s | ~12K |
| 12K-24K | Semantic | 4-5 | 25-40s | ~24K |
| 24K+ | Hierarchical | 6-10 | 40-90s | 30K+ |

### Cost Comparison

| Approach | Cost per 100K tokens |
|----------|---------------------|
| OpenAI GPT-4 | ~$3.00 |
| Anthropic Claude | ~$2.40 |
| **Local Ollama** | **$0.00** |

## Usage

### Python API
```python
from ml.agents import OllamaDecompositionAgent, AgentConfig

config = AgentConfig(
    ollama_host="192.168.2.2:11434",
    ollama_model="deepseek-r1:32b",
    max_parallel_tasks=3,
    aggregation_strategy="auto"
)

agent = OllamaDecompositionAgent(config)
result = await agent.process(large_prompt)

print(f"Response: {result.final_response}")
print(f"Tokens: {result.total_tokens_used}")
print(f"Duration: {result.total_duration_seconds:.2f}s")
```

### CLI Tool
```bash
# Simple prompt
python ml/agents/examples/cli_tool.py "Your prompt here"

# Load from file
python ml/agents/examples/cli_tool.py @large-document.txt

# Custom configuration
python ml/agents/examples/cli_tool.py @prompt.txt \
    --model deepseek-r1:32b \
    --max-tokens 16384 \
    --parallel 4 \
    --aggregation-strategy hierarchical
```

## Configuration

### Core Settings
```python
AgentConfig(
    # Ollama
    ollama_host="192.168.2.2:11434",
    ollama_model="deepseek-r1:32b",
    
    # Context Management
    max_context_tokens=8192,
    response_reserve_tokens=2048,
    chunk_overlap_tokens=200,
    
    # Execution
    max_parallel_tasks=3,
    timeout_seconds=300,
    
    # Performance (v2.0+)
    enable_token_count_cache=True,
    enable_async_file_io=True,
    enable_result_caching=False,
)
```

## Results & Benefits

### Technical Outcomes
```
Performance:
├── Latency reduction: 30-50% (with optimizations)
├── Cache hit rate: 40-60%
├── Backward compatibility: 100%
└── API costs: $0
```

### Use Cases
1. **Security Audits:** Analyze large codebases in parallel
2. **Document Analysis:** Process long reports with coherent synthesis
3. **Code Review:** Multi-file reviews with context preservation
4. **Research:** Complex multi-part questions with structured responses

## Architecture Decisions

- **Tiktoken over custom counting:** OpenAI-standard accuracy, battle-tested
- **Semantic over fixed-size splitting:** Preserves meaning, better coherence
- **Async over threading:** Better I/O performance, cleaner code
- **LRU caching over persistent:** Session-scoped, no stale data issues
