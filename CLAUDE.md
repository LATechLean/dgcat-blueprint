# dgcat-blueprint

The public blueprint for *Formalizing the dg-Enhancement of Triangulated
Categories*. See `../CLAUDE.md` for the project and its rules.

## What this repo is for

A dependency graph and informal statements (LaTeX in `blueprint/src/`) mapping
Keller's ICM 2006 survey onto Lean declarations. The Lean declarations live in
mathlib, on the PI's fork branch `dgcat`, developed in `../dev/`. **No mathematics
is authored in this repo.** `DgCat/` is a thin shell whose only job is to import
the fork's modules so `checkdecls` and the `\lean{}` links resolve.

## Dependency

`lakefile.toml` requires mathlib from `farmanb/mathlib4` at branch `dgcat`, and
`lean-toolchain` must match that branch. When `dgcat` moves:

```
lake update mathlib && lake exe cache get && lake build
```

Never point this repo at upstream mathlib master directly; the dg declarations
are not there until merged.

## Blueprint conventions

- One `\begin{definition}` / `\begin{theorem}` / `\begin{lemma}` per declaration,
  each with `\label{}`, `\lean{Full.Declaration.Name}`, `\uses{...}`.
- `\leanok` only when the declaration builds on branch `dgcat` and `checkdecls`
  passes. A statement with `sorry` gets `\lean{}` but not `\leanok`.
- Chapter map: 1 mathlib prerequisites; 2 dg-categories and dg-functors; 3 Z⁰,
  H⁰, quasi-equivalences; 4 dg-modules; 5 the derived category D(A) and the
  ring-comparison theorem; 6 future work (triangulated structure, Morita).
- Statements are informal mathematics for a reader of Keller, with theorem
  numbers from the survey where they exist. Quote the survey exactly or not at all.

## Build

```
leanblueprint pdf      # blueprint/print/print.pdf
leanblueprint web      # blueprint/web/
leanblueprint serve    # local preview
```

CI (`.github/workflows/blueprint.yml`) builds the Lean project and publishes to
https://latechlean.github.io/dgcat-blueprint on push to `main`.
