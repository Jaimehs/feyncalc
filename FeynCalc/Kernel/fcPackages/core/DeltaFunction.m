(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* :Summary:  Dirac-delta function  (just a name) *)

(* ------------------------------------------------------------------------ *)

DeltaFunction::"usage"= "DeltaFunction is the Dirac delta-function.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

(*Added 18 April 2001, Frederik Orellana*)
DeltaFunction[_?((NumericQ[#]===True&&(Positive[#]===True||Negative[#]===True))&)]:=0;
DeltaFunction[0]:=1;

DeltaFunction /:
   MakeBoxes[ DeltaFunction[y_], TraditionalForm] :=
    RowBox[{"\[Delta]", "(", FeynCalc`Tbox[y], ")"}];

End[];
