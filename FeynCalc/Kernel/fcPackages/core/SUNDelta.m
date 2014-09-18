(* :Summary: Kronecker delta for SU(N) *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`SUNDelta`",{"HighEnergyPhysics`FeynCalc`"}];


SUNDelta::"usage"=
"SUNDelta[a, b] is the Kronecker-delta for SU(N) with color
indices a and b.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

SetAttributes[SUNDelta, Orderless];

   SUNDelta /:
   MakeBoxes[SUNDelta[a_, b_], TraditionalForm ] :=
   SubscripFeynCalc`Tbox["\[Delta]",
     HighEnergyPhysics`FeynCalc`FeynCalc`Tbox[a,b]]

End[];

If[$VeryVerbose > 0,WriteString["stdout", "SUNDelta | \n "]];
Null
