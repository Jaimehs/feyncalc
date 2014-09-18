(* ------------------------------------------------------------------------ *)

(* :Summary: test for non-commutativity *)

(* ------------------------------------------------------------------------ *)

DeclareNonCommutative::"usage" =
"DeclareNonCommutative[a, b, ...] declares a,b, ... to be \
noncommutative, i.e., DataType[a,b, ...,  NonCommutative] is set to \
True.";

(* ------------------------------------------------------------------------ *)

Begin["`DeclareNonCommutitive`Private`"];

DeclareNonCommutative[] := soso /;
Message[DeclareNonCommutative::argrx, DeclareNonCommutative, 0, "1 or more"];

DeclareNonCommutative[b__] :=
 (Map[Set[FeynCalc`DataType[#,
          FeynCalc`NonCommutative],
          True]&, {b}
     ]; Null);

End[];
