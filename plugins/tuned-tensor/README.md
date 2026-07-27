# Tuned Tensor Codex Plugin

This local Codex plugin teaches agents how to use Tuned Tensor through the unified `tt` CLI: normal `tt` commands for account-backed cloud runs, datasets, model artifacts, and serving, plus `tt local ...` commands for local-first training/evaluation on compatible GPU machines.

## Contents

- `.codex-plugin/plugin.json` - plugin metadata for Codex.
- `skills/tuned-tensor/SKILL.md` - overview, unified CLI setup, and workflow routing.
- `skills/tuned-tensor-fine-tune/SKILL.md` - managed behaviour spec, eval, push, run, dataset, run report, and regression workflow.
- `skills/tuned-tensor-serve-local/SKILL.md` - download, serve, configure, and test local model serving.
- `scripts/check-tt.sh` - quick local CLI/auth/credit status check.

## Useful Links

- Tuned Tensor: https://tunedtensor.com/
- Documentation: https://tunedtensor.com/docs
- CLI repository: https://github.com/tunedtensor/tuned-tensor-cli
