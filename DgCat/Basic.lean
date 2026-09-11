/-
Copyright (c) 2026 Blake Farman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Blake Farman
-/
import Mathlib.CategoryTheory.Enriched.Basic
import Mathlib.Algebra.Homology.Monoidal
import Mathlib.Algebra.Category.ModuleCat.Monoidal.Basic

/-!
# Differential graded categories

A dg-category over a commutative ring `k` is a category enriched over the monoidal category
of cochain complexes of `k`-modules (Keller, *On differential graded categories*, §2.2).
The enriched-category axioms encode the graded Leibniz rule: composition is a chain map.

This file is the entry point of the blueprint project; see `blueprint/` for the roadmap.
Nothing here is final: the design is fixed by the PI, and the surrounding lemma layer is
developed against the blueprint's dependency graph.
-/

universe v u w

open CategoryTheory

namespace DgCat

variable (k : Type u) [CommRing k]

/-- The monoidal category of cochain complexes of `k`-modules, the base of enrichment. -/
abbrev Ch := CochainComplex (ModuleCat.{v} k) ℤ

/-- A dg-category over `k`: a category enriched over cochain complexes of `k`-modules. -/
abbrev DGCategory (C : Type w) := EnrichedCategory (Ch.{v} k) C

end DgCat
