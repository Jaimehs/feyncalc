(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`FVD`",{"HighEnergyPhysics`FeynCalc`"}];

FVD::"usage"= "FVD[p,mu] is a fourvector and is
transformed into Pair[Momentum[p,D], LorentzIndex[mu,D]]
by FeynCalcInternal.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

   FVD /: MakeBoxes[FVD[a_Subscripted, b_], TraditionalForm] :=
             SubSuperscriptBox[FeynCalc`Tbox[a[[1,0]]], FeynCalc`Tbox@@a[[1]], FeynCalc`Tbox[b]];

   FVD /: MakeBoxes[FVD[a_Subscript, b_], TraditionalForm] :=
             SubSuperscriptBox[FeynCalc`Tbox[a[[1]]], FeynCalc`Tbox@@Rest[a], FeynCalc`Tbox[b]];

   FVD /: MakeBoxes[FVD[a_, b_], TraditionalForm] :=
            SuperscriptBox[FeynCalc`Tbox[a], FeynCalc`Tbox[b]];

End[];

If[$VeryVerbose > 0,WriteString["stdout", "FVD | \n "]];
Null
