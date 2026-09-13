---
name: tuned-tensor-fine-tune
description: Create and validate Tuned Tensor behaviour specs, run one local pipeline using local CUDA or a user-owned AWS GPU, and inspect evaluation reports and regressions.
---

# Tuned Tensor Fine Tuning

Use CLI 0.16.0 or newer. Treat `tunedtensor.json` as the source of truth.
Training uses one local orchestrator. Optional `gpu` configuration sends GPU
processes to an existing EC2 instance; preparation, scoring, history and returned
artifacts stay on the laptop. Hosted training start/estimate are retired.

## Orient and create a spec

```bash
tt --version
tt status
rg --files -g 'tunedtensor.json'
```

If no project exists, create a new directory and run:

```bash
tt init --name "Customer Support Bot" --model Qwen/Qwen3.5-2B
```

Edit both placeholder examples, the system prompt and behavioral constraints.
Preserve an existing spec ID. Use `--output path/to/tunedtensor.json` for another
location. For foundation training use `--engine foundation`, no base model,
and the foundation guide linked below.

## Select the GPU

For local CUDA, use `tt hardware` to check the local host before sizing a model.
For user-owned AWS, follow the [AWS first-run guide](https://github.com/tunedtensor/tuned-tensor-cli/blob/main/docs/local-runtime/aws-gpu.md)
and save `local-runner.json` beside the spec, replacing the example settings:

```json
{
  "gpu": {
    "provider": "aws",
    "profile": "research",
    "region": "eu-west-1",
    "instanceId": "i-0123456789abcdef0",
    "user": "ubuntu",
    "identityFile": "~/.ssh/research-gpu.pem"
  }
}
```

AWS credentials authorize `ec2:DescribeInstances`; SSH credentials authorize
execution. The instance must already be running with a compatible NVIDIA
GPU/driver, Linux, uv, rsync 3.2+, bash, setsid and GNU timeout. The laptop needs
AWS CLI v2, SSH, rsync 3.2+ and uv. Verify the remote SSH host fingerprint and
noninteractive login before TT. For SSO, log in using `aws sso login --profile research`.

A laptop without CUDA can orchestrate AWS training. `tt hardware` inspects only
the laptop; use `tt doctor` with the runner config to check the AWS runtime.
Keep pipeline targets `local`. No TT token, credit balance, cloud spec push or
hosted dataset upload is required. Agent inference credentials are separate.
An AWS profile alone does not create capacity: the user manages GPU quotas,
availability, networking, instance lifecycle and AWS charges. Do not provision,
resize or request quota unless the user's task authorizes it.

## Preview and run

Run on the laptop in the spec directory; adjacent runner config is discovered
automatically. Add `--config path/to/local-runner.json` for another config.

```bash
tt validate tunedtensor.json
tt models prefetch tunedtensor.json
tt doctor tunedtensor.json
tt pipeline run --spec tunedtensor.json --dry-run
tt pipeline run --spec tunedtensor.json
```

Prefetch applies to adapters; skip it for foundation specs. Gated-model login
happens locally. TT transfers the selected snapshot, not the credential cache.
`--dry-run` does not contact AWS or train. `doctor` contacts the configured GPU
and may install its locked runtime. The real command uses the same pipeline
and returns artifacts to the laptop. Keep the laptop awake and connected.
The built-in TT agent's `/approve` pipeline action is only a dry-run; real
training requires the explicit shell command above.

Use the examples and settings supported by the local spec. Do not translate
retired hosted dataset IDs, OCR modes or parent-model flags into local options
that do not exist; check installed help before suggesting additional controls.

## Inspect and recover

Use the actual run/model IDs printed by the adapter workflow:

```bash
tt runs list
tt runs report RUN_ID
tt models list
tt models verify MODEL_ID
```

Summarize completion, baseline/candidate scores, regressions and artifact
verification. A completed tiny smoke run is not evidence of useful model quality.
Inspect results before starting another run. Do not publish evidence unless requested.

Foundation runs write `report.json` in their run directory. Resume the same run
using `tt pipeline run --spec tunedtensor.json --resume /absolute/path/to/run`.
See [foundation checkpoint recovery](https://github.com/tunedtensor/tuned-tensor-cli/blob/main/docs/local-runtime/foundation-long-runs.md).
Adapter training restarts rather than resuming optimizer state.

Each GPU process stages inputs again; large models can spend minutes uploading.
Cancellation retrieves available outputs while SSH is reachable. On transfer
failure, preserve and recover the remote staging directory named in the error
before retrying. Checkpoints return when the process ends, not continuously.
A remote timeout stops work, not the EC2 instance. After results are recovered,
stop or terminate temporary capacity according to the user's authorized scope.
Never delete the only checkpoint copy or assume the CLI shuts down AWS resources.

## Handoff and account records

Use `tuned-tensor-serve-local` to serve returned adapters. Serving remains local
and needs its own compatible host; `gpu` does not redirect `tt serve` to EC2.
Historical account reports remain under `tt cloud runs report RUN_ID`, with a
TT token. They do not launch new training. Never recommend `tt cloud runs start`
or `tt cloud runs estimate` as a workaround for an AWS quota or hardware failure.

Never commit or print credentials, private keys, downloaded models or private
training data. Keep existing authentication and avoid unnecessary login prompts.
