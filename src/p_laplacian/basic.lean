import tactic
import data.real.basic 
import data.complex.exponential 
import analysis.special_functions.pow

noncomputable theory
open_locale classical
 
open real

notation `|`x`|` := abs x

variables (a : ℝ) (b : ℝ)
/-!
## p-GTFs

This is my speciality but it _needs_ integration, so this won't be able to be
filled in until somebody produces some sort of integration in lean or I prove it
out of spite for not having it.


I've actually remembered that we can define the πₚ function.
-/

def pip (p : ℝ) := (2 * pi)/ (p * sin (pi / p))

-- def sinp (p : ℝ) := sorry

-- def cosp (p : ℝ) := sorry

example (h : a * b = 0) : a = 0 ∨ b = 0 := zero_eq_mul.mp (eq.symm h)

private lemma lt_mul_eq_zero (fab : a < b) (fa : 0 < a) (fb : 0 < b) : 0 < a * b ↔ 0 < a ∨ 0 < b := 
begin
  split,
  intro famulb,
  left,
  exact fa,
  intro famulb,
  rw zero_lt_mul_left,
  exact fb, exact fa,
end

lemma pip_monotone_decreasing : strict_mono_decr_on pip {p : ℝ | 1 < p} :=
begin
  rintros a fa b fb fab,

    have one_lt_b : 1 < b,
    {apply fb},
    have one_lt_a : 1 < a,
    {apply fa},
    have a_pos : 0 < a := by linarith,
    have b_pos : 0 < b := by linarith,
    have two_pi_pos : 0 < 2 * pi, {norm_num, exact pi_pos},
    have pi_a_lt_pi_b : pi/b < pi/a := by {apply div_lt_div', refl, exact fab, exact pi_pos, exact a_pos,},
    have pi_on_b_pos : pi / b < pi := by {rw div_lt_iff b_pos, refine sub_pos.mp _, rw ←mul_one (pi), 
      rw mul_assoc, rw one_mul (b), rw ←mul_sub, refine (div_lt_iff _).mp _,
      /-  ⊢ 0 < b - 1  -/
      { norm_num, exact one_lt_b,},
      /-  ⊢ 0 / (b - 1) < pi  -/
      {rw zero_div, exact pi_pos,},
    },
    have pi_on_a_pos : pi / a < pi := by {rw div_lt_iff a_pos, refine sub_pos.mp _, rw ←mul_one (pi), 
      rw mul_assoc, rw one_mul (a), rw ←mul_sub, refine (div_lt_iff _).mp _,
      /-  ⊢ 0 < b - 1  -/
      { norm_num, exact one_lt_a,},
      /-  ⊢ 0 / (b - 1) < pi  -/
      {rw zero_div, exact pi_pos,},
    },

    have pi_b_pos : 0 < pi/b := by { refine div_pos _ b_pos, exact pi_pos,},
    have pi_a_pos : 0 < pi/a := by { refine div_pos _ a_pos, exact pi_pos,},
    have sin_pi_b_pos : 0 < sin(pi/b),
    {exact sin_pos_of_pos_of_lt_pi pi_b_pos pi_on_b_pos,},
    have sin_pi_a_pos : 0 < sin(pi/a),
    {exact sin_pos_of_pos_of_lt_pi pi_a_pos pi_on_a_pos,},
    
    have sin_fa_lt_sin_fb : sin (pi/a) < sin (pi/b) := sorry,
    /-/- This changes, depending on whether x ∈ (1, 2] or x ∈ (2, ∞). For x < 2, we get
    that f a < f b, however for 2 < x we get f b < f a -/
    {
        apply sin_lt_sin_of_le_of_le_pi_div_two,
        linarith,
        {
          sorry
        },
        -- pi/a < pi/b for all ∀ a < b : b > 2 which is false. So something else must be false 
    sorry}, -/

  unfold pip,
  rw div_eq_mul_one_div,
  rw div_eq_mul_one_div _ (a*sin(pi/a)),
  rw mul_lt_mul_left two_pi_pos,
  repeat {rw one_div_eq_inv},
  rw inv_lt_inv,
  /-
⊢ a * sin (pi / a) < b * sin (pi / b)
-/
    {refine (div_lt_div_iff sin_pi_b_pos sin_pi_a_pos).mp _,
    refine div_lt_div' _ sin_fa_lt_sin_fb b_pos sin_pi_a_pos,
    exact le_of_lt fab,},
  /-
⊢ 0 < b * sin (pi / b)
-/
   {refine mul_pos b_pos sin_pi_b_pos,},
  /-
⊢ 0 < a * sin (pi / a)
-/  
    {refine mul_pos a_pos sin_pi_a_pos,},
end

#exit

-- this is a mess. Please ignore below thiss

example (p : ℝ) : pip p ≤ 16 / (pi ^ 2 - 8) :=
begin
  unfold pip,
  have H : p * sin(pi/p) ≠ 0,
  {intros f,
   --rw zero_eq_mul at f,
   sorry
  }, sorry
end

lemma pip_monotone (a b : ℝ) (ga : 1 < a) (gb : 1 < b) : a < b → pip b < pip a :=
begin
  have h : 0 < 2 * pi, {norm_num, exact pi_pos},
  rintros fab,
  unfold pip,
  rw div_eq_mul_one_div,
  rw div_eq_mul_one_div _ (a*sin(pi/a)),
  rw mul_lt_mul_left h,
  repeat {rw one_div_eq_inv},
  rw inv_lt_inv,
  {
    apply mul_lt_mul,
    {exact fab,},
    {
      -- sin(π / a) ≤ sin(π / b)
      sorry
      },
    {
      -- 0 < sin (π / a)
      sorry },
    {linarith}
  },
  {
    -- 0 < b * sin (π / b)
    have H : 0 < pi / b ∧ pi / b < pi,
    {split,
    {
      have pi_pos : 0 < pi := pi_pos,
      rw div_eq_inv_mul,
      --finish,
      sorry
    },
    {
      have pi_pos : 0 < pi := pi_pos,
      rw div_eq_inv_mul,
      --apply lt_mul_of_inv_mul_lt_left,
    sorry
    },},
    /-
    Basically this follows the proof that we know 0 < π/b < π as b > 1 → 0 < sin (π / b) < π 
    and we know t ∈ [0, π] then 0 < sin t.
    -/

  },
  {
    -- 0 < a * sin (π / b)
    sorry
  }
end

--example (a b c : ℝ) (h : a = b⁻¹ * c) (g : b ≠ 0) : a * b = c := by library_search

#exit


