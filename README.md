# Formalizing the dg-Enhancement of Triangulated Categories

A blueprint-driven formalization, in Lean 4 and mathlib, of the foundations of
differential graded categories following Bernhard Keller's ICM 2006 survey
[*On differential graded categories*](https://arxiv.org/abs/math/0601185):
dg-categories as categories enriched over cochain complexes, dg-functors, Z⁰ and H⁰,
quasi-equivalences, dg-modules, and the derived category of a dg-category, ending with the
theorem that the construction recovers mathlib's derived category of modules for an
ordinary algebra.

- **Blueprint** (dependency graph and informal statements): `blueprint/`, published at
  https://latechlean.github.io/dgcat-blueprint once CI runs.
- **Lean sources**: `DgCat/`.

## Building

Lean (requires [elan](https://github.com/leanprover/elan)):

```bash
lake exe cache get   # download mathlib oleans
lake build
```

Blueprint (requires `pip install leanblueprint` and a TeX distribution with `xelatex`):

```bash
leanblueprint pdf    # blueprint/print/print.pdf
leanblueprint web    # blueprint/web/index.html
leanblueprint serve  # preview the web version locally
```

## Status

Design fixed; Lean development beginning. Chapter 1 of the blueprint records the mathlib
prerequisites; Chapters 2 to 5 are the first-phase deliverables; Chapter 6 is future work.

## AI disclosure

Parts of this project are developed with Claude Code against a live Lean language server.
Every declaration submitted to mathlib is reviewed and understood by the author, and each
pull request description states which tools were used and how, following
[mathlib's policy on AI-generated contributions](https://leanprover-community.github.io/contribute/index.html).
Machine-generated drafts, when they exist, live in a separate staging repository and are
labelled as such; nothing moves from there to mathlib except by the author re-deriving it.

## License

GPL-3.0; see `LICENSE`.
