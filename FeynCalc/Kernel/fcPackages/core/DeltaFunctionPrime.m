(* ------------------------------------------------------------------------ *)

(* :Summary:  Dirac-delta function derivative (just a name) *)

(* ------------------------------------------------------------------------ *)

DeltaFunctionPrime::"usage"=
"DeltaFunctionPrime denotes the derivative of the Dirac delta-function.";

(* ------------------------------------------------------------------------ *)

DeltaFunctionPrime /:
   MakeBoxes[ DeltaFunctionPrime[y_], TraditionalForm] :=
    RowBox[{SuperscriptBox["\[Delta]","\[Prime]"],
           "(", FeynCalc`Tbox[y], ")"}
          ];
