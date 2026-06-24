---
name: tuned-tensor
description: Use for broad Tuned Tensor orientation, setup, safety rules, and choosing between the fine-tuning and local-serving workflows.
---

# Tuned Tensor

Tuned Tensor turns behaviour specs into small open-weight models with regression-aware evaluation. Prefer the `tt` CLI for automation; use the REST API only when the CLI cannot express the workflow.

## Workflow Routing

Use the focused skills when the user has a concrete task:

- `tuned-tensor-fine-tune`: create or update `tunedtensor.json`, validate, push, estimate/start runs, watch runs, inspect regressions, upload datasets, or continue from a parent model.
- `tuned-tensor-serve-local`: inspect model artifacts, download/export completed models, run `tt models serve`, configure the OpenAI-compatible local API, or test local inference.

Use this overview skill for setup, general Tuned Tensor questions, or tasks that span both workflows.

## CLI Setup

Install the CLI:

```bash
npm install -g @tuned-tensor/cli
```

Authenticate with an API key from the Tuned Tensor dashboard:

```bash
tt auth login <api-key>
tt auth status
```

Before making changes, orient with:

```bash
tt --version
tt auth status
tt balance
rg --files -g 'tunedtensor.json'
```

Do not print full API keys. If auth is missing, ask the user for a safe login flow rather than inventing credentials.

## Common Commands

```bash
tt specs list
tt datasets list
tt runs list
tt models list
tt models base
tt balance
```

Use global `--json` when another program needs to parse command output:

```bash
tt --json runs get <run-id>
```

Use a custom API base URL only for local or staging environments:

```bash
tt -u https://your-api.example.com specs list
```

## Supported Base Models

- `google/gemma-4-E2B-it`
- `google/gemma-4-E4B-it`
- `Qwen/Qwen3.5-2B`
- `Qwen/Qwen3.5-4B`
- `Qwen/Qwen3-VL-2B-Instruct` for small multimodal/OCR and image-to-JSON workflows
- `meta-llama/Llama-3.2-3B-Instruct`
- `microsoft/Phi-4-mini-instruct`
- `ibm-granite/granite-3.3-2b-instruct`
- `bigcode/starcoder2-3b`

When unsure, run `tt models base` and choose the smallest supported model that can plausibly handle the task.

## REST API Fallback

Base URL:

```text
https://tunedtensor.com/api/v1
```

Authenticate REST calls with:

```text
Authorization: Bearer <api-key>
```

Prefer official docs before constructing raw requests:

- `https://tunedtensor.com/docs/quickstart`
- `https://tunedtensor.com/docs/cli`
- `https://tunedtensor.com/docs/authentication`
- `https://tunedtensor.com/docs/behavior-specs`
- `https://tunedtensor.com/docs/runs`
- `https://tunedtensor.com/docs/datasets`
- `https://tunedtensor.com/docs/models`
- `https://tunedtensor.com/docs/billing`

## Safety Rules

- Never commit API keys, downloaded model artifacts, `.env` files, or credentials.
- Do not print full API keys in logs or final answers.
- Check `tt balance` before starting expensive or repeated runs.
- If a command fails with insufficient credits, stop and ask the user to add credits or approve top-up.
- Do not delete remote specs, datasets, runs, or models unless the user explicitly asks.
- Do not start repeated training runs without inspecting the previous run's report.
