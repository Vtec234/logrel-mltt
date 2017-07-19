{-# OPTIONS --without-K #-}

module Definition.Typed.Consequences.Equality where

open import Definition.Untyped
open import Definition.Untyped.Properties
open import Definition.Typed
open import Definition.Typed.Properties
open import Definition.Typed.EqRelInstance
open import Definition.LogicalRelation
open import Definition.LogicalRelation.Irrelevance
open import Definition.LogicalRelation.Tactic
open import Definition.LogicalRelation.Substitution
open import Definition.LogicalRelation.Substitution.Properties
open import Definition.LogicalRelation.Substitution.Soundness
open import Definition.LogicalRelation.Fundamental

open import Tools.Product
open import Tools.Empty
open import Tools.Unit
import Tools.PropositionalEquality as PE


U≡A' : ∀ {A Γ l} ([U] : Γ ⊩⟨ l ⟩U)
    → Γ ⊩⟨ l ⟩ Uₑ ≡ A / (U-intr [U])
    → A PE.≡ Uₑ
U≡A' (noemb [U]) [U≡A] = [U≡A]
U≡A' (emb 0<1 [U]) [U≡A] = U≡A' [U] [U≡A]

U≡A : ∀ {A Γ}
    → Γ ⊢ Uₑ ≡ A
    → A PE.≡ Uₑ
U≡A {A} U≡A with fundamentalEq U≡A
U≡A {A} U≡A | [Γ] , [U] , [A] , [U≡A] =
  let [U]' = soundness [Γ] [U]
      [U≡A]' = soundnessEq {Uₑ} {A} [Γ] [U] [U≡A]
  in  U≡A' (U-elim [U]') (irrelevanceEq [U]' (U-intr (U-elim [U]')) [U≡A]')

ℕ≡A' : ∀ {A Γ l} ([ℕ] : Γ ⊩⟨ l ⟩ℕ ℕₑ)
    → Γ ⊩⟨ l ⟩ ℕₑ ≡ A / (ℕ-intr [ℕ])
    → Whnf A
    → A PE.≡ ℕₑ
ℕ≡A' (noemb x) [ℕ≡A] whnfA = whnfRed* [ℕ≡A] whnfA
ℕ≡A' (emb 0<1 [ℕ]) [ℕ≡A] whnfA = ℕ≡A' [ℕ] [ℕ≡A] whnfA

ℕ≡A : ∀ {A Γ}
    → Γ ⊢ ℕₑ ≡ A
    → Whnf A
    → A PE.≡ ℕₑ
ℕ≡A {A} ℕ≡A whnfA with fundamentalEq ℕ≡A
ℕ≡A {A} ℕ≡A whnfA | [Γ] , [ℕ] , [A] , [ℕ≡A] =
  let [ℕ]' = soundness [Γ] [ℕ]
      [ℕ≡A]' = soundnessEq {ℕₑ} {A} [Γ] [ℕ] [ℕ≡A]
  in  ℕ≡A' (ℕ-elim [ℕ]') (irrelevanceEq [ℕ]' (ℕ-intr (ℕ-elim [ℕ]')) [ℕ≡A]') whnfA

ne≡A' : ∀ {A K Γ l}
     → ([K] : Γ ⊩⟨ l ⟩ne K)
     → Γ ⊩⟨ l ⟩ K ≡ A / (ne-intr [K])
     → Whnf A
     → ∃ λ M → Neutral M × A PE.≡ M
ne≡A' (noemb [K]) (ne₌ M D' neM K≡M) whnfA =
  M , neM , (whnfRed* (red D') whnfA)
ne≡A' (emb 0<1 [K]) [K≡A] whnfA = ne≡A' [K] [K≡A] whnfA

ne≡A : ∀ {A K Γ}
    → Neutral K
    → Γ ⊢ K ≡ A
    → Whnf A
    → ∃ λ M → Neutral M × A PE.≡ M
ne≡A {A} neK ne≡A whnfA with fundamentalEq ne≡A
ne≡A {A} neK ne≡A whnfA | [Γ] , [ne] , [A] , [ne≡A] =
  let ⊢Γ = soundContext [Γ]
      [id] = idSubstS [Γ]
      [ne]' = proj₁ ([ne] ⊢Γ [id])
      [ne≡A]' = irrelevanceEq'' {B' = A} PE.refl (subst-id _)
                                [ne]' [ne]' ([ne≡A] ⊢Γ [id])
      neK' = PE.subst Neutral (PE.sym (subst-id _)) neK
  in  ne≡A' (ne-elim neK' [ne]')
            (irrelevanceEq [ne]' (ne-intr (ne-elim neK' [ne]')) [ne≡A]') whnfA

Π≡A' : ∀ {A F G Γ l} ([Π] : Γ ⊩⟨ l ⟩Π Πₑ F ▹ G)
    → Γ ⊩⟨ l ⟩ Πₑ F ▹ G ≡ A / (Π-intr [Π])
    → Whnf A
    → ∃₂ λ H E → A PE.≡ Πₑ H ▹ E
Π≡A' (noemb [Π]) (Π₌ F' G' D' A≡B [F≡F'] [G≡G']) whnfA =
  F' , G' , whnfRed* D' whnfA
Π≡A' (emb 0<1 [Π]) [Π≡A] whnfA = Π≡A' [Π] [Π≡A] whnfA

Π≡A : ∀ {A F G Γ}
    → Γ ⊢ Πₑ F ▹ G ≡ A
    → Whnf A
    → ∃₂ λ H E → A PE.≡ Πₑ H ▹ E
Π≡A {A} Π≡A whnfA with fundamentalEq Π≡A
Π≡A {A} Π≡A whnfA | [Γ] , [Π] , [A] , [Π≡A] =
  let ⊢Γ = soundContext [Γ]
      [id] = idSubstS [Γ]
      [Π]' = proj₁ ([Π] ⊢Γ [id])
      [Π≡A]' = irrelevanceEq'' {B' = A} PE.refl (subst-id _)
                               [Π]' [Π]' ([Π≡A] ⊢Γ [id])
  in  Π≡A' (Π-elim [Π]') (irrelevanceEq [Π]' (Π-intr (Π-elim [Π]')) [Π≡A]') whnfA
