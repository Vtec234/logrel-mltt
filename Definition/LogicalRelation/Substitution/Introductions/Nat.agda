{-# OPTIONS --without-K #-}

open import Definition.Typed.EqualityRelation

module Definition.LogicalRelation.Substitution.Introductions.Nat {{eqrel : EqRelSet}} where
open EqRelSet {{...}}

open import Definition.Untyped
open import Definition.Typed
open import Definition.Typed.Properties
open import Definition.LogicalRelation
open import Definition.LogicalRelation.Properties
open import Definition.LogicalRelation.Substitution
open import Definition.LogicalRelation.Substitution.Introductions.Universe

open import Tools.Unit
open import Tools.Product


ℕₛ : ∀ {Γ l} ([Γ] : ⊩ₛ Γ) → Γ ⊩ₛ⟨ l ⟩ ℕₑ / [Γ]
ℕₛ [Γ] ⊢Δ [σ] = ℕ (idRed:*: (ℕ ⊢Δ)) , λ _ x₂ → id (ℕ ⊢Δ)

ℕₜₛ : ∀ {Γ} ([Γ] : ⊩ₛ Γ)
    → Γ ⊩ₛ⟨ ¹ ⟩ ℕₑ ∷ Uₑ / [Γ] / Uₛ [Γ]
ℕₜₛ [Γ] ⊢Δ [σ] = let ⊢ℕ  = ℕ ⊢Δ
                     [ℕ] = ℕ (idRed:*: (ℕ ⊢Δ))
                 in  Uₜ ℕₑ (idRedTerm:*: ⊢ℕ) ℕ (≅ₜ-ℕrefl ⊢Δ) [ℕ]
                 ,   (λ x x₁ → Uₜ₌ ℕₑ ℕₑ (idRedTerm:*: ⊢ℕ) (idRedTerm:*: ⊢ℕ) ℕ ℕ
                                   (≅ₜ-ℕrefl ⊢Δ) [ℕ] [ℕ] (id (ℕ ⊢Δ)))

zeroₛ : ∀ {Γ} ([Γ] : ⊩ₛ Γ)
      → Γ ⊩ₛ⟨ ¹ ⟩ zeroₑ ∷ ℕₑ / [Γ] / ℕₛ [Γ]
zeroₛ [Γ] ⊢Δ [σ] =
  ℕₜ zeroₑ (idRedTerm:*: (zero ⊢Δ)) (≅ₜ-zerorefl ⊢Δ) zero
    , (λ _ x₁ → ℕₜ₌ zeroₑ zeroₑ (idRedTerm:*: (zero ⊢Δ)) (idRedTerm:*: (zero ⊢Δ))
                    (≅ₜ-zerorefl ⊢Δ) zero)

sucₛ : ∀ {Γ n l} ([Γ] : ⊩ₛ Γ)
         ([ℕ] : Γ ⊩ₛ⟨ l ⟩ ℕₑ / [Γ])
     → Γ ⊩ₛ⟨ l ⟩ n ∷ ℕₑ / [Γ] / [ℕ]
     → Γ ⊩ₛ⟨ l ⟩ sucₑ n ∷ ℕₑ / [Γ] / [ℕ]
sucₛ ⊢Γ [ℕ] [n] ⊢Δ [σ] =
  sucTerm (proj₁ ([ℕ] ⊢Δ [σ])) (proj₁ ([n] ⊢Δ [σ]))
  , (λ x x₁ → sucEqTerm (proj₁ ([ℕ] ⊢Δ [σ])) (proj₂ ([n] ⊢Δ [σ]) x x₁))
