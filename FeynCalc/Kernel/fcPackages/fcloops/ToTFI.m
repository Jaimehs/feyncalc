
(* :Title: ToTFI *)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)
(* :History: File created on 16 February '99 at 0:15 *)
(* ------------------------------------------------------------------------ *)

(* :Summary: introduce (modified Tarasov's) F - notation*) 

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`fcloops`ToTFI`",
             {"HighEnergyPhysics`FeynCalc`"}];

ToTFI::"usage" = "ToTFI[expr, q1, q2, p] translates  FeynCalc 2-loop 
self energy type integrals into the TFI notatation, which can be used as
input for the function TarcerRecurse from the TARCER package. 
See TFI for details on the conventions.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];
   
MakeContext[Apart2,Cases2,Dimension, DotSimplify,Expanding,
ExpandScalarProduct,
FeynCalcExternal,Pair,Momentum,OPEDelta,
FC2RHI,FreeQ2,FAD,SPD,SOD,FeynCalcInternal,PropagatorDenominator,
FeynAmpDenominator, FeynAmpDenominatorCombine,
FeynAmpDenominatorSimplify,  
ScalarProductCancel,
Select1, Select2, TLI, TLI2FC];

Options[ToTFI] = {Dimension -> D, Method -> Automatic};

(*
ToTFI[z_] := ToTFI[z, Global`q1, Global`q2, Global`p];
ToTFI[z_,opts__Rule] := ToTFI[z, Global`q1, Global`q2, Global`p, opts];
*)

ToTFI[z_Plus,qqp___, pe_/;Head[pe]=!=Rule, opts___Rule] := 
    ToTFI[#, qqp, pe, opts]& /@ z;

(* 1-loop *)
ToTFI[a_,q_,p_/;Head[p]=!=Rule,opts___Rule] := 
  (ToExpression["TFIRecurse"][ 
 FeynCalcExternal[
     ToTFI[(* Global`TTT=*)
FeynAmpDenominatorCombine[
	FeynCalcInternal[ Expand[ FAD[{qq, mM}]  *
FixedPoint[Expand[ScalarProductCancel[#, q, FeynAmpDenominatorSimplify -> True], q]&, a, 10]
 ] ]], 
                      q, qq, p, opts]
                 ]/.ToExpression["TFI"]:>ToExpression["TFR"]
                        ] /. ToExpression["TAI"][_, 0, {{1, mM}}] :> 1
  ) /; MemberQ[$ContextPath, "HighEnergyPhysics`Tarcer`"];

ToTFI[z_Times, q1_,q2_,p_,opts___Rule] :=
 FeynCalcExternal[Select1[z, {q1, q2}] saveToTFI[Select2[z, {q1, q2}], q1, q2, p, opts]];

ToTFI[h_/;!MemberQ[{Plus,Times},Head[h]],m__] :=
  saveToTFI[h, m];

(*
*)

saveToTFI[z_Times, q1_, q2_, p_, opts___Rule] := 
 (saveToTFI[Select2[z,{q1,q2}], q1,q2, p, opts] Select1[z,{q1,q2}] )/; 
   Select1[z,{q1,q2}] =!= 1;

saveToTFI[z_/;Head[z]=!=Plus, q1_, q2_, p_, opts___Rule] := 
saveToTFI[z, q1,q2,p,opts] = 
Catch[
Module[
{dim, et0, met, pp, deltap, t0, t1,t2,t3, dummyterm, result, pairs},
   dim = Dimension /. {opts} /. Options[ToTFI];
   met = Method /. {opts} /. Options[ToTFI];
   pp  = FeynCalcExternal[Pair[Momentum[p,dim],Momentum[p,dim]]];
   deltap = FeynCalcExternal[Pair[Momentum[p,dim],Momentum[OPEDelta,dim]]];
   t0 = If[FreeQ2[z, {TLI,FeynAmpDenominator,FAD}], 
 result = z,
   If[met =!= Automatic,
       t0 = FeynCalcInternal[z],
       t0 = FeynCalcInternal[If[!FreeQ[z, DOT], 
       DotSimplify[z, Expanding->False], z]];
       If[Count[t0, FeynAmpDenominator[__],-1]>1, 
          t0=FeynAmpDenominatorCombine[t0],
          If[!FreeQ[t0, FeynAmpDenominator[__]^_], 
             t0=FeynAmpDenominatorCombine[t0], t0]
         ];
   If[!FreeQ[t0, TLI], t0 = FeynAmpDenominatorSimplify[TLI2FC[t0],FC2RHI->False]];

(* added RM 20110819 *)
  If[!FreeQ[et0 = FeynCalcExternal[t0], FAD[-p + q1 - q2]], Throw[ saveToTFI[et0 /. q2 -> (-q2+q1)]]];
  If[!FreeQ[et0 = FeynCalcExternal[t0], FAD[ p - q1 + q2]], Throw[ saveToTFI[et0 /. q2 -> (-q2+q1)]]];

  pairs = Cases2[t0, Pair];
     If[!FreeQ[pairs, Plus],
         pairs = Thread[pairs -> Map[ExpandScalarProduct, pairs]];
         t0 = t0 /. pairs
       ];
   t0 = Expand[Expand[Apart2[t0], q1],q2];
     ];
   If[Head[t0]===Plus, 
      result = ToTFI[t0,q1,q2,p,opts],
   If[Head[t0]=!=Times, t0 = t0 dummyterm; dummytag=True, dummytag=False];

   prtoci[a_, b_]:= prtoci[a, b] = 
      Module[{na = a /. Momentum[em_, ___]:> em,r },
        r=Which[na ===  q1,   c1[b], na === -q1,   c1[b],
                na ===  q2,   c2[b], na === -q2,   c2[b],
                na ===  q1-p, c3[b], na === -q1+p, c3[b],
                na ===  q2-p, c4[b], na === -q2+p, c4[b],
                na ===  q1-q2,c5[b], na === -q1+q2,c5[b]
               ]; If[r === Null, $Failed, r]];

(*Global`TT=t1 = t0 /. PropagatorDenominator -> prtoci;*)

   t1 = t0 /. PropagatorDenominator -> prtoci /.
        {FeynAmpDenominator[a__] :> Apply[Times, {a}] ,
         Pair[Momentum[OPEDelta,___], Momentum[q1, ___]] :> dq1,
         Pair[Momentum[OPEDelta,___], Momentum[q2, ___]] :> dq2,
         Pair[Momentum[p,___], Momentum[q1, ___]] :> pq1,
         Pair[Momentum[p,___], Momentum[q2, ___]] :> pq2,
         Pair[Momentum[q1,___], Momentum[q1, ___]] :> q1q1,
         Pair[Momentum[q1,___], Momentum[q2, ___]] :> q1q2,
         Pair[Momentum[q2,___], Momentum[q2, ___]] :> q2q2,
         Pair[Momentum[OPEDelta,___], Momentum[p, ___]] :> deltap };
   If[FreeQ[t1, c1], t1 = t1 c1[FakeMass]];
   If[FreeQ[t1, c2], t1 = t1 c2[FakeMass]];
   If[FreeQ[t1, c3], t1 = t1 c3[FakeMass]];
   If[FreeQ[t1, c4], t1 = t1 c4[FakeMass]];
   If[FreeQ[t1, c5], t1 = t1 c5[FakeMass]];

If[!FreeQ[t1,$Failed], Throw[z]];

t2 = 
Select[t1,FreeQ[#,c1|c2|c3|c4|c5| dq1|dq2| pq1|pq2|q1q1|q1q2|q2q2]&]*
((*CC = *)
 (Dot @@ ( ( (dq1^a1*dq2^a2*pq1^s3*pq2^s4*q1q1^s1*q1q2^s5*q2q2^s2)
)*
Select[t1, !FreeQ[#, c1| c2| c3| c4| c5| 
                     dq1| dq2| pq1| pq2| q1q1| q1q2| q2q2]&] /.
            {c1[cm1_]^in1_. :> c1[cm1]^(in1+n1), 
             c2[cm2_]^in2_. :> c2[cm2]^(in2+n2),
             c3[cm3_]^in3_. :> c3[cm3]^(in3+n3), 
             c4[cm4_]^in4_. :> c4[cm4]^(in4+n4),
             c5[cm5_]^in5_. :> c5[cm5]^(in5+n5)
             }
         )
 )) /. {Dot[
     dq1^aa1_, dq2^aa2_, pq1^es3_, pq2^es4_, q1q1^es1_, q1q2^es5_, q2q2^es2_,
     c1[em1_]^nu1_,c2[em2_]^nu2_,c3[em3_]^nu3_,c4[em4_]^nu4_,c5[em5_]^nu5_
           ] :> 
      tfi[dim, pp, {aa1-a1, aa2-a2}, {es1-s1,es2-s2,es3-s3,es4-s4,es5-s5},
     {{-n1+nu1,em1},{-n2+nu2,em2},{-n3+nu3,em3},{-n4+nu4,em4},{-n5+nu5,em5}}/.
                    {_,FakeMass} :> {0,0} ]
      };

t3 = 
t2 /. tfi[d_,pep_, {0,0}, re__]           :> tfi[d, pep, re] /.
      tfi[d_,pep_, {0,0,0,0,0}, re_List]  :> tfi[d, pep, re] /.
      tfi[d_,pep_, {a_,b_}, {0,0,0,0,0}, re_List]  :> 
      tfi[d, pep, {a,b}, re] /.
      {tfi[d_,pep_, {a_, b_}, re__]      :> 
      tfi[d, pep, deltap, {a,b}, re] /; ((a^2 + b^2) =!=0)}/.
    tfi->ToExpression["TFI"];
If[dummytag, t3 = t3 /. dummyterm->1];
result = If[FreeQ2[t3,{q1,q2}],t3, z]
]];
FeynCalcExternal[result]
]];


End[];

If[$VeryVerbose > 0,WriteString["stdout", "ToTFI | \n "]];
Null
