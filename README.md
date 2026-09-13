# Tuned Tensor Codex Plugin

This repository publishes the Tuned Tensor Codex plugin as a Git marketplace. It helps Codex use one `tt` CLI for local training, evaluation, serving, user-owned AWS GPUs, and account reporting. `tt` also runs a conversational agent on the user's laptop. The web app displays cloud runs and published local evidence.

## Install

Add the marketplace and install the plugin:

```bash
codex plugin marketplace add tunedtensor/tuned-tensor-codex-plugin --ref main
codex plugin add tuned-tensor@tunedtensor
```

Start a new Codex thread after installing so the skills are available.

## Included Skills

- `tuned-tensor`: CLI setup, local/cloud routing, managed or bring-your-own inference, and account reporting.
- `tuned-tensor-fine-tune`: create and validate specs, execute one pipeline on local or AWS GPUs, and inspect evaluation reports.
- `tuned-tensor-serve-local`: verify and serve local adapters, or download, export, and serve completed cloud models.

## Requirements

Install one CLI package. Node.js 22.19+ is required:

```bash
npm install -g --ignore-scripts @tuned-tensor/cli
tt --version
tt status
```

Local commands require no Tuned Tensor access token. Training additionally needs local `uv` and supported NVIDIA CUDA hardware locally or on an AWS instance:

```bash
tt init --name "Customer Support Bot" --model Qwen/Qwen3.5-2B
# Edit tunedtensor.json, including the system prompt and both example placeholders.
tt validate tunedtensor.json
tt models prefetch tunedtensor.json
tt doctor tunedtensor.json
tt pipeline run --spec tunedtensor.json --dry-run
```

For AWS training, follow the [AWS first-run guide](https://github.com/tunedtensor/tuned-tensor-cli/blob/main/docs/local-runtime/aws-gpu.md).
Add `gpu` to `local-runner.json` beside your spec before running the commands
above. You provide a running EC2 GPU, AWS credentials and SSH access. The laptop
orchestrates `tt pipeline run`; no TT token or credits are required. Keep it
awake until outputs return, and manage instance shutdown yourself. Hosted
training start/estimate are retired; `tt cloud` accesses account records.

For managed agent inference or account operations, use the same Tuned Tensor access token:

```bash
tt auth login
tt agent configure --provider tunedtensor
tt cloud runs list --summary --json
tt balance
tt usage
```

`tt auth login` prompts for the token with hidden input. Managed inference uses the server-selected model and needs no separate OpenRouter key. To use your own OpenRouter key and choose your own model, open `tt`, run `/login openrouter`, then `/model openrouter/<model-id>`. Agent inference choice and local/cloud execution placement are independent.

These skills target CLI 0.16.0 or newer, which includes user-owned AWS GPU support. Check `tt --version` and `tt --help` before using an older installed release; local-only releases do not register account or cloud commands. `tt local ...` is a compatibility alias, not a separate tool.

## Update

```bash
codex plugin marketplace upgrade tunedtensor
codex plugin add tuned-tensor@tunedtensor
```

Start a new Codex thread after updating.

## Sources

- [Tuned Tensor](https://tunedtensor.com/)
- [Documentation](https://tunedtensor.com/docs)
- [CLI repository](https://github.com/tunedtensor/tuned-tensor-cli)
