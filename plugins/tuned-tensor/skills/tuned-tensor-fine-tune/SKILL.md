---
name: tuned-tensor-fine-tune
description: Use when an agent needs to create behaviour specs, validate and push tunedtensor.json, launch Tuned Tensor fine-tuning runs, inspect regressions, upload datasets, or continue training from a parent model.
---

# Tuned Tensor Fine Tuning

Use this skill for the full path from behaviour spec to completed Tuned Tensor run. Prefer the `tt` CLI. Treat `tunedtensor.json` as the source of truth.

## Start State

Before changing or launching anything:

```bash
tt --version
tt auth status
tt balance
rg --files -g 'tunedtensor.json'
```

If auth is missing, stop and ask the user to authenticate safely. Do not print full API keys. Check credits before runs because training can spend balance.

## Create Or Locate The Spec

If no local spec exists, create one:

```bash
tt init --name "Customer Support Bot" --model Qwen/Qwen3.5-2B
```

Useful options:

```bash
tt init --name "Customer Support Bot" --model Qwen/Qwen3.5-2B --file tunedtensor.json
```

When updating an existing `tunedtensor.json`:

- Preserve the `id` field for remote spec updates.
- Keep the target base model explicit.
- Edit behaviour deliberately: system prompt, guidelines, constraints, examples, and evaluation expectations should explain the desired model behavior.
- Prefer small, reviewable edits over broad rewrites.

## Dataset-Backed Runs

If the user provides a JSONL dataset, inspect format and upload it:

```bash
tt datasets upload training.jsonl --name "Training data"
tt datasets list
```

Attach the dataset when starting the run:

```bash
tt runs start <spec-id> --dataset <dataset-id>
```

Optional split controls:

```bash
tt runs start <spec-id> --dataset <dataset-id> --train-ratio 0.8 --validation-ratio 0.1 --test-ratio 0.1
```

## Validate And Push

Always validate before pushing:

```bash
tt eval
tt push
```

For a non-default file path:

```bash
tt eval --file path/to/tunedtensor.json
tt push --file path/to/tunedtensor.json
```

Use global `--json` when another program needs structured output:

```bash
tt --json eval
tt --json runs get <run-id>
```

## Start A Run

Preview cost and rough wall-clock duration before starting, especially for dataset-backed, continued, or hyperparameter-heavy runs:

```bash
tt runs estimate <spec-id>
tt runs estimate <spec-id> --dataset <dataset-id> --epochs 4
```

Start with default training settings unless the user asks for specific hyperparameters:

```bash
tt runs start <spec-id>
```

Common controls:

```bash
tt runs estimate <spec-id> --epochs 3 --lr 0.0002 --batch-size 8
tt runs start <spec-id> --epochs 3 --lr 0.0002 --batch-size 8
tt runs start <spec-id> --max-eval-examples 100 --max-test-eval-examples 100
tt runs start <spec-id> --no-augment
tt runs start <spec-id> --no-llm-judge
```

Use long-example and output-budget controls when dataset rows or expected completions might exceed context limits:

```bash
tt runs start <spec-id> --long-examples truncate --max-seq-length 4096
tt runs start <spec-id> --max-output-tokens 512 --eval-reserved-output-tokens 128
```

Continue from a completed fine-tuned model only when the user wants incremental training:

```bash
tt runs estimate <spec-id> --parent-model <model-id>
tt runs start <spec-id> --parent-model <model-id>
```

## Watch And Inspect

Watch a run:

```bash
tt runs watch <run-id>
tt runs watch <run-id> --interval 10000
```

Inspect results:

```bash
tt runs get <run-id>
```

When reviewing a run, summarize:

- Status and completed model ID, if available.
- Pass/fail movement and aggregate scores.
- Failed examples and regressions.
- Judge notes or recurring failure patterns.
- The next smallest spec or dataset change to try.

Do not start another run until the previous run's result has been inspected.

## Model Handoff

Once a run completes, find and inspect the model:

```bash
tt models list
tt models get <model-id>
```

For local serving or artifact download, switch to the `tuned-tensor-serve-local` skill.

## Safety Rules

- Never commit API keys, `.env` files, downloaded models, or credentials.
- Never print full API keys.
- Confirm balance before training.
- Stop on insufficient credits and ask the user to add credits or approve top-up.
- Do not delete remote specs, datasets, runs, or models unless explicitly asked.
