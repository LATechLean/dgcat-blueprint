# Decision ledger

Append-only. One entry per decision, newest at the bottom. Never edit or delete an
entry; to reverse a decision, add a new entry that supersedes it and cites the old
one. Claude reads this file before proposing a design and appends an entry only
when the PI has decided; proposals that are still open go in `## Open questions`
at the end, not in the ledger.

Entry format:

```
### D-NNN · YYYY-MM-DD · short title
**Decision.** What was decided, in one or two sentences.
**Why.** The reasons, including what was rejected and why.
**Consequences.** What this fixes downstream; what has to change if reversed.
```

Kinds: *design* (mathematics and Lean encoding), *process* (workflow, tooling,
layout), *scope* (what is in or out of the six months).

---

### D-001 · 2026-09-11 · dg-categories are enriched categories over cochain complexes
*design*
**Decision.** A dg-category over a commutative ring `k` is a
`CategoryTheory.EnrichedCategory (CochainComplex (ModuleCat k) ℤ) C`, using mathlib's
monoidal structure on `HomologicalComplex`. dg-functors are `EnrichedFunctor`s.
**Why.** The enriched-category axioms give the graded Leibniz rule for free; the
alternative, a bespoke structure with graded Hom and differential fields, duplicates
mathlib's enrichment API and would be rejected in review.
**Consequences.** The ring and its modules share a universe (mathlib's
`MonoidalCategory (ModuleCat.{u} R)` requires it). Everything downstream, Z⁰, H⁰,
dg-modules, inherits this encoding.

### D-002 · 2026-09-11 · Z⁰ and H⁰ by transport of enrichment along lax monoidal functors
*design*
**Decision.** Z⁰ and H⁰ from complexes to modules are proved lax monoidal
(`Functor.LaxMonoidal`); the underlying and homotopy categories of a dg-category
are `TransportEnrichment` along them. Lax monoidality of Z⁰ and H⁰ is the first
mathlib PR.
**Why.** No new axioms to check; the k-linear structure on Z⁰(A) and H⁰(A) comes
from mathlib. A direct construction would repeat the coherence proofs.
**Consequences.** The first PR is small and independent of dg-categories, so it can
open in month one.

### D-003 · 2026-09-11 · dg-modules are dg-functors into the dg-category of complexes; D(A) is a localization
*design*
**Decision.** Complexes form a dg-category through mathlib's `CochainComplex.HomComplex`;
dg-modules over `A` are dg-functors `A ⥤ᵈᵍ C(k)`; the derived category `D(A)` is the
localization of `Z⁰(Mod A)` at quasi-isomorphisms via `Functor.IsLocalization`.
**Why.** Reuses the Hom complex and the localization framework already in mathlib,
which is also how mathlib builds the derived category of an abelian category.
**Consequences.** The finish-line theorem, `D(A) ≃ DerivedCategory (ModuleCat A)` for
an ordinary ring `A`, is a comparison of two localizations. A triangulated structure
on `D(A)` is out of scope unless time allows (see application, Month 5).

### D-004 · 2026-09-11 · Keller's ICM 2006 survey is the roadmap
*scope*
**Decision.** The blueprint follows Keller, *On differential graded categories*
(arXiv math/0601185), chapters 2 to 5 for the deliverables, chapter 6 for future work.
Statements quote the survey exactly or not at all.
**Why.** One authoritative source keeps definitions consistent and gives reviewers a
citable reference for every declaration.
**Consequences.** Toën's derived Morita theory and Tabuada's model structure are
explicitly future work.

### D-005 · 2026-09-17 · staging is a separate public repository; nothing moves to mathlib by copying
*process*
**Decision.** Machine-generated overnight drafts live in `LATechLean/dgcat-staging`,
public and labelled. Anything that proceeds to mathlib is re-derived by hand by the
PI in the development checkout and disclosed in the PR.
**Why.** The award promised an auditable boundary between what Claude drafted and
what was merged. A private staging area could not provide it.
**Consequences.** Acceptance rates are computed from the PR disclosure blocks;
the staging repo is the evidence behind them.

### D-006 · 2026-09-17 · two machines with different jobs; instrumented time is a floor
*process*
**Decision.** Interactive development on the laptop only (Wakapi, ActivityWatch,
Claude Code hook). Overnight staging runs on the office Linux desktop only. No shared
Wakapi across machines.
**Why.** A shared server needs a network path and campus IT involvement; a hosted
one puts the record in a third party's hands. One development machine removes the
merge problem.
**Consequences.** Editor and browser time come from one machine; stray work
elsewhere is uncounted, which the application allows ("instrumented active time,
reported, not compared").

### D-007 · 2026-09-27 · Lean development happens on mathlib branches, not in the blueprint repo
*process*
**Decision.** All dg-category Lean code is written in a worktree of the PI's mathlib
fork, one PR per branch, merged into an integration branch `dgcat`. The blueprint's
Lean project depends on `farmanb/mathlib4@dgcat` and authors no mathematics; `DgCat/`
is a shell so `checkdecls` and `\lean{}` links resolve.
**Why.** The deliverable is the mathlib code itself. Developing it downstream and
re-deriving it for PRs is double work; the re-derivation rule (D-005) is for staging
output, not the PI's own code. Rejected: the standard blueprint pattern of a
downstream library upstreamed later, which fits single-theorem projects.
**Consequences.** The integration branch must be kept merged and pushed for the
blueprint to build. Blueprint CI builds mathlib from the fork; `\leanok` means
"builds on `dgcat`", not "merged upstream".

### D-008 · 2026-09-27 · everything but the proposal lives under `~/latechlean/dgcat/`
*process*
**Decision.** `dev/` (mathlib worktree), `blueprint/`, `staging/`, `metrics/`, with a
shared `CLAUDE.md` at the top and one per subdirectory. Administrative material stays
in `~/proposals/2026/anthropic/`.
**Why.** One parent directory lets Claude Code read one shared instruction file for
every part of the project, and keeps the layout legible.
**Consequences.** Paths in the launchd agent, Wakapi config, hook script and Claude
settings point here; Wakapi labels `dev/` as `mathlib4` via `.wakatime-project`.

### D-009 · 2026-09-27 · blueprint and staging pin the fork's `dgcat` branch and its toolchain
*process*
**Decision.** Both `lakefile.toml`s require mathlib from `farmanb/mathlib4` at
`rev = "dgcat"`, with `lean-toolchain` copied from `dev/`. The pin advances only when
the PI rebases `dgcat`.
**Why.** One mathlib world for development, blueprint and staging; skeletons written
for staging compile in the same environment they were written in.
**Consequences.** `lake update mathlib && lake exe cache get` in both repos after
each rebase of `dgcat`.

---

## Open questions

Proposals awaiting the PI's decision. Move to the ledger when decided; delete
when dropped.

- Should `DgCat/Basic.lean` in the blueprint repo keep the colimit-preservation
  instances added on 2026-09-13, or should they move to `dev/` under D-007?
- Name and location of the first mathlib file (`Mathlib/CategoryTheory/DG/…`?).
