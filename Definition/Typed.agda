{-# OPTIONS --without-K --safe #-}

module Definition.Typed where

open import Definition.Untyped

open import Tools.Nat using (Nat)
open import Tools.Product


infixl 30 _∙_
infix 30 Πⱼ_▹_
infix 30 Σⱼ_▹_
infix 30 ⟦_⟧ⱼ_▹_


-- Well-typed variables
data _∷_∈_ : (x : Nat) (A : Term) (Γ : Con Term) → Set where
  here  : ∀ {Γ A}                     →         0 ∷ wk1 A ∈ (Γ ∙ A)
  there : ∀ {Γ A B x} (h : x ∷ A ∈ Γ) → Nat.suc x ∷ wk1 A ∈ (Γ ∙ B)

mutual
  -- Well-formed context
  data ⊢_ : Con Term → Set where
    ε   : ⊢ ε
    _∙_ : ∀ {Γ A}
        → ⊢ Γ
        → Γ ⊢ A
        → ⊢ Γ ∙ A

  -- Well-formed type
  data _⊢_ (Γ : Con Term) : Term → Set where
    Uⱼ     : ⊢ Γ → Γ ⊢ U
    ℕⱼ     : ⊢ Γ → Γ ⊢ ℕ
    Emptyⱼ : ⊢ Γ → Γ ⊢ Empty
    Unitⱼ  : ⊢ Γ → Γ ⊢ Unit
    Πⱼ_▹_  : ∀ {F G}
           → Γ     ⊢ F
           → Γ ∙ F ⊢ G
           → Γ     ⊢ Π F ▹ G
    Σⱼ_▹_  : ∀ {F G}
           → Γ     ⊢ F
           → Γ ∙ F ⊢ G
           → Γ     ⊢ Σ F ▹ G
    univ   : ∀ {A}
           → Γ ⊢ A ∷ U
           → Γ ⊢ A

  -- Well-formed term of a type
  data _⊢_∷_ (Γ : Con Term) : Term → Term → Set where
    Πⱼ_▹_     : ∀ {F G}
              → Γ     ⊢ F ∷ U
              → Γ ∙ F ⊢ G ∷ U
              → Γ     ⊢ Π F ▹ G ∷ U
    Σⱼ_▹_     : ∀ {F G}
              → Γ     ⊢ F ∷ U
              → Γ ∙ F ⊢ G ∷ U
              → Γ     ⊢ Σ F ▹ G ∷ U
    ℕⱼ        : ⊢ Γ → Γ ⊢ ℕ ∷ U
    Emptyⱼ    : ⊢ Γ → Γ ⊢ Empty ∷ U
    Unitⱼ     : ⊢ Γ → Γ ⊢ Unit ∷ U

    var       : ∀ {A x}
              → ⊢ Γ
              → x ∷ A ∈ Γ
              → Γ ⊢ var x ∷ A

    lamⱼ      : ∀ {F G t}
              → Γ     ⊢ F
              → Γ ∙ F ⊢ t ∷ G
              → Γ     ⊢ lam t ∷ Π F ▹ G
    _∘ⱼ_      : ∀ {g a F G}
              → Γ ⊢     g ∷ Π F ▹ G
              → Γ ⊢     a ∷ F
              → Γ ⊢ g ∘ a ∷ G [ a ]

    prodⱼ     : ∀ {F G t u}
              → Γ ⊢ F
              → Γ ∙ F ⊢ G
              → Γ ⊢ t ∷ F
              → Γ ⊢ u ∷ G [ t ]
              → Γ ⊢ prod t u ∷ Σ F ▹ G
    fstⱼ      : ∀ {F G t}
              → Γ ⊢ F
              → Γ ∙ F ⊢ G
              → Γ ⊢ t ∷ Σ F ▹ G
              → Γ ⊢ fst t ∷ F
    sndⱼ      : ∀ {F G t}
              → Γ ⊢ F
              → Γ ∙ F ⊢ G
              → Γ ⊢ t ∷ Σ F ▹ G
              → Γ ⊢ snd t ∷ G [ fst t ]

    zeroⱼ     : ⊢ Γ
              → Γ ⊢ zero ∷ ℕ
    sucⱼ      : ∀ {n}
              → Γ ⊢       n ∷ ℕ
              → Γ ⊢ suc n ∷ ℕ
    natrecⱼ   : ∀ {G s z n}
              → Γ ∙ ℕ ⊢ G
              → Γ       ⊢ z ∷ G [ zero ]
              → Γ       ⊢ s ∷ Π ℕ ▹ (G ▹▹ G [ suc (var Nat.zero) ]↑)
              → Γ       ⊢ n ∷ ℕ
              → Γ       ⊢ natrec G z s n ∷ G [ n ]

    Emptyrecⱼ : ∀ {A e}
              → Γ ⊢ A → Γ ⊢ e ∷ Empty → Γ ⊢ Emptyrec A e ∷ A

    starⱼ     : ⊢ Γ → Γ ⊢ star ∷ Unit

    conv      : ∀ {t A B}
              → Γ ⊢ t ∷ A
              → Γ ⊢ A ≡ B
              → Γ ⊢ t ∷ B

  -- Type equality
  data _⊢_≡_ (Γ : Con Term) : Term → Term → Set where
    univ   : ∀ {A B}
           → Γ ⊢ A ≡ B ∷ U
           → Γ ⊢ A ≡ B
    refl   : ∀ {A}
           → Γ ⊢ A
           → Γ ⊢ A ≡ A
    sym    : ∀ {A B}
           → Γ ⊢ A ≡ B
           → Γ ⊢ B ≡ A
    trans  : ∀ {A B C}
           → Γ ⊢ A ≡ B
           → Γ ⊢ B ≡ C
           → Γ ⊢ A ≡ C
    Π-cong : ∀ {F H G E}
           → Γ     ⊢ F
           → Γ     ⊢ F ≡ H
           → Γ ∙ F ⊢ G ≡ E
           → Γ     ⊢ Π F ▹ G ≡ Π H ▹ E
    Σ-cong : ∀ {F H G E}
           → Γ     ⊢ F
           → Γ     ⊢ F ≡ H
           → Γ ∙ F ⊢ G ≡ E
           → Γ     ⊢ Σ F ▹ G ≡ Σ H ▹ E

  -- Term equality
  data _⊢_≡_∷_ (Γ : Con Term) : Term → Term → Term → Set where
    refl          : ∀ {t A}
                  → Γ ⊢ t ∷ A
                  → Γ ⊢ t ≡ t ∷ A
    sym           : ∀ {t u A}
                  → Γ ⊢ t ≡ u ∷ A
                  → Γ ⊢ u ≡ t ∷ A
    trans         : ∀ {t u r A}
                  → Γ ⊢ t ≡ u ∷ A
                  → Γ ⊢ u ≡ r ∷ A
                  → Γ ⊢ t ≡ r ∷ A
    conv          : ∀ {A B t u}
                  → Γ ⊢ t ≡ u ∷ A
                  → Γ ⊢ A ≡ B
                  → Γ ⊢ t ≡ u ∷ B
    Π-cong        : ∀ {E F G H}
                  → Γ     ⊢ F
                  → Γ     ⊢ F ≡ H       ∷ U
                  → Γ ∙ F ⊢ G ≡ E       ∷ U
                  → Γ     ⊢ Π F ▹ G ≡ Π H ▹ E ∷ U
    Σ-cong        : ∀ {E F G H}
                  → Γ     ⊢ F
                  → Γ     ⊢ F ≡ H       ∷ U
                  → Γ ∙ F ⊢ G ≡ E       ∷ U
                  → Γ     ⊢ Σ F ▹ G ≡ Σ H ▹ E ∷ U
    app-cong      : ∀ {a b f g F G}
                  → Γ ⊢ f ≡ g ∷ Π F ▹ G
                  → Γ ⊢ a ≡ b ∷ F
                  → Γ ⊢ f ∘ a ≡ g ∘ b ∷ G [ a ]
    β-red         : ∀ {a t F G}
                  → Γ     ⊢ F
                  → Γ ∙ F ⊢ t ∷ G
                  → Γ     ⊢ a ∷ F
                  → Γ     ⊢ (lam t) ∘ a ≡ t [ a ] ∷ G [ a ]
    η-eq          : ∀ {f g F G}
                  → Γ     ⊢ F
                  → Γ     ⊢ f ∷ Π F ▹ G
                  → Γ     ⊢ g ∷ Π F ▹ G
                  → Γ ∙ F ⊢ wk1 f ∘ var Nat.zero ≡ wk1 g ∘ var Nat.zero ∷ G
                  → Γ     ⊢ f ≡ g ∷ Π F ▹ G
    fst-cong      : ∀ {t t' F G}
                  → Γ ⊢ F
                  → Γ ∙ F ⊢ G
                  → Γ ⊢ t ≡ t' ∷ Σ F ▹ G
                  → Γ ⊢ fst t ≡ fst t' ∷ F
    snd-cong      : ∀ {t t' F G}
                  → Γ ⊢ F
                  → Γ ∙ F ⊢ G
                  → Γ ⊢ t ≡ t' ∷ Σ F ▹ G
                  → Γ ⊢ snd t ≡ snd t' ∷ G [ fst t ]
    Σ-β₁          : ∀ {F G t u}
                  → Γ ⊢ F
                  → Γ ∙ F ⊢ G
                  → Γ ⊢ t ∷ F
                  → Γ ⊢ u ∷ G [ t ]
                  → Γ ⊢ fst (prod t u) ≡ t ∷ F
    Σ-β₂          : ∀ {F G t u}
                  → Γ ⊢ F
                  → Γ ∙ F ⊢ G
                  → Γ ⊢ t ∷ F
                  → Γ ⊢ u ∷ G [ t ]
                  → Γ ⊢ snd (prod t u) ≡ u ∷ G [ fst (prod t u) ]
    Σ-η           : ∀ {p r F G}
                  → Γ ⊢ F
                  → Γ ∙ F ⊢ G
                  → Γ ⊢ p ∷ Σ F ▹ G
                  → Γ ⊢ r ∷ Σ F ▹ G
                  → Γ ⊢ fst p ≡ fst r ∷ F
                  → Γ ⊢ snd p ≡ snd r ∷ G [ fst p ]
                  → Γ ⊢ p ≡ r ∷ Σ F ▹ G
    suc-cong      : ∀ {m n}
                  → Γ ⊢ m ≡ n ∷ ℕ
                  → Γ ⊢ suc m ≡ suc n ∷ ℕ
    natrec-cong   : ∀ {z z′ s s′ n n′ F F′}
                  → Γ ∙ ℕ ⊢ F ≡ F′
                  → Γ     ⊢ z ≡ z′ ∷ F [ zero ]
                  → Γ     ⊢ s ≡ s′ ∷ Π ℕ ▹ (F ▹▹ F [ suc (var Nat.zero) ]↑)
                  → Γ     ⊢ n ≡ n′ ∷ ℕ
                  → Γ     ⊢ natrec F z s n ≡ natrec F′ z′ s′ n′ ∷ F [ n ]
    natrec-zero   : ∀ {z s F}
                  → Γ ∙ ℕ ⊢ F
                  → Γ     ⊢ z ∷ F [ zero ]
                  → Γ     ⊢ s ∷ Π ℕ ▹ (F ▹▹ F [ suc (var Nat.zero) ]↑)
                  → Γ     ⊢ natrec F z s zero ≡ z ∷ F [ zero ]
    natrec-suc    : ∀ {n z s F}
                  → Γ     ⊢ n ∷ ℕ
                  → Γ ∙ ℕ ⊢ F
                  → Γ     ⊢ z ∷ F [ zero ]
                  → Γ     ⊢ s ∷ Π ℕ ▹ (F ▹▹ F [ suc (var Nat.zero) ]↑)
                  → Γ     ⊢ natrec F z s (suc n) ≡ (s ∘ n) ∘ (natrec F z s n)
                          ∷ F [ suc n ]
    Emptyrec-cong : ∀ {A A' e e'}
                  → Γ ⊢ A ≡ A'
                  → Γ ⊢ e ≡ e' ∷ Empty
                  → Γ ⊢ Emptyrec A e ≡ Emptyrec A' e' ∷ A
    η-unit        : ∀ {e e'}
                  → Γ ⊢ e ∷ Unit
                  → Γ ⊢ e' ∷ Unit
                  → Γ ⊢ e ≡ e' ∷ Unit

-- Term reduction
data _⊢_⇒_∷_ (Γ : Con Term) : Term → Term → Term → Set where
  conv           : ∀ {A B t u}
                 → Γ ⊢ t ⇒ u ∷ A
                 → Γ ⊢ A ≡ B
                 → Γ ⊢ t ⇒ u ∷ B
  app-subst      : ∀ {A B t u a}
                 → Γ ⊢ t ⇒ u ∷ Π A ▹ B
                 → Γ ⊢ a ∷ A
                 → Γ ⊢ t ∘ a ⇒ u ∘ a ∷ B [ a ]
  β-red          : ∀ {A B a t}
                 → Γ     ⊢ A
                 → Γ ∙ A ⊢ t ∷ B
                 → Γ     ⊢ a ∷ A
                 → Γ     ⊢ (lam t) ∘ a ⇒ t [ a ] ∷ B [ a ]
  fst-subst      : ∀ {t t' F G}
                 → Γ ⊢ F
                 → Γ ∙ F ⊢ G
                 → Γ ⊢ t ⇒ t' ∷ Σ F ▹ G
                 → Γ ⊢ fst t ⇒ fst t' ∷ F
  snd-subst      : ∀ {t t' F G}
                 → Γ ⊢ F
                 → Γ ∙ F ⊢ G
                 → Γ ⊢ t ⇒ t' ∷ Σ F ▹ G
                 → Γ ⊢ snd t ⇒ snd t' ∷ G [ fst t ]
  Σ-β₁           : ∀ {F G t u}
                 → Γ ⊢ F
                 → Γ ∙ F ⊢ G
                 → Γ ⊢ t ∷ F
                 → Γ ⊢ u ∷ G [ t ]
                 → Γ ⊢ fst (prod t u) ⇒ t ∷ F
  Σ-β₂           : ∀ {F G t u}
                 → Γ ⊢ F
                 → Γ ∙ F ⊢ G
                 → Γ ⊢ t ∷ F
                 → Γ ⊢ u ∷ G [ t ]
                 -- TODO(WN): Prove that 𝔍 ∷ G [ t ] is admissible
                 → Γ ⊢ snd (prod t u) ⇒ u ∷ G [ fst (prod t u) ]
  natrec-subst   : ∀ {z s n n′ F}
                 → Γ ∙ ℕ ⊢ F
                 → Γ     ⊢ z ∷ F [ zero ]
                 → Γ     ⊢ s ∷ Π ℕ ▹ (F ▹▹ F [ suc (var Nat.zero) ]↑)
                 → Γ     ⊢ n ⇒ n′ ∷ ℕ
                 → Γ     ⊢ natrec F z s n ⇒ natrec F z s n′ ∷ F [ n ]
  natrec-zero    : ∀ {z s F}
                 → Γ ∙ ℕ ⊢ F
                 → Γ     ⊢ z ∷ F [ zero ]
                 → Γ     ⊢ s ∷ Π ℕ ▹ (F ▹▹ F [ suc (var Nat.zero) ]↑)
                 → Γ     ⊢ natrec F z s zero ⇒ z ∷ F [ zero ]
  natrec-suc     : ∀ {n z s F}
                 → Γ     ⊢ n ∷ ℕ
                 → Γ ∙ ℕ ⊢ F
                 → Γ     ⊢ z ∷ F [ zero ]
                 → Γ     ⊢ s ∷ Π ℕ ▹ (F ▹▹ F [ suc (var Nat.zero) ]↑)
                 → Γ     ⊢ natrec F z s (suc n) ⇒ (s ∘ n) ∘ (natrec F z s n) ∷ F [ suc n ]
  Emptyrec-subst : ∀ {n n′ A}
                 → Γ ⊢ A
                 → Γ     ⊢ n ⇒ n′ ∷ Empty
                 → Γ     ⊢ Emptyrec A n ⇒ Emptyrec A n′ ∷ A

-- Type reduction
data _⊢_⇒_ (Γ : Con Term) : Term → Term → Set where
  univ : ∀ {A B}
       → Γ ⊢ A ⇒ B ∷ U
       → Γ ⊢ A ⇒ B

-- Term reduction closure
data _⊢_⇒*_∷_ (Γ : Con Term) : Term → Term → Term → Set where
  id  : ∀ {A t}
      → Γ ⊢ t ∷ A
      → Γ ⊢ t ⇒* t ∷ A
  _⇨_ : ∀ {A t t′ u}
      → Γ ⊢ t  ⇒  t′ ∷ A
      → Γ ⊢ t′ ⇒* u  ∷ A
      → Γ ⊢ t  ⇒* u  ∷ A

-- Type reduction closure
data _⊢_⇒*_ (Γ : Con Term) : Term → Term → Set where
  id  : ∀ {A}
      → Γ ⊢ A
      → Γ ⊢ A ⇒* A
  _⇨_ : ∀ {A A′ B}
      → Γ ⊢ A  ⇒  A′
      → Γ ⊢ A′ ⇒* B
      → Γ ⊢ A  ⇒* B

-- Type reduction to whnf
_⊢_↘_ : (Γ : Con Term) → Term → Term → Set
Γ ⊢ A ↘ B = Γ ⊢ A ⇒* B × Whnf B

-- Term reduction to whnf
_⊢_↘_∷_ : (Γ : Con Term) → Term → Term → Term → Set
Γ ⊢ t ↘ u ∷ A = Γ ⊢ t ⇒* u ∷ A × Whnf u

-- Type eqaulity with well-formed types
_⊢_:≡:_ : (Γ : Con Term) → Term → Term → Set
Γ ⊢ A :≡: B = Γ ⊢ A × Γ ⊢ B × (Γ ⊢ A ≡ B)

-- Term equality with well-formed terms
_⊢_:≡:_∷_ : (Γ : Con Term) → Term → Term → Term → Set
Γ ⊢ t :≡: u ∷ A = Γ ⊢ t ∷ A × Γ ⊢ u ∷ A × (Γ ⊢ t ≡ u ∷ A)

-- Type reduction closure with well-formed types
record _⊢_:⇒*:_ (Γ : Con Term) (A B : Term) : Set where
  constructor [_,_,_]
  field
    ⊢A : Γ ⊢ A
    ⊢B : Γ ⊢ B
    D  : Γ ⊢ A ⇒* B

open _⊢_:⇒*:_ using () renaming (D to red; ⊢A to ⊢A-red; ⊢B to ⊢B-red) public

-- Term reduction closure with well-formed terms
record _⊢_:⇒*:_∷_ (Γ : Con Term) (t u A : Term) : Set where
  constructor [_,_,_]
  field
    ⊢t : Γ ⊢ t ∷ A
    ⊢u : Γ ⊢ u ∷ A
    d  : Γ ⊢ t ⇒* u ∷ A

open _⊢_:⇒*:_∷_ using () renaming (d to redₜ; ⊢t to ⊢t-redₜ; ⊢u to ⊢u-redₜ) public

-- Well-formed substitutions.
data _⊢ˢ_∷_ (Δ : Con Term) (σ : Subst) : (Γ : Con Term) → Set where
  id : Δ ⊢ˢ σ ∷ ε
  _,_ : ∀ {Γ A}
      → Δ ⊢ˢ tail σ ∷ Γ
      → Δ ⊢ head σ ∷ subst (tail σ) A
      → Δ ⊢ˢ σ ∷ Γ ∙ A

-- Conversion of well-formed substitutions.
data _⊢ˢ_≡_∷_ (Δ : Con Term) (σ σ′ : Subst) : (Γ : Con Term) → Set where
  id : Δ ⊢ˢ σ ≡ σ′ ∷ ε
  _,_ : ∀ {Γ A}
      → Δ ⊢ˢ tail σ ≡ tail σ′ ∷ Γ
      → Δ ⊢ head σ ≡ head σ′ ∷ subst (tail σ) A
      → Δ ⊢ˢ σ ≡ σ′ ∷ Γ ∙ A

-- Note that we cannot use the well-formed substitutions.
-- For that, we need to prove the fundamental theorem for substitutions.

⟦_⟧ⱼ_▹_ : (W : BindingType) → ∀ {Γ F G}
     → Γ     ⊢ F
     → Γ ∙ F ⊢ G
     → Γ     ⊢ ⟦ W ⟧ F ▹ G
⟦ BΠ ⟧ⱼ ⊢F ▹ ⊢G = Πⱼ ⊢F ▹ ⊢G
⟦ BΣ ⟧ⱼ ⊢F ▹ ⊢G = Σⱼ ⊢F ▹ ⊢G

⟦_⟧ⱼᵤ_▹_ : (W : BindingType) → ∀ {Γ F G}
     → Γ     ⊢ F ∷ U
     → Γ ∙ F ⊢ G ∷ U
     → Γ     ⊢ ⟦ W ⟧ F ▹ G ∷ U
⟦ BΠ ⟧ⱼᵤ ⊢F ▹ ⊢G = Πⱼ ⊢F ▹ ⊢G
⟦ BΣ ⟧ⱼᵤ ⊢F ▹ ⊢G = Σⱼ ⊢F ▹ ⊢G
