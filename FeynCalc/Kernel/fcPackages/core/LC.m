(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* :Summary: *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`LC`",{"HighEnergyPhysics`FeynCalc`"}];

LC::"usage"=
"LC[m,n,r,s] evaluates to LeviCivita[m,n,r,s] applying
FeynCalcInternal.
LC[m,...][p, ...] evaluates to LeviCivita[m,...][p,...]
applying FeynCalcInternal.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

   LC/:
   MakeBoxes[LC[x___][y___] ,TraditionalForm] :=
   SuperscriptBox["\[Epsilon]", FeynCalc`Tbox[x,y]];
   LC/:
   MakeBoxes[LC[x__] ,TraditionalForm] :=
   SuperscriptBox["\[Epsilon]", FeynCalc`Tbox[x]];

End[];

If[$VeryVerbose > 0,WriteString["stdout", "LC | \n "]];
Null
