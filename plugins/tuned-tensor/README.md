# Tuned Tensor Codex Plugin

This local Codex plugin teaches agents how to use Tuned Tensor through TT Local for local-first training/evaluation and the optional managed `tt` CLI for account-backed runs, datasets, model artifacts, and local serving.

## Contents

- `.codex-plugin/plugin.json` - plugin metadata for Codex.
- `skills/tuned-tensor/SKILL.md` - overview, local-vs-managed setup, and workflow routing.
- `skills/tuned-tensor-fine-tune/SKILL.md` - managed behaviour spec, eval, push, run, dataset, run report, and regression workflow.
- `skills/tuned-tensor-serve-local/SKILL.md` - download, serve, configure, and test local model serving.
- `scripts/check-tt.sh` - quick local CLI/auth/credit status check.

## Useful Links

- Tuned Tensor: https://tunedtensor.com/
- Documentation: https://tunedtensor.com/docs
- CLI repository: https://github.com/tunedtensor/tuned-tensor-cli
