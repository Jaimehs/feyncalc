(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`FV`",{"HighEnergyPhysics`FeynCalc`"}];

FV::"usage"= "FV[p,mu] is a fourvector and is transformed into
Pair[Momentum[p], LorentzIndex[mu]]
by FeynCalcInternal.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

MakeContext[ Momentum SP, SPD];

FV[p_ /; Head[p]=!=Momentum, Momentum[b_]]:= SP[p,b];
FV[Momentum[p_], Momentum[b_]]:= SP[p,b];

   FV /: MakeBoxes[FV[a_Subscripted, b_], TraditionalForm] :=
             SubSuperscriptBox[FeynCalc`Tbox[a[[1,0]]], FeynCalc`Tbox@@a[[1]], FeynCalc`Tbox[b]];

   FV /: MakeBoxes[FV[a_Subscript, b_], TraditionalForm] :=
             SubSuperscriptBox[FeynCalc`Tbox[a[[1]]], FeynCalc`Tbox@@Rest[a], FeynCalc`Tbox[b]];

   FV /: MakeBoxes[FV[a_, b_], TraditionalForm] :=
            SuperscriptBox[FeynCalc`Tbox[a], FeynCalc`Tbox[b]];


End[];

If[$VeryVerbose > 0,WriteString["stdout", "FV | \n "]];
Null
