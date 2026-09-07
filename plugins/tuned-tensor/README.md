# Tuned Tensor Codex Plugin

This plugin teaches agents to use the unified `tt` CLI. Root commands operate locally without an account; `tt cloud ...` operates the cloud service. The local conversational agent can use a Tuned Tensor access token for managed inference, or a user's own provider key and model. The web app is the dashboard for cloud runs and published evidence.

## Contents

- `.codex-plugin/plugin.json` — plugin metadata.
- `skills/tuned-tensor/SKILL.md` — setup, inference providers, reporting, and workflow routing.
- `skills/tuned-tensor-fine-tune/SKILL.md` — local pipelines and optional cloud fine-tuning.
- `skills/tuned-tensor-serve-local/SKILL.md` — local serving and optional cloud artifact handoff.
- `scripts/check-tt.sh` — local CLI status; pass `--cloud` to include account, credit, and usage checks.

Use CLI 0.15.0 or newer for the documented `tt cloud` and managed-agent workflows. Earlier local-only releases still support the root local commands; inspect their installed help before using examples.

## Useful Links

- [Tuned Tensor](https://tunedtensor.com/)
- [Documentation](https://tunedtensor.com/docs)
- [CLI repository](https://github.com/tunedtensor/tuned-tensor-cli)
