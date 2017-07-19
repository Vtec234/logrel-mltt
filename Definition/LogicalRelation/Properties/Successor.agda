{-# OPTIONS --without-K #-}

open import Definition.Typed.EqualityRelation

module Definition.LogicalRelation.Properties.Successor {{eqrel : EqRelSet}} where
open EqRelSet {{...}}

open import Definition.Untyped
open import Definition.Typed
open import Definition.Typed.Properties
open import Definition.LogicalRelation
open import Definition.LogicalRelation.Irrelevance
open import Definition.LogicalRelation.Tactic

open import Tools.Product


sucTerm' : ∀ {l Γ n}
           ([ℕ] : Γ ⊩⟨ l ⟩ℕ ℕₑ)
         → Γ ⊩⟨ l ⟩ n ∷ ℕₑ / ℕ-intr [ℕ]
         → Γ ⊩⟨ l ⟩ sucₑ n ∷ ℕₑ / ℕ-intr [ℕ]
sucTerm' (noemb D) (ℕₜ n [ ⊢t , ⊢u , d ] n≡n prop) =
  let natN = natural prop
  in  ℕₜ _ [ suc ⊢t , suc ⊢t , id (suc ⊢t) ]
         (≅-suc-cong (≅ₜ-red (red D) d d ℕ
                             (naturalWhnf natN) (naturalWhnf natN) n≡n))
         (suc (ℕₜ n [ ⊢t , ⊢u , d ] n≡n prop))
sucTerm' (emb 0<1 x) [n] = sucTerm' x [n]

sucTerm : ∀ {l Γ n} ([ℕ] : Γ ⊩⟨ l ⟩ ℕₑ)
        → Γ ⊩⟨ l ⟩ n ∷ ℕₑ / [ℕ]
        → Γ ⊩⟨ l ⟩ sucₑ n ∷ ℕₑ / [ℕ]
sucTerm [ℕ] [n] =
  let [n]' = irrelevanceTerm [ℕ] (ℕ-intr (ℕ-elim [ℕ])) [n]
  in  irrelevanceTerm (ℕ-intr (ℕ-elim [ℕ]))
                      [ℕ]
                      (sucTerm' (ℕ-elim [ℕ]) [n]')

sucEqTerm' : ∀ {l Γ n n'}
             ([ℕ] : Γ ⊩⟨ l ⟩ℕ ℕₑ)
           → Γ ⊩⟨ l ⟩ n ≡ n' ∷ ℕₑ / ℕ-intr [ℕ]
           → Γ ⊩⟨ l ⟩ sucₑ n ≡ sucₑ n' ∷ ℕₑ / ℕ-intr [ℕ]
sucEqTerm' (noemb D) (ℕₜ₌ k k' [ ⊢t , ⊢u , d ]
                              [ ⊢t₁ , ⊢u₁ , d₁ ] t≡u prop) =
  let natK , natK' = split prop
  in  ℕₜ₌ _ _ (idRedTerm:*: (suc ⊢t)) (idRedTerm:*: (suc ⊢t₁))
        (≅-suc-cong (≅ₜ-red (red D) d d₁ ℕ (naturalWhnf natK) (naturalWhnf natK') t≡u))
        (suc (ℕₜ₌ k k' [ ⊢t , ⊢u , d ] [ ⊢t₁ , ⊢u₁ , d₁ ] t≡u prop))
sucEqTerm' (emb 0<1 x) [n≡n'] = sucEqTerm' x [n≡n']

sucEqTerm : ∀ {l Γ n n'} ([ℕ] : Γ ⊩⟨ l ⟩ ℕₑ)
          → Γ ⊩⟨ l ⟩ n ≡ n' ∷ ℕₑ / [ℕ]
          → Γ ⊩⟨ l ⟩ sucₑ n ≡ sucₑ n' ∷ ℕₑ / [ℕ]
sucEqTerm [ℕ] [n≡n'] =
  let [n≡n']' = irrelevanceEqTerm [ℕ] (ℕ-intr (ℕ-elim [ℕ])) [n≡n']
  in  irrelevanceEqTerm (ℕ-intr (ℕ-elim [ℕ])) [ℕ]
                        (sucEqTerm' (ℕ-elim [ℕ]) [n≡n']')
