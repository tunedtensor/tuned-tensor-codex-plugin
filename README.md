# Tuned Tensor Codex Plugin

This repository publishes the Tuned Tensor Codex plugin as a Git marketplace. It helps Codex agents fine-tune and evaluate Tuned Tensor behaviour-spec models with TT Local or the optional managed `tt` CLI, then serve completed models locally.

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

- `tuned-tensor`: overview, local-vs-managed setup, safety rules, and routing.
- `tuned-tensor-fine-tune`: create specs, validate, push, estimate/start managed runs, inspect run reports/regressions, and upload datasets.
- `tuned-tensor-serve-local`: download, export to GGUF/Ollama, configure, serve, test, and troubleshoot local model serving.

## Requirements

For local-first training and evaluation on a compatible NVIDIA GPU on Linux, install TT Local:

```bash
npm install -g @tuned-tensor/local
tt-local info
```

For the optional managed Tuned Tensor service, install and authenticate the managed CLI:

```bash
npm install -g @tuned-tensor/cli
tt auth login <api-key>
tt auth status
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
