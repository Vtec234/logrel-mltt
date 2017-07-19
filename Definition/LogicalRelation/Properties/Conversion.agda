{-# OPTIONS --without-K #-}

open import Definition.Typed.EqualityRelation

module Definition.LogicalRelation.Properties.Conversion {{eqrel : EqRelSet}} where
open EqRelSet {{...}}

open import Definition.Untyped as U
open import Definition.Typed
open import Definition.Typed.RedSteps
open import Definition.Typed.Properties
open import Definition.Typed.Weakening
open import Definition.LogicalRelation
open import Definition.LogicalRelation.Tactic
open import Definition.LogicalRelation.Irrelevance
open import Definition.LogicalRelation.Properties.Wellformed

open import Tools.Product
import Tools.PropositionalEquality as PE


convRed:*: : ∀ {t u A B Γ} → Γ ⊢ t :⇒*: u ∷ A → Γ ⊢ A ≡ B → Γ ⊢ t :⇒*: u ∷ B
convRed:*: [ ⊢t , ⊢u , d ] A≡B = [ conv ⊢t  A≡B , conv ⊢u  A≡B , conv* d  A≡B ]

mutual
  convTermT₁ : ∀ {l l' Γ A B t} {[A] : Γ ⊩⟨ l ⟩ A} {[B] : Γ ⊩⟨ l' ⟩ B}
             → Tactic Γ l l' A B [A] [B]
             → Γ ⊩⟨ l ⟩  A ≡ B / [A]
             → Γ ⊩⟨ l ⟩  t ∷ A / [A]
             → Γ ⊩⟨ l' ⟩ t ∷ B / [B]
  convTermT₁ (ℕ D D') A≡B t = t
  convTermT₁ (ne (ne K D neK K≡K) (ne K₁ D₁ neK₁ K≡K₁)) (ne₌ M D' neM K≡M)
             (neₜ k d (neNfₜ neK₂ ⊢k k≡k)) =
    let K≡K₁ = PE.subst (λ x → _ ⊢ _ ≡ x)
                        (whrDet* (red D' , ne neM) (red D₁ , ne neK₁))
                        (≅-eq (~-to-≅ K≡M))
    in  neₜ k (convRed:*: d K≡K₁)
            (neNfₜ neK₂ (conv ⊢k K≡K₁) (~-conv k≡k K≡K₁))
  convTermT₁ {Γ = Γ} (Π (Π F G D ⊢F ⊢G A≡A [F] [G] G-ext)
                        (Π F₁ G₁ D₁ ⊢F₁ ⊢G₁ A≡A₁ [F]₁ [G]₁ G-ext₁))
             (Π₌ F' G' D' A≡B [F≡F'] [G≡G'])
             (Πₜ f d funcF f≡f [f] [f]₁) =
    let ΠF₁G₁≡ΠF'G'   = whrDet* (red D₁ , Π) (D' , Π)
        F₁≡F' , G₁≡G' = Π-PE-injectivity ΠF₁G₁≡ΠF'G'
        ΠFG≡ΠF₁G₁ = PE.subst (λ x → Γ ⊢ Πₑ F ▹ G ≡ x) (PE.sym ΠF₁G₁≡ΠF'G')
                             (≅-eq A≡B)
    in  Πₜ f (convRed:*: d ΠFG≡ΠF₁G₁) funcF (≅-conv f≡f ΠFG≡ΠF₁G₁)
           (λ {ρ} [ρ] ⊢Δ [a] [b] [a≡b] →
              let [F≡F₁] = irrelevanceEqR' (PE.cong (U.wk ρ) (PE.sym F₁≡F'))
                                           ([F] [ρ] ⊢Δ) ([F≡F'] [ρ] ⊢Δ)
                  [a]₁ = convTerm₂ ([F] [ρ] ⊢Δ) ([F]₁ [ρ] ⊢Δ) [F≡F₁] [a]
                  [b]₁ = convTerm₂ ([F] [ρ] ⊢Δ) ([F]₁ [ρ] ⊢Δ) [F≡F₁] [b]
                  [a≡b]₁ = convEqTerm₂ ([F] [ρ] ⊢Δ) ([F]₁ [ρ] ⊢Δ) [F≡F₁] [a≡b]
                  [G≡G₁] = irrelevanceEqR' (PE.cong (λ x → U.wk (lift ρ) x [ _ ])
                                                    (PE.sym G₁≡G'))
                                           ([G] [ρ] ⊢Δ [a]₁)
                                           ([G≡G'] [ρ] ⊢Δ [a]₁)
              in  convEqTerm₁ ([G] [ρ] ⊢Δ [a]₁) ([G]₁ [ρ] ⊢Δ [a]) [G≡G₁]
                              ([f] [ρ] ⊢Δ [a]₁ [b]₁ [a≡b]₁))
          (λ {ρ} [ρ] ⊢Δ [a] →
             let [F≡F₁] = irrelevanceEqR' (PE.cong (U.wk ρ) (PE.sym F₁≡F'))
                                          ([F] [ρ] ⊢Δ) ([F≡F'] [ρ] ⊢Δ)
                 [a]₁ = convTerm₂ ([F] [ρ] ⊢Δ) ([F]₁ [ρ] ⊢Δ) [F≡F₁] [a]
                 [G≡G₁] = irrelevanceEqR' (PE.cong (λ x → U.wk (lift ρ) x [ _ ])
                                                   (PE.sym G₁≡G'))
                                          ([G] [ρ] ⊢Δ [a]₁)
                                          ([G≡G'] [ρ] ⊢Δ [a]₁)
             in  convTerm₁ ([G] [ρ] ⊢Δ [a]₁) ([G]₁ [ρ] ⊢Δ [a]) [G≡G₁] ([f]₁ [ρ] ⊢Δ [a]₁))
  convTermT₁ (U (U .⁰ 0<1 ⊢Γ) (U .⁰ 0<1 ⊢Γ₁)) A≡B t = t
  convTermT₁ (emb⁰¹ x) A≡B t = convTermT₁ x A≡B t
  convTermT₁ (emb¹⁰ x) A≡B t = convTermT₁ x A≡B t

  convTermT₂ : ∀ {l l' Γ A B t} {[A] : Γ ⊩⟨ l ⟩ A} {[B] : Γ ⊩⟨ l' ⟩ B}
           → Tactic Γ l l' A B [A] [B]
           → Γ ⊩⟨ l ⟩  A ≡ B / [A]
           → Γ ⊩⟨ l' ⟩ t ∷ B / [B]
           → Γ ⊩⟨ l ⟩  t ∷ A / [A]
  convTermT₂ (ℕ D D') A≡B t = t
  convTermT₂ (ne (ne K D neK K≡K) (ne K₁ D₁ neK₁ K≡K₁)) (ne₌ M D' neM K≡M)
             (neₜ k d (neNfₜ neK₂ ⊢k k≡k)) =
    let K₁≡K = PE.subst (λ x → _ ⊢ x ≡ _)
                        (whrDet* (red D' , ne neM) (red D₁ , ne neK₁))
                        (sym (≅-eq (~-to-≅ K≡M)))
    in  neₜ k (convRed:*: d K₁≡K)
            (neNfₜ neK₂ (conv ⊢k K₁≡K) (~-conv k≡k K₁≡K))
  convTermT₂ {Γ = Γ} (Π (Π F G D ⊢F ⊢G A≡A [F] [G] G-ext)
                        (Π F₁ G₁ D₁ ⊢F₁ ⊢G₁ A≡A₁ [F]₁ [G]₁ G-ext₁))
             (Π₌ F' G' D' A≡B [F≡F'] [G≡G'])
             (Πₜ f d funcF f≡f [f] [f]₁) =
    let ΠF₁G₁≡ΠF'G'   = whrDet* (red D₁ , Π) (D' , Π)
        F₁≡F' , G₁≡G' = Π-PE-injectivity ΠF₁G₁≡ΠF'G'
        ΠFG≡ΠF₁G₁ = PE.subst (λ x → Γ ⊢ Πₑ F ▹ G ≡ x)
                             (PE.sym ΠF₁G₁≡ΠF'G') (≅-eq A≡B)
    in  Πₜ f (convRed:*: d (sym ΠFG≡ΠF₁G₁)) funcF (≅-conv f≡f (sym ΠFG≡ΠF₁G₁))
           (λ {ρ} [ρ] ⊢Δ [a] [b] [a≡b] →
              let [F≡F₁] = irrelevanceEqR' (PE.cong (U.wk ρ) (PE.sym F₁≡F'))
                                           ([F] [ρ] ⊢Δ) ([F≡F'] [ρ] ⊢Δ)
                  [a]₁ = convTerm₁ ([F] [ρ] ⊢Δ) ([F]₁ [ρ] ⊢Δ) [F≡F₁] [a]
                  [b]₁ = convTerm₁ ([F] [ρ] ⊢Δ) ([F]₁ [ρ] ⊢Δ) [F≡F₁] [b]
                  [a≡b]₁ = convEqTerm₁ ([F] [ρ] ⊢Δ) ([F]₁ [ρ] ⊢Δ) [F≡F₁] [a≡b]
                  [G≡G₁] = irrelevanceEqR' (PE.cong (λ x → U.wk (lift ρ) x [ _ ])
                                                    (PE.sym G₁≡G'))
                                           ([G] [ρ] ⊢Δ [a])
                                           ([G≡G'] [ρ] ⊢Δ [a])
              in  convEqTerm₂ ([G] [ρ] ⊢Δ [a]) ([G]₁ [ρ] ⊢Δ [a]₁)
                              [G≡G₁] ([f] [ρ] ⊢Δ [a]₁ [b]₁ [a≡b]₁))
           (λ {ρ} [ρ] ⊢Δ [a] →
              let [F≡F₁] = irrelevanceEqR' (PE.cong (U.wk ρ) (PE.sym F₁≡F'))
                                           ([F] [ρ] ⊢Δ) ([F≡F'] [ρ] ⊢Δ)
                  [a]₁ = convTerm₁ ([F] [ρ] ⊢Δ) ([F]₁ [ρ] ⊢Δ) [F≡F₁] [a]
                  [G≡G₁] = irrelevanceEqR' (PE.cong (λ x → U.wk (lift ρ) x [ _ ])
                                                    (PE.sym G₁≡G'))
                                           ([G] [ρ] ⊢Δ [a])
                                           ([G≡G'] [ρ] ⊢Δ [a])
              in  convTerm₂ ([G] [ρ] ⊢Δ [a]) ([G]₁ [ρ] ⊢Δ [a]₁)
                            [G≡G₁] ([f]₁ [ρ] ⊢Δ [a]₁))
  convTermT₂ (U (U .⁰ 0<1 ⊢Γ) (U .⁰ 0<1 ⊢Γ₁)) A≡B t = t
  convTermT₂ (emb⁰¹ x) A≡B t = convTermT₂ x A≡B t
  convTermT₂ (emb¹⁰ x) A≡B t = convTermT₂ x A≡B t

  convTerm₁ : ∀ {Γ A B t l l'} ([A] : Γ ⊩⟨ l ⟩ A) ([B] : Γ ⊩⟨ l' ⟩ B)
            → Γ ⊩⟨ l ⟩  A ≡ B / [A]
            → Γ ⊩⟨ l ⟩  t ∷ A / [A]
            → Γ ⊩⟨ l' ⟩ t ∷ B / [B]
  convTerm₁ [A] [B] A≡B t = convTermT₁ (goodCases [A] [B] A≡B) A≡B t

  convTerm₂ : ∀ {Γ A B t l l'} ([A] : Γ ⊩⟨ l ⟩ A) ([B] : Γ ⊩⟨ l' ⟩ B)
          → Γ ⊩⟨ l ⟩  A ≡ B / [A]
          → Γ ⊩⟨ l' ⟩ t ∷ B / [B]
          → Γ ⊩⟨ l ⟩  t ∷ A / [A]
  convTerm₂ [A] [B] A≡B t = convTermT₂ (goodCases [A] [B] A≡B) A≡B t

  convTerm₂' : ∀ {Γ A B B' t l l'} → B PE.≡ B'
          → ([A] : Γ ⊩⟨ l ⟩ A) ([B] : Γ ⊩⟨ l' ⟩ B)
          → Γ ⊩⟨ l ⟩  A ≡ B' / [A]
          → Γ ⊩⟨ l' ⟩ t ∷ B / [B]
          → Γ ⊩⟨ l ⟩  t ∷ A / [A]
  convTerm₂' PE.refl [A] [B] A≡B t = convTerm₂ [A] [B] A≡B t


  convEqTermT₁ : ∀ {l l' Γ A B t u} {[A] : Γ ⊩⟨ l ⟩ A} {[B] : Γ ⊩⟨ l' ⟩ B}
               → Tactic Γ l l' A B [A] [B]
               → Γ ⊩⟨ l ⟩  A ≡ B / [A]
               → Γ ⊩⟨ l ⟩  t ≡ u ∷ A / [A]
               → Γ ⊩⟨ l' ⟩ t ≡ u ∷ B / [B]
  convEqTermT₁ (ℕ D D') A≡B t≡u = t≡u
  convEqTermT₁ (ne (ne K D neK K≡K) (ne K₁ D₁ neK₁ K≡K₁)) (ne₌ M D' neM K≡M)
               (neₜ₌ k m d d' (neNfₜ₌ neK₂ neM₁ k≡m)) =
    let K≡K₁ = PE.subst (λ x → _ ⊢ _ ≡ x)
                        (whrDet* (red D' , ne neM) (red D₁ , ne neK₁))
                        (≅-eq (~-to-≅ K≡M))
    in  neₜ₌ k m (convRed:*: d K≡K₁)
                 (convRed:*: d' K≡K₁)
                 (neNfₜ₌ neK₂ neM₁ (~-conv k≡m K≡K₁))
  convEqTermT₁ {Γ = Γ} (Π (Π F G D ⊢F ⊢G A≡A [F] [G] G-ext)
                          (Π F₁ G₁ D₁ ⊢F₁ ⊢G₁ A≡A₁ [F]₁ [G]₁ G-ext₁))
               (Π₌ F' G' D' A≡B [F≡F'] [G≡G'])
               (Πₜ₌ f g d d' funcF funcG t≡u [t] [u] [t≡u]) =
    let [A] = Π' F G D ⊢F ⊢G A≡A [F] [G] G-ext
        [B] = Π' F₁ G₁ D₁ ⊢F₁ ⊢G₁ A≡A₁ [F]₁ [G]₁ G-ext₁
        [A≡B] = Π₌ F' G' D' A≡B [F≡F'] [G≡G']
        ΠF₁G₁≡ΠF'G' = whrDet* (red D₁ , Π) (D' , Π)
        ΠFG≡ΠF₁G₁ = PE.subst (λ x → Γ ⊢ Πₑ F ▹ G ≡ x)
                             (PE.sym ΠF₁G₁≡ΠF'G') (≅-eq A≡B)
    in  Πₜ₌ f g (convRed:*: d ΠFG≡ΠF₁G₁) (convRed:*: d' ΠFG≡ΠF₁G₁)
            funcF funcG (≅-conv t≡u ΠFG≡ΠF₁G₁)
            (convTerm₁ [A] [B] [A≡B] [t]) (convTerm₁ [A] [B] [A≡B] [u])
            (λ {ρ} [ρ] ⊢Δ [a] →
               let F₁≡F' , G₁≡G' = Π-PE-injectivity (whrDet* (red D₁ , Π) (D' , Π))
                   [F≡F₁] = irrelevanceEqR' (PE.cong (U.wk ρ) (PE.sym F₁≡F'))
                                            ([F] [ρ] ⊢Δ) ([F≡F'] [ρ] ⊢Δ)
                   [a]₁ = convTerm₂ ([F] [ρ] ⊢Δ) ([F]₁ [ρ] ⊢Δ) [F≡F₁] [a]
                   [G≡G₁] = irrelevanceEqR' (PE.cong (λ x → U.wk (lift ρ) x [ _ ])
                                                     (PE.sym G₁≡G'))
                                            ([G] [ρ] ⊢Δ [a]₁)
                                            ([G≡G'] [ρ] ⊢Δ [a]₁)
               in  convEqTerm₁ ([G] [ρ] ⊢Δ [a]₁) ([G]₁ [ρ] ⊢Δ [a])
                               [G≡G₁] ([t≡u] [ρ] ⊢Δ [a]₁))
  convEqTermT₁ (U (U .⁰ 0<1 ⊢Γ) (U .⁰ 0<1 ⊢Γ₁)) A≡B t≡u = t≡u
  convEqTermT₁ (emb⁰¹ x) A≡B t≡u = convEqTermT₁ x A≡B t≡u
  convEqTermT₁ (emb¹⁰ x) A≡B t≡u = convEqTermT₁ x A≡B t≡u

  convEqTermT₂ : ∀ {l l' Γ A B t u} {[A] : Γ ⊩⟨ l ⟩ A} {[B] : Γ ⊩⟨ l' ⟩ B}
             → Tactic Γ l l' A B [A] [B]
             → Γ ⊩⟨ l ⟩  A ≡ B / [A]
             → Γ ⊩⟨ l' ⟩ t ≡ u ∷ B / [B]
             → Γ ⊩⟨ l ⟩  t ≡ u ∷ A / [A]
  convEqTermT₂ (ℕ D D') A≡B t≡u = t≡u
  convEqTermT₂ (ne (ne K D neK K≡K) (ne K₁ D₁ neK₁ K≡K₁)) (ne₌ M D' neM K≡M)
               (neₜ₌ k m d d' (neNfₜ₌ neK₂ neM₁ k≡m)) =
    let K₁≡K = PE.subst (λ x → _ ⊢ x ≡ _)
                        (whrDet* (red D' , ne neM) (red D₁ , ne neK₁))
                        (sym (≅-eq (~-to-≅ K≡M)))
    in  neₜ₌ k m (convRed:*: d K₁≡K) (convRed:*: d' K₁≡K)
                 (neNfₜ₌ neK₂ neM₁ (~-conv k≡m K₁≡K))
  convEqTermT₂ {Γ = Γ} (Π (Π F G D ⊢F ⊢G A≡A [F] [G] G-ext)
                          (Π F₁ G₁ D₁ ⊢F₁ ⊢G₁ A≡A₁ [F]₁ [G]₁ G-ext₁))
               (Π₌ F' G' D' A≡B [F≡F'] [G≡G'])
               (Πₜ₌ f g d d' funcF funcG t≡u [t] [u] [t≡u]) =
    let [A] = Π' F G D ⊢F ⊢G A≡A [F] [G] G-ext
        [B] = Π' F₁ G₁ D₁ ⊢F₁ ⊢G₁ A≡A₁ [F]₁ [G]₁ G-ext₁
        [A≡B] = Π₌ F' G' D' A≡B [F≡F'] [G≡G']
        ΠF₁G₁≡ΠF'G' = whrDet* (red D₁ , Π) (D' , Π)
        ΠFG≡ΠF₁G₁ = PE.subst (λ x → Γ ⊢ Πₑ F ▹ G ≡ x)
                             (PE.sym ΠF₁G₁≡ΠF'G') (≅-eq A≡B)
    in  Πₜ₌ f g (convRed:*: d (sym ΠFG≡ΠF₁G₁)) (convRed:*: d' (sym ΠFG≡ΠF₁G₁))
            funcF funcG (≅-conv t≡u (sym ΠFG≡ΠF₁G₁))
            (convTerm₂ [A] [B] [A≡B] [t]) (convTerm₂ [A] [B] [A≡B] [u])
            (λ {ρ} [ρ] ⊢Δ [a] →
               let F₁≡F' , G₁≡G' = Π-PE-injectivity (whrDet* (red D₁ , Π) (D' , Π))
                   [F≡F₁] = irrelevanceEqR' (PE.cong (U.wk ρ) (PE.sym F₁≡F'))
                                            ([F] [ρ] ⊢Δ) ([F≡F'] [ρ] ⊢Δ)
                   [a]₁ = convTerm₁ ([F] [ρ] ⊢Δ) ([F]₁ [ρ] ⊢Δ) [F≡F₁] [a]
                   [G≡G₁] = irrelevanceEqR' (PE.cong (λ x → U.wk (lift ρ) x [ _ ])
                                                     (PE.sym G₁≡G'))
                                            ([G] [ρ] ⊢Δ [a])
                                            ([G≡G'] [ρ] ⊢Δ [a])
               in  convEqTerm₂ ([G] [ρ] ⊢Δ [a]) ([G]₁ [ρ] ⊢Δ [a]₁)
                               [G≡G₁] ([t≡u] [ρ] ⊢Δ [a]₁))
  convEqTermT₂ (U (U .⁰ 0<1 ⊢Γ) (U .⁰ 0<1 ⊢Γ₁)) A≡B t≡u = t≡u
  convEqTermT₂ (emb⁰¹ x) A≡B t≡u = convEqTermT₂ x A≡B t≡u
  convEqTermT₂ (emb¹⁰ x) A≡B t≡u = convEqTermT₂ x A≡B t≡u

  convEqTerm₁ : ∀ {l l' Γ A B t u} ([A] : Γ ⊩⟨ l ⟩ A) ([B] : Γ ⊩⟨ l' ⟩ B)
              → Γ ⊩⟨ l ⟩  A ≡ B / [A]
              → Γ ⊩⟨ l ⟩  t ≡ u ∷ A / [A]
              → Γ ⊩⟨ l' ⟩ t ≡ u ∷ B / [B]
  convEqTerm₁ [A] [B] A≡B t≡u = convEqTermT₁ (goodCases [A] [B] A≡B) A≡B t≡u

  convEqTerm₂ : ∀ {l l' Γ A B t u} ([A] : Γ ⊩⟨ l ⟩ A) ([B] : Γ ⊩⟨ l' ⟩ B)
            → Γ ⊩⟨ l ⟩  A ≡ B / [A]
            → Γ ⊩⟨ l' ⟩ t ≡ u ∷ B / [B]
            → Γ ⊩⟨ l ⟩  t ≡ u ∷ A / [A]
  convEqTerm₂ [A] [B] A≡B t≡u = convEqTermT₂ (goodCases [A] [B] A≡B) A≡B t≡u
