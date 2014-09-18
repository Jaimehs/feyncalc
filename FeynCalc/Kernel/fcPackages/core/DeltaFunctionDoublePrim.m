(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* :Summary:  Dirac-delta function double derivative (just a name) *)

(* ------------------------------------------------------------------------ *)

DeltaFunctionDoublePrime::"usage"=
"DeltaFunctionDoublePrime denotes the second derivative of the \
Dirac delta-function.";

(* ------------------------------------------------------------------------ *)

DeltaFunctionDoublePrime /:
   MakeBoxes[ DeltaFunctionDoublePrime[y_], TraditionalForm] :=
    RowBox[{SuperscriptBox["\[Delta]","\[DoublePrime]"],
           "(", FeynCalc`Tbox[y], ")"}
          ];
