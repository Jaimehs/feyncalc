(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* :Summary: test for non-commutativity *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`UnDeclareNonCommutative`",{"HighEnergyPhysics`FeynCalc`"}];

UnDeclareNonCommutative::"usage" =
"UnDeclareNonCommutative[a, b, ...] undeclares a,b, ... to be
noncommutative, i.e., DataType[a,b, ..., NonCommutative] = False
is performed.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

(*MakeContext[DataType, NonCommutative];
*)

UnDeclareNonCommutative[] := soso /;
Message[UnDeclareNonCommutative::argrx,
        UnDeclareNonCommutative, 0, "1 or more"];

UnDeclareNonCommutative[b__] :=
 (Map[Set[HighEnergyPhysics`FeynCalc`DataType`DataType[#,
          HighEnergyPhysics`FeynCalc`NonCommutative`NonCommutative],
          False]&, Flatten[{b}]
     ]; Null);

End[];

If[$VeryVerbose > 0,WriteString["stdout", "UnDeclareNonCommutative | \n "]];
Null
