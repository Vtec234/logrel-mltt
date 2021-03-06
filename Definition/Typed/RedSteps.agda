{-# OPTIONS --without-K --safe #-}

module Definition.Typed.RedSteps where

open import Definition.Untyped
open import Definition.Typed


-- Concatenation of type reduction closures
_⇨*_ : ∀ {Γ A B C} → Γ ⊢ A ⇒* B → Γ ⊢ B ⇒* C → Γ ⊢ A ⇒* C
id ⊢B ⇨* B⇒C = B⇒C
(A⇒A′ ⇨ A′⇒B) ⇨* B⇒C = A⇒A′ ⇨ (A′⇒B ⇨* B⇒C)

-- Concatenation of term reduction closures
_⇨∷*_ : ∀ {Γ A t u r} → Γ ⊢ t ⇒* u ∷ A → Γ ⊢ u ⇒* r ∷ A → Γ ⊢ t ⇒* r ∷ A
id ⊢u ⇨∷* u⇒r = u⇒r
(t⇒t′ ⇨ t′⇒u) ⇨∷* u⇒r = t⇒t′ ⇨ (t′⇒u ⇨∷* u⇒r)

-- Conversion of reduction closures
conv* : ∀ {Γ A B t u} → Γ ⊢ t ⇒* u ∷ A → Γ ⊢ A ≡ B → Γ ⊢ t ⇒* u ∷ B
conv* (id x) A≡B = id (conv x A≡B)
conv* (x ⇨ d) A≡B = conv x A≡B ⇨ conv* d A≡B

-- Universe of reduction closures
univ* : ∀ {Γ A B} → Γ ⊢ A ⇒* B ∷ U → Γ ⊢ A ⇒* B
univ* (id x) = id (univ x)
univ* (x ⇨ A⇒B) = univ x ⇨ univ* A⇒B

-- Application substitution of reduction closures
app-subst* : ∀ {Γ A B t t′ a} → Γ ⊢ t ⇒* t′ ∷ Π A ▹ B → Γ ⊢ a ∷ A
           → Γ ⊢ t ∘ a ⇒* t′ ∘ a ∷ B [ a ]
app-subst* (id x) a₁ = id (x ∘ⱼ a₁)
app-subst* (x ⇨ t⇒t′) a₁ = app-subst x a₁ ⇨ app-subst* t⇒t′ a₁
