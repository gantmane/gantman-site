---
title: "DevSecOps-5090 — GPU Training Pipeline on Kubernetes"
date: 2026-04-29
description: "Production-ready QLoRA fine-tuning pipeline for RTX 5090 with pre-built Docker images, Helm deployment, and k3s integration"
technologies: ["PyTorch", "Transformers", "QLoRA", "PEFT", "Kubernetes", "Helm", "Docker", "RTX 5090"]
categories: ["Product", "AI/ML", "Infrastructure"]
tags: ["LLM Fine-tuning", "QLoRA", "GPU", "Kubernetes", "Self-Hosted", "ML Infrastructure"]
client: "Internal Tool"
duration: "2 weeks"
team_size: "1"
metrics:
  - "11.4 GB training image"
  - "8x faster pod startup"
  - "32GB VRAM utilization"
  - "Zero SSL/network errors"
---

# DevSecOps-5090 — GPU Training Pipeline on Kubernetes

## Challenge
Fine-tuning Large Language Models typically requires cloud GPU instances (expensive) or complex local setups. Need a production-ready, self-hosted training pipeline that:
- Runs on local RTX 5090 (32GB VRAM)
- Deploys via Kubernetes (k3s homelab)
- Uses pre-built images (no runtime pip installs)
- Supports QLoRA for memory efficiency

## Solution Architecture

### Pipeline Overview
```
┌─────────────────────────────────────────────────────────────┐
│                    K3s Cluster (Homelab)                     │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────┐   │
│  │              Training Pod (GPU)                      │   │
│  │  ┌─────────────────┐  ┌─────────────────────────┐   │   │
│  │  │ Init Containers │  │    Main Container       │   │   │
│  │  │ - Verify GPU    │  │ - qwen_qlora_trainer.py │   │   │
│  │  │ - Check deps    │  │ - HuggingFace ecosystem │   │   │
│  │  │ - Mount PVCs    │  │ - bitsandbytes (4-bit)  │   │   │
│  │  └─────────────────┘  └─────────────────────────┘   │   │
│  │                                                      │   │
│  │  ┌─────────────────────────────────────────────┐    │   │
│  │  │              Sidecar                         │    │   │
│  │  │         metrics-exporter                     │    │   │
│  │  └─────────────────────────────────────────────┘    │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  Volumes:                                                   │
│  ├── /mnt/models      (RO) - Model cache                   │
│  ├── /mnt/data        (RO) - Training data                 │
│  ├── /mnt/checkpoints (RW) - Output checkpoints            │
│  └── /mnt/training-logs (RW) - Logs + TensorBoard          │
└─────────────────────────────────────────────────────────────┘
```

### Pre-Built Training Image
```dockerfile
FROM pytorch/pytorch:2.6.0-cuda12.4-cudnn9-runtime

# Pre-install all dependencies (no runtime downloads)
RUN pip install --no-cache-dir \
    transformers==4.47.0 \
    peft==0.14.0 \
    trl==0.13.0 \
    bitsandbytes==0.45.0 \
    datasets==3.2.0 \
    accelerate==1.2.1 \
    safetensors \
    sentencepiece \
    protobuf
```

**Result:** 11.4 GB image, ~2 min boot (vs. 15+ min with runtime pip)

## Key Features

### 1. QLoRA Training Script
```python
# qwen_qlora_trainer.py
from transformers import AutoModelForCausalLM, BitsAndBytesConfig
from peft import LoraConfig, get_peft_model

# 4-bit quantization config
bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_compute_dtype=torch.bfloat16,
    bnb_4bit_use_double_quant=True
)

# LoRA config for efficient fine-tuning
lora_config = LoraConfig(
    r=16,
    lora_alpha=32,
    target_modules=["q_proj", "v_proj", "k_proj", "o_proj"],
    lora_dropout=0.05,
    task_type="CAUSAL_LM"
)
```

### 2. Helm Deployment
```yaml
# helm/values.yaml
training:
  enabled: true
  image:
    repository: 192.168.2.30:5000/devsecops-training
    tag: v0.1.0
  
  resources:
    limits:
      nvidia.com/gpu: 1
      memory: 14Gi
      cpu: 4
    requests:
      memory: 12Gi
      cpu: 2
  
  securityContext:
    runAsNonRoot: true
    runAsUser: 1001
    readOnlyRootFilesystem: true
```

### 3. Container Security
```yaml
# Non-root execution
securityContext:
  runAsUser: 1001 (trainuser)
  runAsGroup: 1001
  
# Read-only filesystem with exceptions
volumes:
  - /tmp (writable) - Triton cache
  - /dev/shm (4Gi) - PyTorch DataLoader
  - /mnt/checkpoints (writable) - Model output
```

### 4. GPU Resource Management
```
RTX 5090 (32GB VRAM):
├── Model (4-bit quantized): ~8GB
├── Gradients + Optimizer: ~4GB
├── Batch activations: ~2GB
└── Available for larger batches: ~18GB
```

## Training Configuration

### Supported Models
| Model | Parameters | 4-bit VRAM | Use Case |
|-------|------------|------------|----------|
| GPT-2 | 124M | ~1GB | Testing/validation |
| Qwen-7B | 7B | ~4GB | General fine-tuning |
| Qwen-14B | 14B | ~8GB | Higher quality |
| DeepSeek-R1-32B | 32B | ~18GB | Maximum capability |

### Example Config
```yaml
# qlora-8b-devsecops.yaml
model:
  name: "Qwen/Qwen2.5-7B-Instruct"
  quantization: "4bit"

training:
  epochs: 3
  batch_size: 4
  learning_rate: 2e-4
  max_seq_length: 2048
  
lora:
  r: 16
  alpha: 32
  dropout: 0.05
  
output:
  checkpoint_dir: "/mnt/checkpoints"
  save_steps: 500
```

## Deployment

### Quick Start
```bash
# 1. Build and push image
docker buildx build -f Dockerfile.training \
  -t 192.168.2.30:5000/devsecops-training:v0.1.0 .
docker push 192.168.2.30:5000/devsecops-training:v0.1.0

# 2. Deploy via Helm
helm upgrade --install devsecops ./helm \
  --namespace devsecops \
  --values helm/values.yaml

# 3. Monitor training
kubectl logs -f -n devsecops -l app=devsecops-training
```

### Expected Output
```
=== Verifying environment ===
PyTorch: 2.6.0+cu124
CUDA: True
GPU: NVIDIA GeForce RTX 5090

=== Starting QLoRA Training ===
Loading model: Qwen/Qwen2.5-7B-Instruct
Applying 4-bit quantization...
Creating LoRA adapters...

Training: /mnt/checkpoints
[100/1000] loss: 2.45
[200/1000] loss: 1.87
...
Model saved to /mnt/checkpoints/final_model
Training complete!
```

## Results & Benefits

### Performance Gains
```
Image Optimization:
├── Boot time: 2 min (vs. 15+ min)
├── Image size: 11.4 GB (optimized)
├── Zero runtime downloads
└── No SSL/network errors

Resource Efficiency:
├── 4-bit quantization: 4x memory reduction
├── LoRA adapters: <1% trainable params
└── Full RTX 5090 VRAM utilization
```

### Cost Comparison
| Approach | Cost per training run |
|----------|----------------------|
| AWS p4d.24xlarge | ~$32/hour |
| GCP A100 | ~$25/hour |
| Lambda Labs | ~$10/hour |
| **Self-hosted RTX 5090** | **~$0.15/hour** (electricity) |

## Architecture Decisions

- **Pre-built images:** Eliminates runtime dependency resolution failures
- **QLoRA over full fine-tuning:** 4x memory reduction, comparable quality
- **k3s over Docker Compose:** Production-grade scheduling, resource limits
- **Non-root containers:** Security hardening, CIS benchmark compliance
- **Separate metrics sidecar:** Clean separation, Prometheus-native
