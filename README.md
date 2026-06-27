# Tuned Tensor Codex Plugin

This repository publishes the Tuned Tensor Codex plugin as a Git marketplace. It helps Codex agents fine-tune Tuned Tensor behaviour-spec models and serve completed models locally with the `tt` CLI.

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

- `tuned-tensor`: overview, setup, safety rules, and routing.
- `tuned-tensor-fine-tune`: create specs, validate, push, estimate/start runs, inspect run reports/regressions, and upload datasets.
- `tuned-tensor-serve-local`: download, export to GGUF/Ollama, configure, serve, test, and troubleshoot local model serving.

## Requirements

Install the Tuned Tensor CLI:

```bash
npm install -g @tuned-tensor/cli
```

Authenticate:

```bash
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
