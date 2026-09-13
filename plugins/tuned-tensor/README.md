# Tuned Tensor Codex Plugin

This plugin teaches agents to use the unified `tt` CLI. Root commands orchestrate locally without an account and can use a user-owned AWS GPU; `tt cloud ...` accesses TT account records. The local conversational agent can use a Tuned Tensor access token for managed inference, or a user's own provider key and model. The web app is the dashboard for cloud runs and published evidence.

## Contents

- `.codex-plugin/plugin.json` — plugin metadata.
- `skills/tuned-tensor/SKILL.md` — setup, inference providers, reporting, and workflow routing.
- `skills/tuned-tensor-fine-tune/SKILL.md` — local pipelines and optional user-owned AWS training.
- `skills/tuned-tensor-serve-local/SKILL.md` — local serving and optional cloud artifact handoff.
- `scripts/check-tt.sh` — local CLI status; pass `--cloud` to include account, credit, and usage checks.

Use CLI 0.16.0 or newer for the documented AWS GPU and managed-agent workflows. Earlier local-only releases still support the root local commands; inspect their installed help before using examples.

## Useful Links

- [Tuned Tensor](https://tunedtensor.com/)
- [Documentation](https://tunedtensor.com/docs)
- [CLI repository](https://github.com/tunedtensor/tuned-tensor-cli)

## AWS training

Requires CLI 0.16.0+. The fine-tuning skill uses `tt pipeline run` with `gpu`
configuration for an existing EC2 instance. AWS profile lookup and SSH access
are separate; no TT token or credit balance is needed. Hosted training
start/estimate are retired. See the [AWS first-run guide](https://github.com/tunedtensor/tuned-tensor-cli/blob/main/docs/local-runtime/aws-gpu.md).
