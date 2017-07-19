{-# OPTIONS --without-K #-}

module Definition.Conversion.Universe where

open import Definition.Untyped
open import Definition.Typed
open import Definition.Typed.Properties
open import Definition.Typed.RedSteps
open import Definition.Conversion
open import Definition.Conversion.Reduction
open import Definition.Conversion.Lift

import Tools.PropositionalEquality as PE


univConv↓ : ∀ {A B Γ}
          → Γ ⊢ A [conv↓] B ∷ Uₑ
          → Γ ⊢ A [conv↓] B
univConv↓ (ne-ins t u () x)
univConv↓ (univ x x₁ x₂) = x₂

univConv↑ : ∀ {A B Γ}
      → Γ ⊢ A [conv↑] B ∷ Uₑ
      → Γ ⊢ A [conv↑] B
univConv↑ ([↑]ₜ B₁ t' u' D d d' whnfB whnft' whnfu' t<>u)
      rewrite PE.sym (whnfRed* D U) =
  reductionConv↑ (univ* d) (univ* d') whnft' whnfu' (liftConv (univConv↓ t<>u))
