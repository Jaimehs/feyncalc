CommutatorExplicit::"usage"=
"CommutatorExplicit[exp] substitutes any Commutator and AntiCommutator \
in exp by their definitions.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

CommutatorExplicit[exp_] := exp /.
   {FeynCalc`Commutator :> ((FeynCalc`DOT[#1, #2] - FeynCalc`DOT[#2, #1])&),
    FeynCalc`AntiCommutator :> ((FeynCalc`DOT[#1, #2] + FeynCalc`DOT[#2, #1])&)
   };

End[];
