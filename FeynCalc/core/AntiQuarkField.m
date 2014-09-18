(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`AntiQuarkField`",{"HighEnergyPhysics`FeynCalc`"}];

AntiQuarkField::"usage" =
"AntiQuarkField is the name of a fermionic field.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

AntiQuarkField /: MakeBoxes[AntiQuarkField, TraditionalForm] :=
  OverscripFeynCalc`Tbox["\[Psi]","_"];

End[];

If[$VeryVerbose > 0,WriteString["stdout", "AntiQuarkField | \n "]];
Null
