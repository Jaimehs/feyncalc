

(* :Title: Zeta2 *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`general`Zeta2`",{"HighEnergyPhysics`FeynCalc`"}];

Zeta2::"usage"=
"Zeta2 denotes Zeta[2]. For convenience every Pi^2 occuring in 
OPEIntegrateDelta is replaced by (6 Zeta2).";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];
   

Zeta2 /: N[Zeta2] = N[Zeta[2]];
Zeta2 /: N[Zeta2, prec_] := N[Zeta[2], prec];

   Zeta2 /: 
   MakeBoxes[Zeta2, TraditionalForm] := 
    RowBox[{"\[Zeta]","(",2,")"}];
(*SubscripFeynCalc`Tbox["\[Zeta]", 2]*)

End[];


If[$VeryVerbose > 0,WriteString["stdout", "Zeta2 | \n "]];
Null
