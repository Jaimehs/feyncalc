(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* :Summary:  \int_0^1 dx *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`Integratedx`",{"HighEnergyPhysics`FeynCalc`"}];

Integratedx::"usage"=
"Integratedx[x, low, up] is a variable representing the integration
operator Integrate[#, {x,low,up}]&.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

   Integratedx /:
   MakeBoxes[Integratedx[x_, low_, up_], TraditionalForm] :=
   RowBox[{ SubSuperscriptBox["\[Integral]", FeynCalc`Tbox[low], FeynCalc`Tbox[up]],
            "\[DifferentialD]", MakeBoxes[TraditionalForm[x]](*x*), "\[VeryThinSpace]" }
         ]

End[];

If[$VeryVerbose > 0,WriteString["stdout", "Integratedx | \n "]];
Null
