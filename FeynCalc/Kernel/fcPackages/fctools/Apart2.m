

(* :Title: Apart2 *)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)
(* :History: File created on 7 February '99 at 18:37 *)
(* ------------------------------------------------------------------------ *)

(* ------------------------------------------------------------------------ *)

Apart2::"usage"=
"Apart2[expr] partial fractions FeynAmpDenominators.";

(* ------------------------------------------------------------------------ *)


Apart2[y_] :=(FeynCalcInternal[y] //. 
                FeynAmpDenominator -> `Apart2`Private`feynampdenpartfrac
             ) /. `Apart2`Private`feynampdenpartfrac -> FeynAmpDenominator;

`Apart2`Private`feynampdenpartfrac[ a___, PropagatorDenominator[qpe1_, m1_], b___,
                          PropagatorDenominator[qpe1_, m2_], c___
                  ] := Factor2[(1/(m1^2 - m2^2) *
  (FeynAmpDenominator[a, PropagatorDenominator[qpe1, m1], b, c] -
   FeynAmpDenominator[a, b, PropagatorDenominator[qpe1, m2], c]
  )                    )     ] /; m1 =!= m2;

End[];

