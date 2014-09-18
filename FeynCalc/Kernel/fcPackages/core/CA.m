(* ------------------------------------------------------------------------ *)

(* :Summary: CA = the N of SU(N) *)

(* ------------------------------------------------------------------------ *)

CA::"usage"=
"CA is one of the Casimir operator eigenvalues of SU(N); CA = N";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

CA /:
   MakeBoxes[
             CA, TraditionalForm
            ] := SubscripFeynCalc`Tbox["C", "A"];

End[];