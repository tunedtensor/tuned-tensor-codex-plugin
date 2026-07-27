# Tuned Tensor Codex Plugin

This repository publishes the Tuned Tensor Codex plugin as a Git marketplace. It helps Codex agents fine-tune and evaluate Tuned Tensor behaviour-spec models with the unified `tt` CLI, use `tt local ...` for local GPU workflows, then serve completed models locally.

## Install

Add the marketplace:

```bash
codex plugin marketplace add tunedtensor/tuned-tensor-codex-plugin --ref main
```

Install the plugin:

```bash
codex plugin add tuned-tensor@tunedtensor
```

Start a new Codex thread after installing so the new skills are available.

## Included Skills

- `tuned-tensor`: overview, unified CLI setup, local-vs-cloud routing, safety rules, and routing.
- `tuned-tensor-fine-tune`: create specs, validate, push, estimate/start managed runs, inspect run reports/regressions, and upload datasets.
- `tuned-tensor-serve-local`: download, export to GGUF/Ollama, configure, serve, test, and troubleshoot local model serving.

## Requirements

Install one CLI package for both cloud and local workflows. Node.js 22+ is required:

```bash
npm install -g @tuned-tensor/cli
tt --version
tt status
```

For the optional managed Tuned Tensor service, authenticate with an API key:

```bash
tt auth login <api-key>
tt auth status
```

For local training/evaluation on a compatible NVIDIA GPU on Linux, use the same CLI with the local workflow:

```bash
tt local info
tt local init --name "Customer Support Bot" --model Qwen/Qwen3.5-2B --profile spark
```

## Update

Refresh the marketplace snapshot:

```bash
codex plugin marketplace upgrade tunedtensor
codex plugin add tuned-tensor@tunedtensor
```

Start a new Codex thread after updating.

## Sources

- Tuned Tensor: https://tunedtensor.com/
- Tuned Tensor docs: https://tunedtensor.com/docs
- Tuned Tensor CLI: https://github.com/tunedtensor/tuned-tensor-cli
