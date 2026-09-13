---
name: tuned-tensor
description: Set up and operate the unified Tuned Tensor CLI, choose local or user-owned AWS GPUs and managed or user-supplied agent inference, and inspect usage and run information.
---

# Tuned Tensor

`tt` is both the local conversational agent and the CLI for Tuned Tensor. Root workflow commands orchestrate locally, with optional user-owned AWS GPU execution through `gpu` in the runner config. `tt cloud ...` selects TT account records; hosted training start/estimate are retired. The web app displays cloud runs and local evidence the user chooses to publish. Use the CLI to operate workflows.

## Setup And Orientation

Node.js 22.19+ is required:

```bash
npm install -g --ignore-scripts @tuned-tensor/cli
tt --version
tt --help
tt status
rg --files -g 'tunedtensor.json'
```

Local spec creation, validation, reports, and local execution require no Tuned Tensor account or agent-provider key. Training needs local `uv` and supported NVIDIA CUDA hardware locally or on a configured AWS instance; basic CLI inspection does not need a GPU. `tt local ...` and `tt run` are compatibility aliases. Prefer root commands and `tt pipeline run` in new instructions.

These skills target CLI 0.16.0 or newer, with user-owned AWS GPU support. If an earlier local-only release does not show those commands in help, update the CLI for account workflows. Do not infer command availability from an old cloud example.

## Agent Inference

The agent loop and tools run on the user's laptop. Inference selection is independent of whether a training run executes locally or in the cloud.

For managed inference, one Tuned Tensor access token authenticates both the inference proxy and cloud/account APIs:

```bash
tt auth login
tt agent configure --provider tunedtensor
tt agent status
tt
```

`tt auth login` uses a hidden prompt. A token also enables managed inference automatically when no other provider is selected. The app owns the managed model selection; do not request an OpenRouter key or offer a managed-model override. `/model tunedtensor/managed` selects it inside the shell.

For a user's own OpenRouter key, use the shell's hidden provider login and select any model the provider supports:

```text
/login openrouter
/model openrouter/<model-id>
```

Use `tt agent models --provider openrouter --all` to inspect the catalog. Bring-your-own provider selection remains explicit and is not restricted to the managed service's model. Other supported providers and local endpoints are available through the CLI's provider configuration. Never copy credentials into a spec, command log, or repository.

## Workflow Routing

- Use `tuned-tensor-fine-tune` to create specs, run one pipeline using local CUDA or a user-owned AWS GPU, and inspect regression reports.
- Use `tuned-tensor-serve-local` to verify and serve a local adapter, or download/export/serve a completed cloud model.

Token-free local workflow:

```bash
tt init --name "Customer Support Bot" --model Qwen/Qwen3.5-2B
# Edit tunedtensor.json, including the system prompt and both example placeholders.
tt validate tunedtensor.json
tt models prefetch tunedtensor.json
tt doctor tunedtensor.json
tt pipeline run --spec tunedtensor.json --dry-run
tt pipeline run --spec tunedtensor.json
tt runs report <run-id>
```

For AWS, configure `gpu` before `doctor` and training using the
[AWS first-run guide](https://github.com/tunedtensor/tuned-tensor-cli/blob/main/docs/local-runtime/aws-gpu.md).
The fine-tuning skill includes an example. AWS profiles and SSH access are
separate from TT login. `tt hardware` inspects only the laptop; a missing local
GPU does not prevent AWS training. `tt doctor` checks the configured instance.
The user supplies capacity and manages AWS charges and shutdown. Keep the laptop
running until outputs return. Serving remains local.

## Reports And Account Information

Local information is available without authentication:

```bash
tt status
tt runs list
tt runs report <run-id>
tt models list
```

For the user's cloud/account task, authenticate only if needed, then use:

```bash
tt auth status
tt cloud runs list --summary --json
tt cloud runs report <run-id>
tt cloud datasets list
tt cloud models list
tt balance
tt usage
```

Compact cloud run summaries omit detailed evaluation/event payloads; retrieve a full report for triage. `tt usage` reports managed-agent usage, not all bring-your-own provider activity or all local training. Local run reports remain the source for local metrics. `tt publish <local-run-id>` explicitly uploads local evidence for dashboard display; do not publish as part of routine local inspection.

Use `tt usage` for managed-agent allowance and `tt balance` for TT credits used by account services. Neither funds user-owned AWS GPUs. Training needs no TT balance check. If credits or allowance are insufficient, report that result; a credit top-up requires the user's authorization. Do not automatically change providers, execution placement, or models after an authentication or quota error.

## API Fallback

Prefer the CLI and its installed help. Use the authenticated REST API only when the CLI cannot express the requested workflow:

```text
https://tunedtensor.com/api/v1
Authorization: Bearer <access-token>
```

Consult the [CLI documentation](https://tunedtensor.com/docs/cli) and [authentication documentation](https://tunedtensor.com/docs/authentication) before constructing raw requests. A Tuned Tensor token goes only to the intended Tuned Tensor API origin; an OpenRouter key goes to OpenRouter.
