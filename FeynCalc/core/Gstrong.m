(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* :Summary: The strong coupling constant *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`Gstrong`",{"HighEnergyPhysics`FeynCalc`"}];

Gstrong::"usage" =
"Gstrong denotes the strong coupling constant.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

  Gstrong /:
   MakeBoxes[Gstrong, TraditionalForm] :=
    SubscripFeynCalc`Tbox["g","s"]

End[];

If[$VeryVerbose > 0,WriteString["stdout", "Gstrong | \n "]];
Null
