---
name: tuned-tensor-fine-tune
description: Create and validate Tuned Tensor behaviour specs, run local fine-tuning pipelines or cloud runs, and inspect evaluation reports and regressions.
---

# Tuned Tensor Fine Tuning

Use this skill for the full path from behaviour spec to completed Tuned Tensor run. Prefer the `tt` CLI. Treat `tunedtensor.json` as the source of truth.

## Start State

Orient locally before editing or choosing execution placement:

```bash
tt --version
tt status
rg --files -g 'tunedtensor.json'
```

Spec creation, local validation, and local pipelines need no account token or agent inference key. Choose cloud execution only when the user requests it; cloud authentication and credits are checked at that boundary.

## Create Or Locate The Spec

If no local spec exists, create one:

```bash
tt init --name "Customer Support Bot" --model Qwen/Qwen3.5-2B
```

Useful options:

```bash
tt init --name "Customer Support Bot" --model Qwen/Qwen3.5-2B --output tunedtensor.json
```

When updating an existing `tunedtensor.json`:

- Preserve the `id` field for remote spec updates.
- Keep the target base model explicit.
- Edit behaviour deliberately: system prompt, guidelines, constraints, examples, and evaluation expectations should explain the desired model behavior.
- Prefer small, reviewable edits over broad rewrites.

## Local Pipeline

Use the local workflow on supported CUDA hardware. `--profile spark` on `tt init` writes an adjacent runner config when appropriate for the host. Inspect hardware before selecting a local base model:

```bash
tt hardware
tt validate tunedtensor.json
tt doctor tunedtensor.json
tt models prefetch tunedtensor.json
tt pipeline run --spec tunedtensor.json --dry-run
tt pipeline run --spec tunedtensor.json
tt runs list
tt runs report <run-id>
```

`tt pipeline run` derives the canonical recipe from the spec when no pipeline file exists. Use `--config <path>` for a non-default local runner config. Training and its artifacts stay on the execution host. Do not upload local evidence unless the user wants it published.

Inspect the completed report before proposing another training run. For local serving, use the `tuned-tensor-serve-local` skill with the resulting `local-<run-id>` model.

## Cloud Execution

The commands below operate the cloud service. Authenticate with the same Tuned Tensor access token used for managed agent inference; a separate OpenRouter key is not required:

```bash
tt auth login
tt auth status
tt balance
tt cloud models base
```

Use the hidden token prompt when login is needed. Preserve an existing login. Check balance before starting paid runs and inspect the cloud catalog rather than assuming every local model is cloud-supported.

## Dataset-Backed Runs

If the user provides a JSONL dataset, inspect format and upload it:

```bash
tt cloud datasets upload training.jsonl --name "Training data"
tt cloud datasets list
```

For document OCR/image-to-JSON datasets, use the explicit OCR format so the CLI validates image assets before upload:

```bash
tt cloud datasets upload ocr-training.jsonl --name "OCR training data" --format document_ocr_jsonl
```

Each OCR row should include an `input` object with `prompt` and `assets` fields plus a string `output`; each asset can use image metadata and a `data_uri`, `uri`, or `path` reference. Prefer `Qwen/Qwen3-VL-2B-Instruct` for small document/OCR multimodal runs.

Attach the dataset when starting the run:

```bash
tt cloud runs start <spec-id> --dataset <dataset-id>
```

Optional split controls:

```bash
tt cloud runs start <spec-id> --dataset <dataset-id> --train-ratio 0.8 --validation-ratio 0.1 --test-ratio 0.1
```

## Validate And Push

Validate locally before pushing; `tt cloud push` also checks cloud compatibility:

```bash
tt validate tunedtensor.json
tt cloud push
```

For a non-default file path:

```bash
tt validate path/to/tunedtensor.json
tt cloud push --file path/to/tunedtensor.json
```

Use global `--json` when another program needs structured output:

```bash
tt --json validate tunedtensor.json
tt --json cloud runs get <run-id>
tt --json cloud runs report <run-id>
```

## Start A Run

Preview cost and rough wall-clock duration before starting, especially for dataset-backed, continued, or hyperparameter-heavy runs:

```bash
tt cloud runs estimate <spec-id>
tt cloud runs estimate <spec-id> --dataset <dataset-id> --epochs 4
```

Start with default training settings unless the user asks for specific hyperparameters:

```bash
tt cloud runs start <spec-id>
```

Common controls:

```bash
tt cloud runs estimate <spec-id> --epochs 3 --lr 0.0002 --batch-size 8
tt cloud runs start <spec-id> --epochs 3 --lr 0.0002 --batch-size 8
tt cloud runs start <spec-id> --max-eval-examples 100 --max-test-eval-examples 100
tt cloud runs start <spec-id> --no-augment
tt cloud runs start <spec-id> --no-llm-judge
```

Use long-example and output-budget controls when dataset rows or expected completions might exceed context limits:

```bash
tt cloud runs start <spec-id> --long-examples truncate --max-seq-length 4096
tt cloud runs start <spec-id> --max-output-tokens 512 --eval-reserved-output-tokens 128
```

Continue from a completed fine-tuned model only when the user wants incremental training:

```bash
tt cloud runs estimate <spec-id> --parent-model <model-id>
tt cloud runs start <spec-id> --parent-model <model-id>
```

## Watch And Inspect

Watch a run:

```bash
tt cloud runs watch <run-id>
tt cloud runs watch <run-id> --interval 10000
```

Inspect results:

```bash
tt cloud runs list --summary --json
tt cloud runs get <run-id>
tt cloud runs report <run-id>
```

Use `tt cloud runs list --summary --json` when an agent or script only needs compact run status, scores, and pagination without detailed evaluation/event payloads. Use `tt cloud runs report <run-id>` to compare aggregate base-vs-tuned metrics and inspect side-by-side Expected, Base, and Tuned outputs for top regressions. For the worst tuned failures instead of regressions, use:

```bash
tt cloud runs report <run-id> --mode failures
```

For held-out test examples, use:

```bash
tt cloud runs report <run-id> --split test
tt cloud runs report <run-id> --split all
```

When reviewing a run, summarize:

- Status and completed model ID, if available.
- Pass/fail movement and aggregate scores.
- Failed examples and regressions, including Expected/Base/Tuned differences from `tt cloud runs report` when available.
- Judge notes or recurring failure patterns.
- The next smallest spec or dataset change to try.

Do not start another run until the previous run's result has been inspected.

## Model Handoff

Once a run completes, find and inspect the model:

```bash
tt cloud models list
tt cloud models get <model-id>
```

For local serving or artifact download, switch to the `tuned-tensor-serve-local` skill.

## Safety Rules

- Never commit API keys, `.env` files, downloaded models, or credentials.
- Never print full API keys.
- Confirm balance before paid cloud training; local training has no Tuned Tensor credit requirement.
- Stop on insufficient credits and ask the user to add credits or approve top-up.
- Do not delete remote specs, datasets, runs, or models unless explicitly asked.
