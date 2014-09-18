(* ------------------------------------------------------------------------ *)

(* :Summary: CF *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`CF`",{"HighEnergyPhysics`FeynCalc`"}];

CF::"usage"=
"CF is one of the Casimir operator eigenvalues of SU(N); CF = (N^2-1)/(2 N)";

(* ------------------------------------------------------------------------ *)

Begin["`CF`Private`"];

CF /:
   MakeBoxes[
             CF, TraditionalForm
            ] := SubscripFeynCalc`Tbox["C", "F"];

End[];