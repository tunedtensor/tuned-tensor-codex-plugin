---
name: tuned-tensor-serve-local
description: Verify and serve local Tuned Tensor adapters, or download, export, and serve completed cloud models through an OpenAI-compatible local API.
---

# Tuned Tensor Local Serving

Use the root `tt serve` lifecycle for local adapters. Cloud model download, export, and serving are under `tt cloud models`. Both serving paths expose an OpenAI-compatible local API, but their model identifiers and options differ.

## Local Adapters

Local models and already-local artifacts do not require a Tuned Tensor access token. Start with local context:

```bash
tt --version
tt status
tt models list
tt runs report <run-id>
tt models verify local-<run-id>
tt serve local-<run-id> --config local-runner.json --print-command
tt serve local-<run-id> --config local-runner.json
```

Use the same runner config as the training run. `tt serve` accepts a local model ID, `active`, or `base`; it does not accept an arbitrary downloaded cloud archive. Inspect `tt serve --help` for options. The packaged vLLM server requires Linux and NVIDIA CUDA; CPU/macOS serving is not supported by this path. Local evaluation can use CPU. The separate cloud-artifact loader below retains its own device options.

Optional activation requires a verified model and a passing `generalRegression` suite configured for its run:

```bash
tt models activate local-<run-id> --config local-runner.json
tt serve active --config local-runner.json
```

Without a passing gate, serve the verified model explicitly instead of bypassing activation. `tt serve active` fails if no adapter has been activated. `tt serve base` requires `--spec tunedtensor.json` when the project instructions should be enforced.

Keep the default loopback bind. A user-requested non-loopback bind requires the CLI's `--allow-remote` and `--api-key-env <name>` options.

## Cloud Artifacts

The remaining artifact commands use `tt cloud models`. Fetching a remote model or cloud run requires the user's Tuned Tensor access token:

```bash
tt auth status
# Only if the requested remote operation needs a login:
tt auth login
tt cloud models list
```

Use the hidden login prompt and keep tokens out of arguments and logs. A downloaded directory or archive can be served or exported without account authentication.

If the user provides a cloud run ID, inspect completion before downloading:

```bash
tt cloud runs get <run-id>
tt cloud runs watch <run-id>
```

## Choose A Cloud Artifact Target

`tt cloud models serve` accepts any of these targets:

- A model ID or prefix.
- A downloaded model directory.
- A `.tar.gz` model artifact.

Inspect model details when needed:

```bash
tt cloud models get <model-id>
```

Download only when the user needs a durable local artifact or offline handoff:

```bash
tt cloud models download <model-id> --output model.tar.gz
tt cloud models download <model-id> --output ./model-dir
```

Use `--force` only when the user intends to overwrite an existing output.

## Export For GGUF Or Ollama

Use `tt cloud models export` when the user wants a llama.cpp GGUF file or an Ollama package instead of a live local server:

```bash
tt cloud models export <model-id> --format gguf --quant q4_k_m --ollama
tt cloud models export <model-id> --quant q8_0 --ollama --print-command
```

If llama.cpp tools are not on `PATH`, point the CLI at the local build:

```bash
tt cloud models export <model-id> --llama-cpp /path/to/llama.cpp
tt cloud models export <model-id> --convert-script /path/to/convert_hf_to_gguf.py --quantize-bin /path/to/llama-quantize
```

Use `--print-command` before running conversions in unfamiliar environments, and do not commit exported `.gguf` files, Modelfiles, downloaded archives, or extracted model directories.

## Serve A Cloud Artifact Locally

Cloud artifact serving on the local host:

```bash
tt cloud models serve <model-id>
```

Bind to an explicit host and port:

```bash
tt cloud models serve <model-id> --host 127.0.0.1 --port 8000
```

Apply a behaviour spec as the default system prompt:

```bash
tt cloud models serve <model-id> --spec tunedtensor.json
```

Disable automatic spec prompt injection:

```bash
tt cloud models serve <model-id> --no-spec-prompt
```

Select device and generation defaults:

```bash
tt cloud models serve <model-id> --device mps --max-tokens 512 --temperature 0.7
tt cloud models serve <model-id> --device cpu
tt cloud models serve <model-id> --device cuda
```

Use a cache directory for downloaded and extracted artifacts:

```bash
tt cloud models serve <model-id> --cache-dir ./.tunedtensor-cache
```

Print the underlying Python command without starting the server:

```bash
tt cloud models serve <model-id> --print-command
```

## Local Server Lifecycle For Cloud Artifacts

The `--managed` flag below selects a local server lifecycle manager; it is unrelated to managed agent inference or cloud execution:

```bash
tt cloud models serve <model-id> --managed --idle-timeout 300 --restart-after-requests 100
```

For JSON output workflows:

```bash
tt cloud models serve <model-id> --json-schema schema.json --json-repair-attempts 1
```

Managed request logging:

```bash
tt cloud models serve <model-id> --managed --log-file serving.jsonl --gate-field should_process
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

For Qwen3-VL or other multimodal artifacts, send OpenAI-style image content parts. Use a data URI or reachable image URL and keep local/private images out of logs:

```bash
curl http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "tuned-tensor-local",
    "messages": [
      {
        "role": "user",
        "content": [
          {"type": "text", "text": "Extract the invoice total as JSON."},
          {"type": "image_url", "image_url": {"url": "data:image/png;base64,<image-bytes>"}}
        ]
      }
    ]
  }'
```

If the API model name differs, use the model name returned by `/v1/models`.

## Troubleshooting

- If the model is not found, run `tt cloud models list` and `tt cloud models get <model-id>`.
- If download or extraction fails, retry with a clean `--cache-dir`; use `--force-download` only when a stale cache is likely.
- If GPU startup fails, try `--device auto`, then `--device cpu` to separate environment issues from model issues.
- If local Python dependencies fail, use `--python <path>` with the intended Python executable.
- If the port is busy, choose another port with `--port`.

## Safety Rules

- Do not commit downloaded model artifacts, cache directories, serving logs, `.env` files, or credentials.
- Do not expose the server beyond localhost unless the user explicitly requests it.
- Do not print full API keys.
- Treat prompts and outputs in logs as potentially sensitive.
