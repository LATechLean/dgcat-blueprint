/-
Copyright (c) 2026 Blake Farman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Blake Farman
-/
import Mathlib.CategoryTheory.Enriched.Basic
import Mathlib.Algebra.Homology.Monoidal
import Mathlib.Algebra.Homology.ComplexShapeSigns
import Mathlib.Algebra.Category.ModuleCat.Monoidal.Closed
import Mathlib.Algebra.Category.ModuleCat.Colimits
-- Mathlib prerequisites cited by the blueprint (checked by `checkdecls`).
import Mathlib.Algebra.Homology.HomotopyCategory
import Mathlib.Algebra.Homology.HomotopyCategory.HomComplex
import Mathlib.Algebra.Homology.DerivedCategory.Basic
import Mathlib.CategoryTheory.Localization.Predicate

/-!
# Differential graded categories

A dg-category over a commutative ring `k` is a category enriched over the monoidal category
of cochain complexes of `k`-modules (Keller, *On differential graded categories*, §2.2).
The enriched-category axioms encode the graded Leibniz rule: composition is a chain map.

This file is the entry point of the blueprint project; see `blueprint/` for the roadmap.
Nothing here is final: the design is fixed by the PI, and the surrounding lemma layer is
developed against the blueprint's dependency graph.

## Implementation notes

Mathlib's monoidal structure on `HomologicalComplex C c` (for `c = ComplexShape.up ℤ`) needs
`C` to have the coproducts indexed by the fibres of `(i, j) ↦ i + j`, and the functors
`X ⊗ -` and `- ⊗ X` to preserve them. For `C = ModuleCat k` the coproducts come from
`ModuleCat` having all colimits, and the preservation from `X ⊗ -` being a left adjoint
(`ModuleCat` is monoidal closed) together with the braiding `X ⊗ - ≅ - ⊗ X`. Mathlib states
these hypotheses in terms of `curriedTensor`, so we register them in that form here.

The ring and its modules live in the same universe `u`: this is what mathlib's
`MonoidalCategory (ModuleCat.{u} R)` instance requires.
-/

universe u w

open CategoryTheory Limits MonoidalCategory

namespace DgCat

variable (k : Type u) [CommRing k]

/-- `X ⊗ -` preserves colimits in `ModuleCat k`: it is left adjoint to the internal hom. -/
instance (X : ModuleCat.{u} k) :
    PreservesColimitsOfSize.{0, 0} ((curriedTensor (ModuleCat.{u} k)).obj X) :=
  preservesSmallestColimits_of_preservesColimits (tensorLeft X)

/-- `- ⊗ X` preserves colimits in `ModuleCat k`, via the braiding `X ⊗ - ≅ - ⊗ X`. -/
instance (X : ModuleCat.{u} k) :
    PreservesColimitsOfSize.{0, 0} ((curriedTensor (ModuleCat.{u} k)).flip.obj X) :=
  haveI : PreservesColimitsOfSize.{0, 0} (tensorLeft X) :=
    preservesSmallestColimits_of_preservesColimits (tensorLeft X)
  preservesColimits_of_natIso (BraidedCategory.tensorLeftIsoTensorRight X)

/-- The monoidal category of cochain complexes of `k`-modules, the base of enrichment. -/
abbrev Ch := CochainComplex (ModuleCat.{u} k) ℤ

/-- Sanity check: the base of enrichment is a monoidal category. -/
noncomputable example : MonoidalCategory (Ch k) := inferInstance

/-- A dg-category over `k`: a category enriched over cochain complexes of `k`-modules. -/
abbrev DGCategory (C : Type w) := EnrichedCategory (Ch k) C

end DgCat
