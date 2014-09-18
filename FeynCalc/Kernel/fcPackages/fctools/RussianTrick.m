

(* :Title: RussianTrick *)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)
(* :History: File created on 22 June '97 at 23:00 *)
(* ------------------------------------------------------------------------ *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`fctools`RussianTrick`",{"HighEnergyPhysics`FeynCalc`"}];

RussianTrick::"usage"= 
"RussianTrick[exp, k, {q1,q2,p}] (=RussianTrick[exp,p,p,{q1,q2,p}])
does the russian trick where p is the external momentum.
 RussianTrick[exp, k,l, {q1,q2,p}] (=RussianTrick[exp,k,l])
does the russian trick where 
l is the momentum to be differentiated.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];
   

MakeContext[
Apart2,
Collect2,
Dimension,
ExpandScalarProduct,
FC2TLI,
FeynCalcInternal,
FeynAmpDenominatorSimplify,
FourVector,
FourDivergence,
ScalarProductCancel
           ];

OPE2TID := OPE2TID = MakeContext["OPE2TID"];

Options[RussianTrick] = {Dimension -> D, FC2TLI -> False};

RussianTrick[exp_,k_, opt___Rule] :=
  RussianTrick[exp,k,k,{Global`q1, Global`q2, Global`p},opt];

RussianTrick[exp_,k_, pe_/; Head[pe]=!=List, opt___Rule] :=
  RussianTrick[exp,k,pe,{Global`q1, Global`q2, Global`p},opt];

RussianTrick[ex_, p_,k_, {q1_, q2_, pe_}, opt___Rule] := 
Block[{fv, t1, t2, t3, dime, exp,mu},
exp = FeynCalcInternal[ex];
dim = Dimension /. {opt} /. Options[RussianTrick];
fv  = ExpandScalarProduct[FourVector[##, Dimension -> dim]]&;
t1  = FourDivergence[exp fv[p,mu], fv[k, mu]];
t1  = FixedPoint[Apart2,t1,5];
t2  = ScalarProductCancel[t1, q1, q2];
t2  = Collect2[FeynAmpDenominatorSimplify[t2, q1,q2], q1,q2];
If[Head[t2] === Plus,
   t2  = ScalarProductCancel[#, q1, q2]& /@ t2;
   t2  = ScalarProductCancel[t1, q1, q2]
  ];
t3  = Collect2[t2,q1,q2];
If[(FC2TLI/.{opt} /. Options[RussianTrick]) === True,
   t3 = OPE2TID[t3,q1,q2,pe];
   t3 = FC2TLI[t3,q1,q2]
  ];
   t3];

End[];


If[$VeryVerbose > 0,WriteString["stdout", "RussianTrick | \n "]];
Null
