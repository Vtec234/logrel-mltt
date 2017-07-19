{-# OPTIONS --without-K #-}

module Definition.Typed.Consequences.SucCong where

open import Definition.Untyped
open import Definition.Typed
open import Definition.Typed.Weakening as T
open import Definition.Typed.Properties
open import Definition.Typed.Consequences.Syntactic
open import Definition.Typed.Consequences.Substitution

open import Tools.Nat
open import Tools.Product


sucCong : ∀ {F G Γ} → Γ ∙ ℕₑ ⊢ F ≡ G
        → Γ ⊢ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑)
            ≡ Πₑ ℕₑ ▹ (G ▹▹ G [ sucₑ (var zero) ]↑)
sucCong F≡G with wfEq F≡G
sucCong F≡G | ⊢Γ ∙ ⊢ℕ =
  let ⊢F , _ = syntacticEq F≡G
  in  Π-cong ⊢ℕ (refl ⊢ℕ)
             (Π-cong ⊢F F≡G
                     (wkEq (step id) (⊢Γ ∙ ⊢ℕ ∙ ⊢F)
                           (subst↑TypeEq F≡G
                                         (refl (suc (var (⊢Γ ∙ ⊢ℕ) here))))))
