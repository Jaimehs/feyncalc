(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* :Summary: quark field *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`QuarkField`",{"HighEnergyPhysics`FeynCalc`"}];

QuarkField::"usage" =
"QuarkField is the name of a fermionic field.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

   QuarkField /: MakeBoxes[QuarkField, TraditionalForm] := "\[Psi]";

End[];

If[$VeryVerbose > 0,WriteString["stdout", "QuarkField | \n "]];
Null
