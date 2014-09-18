AntiQuarkField::"usage" =
"AntiQuarkField is the name of a fermionic field.";

(* ------------------------------------------------------------------------ *)

Begin["`AntiQuarkField`Private`"];

AntiQuarkField /: MakeBoxes[AntiQuarkField, TraditionalForm] :=
  OverscripFeynCalc`Tbox["\[Psi]","_"];

End[]; 
