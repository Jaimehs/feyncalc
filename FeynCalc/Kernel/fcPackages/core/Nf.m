(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* :Summary: Nf *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`Nf`",{"HighEnergyPhysics`FeynCalc`"}];

Nf::"usage" =
"Nf denotes the number of flavors."

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];
   Nf /:
   MakeBoxes[Nf, TraditionalForm] := SubscripFeynCalc`Tbox["N", "f"];

End[];

If[$VeryVerbose > 0,WriteString["stdout", "Nf | \n "]];
Null
