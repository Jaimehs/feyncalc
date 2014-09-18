(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* :Summary: Gluon field *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`GluonField`",{"HighEnergyPhysics`FeynCalc`"}];

GluonField::"usage" =
"GluonField is a name of a gauge field.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

   GluonField /: MakeBoxes[GluonField, TraditionalForm] := "A";

End[];

If[$VeryVerbose > 0,WriteString["stdout", "GluonField | \n "]];
Null
