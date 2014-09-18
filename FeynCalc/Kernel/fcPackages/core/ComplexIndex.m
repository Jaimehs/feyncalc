(* ------------------------------------------------------------------------ *)

(* :Summary: The head for complex conjugated indices *)

(* ------------------------------------------------------------------------ *)

ComplexIndex::"usage"=
"ComplexIndex is the head of a complex conjugate index.";

(* ------------------------------------------------------------------------ *)

Begin["`ComplexIndex`Private`"];

ComplexIndex[ComplexIndex[x_]] := x;

   ComplexIndex /:
   MakeBoxes[ComplexIndex[x_] ,TraditionalForm] :=
   SuperscriptBox[FeynCalc`Tbox[x], "*"];

End[];
