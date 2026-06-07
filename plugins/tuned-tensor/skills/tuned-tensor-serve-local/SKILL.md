---
name: tuned-tensor-serve-local
description: Use when an agent needs to download, export, configure, run, test, or troubleshoot a completed Tuned Tensor model with tt models serve and its OpenAI-compatible local API.
---

# Tuned Tensor Local Serving

Use this skill when the user wants to run a completed Tuned Tensor model locally, export it to GGUF/Ollama, or inspect downloaded artifacts. The serving command exposes an OpenAI-compatible local API.

## Start State

Before downloading or starting a server:

```bash
tt --version
tt auth status
tt models list
```

If the user provides a run ID rather than a model ID, inspect the run first:

```bash
tt runs get <run-id>
```

Serve only completed models. If the run is still active, use:

```bash
tt runs watch <run-id>
```

## Choose A Target

`tt models serve` accepts any of these targets:

- A model ID or prefix.
- A downloaded model directory.
- A `.tar.gz` model artifact.

Inspect model details when needed:

```bash
tt models get <model-id>
```

Download only when the user needs a durable local artifact or offline handoff:

```bash
tt models download <model-id> --output model.tar.gz
tt models download <model-id> --output ./model-dir
```

Use `--force` only when the user intends to overwrite an existing output.

## Export For GGUF Or Ollama

Use `tt models export` when the user wants a llama.cpp GGUF file or an Ollama package instead of a live local server:

```bash
tt models export <model-id> --format gguf --quant q4_k_m --ollama
tt models export <model-id> --quant q8_0 --ollama --print-command
```

If llama.cpp tools are not on `PATH`, point the CLI at the local build:

```bash
tt models export <model-id> --llama-cpp /path/to/llama.cpp
tt models export <model-id> --convert-script /path/to/convert_hf_to_gguf.py --quantize-bin /path/to/llama-quantize
```

Use `--print-command` before running conversions in unfamiliar environments, and do not commit exported `.gguf` files, Modelfiles, downloaded archives, or extracted model directories.

## Serve The Model

Default local serving:

```bash
tt models serve <model-id>
```

Bind to an explicit host and port:

```bash
tt models serve <model-id> --host 127.0.0.1 --port 8000
```

Apply a behaviour spec as the default system prompt:

```bash
tt models serve <model-id> --spec tunedtensor.json
```

Disable automatic spec prompt injection:

```bash
tt models serve <model-id> --no-spec-prompt
```

Select device and generation defaults:

```bash
tt models serve <model-id> --device mps --max-tokens 512 --temperature 0.7
tt models serve <model-id> --device cpu
tt models serve <model-id> --device cuda
```

Use a cache directory for downloaded and extracted artifacts:

```bash
tt models serve <model-id> --cache-dir ./.tunedtensor-cache
```

Print the underlying Python command without starting the server:

```bash
tt models serve <model-id> --print-command
```

## Managed Mode

Use managed mode when the user wants a local lifecycle manager in front of the model server:

```bash
tt models serve <model-id> --managed --idle-timeout 300 --restart-after-requests 100
```

For JSON output workflows:

```bash
tt models serve <model-id> --json-schema schema.json --json-repair-attempts 1
```

Managed request logging:

```bash
tt models serve <model-id> --managed --log-file serving.jsonl --gate-field should_process
```

Do not create verbose request logs in a repository unless the user wants them; logs may contain sensitive prompts or outputs.

## Test The Local API

Once the server is running, test it from another shell:

```bash
curl http://127.0.0.1:8000/v1/models
```

Example chat completion:

```bash
curl http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "tuned-tensor-local",
    "messages": [
      {"role": "user", "content": "Hello"}
    ]
  }'
```

If the API model name differs, use the model name returned by `/v1/models`.

## Troubleshooting

- If the model is not found, run `tt models list` and `tt models get <model-id>`.
- If download or extraction fails, retry with a clean `--cache-dir`; use `--force-download` only when a stale cache is likely.
- If GPU startup fails, try `--device auto`, then `--device cpu` to separate environment issues from model issues.
- If local Python dependencies fail, use `--python <path>` with the intended Python executable.
- If the port is busy, choose another port with `--port`.

## Safety Rules

- Do not commit downloaded model artifacts, cache directories, serving logs, `.env` files, or credentials.
- Do not expose the server beyond localhost unless the user explicitly requests it.
- Do not print full API keys.
- Treat prompts and outputs in logs as potentially sensitive.
