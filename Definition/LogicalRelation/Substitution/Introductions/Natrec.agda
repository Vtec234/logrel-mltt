{-# OPTIONS --without-K #-}

open import Definition.Typed.EqualityRelation

module Definition.LogicalRelation.Substitution.Introductions.Natrec {{eqrel : EqRelSet}} where
open EqRelSet {{...}}

open import Definition.Untyped as U hiding (wk)
open import Definition.Untyped.Properties
open import Definition.Typed
import Definition.Typed.Weakening as T
open import Definition.Typed.Properties
open import Definition.Typed.RedSteps
open import Definition.LogicalRelation
open import Definition.LogicalRelation.Tactic
open import Definition.LogicalRelation.Weakening
open import Definition.LogicalRelation.Irrelevance
open import Definition.LogicalRelation.Properties
open import Definition.LogicalRelation.Substitution
open import Definition.LogicalRelation.Substitution.Properties
import Definition.LogicalRelation.Substitution.Irrelevance as S
open import Definition.LogicalRelation.Substitution.Reflexivity
open import Definition.LogicalRelation.Substitution.Weakening
open import Definition.LogicalRelation.Substitution.Introductions.Application
open import Definition.LogicalRelation.Substitution.Introductions.Nat
open import Definition.LogicalRelation.Substitution.Introductions.Pi
open import Definition.LogicalRelation.Substitution.Introductions.SingleSubst

open import Tools.Product
open import Tools.Unit
open import Tools.Empty
open import Tools.Nat

import Tools.PropositionalEquality as PE


natrec-subst* : ∀ {Γ C c g n n' l} → Γ ∙ ℕₑ ⊢ C → Γ ⊢ c ∷ C [ zeroₑ ]
              → Γ ⊢ g ∷ Πₑ ℕₑ ▹ (C ▹▹ C [ sucₑ (var zero) ]↑)
              → Γ ⊢ n ⇒* n' ∷ ℕₑ
              → ([ℕ] : Γ ⊩⟨ l ⟩ ℕₑ)
              → Γ ⊩⟨ l ⟩ n' ∷ ℕₑ / [ℕ]
              → (∀ {t t'} → Γ ⊩⟨ l ⟩ t  ∷ ℕₑ / [ℕ]
                          → Γ ⊩⟨ l ⟩ t' ∷ ℕₑ / [ℕ]
                          → Γ ⊩⟨ l ⟩ t ≡ t' ∷ ℕₑ / [ℕ]
                          → Γ ⊢ C [ t ] ≡ C [ t' ])
              → Γ ⊢ natrecₑ C c g n ⇒* natrecₑ C c g n' ∷ C [ n ]
natrec-subst* C c g (id x) [ℕ] [n'] prop = id (natrec C c g x)
natrec-subst* C c g (x ⇨ n⇒n') [ℕ] [n'] prop =
  let q , w = redSubst*Term n⇒n' [ℕ] [n']
      a , s = redSubstTerm x [ℕ] q
  in  natrec-subst C c g x ⇨ conv* (natrec-subst* C c g n⇒n' [ℕ] [n'] prop)
                   (prop q a (symEqTerm [ℕ] s))

sucCase₃ : ∀ {Γ l} ([Γ] : ⊩ₛ Γ)
           ([ℕ] : Γ ⊩ₛ⟨ l ⟩ ℕₑ / [Γ])
         → Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ sucₑ (var zero) ∷ ℕₑ / [Γ] ∙ [ℕ]
                 / (λ {Δ} {σ} → wk1ₛ {ℕₑ} {ℕₑ} [Γ] [ℕ] [ℕ] {Δ} {σ})
sucCase₃ {Γ} {l} [Γ] [ℕ] {Δ} {σ} =
  sucₛ {n = var zero} {l = l} (_∙_ {A = ℕₑ} [Γ] [ℕ])
       (λ {Δ} {σ} → wk1ₛ {ℕₑ} {ℕₑ} [Γ] [ℕ] [ℕ] {Δ} {σ})
       (λ ⊢Δ [σ] → proj₂ [σ] , (λ [σ'] [σ≡σ'] → proj₂ [σ≡σ'])) {Δ} {σ}

sucCase₂ : ∀ {F Γ l} ([Γ] : ⊩ₛ Γ)
           ([ℕ] : Γ ⊩ₛ⟨ l ⟩ ℕₑ / [Γ])
           ([F] : Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F / [Γ] ∙ [ℕ])
         → Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F [ sucₑ (var zero) ]↑ / [Γ] ∙ [ℕ]
sucCase₂ {F} {Γ} {l} [Γ] [ℕ] [F] =
  subst↑S {ℕₑ} {F} {sucₑ (var zero)} [Γ] [ℕ] [F]
          (λ {Δ} {σ} → sucCase₃ [Γ] [ℕ] {Δ} {σ})

sucCase₁ : ∀ {F Γ l} ([Γ] : ⊩ₛ Γ)
           ([ℕ] : Γ ⊩ₛ⟨ l ⟩ ℕₑ / [Γ])
           ([F] : Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F / [Γ] ∙ [ℕ])
         → Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F ▹▹ F [ sucₑ (var zero) ]↑ / [Γ] ∙ [ℕ]
sucCase₁ {F} {Γ} {l} [Γ] [ℕ] [F] =
  ▹▹ₛ {F} {F [ sucₑ (var zero) ]↑} (_∙_ {A = ℕₑ} [Γ] [ℕ]) [F]
      (sucCase₂ {F} [Γ] [ℕ] [F])

sucCase : ∀ {F Γ l} ([Γ] : ⊩ₛ Γ)
          ([ℕ] : Γ ⊩ₛ⟨ l ⟩ ℕₑ / [Γ])
          ([F] : Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F / [Γ] ∙ [ℕ])
        → Γ ⊩ₛ⟨ l ⟩ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑) / [Γ]
sucCase {F} {Γ} {l} [Γ] [ℕ] [F] =
  Πₛ {ℕₑ} {F ▹▹ F [ sucₑ (var zero) ]↑} [Γ] [ℕ]
     (sucCase₁ {F} [Γ] [ℕ] [F])

sucCaseCong : ∀ {F F' Γ l} ([Γ] : ⊩ₛ Γ)
              ([ℕ] : Γ ⊩ₛ⟨ l ⟩ ℕₑ / [Γ])
              ([F] : Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F / [Γ] ∙ [ℕ])
              ([F'] : Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F' / [Γ] ∙ [ℕ])
              ([F≡F'] : Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F ≡ F' / [Γ] ∙ [ℕ] / [F])
        → Γ ⊩ₛ⟨ l ⟩ Πₑ ℕₑ ▹ (F  ▹▹ F  [ sucₑ (var zero) ]↑)
                  ≡ Πₑ ℕₑ ▹ (F' ▹▹ F' [ sucₑ (var zero) ]↑)
                  / [Γ] / sucCase {F} [Γ] [ℕ] [F]
sucCaseCong {F} {F'} {Γ} {l} [Γ] [ℕ] [F] [F'] [F≡F'] =
  Π-congₛ {ℕₑ} {F ▹▹ F [ sucₑ (var zero) ]↑} {ℕₑ} {F' ▹▹ F' [ sucₑ (var zero) ]↑}
          [Γ] [ℕ] (sucCase₁ {F} [Γ] [ℕ] [F]) [ℕ] (sucCase₁ {F'} [Γ] [ℕ] [F'])
          (reflₛ {ℕₑ} [Γ] [ℕ])
          (▹▹-congₛ {F} {F'} {F [ sucₑ (var zero) ]↑} {F' [ sucₑ (var zero) ]↑}
             (_∙_ {A = ℕₑ} [Γ] [ℕ]) [F] [F'] [F≡F']
             (sucCase₂ {F} [Γ] [ℕ] [F]) (sucCase₂ {F'} [Γ] [ℕ] [F'])
             (subst↑SEq {ℕₑ} {F} {F'} {sucₑ (var zero)} {sucₑ (var zero)}
                        [Γ] [ℕ] [F] [F'] [F≡F']
                        (λ {Δ} {σ} → sucCase₃ [Γ] [ℕ] {Δ} {σ})
                        (λ {Δ} {σ} → sucCase₃ [Γ] [ℕ] {Δ} {σ})
                        (λ {Δ} {σ} →
                           reflₜₛ {ℕₑ} {sucₑ (var zero)} (_∙_ {A = ℕₑ} [Γ] [ℕ])
                                  (λ {Δ} {σ} → wk1ₛ {ℕₑ} {ℕₑ} [Γ] [ℕ] [ℕ] {Δ} {σ})
                                  (λ {Δ} {σ} → sucCase₃ [Γ] [ℕ] {Δ} {σ})
                           {Δ} {σ})))

natrecTerm : ∀ {F z s n Γ Δ σ l}
             ([Γ]  : ⊩ₛ Γ)
             ([F]  : Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F / _∙_ {l = l} [Γ] (ℕₛ [Γ]))
             ([F₀] : Γ ⊩ₛ⟨ l ⟩ F [ zeroₑ ] / [Γ])
             ([F₊] : Γ ⊩ₛ⟨ l ⟩ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑) / [Γ])
             ([z]  : Γ ⊩ₛ⟨ l ⟩ z ∷ F [ zeroₑ ] / [Γ] / [F₀])
             ([s]  : Γ ⊩ₛ⟨ l ⟩ s ∷ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑)
                       / [Γ] / [F₊])
             (⊢Δ   : ⊢ Δ)
             ([σ]  : Δ ⊩ₛ σ ∷ Γ / [Γ] / ⊢Δ)
             ([σn] : Δ ⊩⟨ l ⟩ n ∷ ℕₑ / ℕ (idRed:*: (ℕ ⊢Δ)))
           → Δ ⊩⟨ l ⟩ natrecₑ (subst (liftSubst σ) F) (subst σ z) (subst σ s) n
               ∷ subst (liftSubst σ) F [ n ]
               / irrelevance' (PE.sym (singleSubstComp n σ F))
                              (proj₁ ([F] ⊢Δ ([σ] , [σn])))
natrecTerm {F} {z} {s} {n} {Γ} {Δ} {σ} {l} [Γ] [F] [F₀] [F₊] [z] [s] ⊢Δ [σ]
           (ℕₜ .(sucₑ m) d n≡n (suc {m} [m])) =
  let [ℕ] = ℕₛ {l = l} [Γ]
      [σℕ] = proj₁ ([ℕ] ⊢Δ [σ])
      ⊢ℕ = wellformed (proj₁ ([ℕ] ⊢Δ [σ]))
      ⊢F = wellformed (proj₁ ([F] (⊢Δ ∙ ⊢ℕ) (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ])))
      ⊢z = PE.subst (λ x → _ ⊢ _ ∷ x) (singleSubstLift F zeroₑ)
                    (wellformedTerm (proj₁ ([F₀] ⊢Δ [σ])) (proj₁ ([z] ⊢Δ [σ])))
      ⊢s = PE.subst (λ x → Δ ⊢ subst σ s ∷ x) (natrecSucCase σ F)
                    (wellformedTerm (proj₁ ([F₊] ⊢Δ [σ])) (proj₁ ([s] ⊢Δ [σ])))
      ⊢n = wellformedTerm {l = l} (ℕ ([ ⊢ℕ , ⊢ℕ , id ⊢ℕ ]))
                          (ℕₜ (sucₑ m) d n≡n (suc [m]))
      ⊢m = wellformedTerm {l = l} [σℕ] [m]
      [σsm] = irrelevanceTerm {l = l} (ℕ (idRed:*: (ℕ ⊢Δ))) [σℕ]
                              (ℕₜ (sucₑ m) (idRedTerm:*: (suc ⊢m)) n≡n (suc [m]))
      [σn] = ℕₜ (sucₑ m) d n≡n (suc [m])
      [σn]' , [σn≡σsm] = redSubst*Term (redₜ d) [σℕ] [σsm]
      [σFₙ]' = proj₁ ([F] ⊢Δ ([σ] , [σn]))
      [σFₙ] = irrelevance' (PE.sym (singleSubstComp n σ F)) [σFₙ]'
      [σFₛₘ] = irrelevance' (PE.sym (singleSubstComp (sucₑ m) σ F))
                            (proj₁ ([F] ⊢Δ ([σ] , [σsm])))
      [Fₙ≡Fₛₘ] = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                 (PE.sym (singleSubstComp (sucₑ m) σ F))
                                 [σFₙ]' [σFₙ]
                                 (proj₂ ([F] ⊢Δ ([σ] , [σn])) ([σ] , [σsm])
                                        (reflSubst [Γ] ⊢Δ [σ] , [σn≡σsm]))
      [σFₘ] = irrelevance' (PE.sym (PE.trans (substCompEq F)
                                             (substSingletonComp F)))
                           (proj₁ ([F] ⊢Δ ([σ] , [m])))
      [σFₛₘ]' = irrelevance' (natrecIrrelevantSubst F z s m σ)
                             (proj₁ ([F] ⊢Δ ([σ] , [σsm])))
      [σF₊ₘ] = substSΠ₁ (proj₁ ([F₊] ⊢Δ [σ])) [σℕ] [m]
      natrecM = appTerm [σFₘ] [σFₛₘ]' [σF₊ₘ]
                        (appTerm [σℕ] [σF₊ₘ]
                                 (proj₁ ([F₊] ⊢Δ [σ]))
                                 (proj₁ ([s] ⊢Δ [σ])) [m])
                        (natrecTerm {F} {z} {s} {m} {σ = σ}
                                    [Γ] [F] [F₀] [F₊] [z] [s] ⊢Δ [σ] [m])
      natrecM' = irrelevanceTerm' (PE.trans
                                    (PE.sym (natrecIrrelevantSubst F z s m σ))
                                    (PE.sym (singleSubstComp (sucₑ m) σ F)))
                                  [σFₛₘ]' [σFₛₘ] natrecM
      reduction = natrec-subst* ⊢F ⊢z ⊢s (redₜ d) [σℕ] [σsm]
                    (λ {t} {t'} [t] [t'] [t≡t'] →
                       PE.subst₂ (λ x y → _ ⊢ x ≡ y)
                                 (PE.sym (singleSubstComp t σ F))
                                 (PE.sym (singleSubstComp t' σ F))
                                 (≅-eq (wellformedEq (proj₁ ([F] ⊢Δ ([σ] , [t])))
                                              (proj₂ ([F] ⊢Δ ([σ] , [t]))
                                                     ([σ] , [t'])
                                                     (reflSubst [Γ] ⊢Δ [σ] ,
                                                                [t≡t'])))))
                  ⇨∷* (conv* (natrec-suc ⊢m ⊢F ⊢z ⊢s
                              ⇨ id (wellformedTerm [σFₛₘ] natrecM'))
                             (sym (≅-eq (wellformedEq [σFₙ] [Fₙ≡Fₛₘ]))))
  in  proj₁ (redSubst*Term reduction [σFₙ]
                           (convTerm₂ [σFₙ] [σFₛₘ] [Fₙ≡Fₛₘ] natrecM'))
natrecTerm {F} {z} {s} {n} {Γ} {Δ} {σ} {l} [Γ] [F] [F₀] [F₊] [z] [s] ⊢Δ [σ]
           (ℕₜ .zeroₑ d n≡n zero) =
  let [ℕ] = ℕₛ {l = l} [Γ]
      [σℕ] = proj₁ ([ℕ] ⊢Δ [σ])
      ⊢ℕ = wellformed (proj₁ ([ℕ] ⊢Δ [σ]))
      [σF] = proj₁ ([F] (⊢Δ ∙ ⊢ℕ) (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ]))
      ⊢F = wellformed [σF]
      ⊢z = PE.subst (λ x → _ ⊢ _ ∷ x) (singleSubstLift F zeroₑ)
                    (wellformedTerm (proj₁ ([F₀] ⊢Δ [σ])) (proj₁ ([z] ⊢Δ [σ])))
      ⊢s = PE.subst (λ x → Δ ⊢ subst σ s ∷ x) (natrecSucCase σ F)
                    (wellformedTerm (proj₁ ([F₊] ⊢Δ [σ])) (proj₁ ([s] ⊢Δ [σ])))
      ⊢n = wellformedTerm {l = l} (ℕ ([ ⊢ℕ , ⊢ℕ , id ⊢ℕ ]))
                          (ℕₜ zeroₑ d n≡n zero)
      [σ0] = irrelevanceTerm {l = l} (ℕ (idRed:*: (ℕ ⊢Δ))) [σℕ]
                             (ℕₜ zeroₑ (idRedTerm:*: (zero ⊢Δ)) n≡n zero)
      [σn]' , [σn≡σ0] = redSubst*Term (redₜ d) (proj₁ ([ℕ] ⊢Δ [σ])) [σ0]
      [σn] = ℕₜ zeroₑ d n≡n zero
      [σFₙ]' = proj₁ ([F] ⊢Δ ([σ] , [σn]))
      [σFₙ] = irrelevance' (PE.sym (singleSubstComp n σ F)) [σFₙ]'
      [σF₀] = irrelevance' (PE.sym (singleSubstComp zeroₑ σ F))
                           (proj₁ ([F] ⊢Δ ([σ] , [σ0])))
      [Fₙ≡F₀]' = proj₂ ([F] ⊢Δ ([σ] , [σn])) ([σ] , [σ0])
                       (reflSubst [Γ] ⊢Δ [σ] , [σn≡σ0])
      [Fₙ≡F₀] = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                (PE.sym (substCompEq F))
                                [σFₙ]' [σFₙ] [Fₙ≡F₀]'
      [Fₙ≡F₀]'' = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                  (PE.trans (substConcatSingleton' F)
                                            (PE.sym (singleSubstComp zeroₑ σ F)))
                                  [σFₙ]' [σFₙ] [Fₙ≡F₀]'
      [σz] = proj₁ ([z] ⊢Δ [σ])
      reduction = natrec-subst* ⊢F ⊢z ⊢s (redₜ d) (proj₁ ([ℕ] ⊢Δ [σ])) [σ0]
                    (λ {t} {t'} [t] [t'] [t≡t'] →
                       PE.subst₂ (λ x y → _ ⊢ x ≡ y)
                                 (PE.sym (singleSubstComp t σ F))
                                 (PE.sym (singleSubstComp t' σ F))
                                 (≅-eq (wellformedEq (proj₁ ([F] ⊢Δ ([σ] , [t])))
                                              (proj₂ ([F] ⊢Δ ([σ] , [t]))
                                                     ([σ] , [t'])
                                                     (reflSubst [Γ] ⊢Δ [σ] ,
                                                                [t≡t'])))))
                  ⇨∷* (conv* (natrec-zero ⊢F ⊢z ⊢s ⇨ id ⊢z)
                             (sym (≅-eq (wellformedEq [σFₙ] [Fₙ≡F₀]''))))
  in  proj₁ (redSubst*Term reduction [σFₙ]
                           (convTerm₂ [σFₙ] (proj₁ ([F₀] ⊢Δ [σ])) [Fₙ≡F₀] [σz]))
natrecTerm {F} {z} {s} {n} {Γ} {Δ} {σ} {l} [Γ] [F] [F₀] [F₊] [z] [s] ⊢Δ [σ]
           (ℕₜ m d n≡n (ne (neNfₜ neM ⊢m m≡m))) =
  let [ℕ] = ℕₛ {l = l} [Γ]
      [σℕ] = proj₁ ([ℕ] ⊢Δ [σ])
      ⊢ℕ = wellformed (proj₁ ([ℕ] ⊢Δ [σ]))
      [σn] = ℕₜ m d n≡n (ne (neNfₜ neM ⊢m m≡m))
      [σF] = proj₁ ([F] (⊢Δ ∙ ⊢ℕ) (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ]))
      ⊢F = wellformed [σF]
      ⊢F≡F = wellformedEq [σF] (reflEq [σF])
      ⊢z = PE.subst (λ x → _ ⊢ _ ∷ x) (singleSubstLift F zeroₑ)
                    (wellformedTerm (proj₁ ([F₀] ⊢Δ [σ])) (proj₁ ([z] ⊢Δ [σ])))
      ⊢z≡z = PE.subst (λ x → _ ⊢ _ ≅ _ ∷ x) (singleSubstLift F zeroₑ)
                      (wellformedTermEq (proj₁ ([F₀] ⊢Δ [σ]))
                                        (reflEqTerm (proj₁ ([F₀] ⊢Δ [σ]))
                                                    (proj₁ ([z] ⊢Δ [σ]))))
      ⊢s = PE.subst (λ x → Δ ⊢ subst σ s ∷ x) (natrecSucCase σ F)
                    (wellformedTerm (proj₁ ([F₊] ⊢Δ [σ])) (proj₁ ([s] ⊢Δ [σ])))
      ⊢s≡s = PE.subst (λ x → Δ ⊢ subst σ s ≅ subst σ s ∷ x) (natrecSucCase σ F)
                      (wellformedTermEq (proj₁ ([F₊] ⊢Δ [σ]))
                                        (reflEqTerm (proj₁ ([F₊] ⊢Δ [σ]))
                                                    (proj₁ ([s] ⊢Δ [σ]))))
      ⊢n = wellformedTerm [σℕ] [σn]
      [σm] = neuTerm [σℕ] neM ⊢m m≡m
      [σn]' , [σn≡σm] = redSubst*Term (redₜ d) [σℕ] [σm]
      [σFₙ]' = proj₁ ([F] ⊢Δ ([σ] , [σn]))
      [σFₙ] = irrelevance' (PE.sym (singleSubstComp n σ F)) [σFₙ]'
      [σFₘ] = irrelevance' (PE.sym (singleSubstComp m σ F))
                           (proj₁ ([F] ⊢Δ ([σ] , [σm])))
      [Fₙ≡Fₘ] = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                (PE.sym (singleSubstComp m σ F)) [σFₙ]' [σFₙ]
                                ((proj₂ ([F] ⊢Δ ([σ] , [σn]))) ([σ] , [σm])
                                        (reflSubst [Γ] ⊢Δ [σ] , [σn≡σm]))
      natrecM = neuTerm [σFₘ] (natrec neM) (natrec ⊢F ⊢z ⊢s ⊢m)
                        (~-natrec ⊢F≡F ⊢z≡z ⊢s≡s m≡m)
      reduction = natrec-subst* ⊢F ⊢z ⊢s (redₜ d) [σℕ] [σm]
                    (λ {t} {t'} [t] [t'] [t≡t'] →
                       PE.subst₂ (λ x y → _ ⊢ x ≡ y)
                                 (PE.sym (singleSubstComp t σ F))
                                 (PE.sym (singleSubstComp t' σ F))
                                 (≅-eq (wellformedEq (proj₁ ([F] ⊢Δ ([σ] , [t])))
                                              (proj₂ ([F] ⊢Δ ([σ] , [t]))
                                                     ([σ] , [t'])
                                                     (reflSubst [Γ] ⊢Δ [σ] ,
                                                                [t≡t'])))))
  in  proj₁ (redSubst*Term reduction [σFₙ]
                           (convTerm₂ [σFₙ] [σFₘ] [Fₙ≡Fₘ] natrecM))


natrec-congTerm : ∀ {F F' z z' s s' n m Γ Δ σ σ' l}
                  ([Γ]      : ⊩ₛ Γ)
                  ([F]      : Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F / _∙_ {l = l} [Γ] (ℕₛ [Γ]))
                  ([F']     : Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F' / _∙_ {l = l} [Γ] (ℕₛ [Γ]))
                  ([F≡F']   : Γ ∙ ℕₑ ⊩ₛ⟨ l ⟩ F ≡ F' / _∙_ {l = l} [Γ] (ℕₛ [Γ])
                                    / [F])
                  ([F₀]     : Γ ⊩ₛ⟨ l ⟩ F [ zeroₑ ] / [Γ])
                  ([F'₀]    : Γ ⊩ₛ⟨ l ⟩ F' [ zeroₑ ] / [Γ])
                  ([F₀≡F'₀] : Γ ⊩ₛ⟨ l ⟩ F [ zeroₑ ] ≡ F' [ zeroₑ ] / [Γ] / [F₀])
                  ([F₊]     : Γ ⊩ₛ⟨ l ⟩ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑)
                                / [Γ])
                  ([F'₊]    : Γ ⊩ₛ⟨ l ⟩ Πₑ ℕₑ ▹ (F' ▹▹ F' [ sucₑ (var zero) ]↑)
                                / [Γ])
                  ([F₊≡F₊'] : Γ ⊩ₛ⟨ l ⟩ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑)
                                ≡ Πₑ ℕₑ ▹ (F' ▹▹ F' [ sucₑ (var zero) ]↑)
                                / [Γ] / [F₊])
                  ([z]      : Γ ⊩ₛ⟨ l ⟩ z ∷ F [ zeroₑ ] / [Γ] / [F₀])
                  ([z']     : Γ ⊩ₛ⟨ l ⟩ z' ∷ F' [ zeroₑ ] / [Γ] / [F'₀])
                  ([z≡z']   : Γ ⊩ₛ⟨ l ⟩ z ≡ z' ∷ F [ zeroₑ ] / [Γ] / [F₀])
                  ([s]      : Γ ⊩ₛ⟨ l ⟩ s ∷ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑)
                                / [Γ] / [F₊])
                  ([s']     : Γ ⊩ₛ⟨ l ⟩ s'
                                ∷ Πₑ ℕₑ ▹ (F' ▹▹ F' [ sucₑ (var zero) ]↑)
                                / [Γ] / [F'₊])
                  ([s≡s']   : Γ ⊩ₛ⟨ l ⟩ s ≡ s'
                                ∷ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑)
                                / [Γ] / [F₊])
                  (⊢Δ       : ⊢ Δ)
                  ([σ]      : Δ ⊩ₛ σ  ∷ Γ / [Γ] / ⊢Δ)
                  ([σ']     : Δ ⊩ₛ σ' ∷ Γ / [Γ] / ⊢Δ)
                  ([σ≡σ']   : Δ ⊩ₛ σ ≡ σ' ∷ Γ / [Γ] / ⊢Δ / [σ])
                  ([σn]     : Δ ⊩⟨ l ⟩ n ∷ ℕₑ / ℕ (idRed:*: (ℕ ⊢Δ)))
                  ([σm]     : Δ ⊩⟨ l ⟩ m ∷ ℕₑ / ℕ (idRed:*: (ℕ ⊢Δ)))
                  ([σn≡σm]  : Δ ⊩⟨ l ⟩ n ≡ m ∷ ℕₑ / ℕ (idRed:*: (ℕ ⊢Δ)))
                → Δ ⊩⟨ l ⟩ natrecₑ (subst (liftSubst σ) F)
                                  (subst σ z) (subst σ s) n
                    ≡ natrecₑ (subst (liftSubst σ') F')
                             (subst σ' z') (subst σ' s') m
                    ∷ subst (liftSubst σ) F [ n ]
                    / irrelevance' (PE.sym (singleSubstComp n σ F))
                                   (proj₁ ([F] ⊢Δ ([σ] , [σn])))
natrec-congTerm {F} {F'} {z} {z'} {s} {s'} {n} {m} {Γ} {Δ} {σ} {σ'} {l}
                [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                (ℕₜ .(sucₑ n') d n≡n (suc {n'} [n']))
                (ℕₜ .(sucₑ m') d' m≡m (suc {m'} [m']))
                (ℕₜ₌ .(sucₑ n'') .(sucₑ m'') d₁ d₁'
                     t≡u (suc {n''} {m''} [n''≡m''])) =
  let n''≡n' = suc-PE-injectivity (whrDet*Term (redₜ d₁ , suc) (redₜ d , suc))
      m''≡m' = suc-PE-injectivity (whrDet*Term (redₜ d₁' , suc) (redₜ d' , suc))
      [ℕ] = ℕₛ {l = l} [Γ]
      [σℕ] = proj₁ ([ℕ] ⊢Δ [σ])
      [σ'ℕ] = proj₁ ([ℕ] ⊢Δ [σ'])
      [n'≡m'] = irrelevanceEqTerm'' n''≡n' m''≡m' PE.refl [σℕ] [σℕ] [n''≡m'']
      [σn] = ℕₜ (sucₑ n') d n≡n (suc [n'])
      [σ'm] = ℕₜ (sucₑ m') d' m≡m (suc [m'])
      [σn≡σ'm] = ℕₜ₌ (sucₑ n'') (sucₑ m'') d₁ d₁' t≡u (suc [n''≡m''])
      ⊢ℕ = wellformed [σℕ]
      ⊢F = wellformed (proj₁ ([F] (⊢Δ ∙ ⊢ℕ) (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ])))
      ⊢z = PE.subst (λ x → _ ⊢ _ ∷ x) (singleSubstLift F zeroₑ)
                    (wellformedTerm (proj₁ ([F₀] ⊢Δ [σ])) (proj₁ ([z] ⊢Δ [σ])))
      ⊢s = PE.subst (λ x → Δ ⊢ subst σ s ∷ x) (natrecSucCase σ F)
                    (wellformedTerm (proj₁ ([F₊] ⊢Δ [σ])) (proj₁ ([s] ⊢Δ [σ])))
      ⊢n = wellformedTerm {l = l} (ℕ ([ ⊢ℕ , ⊢ℕ , id ⊢ℕ ])) [σn]
      ⊢n' = wellformedTerm {l = l} [σℕ] [n']
      ⊢ℕ' = wellformed [σ'ℕ]
      ⊢F' = wellformed (proj₁ ([F'] (⊢Δ ∙ ⊢ℕ')
                      (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ'])))
      ⊢z' = PE.subst (λ x → _ ⊢ _ ∷ x) (singleSubstLift F' zeroₑ)
                     (wellformedTerm (proj₁ ([F'₀] ⊢Δ [σ']))
                                    (proj₁ ([z'] ⊢Δ [σ'])))
      ⊢s' = PE.subst (λ x → Δ ⊢ subst σ' s' ∷ x) (natrecSucCase σ' F')
                     (wellformedTerm (proj₁ ([F'₊] ⊢Δ [σ']))
                                    (proj₁ ([s'] ⊢Δ [σ'])))
      ⊢m  = wellformedTerm {l = l} (ℕ ([ ⊢ℕ' , ⊢ℕ' , id ⊢ℕ' ])) [σ'm]
      ⊢m' = wellformedTerm {l = l} [σ'ℕ] [m']
      [σsn'] = irrelevanceTerm {l = l} (ℕ (idRed:*: (ℕ ⊢Δ))) [σℕ]
                               (ℕₜ (sucₑ n') (idRedTerm:*: (suc ⊢n')) n≡n (suc [n']))
      [σn]' , [σn≡σsn'] = redSubst*Term (redₜ d) [σℕ] [σsn']
      [σFₙ]' = proj₁ ([F] ⊢Δ ([σ] , [σn]))
      [σFₙ] = irrelevance' (PE.sym (singleSubstComp n σ F)) [σFₙ]'
      [σFₛₙ'] = irrelevance' (PE.sym (singleSubstComp (sucₑ n') σ F))
                             (proj₁ ([F] ⊢Δ ([σ] , [σsn'])))
      [Fₙ≡Fₛₙ'] = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                  (PE.sym (singleSubstComp (sucₑ n') σ F))
                                  [σFₙ]' [σFₙ]
                                  (proj₂ ([F] ⊢Δ ([σ] , [σn])) ([σ] , [σsn'])
                                         (reflSubst [Γ] ⊢Δ [σ] , [σn≡σsn']))
      [Fₙ≡Fₛₙ']' = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                   (natrecIrrelevantSubst F z s n' σ)
                                   [σFₙ]' [σFₙ]
                                   (proj₂ ([F] ⊢Δ ([σ] , [σn])) ([σ] , [σsn'])
                                          (reflSubst [Γ] ⊢Δ [σ] , [σn≡σsn']))
      [σFₙ'] = irrelevance' (PE.sym (PE.trans (substCompEq F)
                                              (substSingletonComp F)))
                            (proj₁ ([F] ⊢Δ ([σ] , [n'])))
      [σFₛₙ']' = irrelevance' (natrecIrrelevantSubst F z s n' σ)
                              (proj₁ ([F] ⊢Δ ([σ] , [σsn'])))
      [σF₊ₙ'] = substSΠ₁ (proj₁ ([F₊] ⊢Δ [σ])) [σℕ] [n']
      [σ'sm'] = irrelevanceTerm {l = l} (ℕ (idRed:*: (ℕ ⊢Δ))) [σ'ℕ]
                                (ℕₜ (sucₑ m') (idRedTerm:*: (suc ⊢m')) m≡m (suc [m']))
      [σ'm]' , [σ'm≡σ'sm'] = redSubst*Term (redₜ d') [σ'ℕ] [σ'sm']
      [σ'F'ₘ]' = proj₁ ([F'] ⊢Δ ([σ'] , [σ'm]))
      [σ'F'ₘ] = irrelevance' (PE.sym (singleSubstComp m σ' F')) [σ'F'ₘ]'
      [σ'Fₘ]' = proj₁ ([F] ⊢Δ ([σ'] , [σ'm]))
      [σ'Fₘ] = irrelevance' (PE.sym (singleSubstComp m σ' F)) [σ'Fₘ]'
      [σ'F'ₛₘ'] = irrelevance' (PE.sym (singleSubstComp (sucₑ m') σ' F'))
                               (proj₁ ([F'] ⊢Δ ([σ'] , [σ'sm'])))
      [F'ₘ≡F'ₛₘ'] = irrelevanceEq'' (PE.sym (singleSubstComp m σ' F'))
                                    (PE.sym (singleSubstComp (sucₑ m') σ' F'))
                                    [σ'F'ₘ]' [σ'F'ₘ]
                                    (proj₂ ([F'] ⊢Δ ([σ'] , [σ'm]))
                                           ([σ'] , [σ'sm'])
                                           (reflSubst [Γ] ⊢Δ [σ'] , [σ'm≡σ'sm']))
      [σ'Fₘ'] = irrelevance' (PE.sym (PE.trans (substCompEq F)
                                               (substSingletonComp F)))
                             (proj₁ ([F] ⊢Δ ([σ'] , [m'])))
      [σ'F'ₘ'] = irrelevance' (PE.sym (PE.trans (substCompEq F')
                                                (substSingletonComp F')))
                              (proj₁ ([F'] ⊢Δ ([σ'] , [m'])))
      [σ'F'ₛₘ']' = irrelevance' (natrecIrrelevantSubst F' z' s' m' σ')
                                (proj₁ ([F'] ⊢Δ ([σ'] , [σ'sm'])))
      [σ'F'₊ₘ'] = substSΠ₁ (proj₁ ([F'₊] ⊢Δ [σ'])) [σ'ℕ] [m']
      [σFₙ'≡σ'Fₘ'] = irrelevanceEq'' (PE.sym (singleSubstComp n' σ F))
                                     (PE.sym (singleSubstComp m' σ' F))
                                     (proj₁ ([F] ⊢Δ ([σ] , [n']))) [σFₙ']
                                     (proj₂ ([F] ⊢Δ ([σ] , [n']))
                                            ([σ'] , [m']) ([σ≡σ'] , [n'≡m']))
      [σ'Fₘ'≡σ'F'ₘ'] = irrelevanceEq'' (PE.sym (singleSubstComp m' σ' F))
                                       (PE.sym (singleSubstComp m' σ' F'))
                                       (proj₁ ([F] ⊢Δ ([σ'] , [m'])))
                                       [σ'Fₘ'] ([F≡F'] ⊢Δ ([σ'] , [m']))
      [σFₙ'≡σ'F'ₘ'] = transEq [σFₙ'] [σ'Fₘ'] [σ'F'ₘ'] [σFₙ'≡σ'Fₘ'] [σ'Fₘ'≡σ'F'ₘ']
      [σFₙ≡σ'Fₘ] = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                   (PE.sym (singleSubstComp m σ' F))
                                   (proj₁ ([F] ⊢Δ ([σ] , [σn]))) [σFₙ]
                                   (proj₂ ([F] ⊢Δ ([σ] , [σn]))
                                          ([σ'] , [σ'm]) ([σ≡σ'] , [σn≡σ'm]))
      [σ'Fₘ≡σ'F'ₘ] = irrelevanceEq'' (PE.sym (singleSubstComp m σ' F))
                                     (PE.sym (singleSubstComp m σ' F'))
                                     [σ'Fₘ]' [σ'Fₘ] ([F≡F'] ⊢Δ ([σ'] , [σ'm]))
      [σFₙ≡σ'F'ₘ] = transEq [σFₙ] [σ'Fₘ] [σ'F'ₘ] [σFₙ≡σ'Fₘ] [σ'Fₘ≡σ'F'ₘ]
      natrecN = appTerm [σFₙ'] [σFₛₙ']' [σF₊ₙ']
                        (appTerm [σℕ] [σF₊ₙ'] (proj₁ ([F₊] ⊢Δ [σ]))
                                 (proj₁ ([s] ⊢Δ [σ])) [n'])
                        (natrecTerm {F} {z} {s} {n'} {σ = σ}
                                    [Γ] [F] [F₀] [F₊] [z] [s] ⊢Δ [σ] [n'])
      natrecN' = irrelevanceTerm' (PE.trans (PE.sym (natrecIrrelevantSubst F z s n' σ))
                                            (PE.sym (singleSubstComp (sucₑ n') σ F)))
                                  [σFₛₙ']' [σFₛₙ'] natrecN
      natrecM = appTerm [σ'F'ₘ'] [σ'F'ₛₘ']' [σ'F'₊ₘ']
                        (appTerm [σ'ℕ] [σ'F'₊ₘ'] (proj₁ ([F'₊] ⊢Δ [σ']))
                                 (proj₁ ([s'] ⊢Δ [σ'])) [m'])
                        (natrecTerm {F'} {z'} {s'} {m'} {σ = σ'}
                                    [Γ] [F'] [F'₀] [F'₊] [z'] [s'] ⊢Δ [σ'] [m'])
      natrecM' = irrelevanceTerm' (PE.trans (PE.sym (natrecIrrelevantSubst F' z' s' m' σ'))
                                            (PE.sym (singleSubstComp (sucₑ m') σ' F')))
                                  [σ'F'ₛₘ']' [σ'F'ₛₘ'] natrecM
      [σs≡σ's] = proj₂ ([s] ⊢Δ [σ]) [σ'] [σ≡σ']
      [σ's≡σ's'] = convEqTerm₂ (proj₁ ([F₊] ⊢Δ [σ])) (proj₁ ([F₊] ⊢Δ [σ']))
                               (proj₂ ([F₊] ⊢Δ [σ]) [σ'] [σ≡σ']) ([s≡s'] ⊢Δ [σ'])
      [σs≡σ's'] = transEqTerm (proj₁ ([F₊] ⊢Δ [σ])) [σs≡σ's] [σ's≡σ's']
      appEq = convEqTerm₂ [σFₙ] [σFₛₙ']' [Fₙ≡Fₛₙ']'
                (app-congTerm [σFₙ'] [σFₛₙ']' [σF₊ₙ']
                  (app-congTerm [σℕ] [σF₊ₙ'] (proj₁ ([F₊] ⊢Δ [σ])) [σs≡σ's']
                                [n'] [m'] [n'≡m'])
                  (natrecTerm {F} {z} {s} {n'} {σ = σ}
                              [Γ] [F] [F₀] [F₊] [z] [s] ⊢Δ [σ] [n'])
                  (convTerm₂ [σFₙ'] [σ'F'ₘ'] [σFₙ'≡σ'F'ₘ']
                             (natrecTerm {F'} {z'} {s'} {m'} {σ = σ'}
                                         [Γ] [F'] [F'₀] [F'₊] [z'] [s']
                                         ⊢Δ [σ'] [m']))
                  (natrec-congTerm {F} {F'} {z} {z'} {s} {s'} {n'} {m'} {σ = σ}
                                   [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀]
                                   [F₊] [F'₊] [F₊≡F'₊] [z] [z'] [z≡z']
                                   [s] [s'] [s≡s']
                                   ⊢Δ [σ] [σ'] [σ≡σ'] [n'] [m'] [n'≡m']))
      reduction₁ = natrec-subst* ⊢F ⊢z ⊢s (redₜ d) [σℕ] [σsn']
                     (λ {t} {t'} [t] [t'] [t≡t'] →
                        PE.subst₂ (λ x y → _ ⊢ x ≡ y)
                                  (PE.sym (singleSubstComp t σ F))
                                  (PE.sym (singleSubstComp t' σ F))
                                  (≅-eq (wellformedEq (proj₁ ([F] ⊢Δ ([σ] , [t])))
                                               (proj₂ ([F] ⊢Δ ([σ] , [t]))
                                                      ([σ] , [t'])
                                                      (reflSubst [Γ] ⊢Δ [σ] , [t≡t'])))))
                   ⇨∷* (conv* (natrec-suc ⊢n' ⊢F ⊢z ⊢s
                   ⇨   id (wellformedTerm [σFₛₙ'] natrecN'))
                          (sym (≅-eq (wellformedEq [σFₙ] [Fₙ≡Fₛₙ']))))
      reduction₂ = natrec-subst* ⊢F' ⊢z' ⊢s' (redₜ d') [σ'ℕ] [σ'sm']
                     (λ {t} {t'} [t] [t'] [t≡t'] →
                        PE.subst₂ (λ x y → _ ⊢ x ≡ y)
                                  (PE.sym (singleSubstComp t σ' F'))
                                  (PE.sym (singleSubstComp t' σ' F'))
                                  (≅-eq (wellformedEq (proj₁ ([F'] ⊢Δ ([σ'] , [t])))
                                               (proj₂ ([F'] ⊢Δ ([σ'] , [t]))
                                                      ([σ'] , [t'])
                                                      (reflSubst [Γ] ⊢Δ [σ'] , [t≡t'])))))
                   ⇨∷* (conv* (natrec-suc ⊢m' ⊢F' ⊢z' ⊢s'
                   ⇨   id (wellformedTerm [σ'F'ₛₘ'] natrecM'))
                          (sym (≅-eq (wellformedEq [σ'F'ₘ] [F'ₘ≡F'ₛₘ']))))
      eq₁ = proj₂ (redSubst*Term reduction₁ [σFₙ]
                                 (convTerm₂ [σFₙ] [σFₛₙ']
                                            [Fₙ≡Fₛₙ'] natrecN'))
      eq₂ = proj₂ (redSubst*Term reduction₂ [σ'F'ₘ]
                                 (convTerm₂ [σ'F'ₘ] [σ'F'ₛₘ']
                                            [F'ₘ≡F'ₛₘ'] natrecM'))
  in  transEqTerm [σFₙ] eq₁
                  (transEqTerm [σFₙ] appEq
                               (convEqTerm₂ [σFₙ] [σ'F'ₘ] [σFₙ≡σ'F'ₘ]
                                            (symEqTerm [σ'F'ₘ] eq₂)))
natrec-congTerm {F} {F'} {z} {z'} {s} {s'} {n} {m} {Γ} {Δ} {σ} {σ'} {l}
                [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                (ℕₜ .zeroₑ d n≡n zero) (ℕₜ .zeroₑ d₁ m≡m zero)
                (ℕₜ₌ .zeroₑ .zeroₑ d₂ d' t≡u zero) =
  let [ℕ] = ℕₛ {l = l} [Γ]
      [σℕ] = proj₁ ([ℕ] ⊢Δ [σ])
      ⊢ℕ = wellformed (proj₁ ([ℕ] ⊢Δ [σ]))
      ⊢F = wellformed (proj₁ ([F] {σ = liftSubst σ} (⊢Δ ∙ ⊢ℕ)
                                 (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ])))
      ⊢z = PE.subst (λ x → _ ⊢ _ ∷ x) (singleSubstLift F zeroₑ)
                    (wellformedTerm (proj₁ ([F₀] ⊢Δ [σ])) (proj₁ ([z] ⊢Δ [σ])))
      ⊢s = PE.subst (λ x → Δ ⊢ subst σ s ∷ x) (natrecSucCase σ F)
                    (wellformedTerm (proj₁ ([F₊] ⊢Δ [σ])) (proj₁ ([s] ⊢Δ [σ])))
      ⊢F' = wellformed (proj₁ ([F'] {σ = liftSubst σ'} (⊢Δ ∙ ⊢ℕ)
                                   (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ'])))
      ⊢z' = PE.subst (λ x → _ ⊢ _ ∷ x) (singleSubstLift F' zeroₑ)
                     (wellformedTerm (proj₁ ([F'₀] ⊢Δ [σ'])) (proj₁ ([z'] ⊢Δ [σ'])))
      ⊢s' = PE.subst (λ x → Δ ⊢ subst σ' s' ∷ x) (natrecSucCase σ' F')
                     (wellformedTerm (proj₁ ([F'₊] ⊢Δ [σ'])) (proj₁ ([s'] ⊢Δ [σ'])))
      ⊢n = wellformedTerm {l = l} (ℕ ([ ⊢ℕ , ⊢ℕ , id ⊢ℕ ]))
                          (ℕₜ zeroₑ d n≡n zero)
      [σ0] = irrelevanceTerm {l = l} (ℕ (idRed:*: (ℕ ⊢Δ))) (proj₁ ([ℕ] ⊢Δ [σ]))
                             (ℕₜ zeroₑ (idRedTerm:*: (zero ⊢Δ)) n≡n zero)
      [σ'0] = irrelevanceTerm {l = l} (ℕ (idRed:*: (ℕ ⊢Δ))) (proj₁ ([ℕ] ⊢Δ [σ']))
                              (ℕₜ zeroₑ (idRedTerm:*: (zero ⊢Δ)) m≡m zero)
      [σn]' , [σn≡σ0] = redSubst*Term (redₜ d) (proj₁ ([ℕ] ⊢Δ [σ])) [σ0]
      [σ'm]' , [σ'm≡σ'0] = redSubst*Term (redₜ d') (proj₁ ([ℕ] ⊢Δ [σ'])) [σ'0]
      [σn] = ℕₜ zeroₑ d n≡n zero
      [σ'm] = ℕₜ zeroₑ d' m≡m zero
      [σn≡σ'm] = ℕₜ₌ zeroₑ zeroₑ d₂ d' t≡u zero
      [σn≡σ'0] = transEqTerm [σℕ] [σn≡σ'm] [σ'm≡σ'0]
      [σFₙ]' = proj₁ ([F] ⊢Δ ([σ] , [σn]))
      [σFₙ] = irrelevance' (PE.sym (singleSubstComp n σ F)) [σFₙ]'
      [σ'Fₘ]' = proj₁ ([F] ⊢Δ ([σ'] , [σ'm]))
      [σ'Fₘ] = irrelevance' (PE.sym (singleSubstComp m σ' F)) [σ'Fₘ]'
      [σ'F'ₘ]' = proj₁ ([F'] ⊢Δ ([σ'] , [σ'm]))
      [σ'F'ₘ] = irrelevance' (PE.sym (singleSubstComp m σ' F')) [σ'F'ₘ]'
      [σFₙ≡σ'Fₘ] = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                   (PE.sym (singleSubstComp m σ' F))
                                   [σFₙ]' [σFₙ]
                                   (proj₂ ([F] ⊢Δ ([σ] , [σn])) ([σ'] , [σ'm])
                                          ([σ≡σ'] , [σn≡σ'm]))
      [σ'Fₘ≡σ'F'ₘ] = irrelevanceEq'' (PE.sym (singleSubstComp m σ' F))
                                     (PE.sym (singleSubstComp m σ' F'))
                                     [σ'Fₘ]' [σ'Fₘ] ([F≡F'] ⊢Δ ([σ'] , [σ'm]))
      [σFₙ≡σ'F'ₘ] = transEq [σFₙ] [σ'Fₘ] [σ'F'ₘ] [σFₙ≡σ'Fₘ] [σ'Fₘ≡σ'F'ₘ]
      [σF₀] = irrelevance' (PE.sym (singleSubstComp zeroₑ σ F))
                           (proj₁ ([F] ⊢Δ ([σ] , [σ0])))
      [σ'F₀] = irrelevance' (PE.sym (singleSubstComp zeroₑ σ' F))
                            (proj₁ ([F] ⊢Δ ([σ'] , [σ'0])))
      [Fₙ≡F₀]' = proj₂ ([F] ⊢Δ ([σ] , [σn])) ([σ] , [σ0]) (reflSubst [Γ] ⊢Δ [σ] , [σn≡σ0])
      [Fₙ≡F₀] = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                (PE.sym (substCompEq F))
                                [σFₙ]' [σFₙ] [Fₙ≡F₀]'
      [σFₙ≡σ'F₀]' = proj₂ ([F] ⊢Δ ([σ] , [σn])) ([σ'] , [σ'0]) ([σ≡σ'] , [σn≡σ'0])
      [σFₙ≡σ'F₀] = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                (PE.sym (substCompEq F))
                                [σFₙ]' [σFₙ] [σFₙ≡σ'F₀]'
      [F'ₘ≡F'₀]' = proj₂ ([F'] ⊢Δ ([σ'] , [σ'm])) ([σ'] , [σ'0])
                         (reflSubst [Γ] ⊢Δ [σ'] , [σ'm≡σ'0])
      [F'ₘ≡F'₀] = irrelevanceEq'' (PE.sym (singleSubstComp m σ' F'))
                                  (PE.sym (substCompEq F'))
                                  [σ'F'ₘ]' [σ'F'ₘ] [F'ₘ≡F'₀]'
      [Fₙ≡F₀]'' = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                  (PE.trans (substConcatSingleton' F)
                                            (PE.sym (singleSubstComp zeroₑ σ F)))
                                  [σFₙ]' [σFₙ] [Fₙ≡F₀]'
      [F'ₘ≡F'₀]'' = irrelevanceEq'' (PE.sym (singleSubstComp m σ' F'))
                                    (PE.trans (substConcatSingleton' F')
                                              (PE.sym (singleSubstComp zeroₑ σ' F')))
                                    [σ'F'ₘ]' [σ'F'ₘ] [F'ₘ≡F'₀]'
      [σz] = proj₁ ([z] ⊢Δ [σ])
      [σ'z'] = proj₁ ([z'] ⊢Δ [σ'])
      [σz≡σ'z] = convEqTerm₂ [σFₙ] (proj₁ ([F₀] ⊢Δ [σ])) [Fₙ≡F₀]
                             (proj₂ ([z] ⊢Δ [σ]) [σ'] [σ≡σ'])
      [σ'z≡σ'z'] = convEqTerm₂ [σFₙ] (proj₁ ([F₀] ⊢Δ [σ'])) [σFₙ≡σ'F₀]
                               ([z≡z'] ⊢Δ [σ'])
      [σz≡σ'z'] = transEqTerm [σFₙ] [σz≡σ'z] [σ'z≡σ'z']
      reduction₁ = natrec-subst* ⊢F ⊢z ⊢s (redₜ d) (proj₁ ([ℕ] ⊢Δ [σ])) [σ0]
                    (λ {t} {t'} [t] [t'] [t≡t'] →
                       PE.subst₂ (λ x y → _ ⊢ x ≡ y)
                                 (PE.sym (singleSubstComp t σ F))
                                 (PE.sym (singleSubstComp t' σ F))
                                 (≅-eq (wellformedEq (proj₁ ([F] ⊢Δ ([σ] , [t])))
                                              (proj₂ ([F] ⊢Δ ([σ] , [t]))
                                                     ([σ] , [t'])
                                                     (reflSubst [Γ] ⊢Δ [σ] , [t≡t'])))))
                  ⇨∷* (conv* (natrec-zero ⊢F ⊢z ⊢s ⇨ id ⊢z)
                             (sym (≅-eq (wellformedEq [σFₙ] [Fₙ≡F₀]''))))
      reduction₂ = natrec-subst* ⊢F' ⊢z' ⊢s' (redₜ d') (proj₁ ([ℕ] ⊢Δ [σ'])) [σ'0]
                    (λ {t} {t'} [t] [t'] [t≡t'] →
                       PE.subst₂ (λ x y → _ ⊢ x ≡ y)
                                 (PE.sym (singleSubstComp t σ' F'))
                                 (PE.sym (singleSubstComp t' σ' F'))
                                 (≅-eq (wellformedEq (proj₁ ([F'] ⊢Δ ([σ'] , [t])))
                                              (proj₂ ([F'] ⊢Δ ([σ'] , [t]))
                                                     ([σ'] , [t'])
                                                     (reflSubst [Γ] ⊢Δ [σ'] , [t≡t'])))))
                  ⇨∷* (conv* (natrec-zero ⊢F' ⊢z' ⊢s' ⇨ id ⊢z')
                             (sym (≅-eq (wellformedEq [σ'F'ₘ] [F'ₘ≡F'₀]''))))
      eq₁ = proj₂ (redSubst*Term reduction₁ [σFₙ]
                                 (convTerm₂ [σFₙ] (proj₁ ([F₀] ⊢Δ [σ]))
                                            [Fₙ≡F₀] [σz]))
      eq₂ = proj₂ (redSubst*Term reduction₂ [σ'F'ₘ]
                                 (convTerm₂ [σ'F'ₘ] (proj₁ ([F'₀] ⊢Δ [σ']))
                                            [F'ₘ≡F'₀] [σ'z']))
  in  transEqTerm [σFₙ] eq₁
                  (transEqTerm [σFₙ] [σz≡σ'z']
                               (convEqTerm₂ [σFₙ] [σ'F'ₘ] [σFₙ≡σ'F'ₘ]
                                            (symEqTerm [σ'F'ₘ] eq₂)))
natrec-congTerm {F} {F'} {z} {z'} {s} {s'} {n} {m} {Γ} {Δ} {σ} {σ'} {l}
                [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                (ℕₜ n' d n≡n (ne (neNfₜ neN' ⊢n' n≡n₁)))
                (ℕₜ m' d' m≡m (ne (neNfₜ neM' ⊢m' m≡m₁)))
                (ℕₜ₌ n'' m'' d₁ d₁' t≡u (ne (neNfₜ₌ x₂ x₃ prop₂))) =
  let n''≡n' = whrDet*Term (redₜ d₁ , ne x₂) (redₜ d , ne neN')
      m''≡m' = whrDet*Term (redₜ d₁' , ne x₃) (redₜ d' , ne neM')
      [ℕ] = ℕₛ {l = l} [Γ]
      [σℕ] = proj₁ ([ℕ] ⊢Δ [σ])
      [σ'ℕ] = proj₁ ([ℕ] ⊢Δ [σ'])
      [σn] = ℕₜ n' d n≡n (ne (neNfₜ neN' ⊢n' n≡n₁))
      [σ'm] = ℕₜ m' d' m≡m (ne (neNfₜ neM' ⊢m' m≡m₁))
      [σn≡σ'm] = ℕₜ₌ n'' m'' d₁ d₁' t≡u (ne (neNfₜ₌ x₂ x₃ prop₂))
      ⊢ℕ = wellformed (proj₁ ([ℕ] ⊢Δ [σ]))
      [σF] = proj₁ ([F] (⊢Δ ∙ ⊢ℕ) (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ]))
      [σ'F] = proj₁ ([F] (⊢Δ ∙ ⊢ℕ) (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ']))
      [σ'F'] = proj₁ ([F'] (⊢Δ ∙ ⊢ℕ) (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ']))
      ⊢F = wellformed [σF]
      ⊢F≡F = wellformedEq [σF] (reflEq [σF])
      ⊢z = PE.subst (λ x → _ ⊢ _ ∷ x) (singleSubstLift F zeroₑ)
                    (wellformedTerm (proj₁ ([F₀] ⊢Δ [σ])) (proj₁ ([z] ⊢Δ [σ])))
      ⊢z≡z = PE.subst (λ x → _ ⊢ _ ≅ _ ∷ x) (singleSubstLift F zeroₑ)
                      (wellformedTermEq (proj₁ ([F₀] ⊢Δ [σ]))
                                        (reflEqTerm (proj₁ ([F₀] ⊢Δ [σ]))
                                                    (proj₁ ([z] ⊢Δ [σ]))))
      ⊢s = PE.subst (λ x → Δ ⊢ subst σ s ∷ x) (natrecSucCase σ F)
                    (wellformedTerm (proj₁ ([F₊] ⊢Δ [σ])) (proj₁ ([s] ⊢Δ [σ])))
      ⊢s≡s = PE.subst (λ x → Δ ⊢ subst σ s ≅ subst σ s ∷ x) (natrecSucCase σ F)
                      (wellformedTermEq (proj₁ ([F₊] ⊢Δ [σ]))
                                        (reflEqTerm (proj₁ ([F₊] ⊢Δ [σ]))
                                                    (proj₁ ([s] ⊢Δ [σ]))))
      ⊢F' = wellformed [σ'F']
      ⊢F'≡F' = wellformedEq [σ'F'] (reflEq [σ'F'])
      ⊢z' = PE.subst (λ x → _ ⊢ _ ∷ x) (singleSubstLift F' zeroₑ)
                     (wellformedTerm (proj₁ ([F'₀] ⊢Δ [σ'])) (proj₁ ([z'] ⊢Δ [σ'])))
      ⊢z'≡z' = PE.subst (λ x → _ ⊢ _ ≅ _ ∷ x) (singleSubstLift F' zeroₑ)
                        (wellformedTermEq (proj₁ ([F'₀] ⊢Δ [σ']))
                                          (reflEqTerm (proj₁ ([F'₀] ⊢Δ [σ']))
                                                      (proj₁ ([z'] ⊢Δ [σ']))))
      ⊢s' = PE.subst (λ x → Δ ⊢ subst σ' s' ∷ x) (natrecSucCase σ' F')
                     (wellformedTerm (proj₁ ([F'₊] ⊢Δ [σ'])) (proj₁ ([s'] ⊢Δ [σ'])))
      ⊢s'≡s' = PE.subst (λ x → Δ ⊢ subst σ' s' ≅ subst σ' s' ∷ x) (natrecSucCase σ' F')
                      (wellformedTermEq (proj₁ ([F'₊] ⊢Δ [σ']))
                                        (reflEqTerm (proj₁ ([F'₊] ⊢Δ [σ']))
                                                    (proj₁ ([s'] ⊢Δ [σ']))))
      ⊢σF≡σ'F = wellformedEq [σF] (proj₂ ([F] {σ = liftSubst σ} (⊢Δ ∙ ⊢ℕ)
                                           (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ]))
                                      {σ' = liftSubst σ'}
                                      (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ'])
                                      (liftSubstSEq {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ] [σ≡σ']))
      ⊢σz≡σ'z = PE.subst (λ x → _ ⊢ _ ≅ _ ∷ x) (singleSubstLift F zeroₑ)
                         (wellformedTermEq (proj₁ ([F₀] ⊢Δ [σ]))
                                          (proj₂ ([z] ⊢Δ [σ]) [σ'] [σ≡σ']))
      ⊢σs≡σ's = PE.subst (λ x → Δ ⊢ subst σ s ≅ subst σ' s ∷ x)
                         (natrecSucCase σ F)
                         (wellformedTermEq (proj₁ ([F₊] ⊢Δ [σ]))
                                          (proj₂ ([s] ⊢Δ [σ]) [σ'] [σ≡σ']))
      ⊢σ'F≡⊢σ'F' = wellformedEq [σ'F] ([F≡F'] (⊢Δ ∙ ⊢ℕ)
                               (liftSubstS {F = ℕₑ} [Γ] ⊢Δ [ℕ] [σ']))
      ⊢σ'z≡⊢σ'z' = PE.subst (λ x → _ ⊢ _ ≅ _ ∷ x)
                            (singleSubstLift F zeroₑ)
                            (≅-conv (wellformedTermEq (proj₁ ([F₀] ⊢Δ [σ']))
                                                   ([z≡z'] ⊢Δ [σ']))
                                  (sym (≅-eq (wellformedEq (proj₁ ([F₀] ⊢Δ [σ]))
                                                    (proj₂ ([F₀] ⊢Δ [σ]) [σ'] [σ≡σ'])))))
      ⊢σ's≡⊢σ's' = PE.subst (λ x → Δ ⊢ subst σ' s ≅ subst σ' s' ∷ x)
                            (natrecSucCase σ F)
                            (≅-conv (wellformedTermEq (proj₁ ([F₊] ⊢Δ [σ']))
                                                   ([s≡s'] ⊢Δ [σ']))
                                  (sym (≅-eq (wellformedEq (proj₁ ([F₊] ⊢Δ [σ]))
                                                    (proj₂ ([F₊] ⊢Δ [σ]) [σ'] [σ≡σ'])))))
      ⊢F≡F' = ≅-trans ⊢σF≡σ'F ⊢σ'F≡⊢σ'F'
      ⊢z≡z' = ≅ₜ-trans ⊢σz≡σ'z ⊢σ'z≡⊢σ'z'
      ⊢s≡s' = ≅ₜ-trans ⊢σs≡σ's ⊢σ's≡⊢σ's'
      ⊢n = wellformedTerm [σℕ] [σn]
      [σn'] = neuTerm [σℕ] neN' ⊢n' n≡n₁
      [σn]' , [σn≡σn'] = redSubst*Term (redₜ d) [σℕ] [σn']
      [σFₙ]' = proj₁ ([F] ⊢Δ ([σ] , [σn]))
      [σFₙ] = irrelevance' (PE.sym (singleSubstComp n σ F)) [σFₙ]'
      [σFₙ'] = irrelevance' (PE.sym (singleSubstComp n' σ F))
                            (proj₁ ([F] ⊢Δ ([σ] , [σn'])))
      [Fₙ≡Fₙ'] = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                (PE.sym (singleSubstComp n' σ F)) [σFₙ]' [σFₙ]
                                ((proj₂ ([F] ⊢Δ ([σ] , [σn])))
                                        ([σ] , [σn'])
                                        (reflSubst [Γ] ⊢Δ [σ] , [σn≡σn']))
      [σ'm'] = neuTerm [σ'ℕ] neM' ⊢m' m≡m₁
      [σ'm]' , [σ'm≡σ'm'] = redSubst*Term (redₜ d') [σ'ℕ] [σ'm']
      [σ'F'ₘ]' = proj₁ ([F'] ⊢Δ ([σ'] , [σ'm]))
      [σ'F'ₘ] = irrelevance' (PE.sym (singleSubstComp m σ' F')) [σ'F'ₘ]'
      [σ'Fₘ]' = proj₁ ([F] ⊢Δ ([σ'] , [σ'm]))
      [σ'Fₘ] = irrelevance' (PE.sym (singleSubstComp m σ' F)) [σ'Fₘ]'
      [σ'F'ₘ'] = irrelevance' (PE.sym (singleSubstComp m' σ' F'))
                              (proj₁ ([F'] ⊢Δ ([σ'] , [σ'm'])))
      [F'ₘ≡F'ₘ'] = irrelevanceEq'' (PE.sym (singleSubstComp m σ' F'))
                                   (PE.sym (singleSubstComp m' σ' F'))
                                   [σ'F'ₘ]' [σ'F'ₘ]
                                   ((proj₂ ([F'] ⊢Δ ([σ'] , [σ'm])))
                                           ([σ'] , [σ'm'])
                                           (reflSubst [Γ] ⊢Δ [σ'] , [σ'm≡σ'm']))
      [σFₙ≡σ'Fₘ] = irrelevanceEq'' (PE.sym (singleSubstComp n σ F))
                                   (PE.sym (singleSubstComp m σ' F))
                                   [σFₙ]' [σFₙ]
                                   (proj₂ ([F] ⊢Δ ([σ] , [σn])) ([σ'] , [σ'm])
                                          ([σ≡σ'] , [σn≡σ'm]))
      [σ'Fₘ≡σ'F'ₘ] = irrelevanceEq'' (PE.sym (singleSubstComp m σ' F))
                                     (PE.sym (singleSubstComp m σ' F'))
                                     (proj₁ ([F] ⊢Δ ([σ'] , [σ'm])))
                                     [σ'Fₘ] ([F≡F'] ⊢Δ ([σ'] , [σ'm]))
      [σFₙ≡σ'F'ₘ] = transEq [σFₙ] [σ'Fₘ] [σ'F'ₘ] [σFₙ≡σ'Fₘ] [σ'Fₘ≡σ'F'ₘ]
      [σFₙ'≡σ'Fₘ'] = transEq [σFₙ'] [σFₙ] [σ'F'ₘ'] (symEq [σFₙ] [σFₙ'] [Fₙ≡Fₙ'])
                             (transEq [σFₙ] [σ'F'ₘ] [σ'F'ₘ'] [σFₙ≡σ'F'ₘ] [F'ₘ≡F'ₘ'])
      natrecN = neuTerm [σFₙ'] (natrec neN') (natrec ⊢F ⊢z ⊢s ⊢n')
                        (~-natrec ⊢F≡F ⊢z≡z ⊢s≡s n≡n₁)
      natrecM = neuTerm [σ'F'ₘ'] (natrec neM') (natrec ⊢F' ⊢z' ⊢s' ⊢m')
                        (~-natrec ⊢F'≡F' ⊢z'≡z' ⊢s'≡s' m≡m₁)
      natrecN≡M =
        convEqTerm₂ [σFₙ] [σFₙ'] [Fₙ≡Fₙ']
          (neuEqTerm [σFₙ'] (natrec neN') (natrec neM')
                     (natrec ⊢F ⊢z ⊢s ⊢n')
                     (conv (natrec ⊢F' ⊢z' ⊢s' ⊢m')
                            (sym (≅-eq (wellformedEq [σFₙ'] [σFₙ'≡σ'Fₘ']))))
                     (~-natrec ⊢F≡F' ⊢z≡z' ⊢s≡s'
                               (PE.subst₂ (λ x y → _ ⊢ x ~ y ∷ _)
                                          n''≡n' m''≡m' prop₂)))
      reduction₁ = natrec-subst* ⊢F ⊢z ⊢s (redₜ d) [σℕ] [σn']
                     (λ {t} {t'} [t] [t'] [t≡t'] →
                        PE.subst₂ (λ x y → _ ⊢ x ≡ y)
                                  (PE.sym (singleSubstComp t σ F))
                                  (PE.sym (singleSubstComp t' σ F))
                                  (≅-eq (wellformedEq (proj₁ ([F] ⊢Δ ([σ] , [t])))
                                               (proj₂ ([F] ⊢Δ ([σ] , [t]))
                                                      ([σ] , [t'])
                                                      (reflSubst [Γ] ⊢Δ [σ] , [t≡t'])))))
      reduction₂ = natrec-subst* ⊢F' ⊢z' ⊢s' (redₜ d') [σ'ℕ] [σ'm']
                     (λ {t} {t'} [t] [t'] [t≡t'] →
                        PE.subst₂ (λ x y → _ ⊢ x ≡ y)
                                  (PE.sym (singleSubstComp t σ' F'))
                                  (PE.sym (singleSubstComp t' σ' F'))
                                  (≅-eq (wellformedEq (proj₁ ([F'] ⊢Δ ([σ'] , [t])))
                                               (proj₂ ([F'] ⊢Δ ([σ'] , [t]))
                                                      ([σ'] , [t'])
                                                      (reflSubst [Γ] ⊢Δ [σ'] , [t≡t'])))))
      eq₁ = proj₂ (redSubst*Term reduction₁ [σFₙ]
                                 (convTerm₂ [σFₙ] [σFₙ'] [Fₙ≡Fₙ'] natrecN))
      eq₂ = proj₂ (redSubst*Term reduction₂ [σ'F'ₘ]
                                 (convTerm₂ [σ'F'ₘ] [σ'F'ₘ'] [F'ₘ≡F'ₘ'] natrecM))
  in  transEqTerm [σFₙ] eq₁
                  (transEqTerm [σFₙ] natrecN≡M
                               (convEqTerm₂ [σFₙ] [σ'F'ₘ] [σFₙ≡σ'F'ₘ]
                                            (symEqTerm [σ'F'ₘ] eq₂)))
-- Refuting cases
natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                [σn] (ℕₜ zeroₑ d₁ _ zero)
                (ℕₜ₌ _ _ d₂ d' t≡u (suc prop₂)) =
  ⊥-elim (zero≢suc (whrDet*Term (redₜ d₁ , zero) (redₜ d' , suc)))
natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                [σn] (ℕₜ n d₁ _ (ne (neNfₜ neK ⊢k k≡k)))
                (ℕₜ₌ _ _ d₂ d' t≡u (suc prop₂)) =
  ⊥-elim (suc≢ne neK (whrDet*Term (redₜ d' , suc) (redₜ d₁ , ne neK)))
natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                (ℕₜ zeroₑ d _ zero) [σm]
                (ℕₜ₌ _ _ d₁ d' t≡u (suc prop₂)) =
  ⊥-elim (zero≢suc (whrDet*Term (redₜ d , zero) (redₜ d₁ , suc)))
natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                (ℕₜ n d _ (ne (neNfₜ neK ⊢k k≡k))) [σm]
                (ℕₜ₌ _ _ d₁ d' t≡u (suc prop₂)) =
  ⊥-elim (suc≢ne neK (whrDet*Term (redₜ d₁ , suc) (redₜ d , ne neK)))

natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                (ℕₜ _ d _ (suc prop)) [σm]
                (ℕₜ₌ .zeroₑ .zeroₑ d₂ d' t≡u zero) =
  ⊥-elim (zero≢suc (whrDet*Term (redₜ d₂ , zero) (redₜ d , suc)))
natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                [σn] (ℕₜ _ d₁ _ (suc prop₁))
                (ℕₜ₌ .zeroₑ .zeroₑ d₂ d' t≡u zero) =
  ⊥-elim (zero≢suc (whrDet*Term (redₜ d' , zero) (redₜ d₁ , suc)))
natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                [σn] (ℕₜ n d₁ _ (ne (neNfₜ neK ⊢k k≡k)))
                (ℕₜ₌ .zeroₑ .zeroₑ d₂ d' t≡u zero) =
  ⊥-elim (zero≢ne neK (whrDet*Term (redₜ d' , zero) (redₜ d₁ , ne neK)))
natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                (ℕₜ n d _ (ne (neNfₜ neK ⊢k k≡k))) [σm]
                (ℕₜ₌ .zeroₑ .zeroₑ d₂ d' t≡u zero) =
  ⊥-elim (zero≢ne neK (whrDet*Term (redₜ d₂ , zero) (redₜ d , ne neK)))

natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                (ℕₜ _ d _ (suc prop)) [σm]
                (ℕₜ₌ n₁ n' d₂ d' t≡u (ne (neNfₜ₌ x x₁ prop₂))) =
  ⊥-elim (suc≢ne x (whrDet*Term (redₜ d , suc) (redₜ d₂ , ne x)))
natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                (ℕₜ zeroₑ d _ zero) [σm]
                (ℕₜ₌ n₁ n' d₂ d' t≡u (ne (neNfₜ₌ x x₁ prop₂))) =
  ⊥-elim (zero≢ne x (whrDet*Term (redₜ d , zero) (redₜ d₂ , ne x)))
natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                [σn] (ℕₜ _ d₁ _ (suc prop₁))
                (ℕₜ₌ n₁ n' d₂ d' t≡u (ne (neNfₜ₌ x₁ x₂ prop₂))) =
  ⊥-elim (suc≢ne x₂ (whrDet*Term (redₜ d₁ , suc) (redₜ d' , ne x₂)))
natrec-congTerm [Γ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
                [z] [z'] [z≡z'] [s] [s'] [s≡s'] ⊢Δ [σ] [σ'] [σ≡σ']
                [σn] (ℕₜ zeroₑ d₁ _ zero)
                (ℕₜ₌ n₁ n' d₂ d' t≡u (ne (neNfₜ₌ x₁ x₂ prop₂))) =
  ⊥-elim (zero≢ne x₂ (whrDet*Term (redₜ d₁ , zero) (redₜ d' , ne x₂)))

natrecₛ : ∀ {F z s n Γ} ([Γ] : ⊩ₛ Γ)
          ([ℕ]  : Γ ⊩ₛ⟨ ¹ ⟩ ℕₑ / [Γ])
          ([F]  : Γ ∙ ℕₑ ⊩ₛ⟨ ¹ ⟩ F / [Γ] ∙ [ℕ])
          ([F₀] : Γ ⊩ₛ⟨ ¹ ⟩ F [ zeroₑ ] / [Γ])
          ([F₊] : Γ ⊩ₛ⟨ ¹ ⟩ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑) / [Γ])
          ([Fₙ] : Γ ⊩ₛ⟨ ¹ ⟩ F [ n ] / [Γ])
        → Γ ⊩ₛ⟨ ¹ ⟩ z ∷ F [ zeroₑ ] / [Γ] / [F₀]
        → Γ ⊩ₛ⟨ ¹ ⟩ s ∷ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑) / [Γ] / [F₊]
        → ([n] : Γ ⊩ₛ⟨ ¹ ⟩ n ∷ ℕₑ / [Γ] / [ℕ])
        → Γ ⊩ₛ⟨ ¹ ⟩ natrecₑ F z s n ∷ F [ n ] / [Γ] / [Fₙ]
natrecₛ {F} {z} {s} {n} [Γ] [ℕ] [F] [F₀] [F₊] [Fₙ] [z] [s] [n]
        {Δ = Δ} {σ = σ} ⊢Δ [σ] =
  let [F]' = S.irrelevance {A = F} (_∙_ {A = ℕₑ} [Γ] [ℕ])
                           (_∙_ {l = ¹} [Γ] (ℕₛ [Γ])) [F]
      [σn]' = irrelevanceTerm {l' = ¹} (proj₁ ([ℕ] ⊢Δ [σ]))
                              (ℕ (idRed:*: (ℕ ⊢Δ))) (proj₁ ([n] ⊢Δ [σ]))
      n' = subst σ n
      eqPrf = PE.trans (singleSubstComp n' σ F)
                       (PE.sym (PE.trans (substCompEq F)
                               (substConcatSingleton' F)))
  in  irrelevanceTerm' eqPrf (irrelevance' (PE.sym (singleSubstComp n' σ F))
                                           (proj₁ ([F]' ⊢Δ ([σ] , [σn]'))))
                        (proj₁ ([Fₙ] ⊢Δ [σ]))
                   (natrecTerm {F} {z} {s} {n'} {σ = σ} [Γ]
                               [F]'
                               [F₀] [F₊] [z] [s] ⊢Δ [σ]
                               [σn]')
 ,   (λ {σ'} [σ'] [σ≡σ'] →
        let [σ'n]' = irrelevanceTerm {l' = ¹} (proj₁ ([ℕ] ⊢Δ [σ']))
                                     (ℕ (idRed:*: (ℕ ⊢Δ)))
                                     (proj₁ ([n] ⊢Δ [σ']))
            [σn≡σ'n] = irrelevanceEqTerm {l' = ¹} (proj₁ ([ℕ] ⊢Δ [σ]))
                                         (ℕ (idRed:*: (ℕ ⊢Δ)))
                                         (proj₂ ([n] ⊢Δ [σ]) [σ'] [σ≡σ'])
        in  irrelevanceEqTerm' eqPrf
              (irrelevance' (PE.sym (singleSubstComp n' σ F))
                            (proj₁ ([F]' ⊢Δ ([σ] , [σn]'))))
              (proj₁ ([Fₙ] ⊢Δ [σ]))
              (natrec-congTerm {F} {F} {z} {z} {s} {s} {n'} {subst σ' n} {σ = σ}
                               [Γ] [F]' [F]' (reflₛ {F} (_∙_ {A = ℕₑ} {l = ¹}
                               [Γ] (ℕₛ [Γ])) [F]') [F₀] [F₀]
                               (reflₛ {F [ zeroₑ ]} [Γ] [F₀]) [F₊] [F₊]
                               (reflₛ {Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑)}
                                      [Γ] [F₊])
                               [z] [z] (reflₜₛ {F [ zeroₑ ]} {z} [Γ] [F₀] [z])
                               [s] [s]
                               (reflₜₛ {Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑)} {s}
                                       [Γ] [F₊] [s])
                               ⊢Δ [σ] [σ'] [σ≡σ'] [σn]' [σ'n]' [σn≡σ'n]))

natrec-congₛ : ∀ {F F' z z' s s' n n' Γ} ([Γ] : ⊩ₛ Γ)
          ([ℕ]  : Γ ⊩ₛ⟨ ¹ ⟩ ℕₑ / [Γ])
          ([F]  : Γ ∙ ℕₑ ⊩ₛ⟨ ¹ ⟩ F / [Γ] ∙ [ℕ])
          ([F']  : Γ ∙ ℕₑ ⊩ₛ⟨ ¹ ⟩ F' / [Γ] ∙ [ℕ])
          ([F≡F']  : Γ ∙ ℕₑ ⊩ₛ⟨ ¹ ⟩ F ≡ F' / [Γ] ∙ [ℕ] / [F])
          ([F₀] : Γ ⊩ₛ⟨ ¹ ⟩ F [ zeroₑ ] / [Γ])
          ([F'₀] : Γ ⊩ₛ⟨ ¹ ⟩ F' [ zeroₑ ] / [Γ])
          ([F₀≡F'₀] : Γ ⊩ₛ⟨ ¹ ⟩ F [ zeroₑ ] ≡ F' [ zeroₑ ] / [Γ] / [F₀])
          ([F₊] : Γ ⊩ₛ⟨ ¹ ⟩ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑) / [Γ])
          ([F'₊] : Γ ⊩ₛ⟨ ¹ ⟩ Πₑ ℕₑ ▹ (F' ▹▹ F' [ sucₑ (var zero) ]↑) / [Γ])
          ([F₊≡F'₊] : Γ ⊩ₛ⟨ ¹ ⟩ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑)
                              ≡ Πₑ ℕₑ ▹ (F' ▹▹ F' [ sucₑ (var zero) ]↑) / [Γ]
                              / [F₊])
          ([Fₙ] : Γ ⊩ₛ⟨ ¹ ⟩ F [ n ] / [Γ])
          ([z] : Γ ⊩ₛ⟨ ¹ ⟩ z ∷ F [ zeroₑ ] / [Γ] / [F₀])
          ([z'] : Γ ⊩ₛ⟨ ¹ ⟩ z' ∷ F' [ zeroₑ ] / [Γ] / [F'₀])
          ([z≡z'] : Γ ⊩ₛ⟨ ¹ ⟩ z ≡ z' ∷ F [ zeroₑ ] / [Γ] / [F₀])
          ([s] : Γ ⊩ₛ⟨ ¹ ⟩ s ∷ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑) / [Γ] / [F₊])
          ([s'] : Γ ⊩ₛ⟨ ¹ ⟩ s' ∷ Πₑ ℕₑ ▹ (F' ▹▹ F' [ sucₑ (var zero) ]↑) / [Γ]
                           / [F'₊])
          ([s≡s'] : Γ ⊩ₛ⟨ ¹ ⟩ s ≡ s' ∷ Πₑ ℕₑ ▹ (F ▹▹ F [ sucₑ (var zero) ]↑)
                             / [Γ] / [F₊])
          ([n] : Γ ⊩ₛ⟨ ¹ ⟩ n ∷ ℕₑ / [Γ] / [ℕ])
          ([n'] : Γ ⊩ₛ⟨ ¹ ⟩ n' ∷ ℕₑ / [Γ] / [ℕ])
          ([n≡n'] : Γ ⊩ₛ⟨ ¹ ⟩ n ≡ n' ∷ ℕₑ / [Γ] / [ℕ])
        → Γ ⊩ₛ⟨ ¹ ⟩ natrecₑ F z s n ≡ natrecₑ F' z' s' n' ∷ F [ n ] / [Γ] / [Fₙ]
natrec-congₛ {F} {F'} {z} {z'} {s} {s'} {n} {n'}
             [Γ] [ℕ] [F] [F'] [F≡F'] [F₀] [F'₀] [F₀≡F'₀] [F₊] [F'₊] [F₊≡F'₊]
             [Fₙ] [z] [z'] [z≡z'] [s] [s'] [s≡s'] [n] [n']
             [n≡n'] {Δ = Δ} {σ = σ} ⊢Δ [σ] =
  let [F]' = S.irrelevance {A = F} (_∙_ {A = ℕₑ} [Γ] [ℕ])
                           (_∙_ {l = ¹} [Γ] (ℕₛ [Γ])) [F]
      [F']' = S.irrelevance {A = F'} (_∙_ {A = ℕₑ} [Γ] [ℕ])
                            (_∙_ {l = ¹} [Γ] (ℕₛ [Γ])) [F']
      [F≡F']' = S.irrelevanceEq {A = F} {B = F'} (_∙_ {A = ℕₑ} [Γ] [ℕ])
                                (_∙_ {l = ¹} [Γ] (ℕₛ [Γ])) [F] [F]' [F≡F']
      [σn]' = irrelevanceTerm {l' = ¹} (proj₁ ([ℕ] ⊢Δ [σ]))
                              (ℕ (idRed:*: (ℕ ⊢Δ))) (proj₁ ([n] ⊢Δ [σ]))
      [σn']' = irrelevanceTerm {l' = ¹} (proj₁ ([ℕ] ⊢Δ [σ]))
                               (ℕ (idRed:*: (ℕ ⊢Δ))) (proj₁ ([n'] ⊢Δ [σ]))
      [σn≡σn']' = irrelevanceEqTerm {l' = ¹} (proj₁ ([ℕ] ⊢Δ [σ]))
                                    (ℕ (idRed:*: (ℕ ⊢Δ))) ([n≡n'] ⊢Δ [σ])
      [Fₙ]' = irrelevance' (PE.sym (singleSubstComp (subst σ n) σ F))
                           (proj₁ ([F]' ⊢Δ ([σ] , [σn]')))
  in  irrelevanceEqTerm' (PE.sym (singleSubstLift F n))
                         [Fₙ]' (proj₁ ([Fₙ] ⊢Δ [σ]))
                         (natrec-congTerm {F} {F'} {z} {z'} {s} {s'}
                                          {subst σ n} {subst σ n'}
                                          [Γ] [F]' [F']' [F≡F']'
                                          [F₀] [F'₀] [F₀≡F'₀]
                                          [F₊] [F'₊] [F₊≡F'₊]
                                          [z] [z'] [z≡z']
                                          [s] [s'] [s≡s'] ⊢Δ
                                          [σ] [σ] (reflSubst [Γ] ⊢Δ [σ])
                                          [σn]' [σn']' [σn≡σn']')
