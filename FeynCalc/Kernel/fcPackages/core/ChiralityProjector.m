(* :Summary: left and right handed projectors *)

(* ------------------------------------------------------------------------ *)

ChiralityProjector::usage =
"ChiralityProjector[+1] denotes DiracGamma[6] (=1/2(1 + DiracMatrix[5])).
ChiralityProjector[-1] denotes DiracGamma[7] (=1/2(1 - DiracMatrix[5])).";

(* ------------------------------------------------------------------------ *)

Begin["`ChiralityProjector`Private`"];

FeynCalc`DeclareNonCommutative[ChiralityProjector];

ChiralityProjector[1] = FeynCalc`DiracGamma[6];
ChiralityProjector[-1] = FeynCalc`DiracGamma[7];

ChiralityProjector /:
   MakeBoxes[ChiralityProjector[1], TraditionalForm] :=
    SubscripFeynCalc`Tbox["\[Omega]", "+"];

ChiralityProjector /:
   MakeBoxes[ChiralityProjector[-1], TraditionalForm] :=
    SubscripFeynCalc`Tbox["\[Omega]", "-"];

End[];
