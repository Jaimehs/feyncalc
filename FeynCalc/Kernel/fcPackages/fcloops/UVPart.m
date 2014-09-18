

(* :Title: UVPart *)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)
(* :History: File created on 22 June '97 at 23:01 *)
(* ------------------------------------------------------------------------ *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`fcloops`UVPart`",
             {"HighEnergyPhysics`FeynCalc`"}];

UVPart::"usage"= 
"UVPart[exp, q] discards ultraviolet finite integrals
(q = integration momentum).";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];
   

MakeContext[
Cases2,
DiracGamma,
FeynAmpDenominator,
Momentum,
OPEDelta,
Pair,
PropagatorDenominator,
Select1,
Select2
];

UVPart[0,_]:=0;
UVPart[exp_Plus, q_] := Map[UVPart[#, q]&, exp];
UVPart[exp_,q_] := Block[{neglect, qcheck},

neglect[ FeynAmpDenominator[
          PropagatorDenominator[Momentum[q,___],0]..
                         ]
       ] := 0;

neglect[ FeynAmpDenominator[
          PropagatorDenominator[Momentum[q,___],0]..
                           ]*
          (_. + _. Pair[Momentum[q,___], Momentum[OPEDelta,___]])^_.
       ] := 0;

neglect[ FeynAmpDenominator[_PropagatorDenominator,
                           _PropagatorDenominator,
                          __PropagatorDenominator
                         ]
       ] := 0;

qcheck[w_] := If[!FreeQ[w, DiracGamma], False,
(* check if all occurences of q are q.OPDElta's *)
Block[{w1, w2, qQ},
Catch[
      w1 = Select2[Cases2[w, Pair], q];
      If[!MatchQ[w1, {Pair[Momentum[q,___],
                           Momentum[OPEDelta,___]]..}
                ], 
         Throw[False],
         w2 = Table[w1[[i]] -> (w1[[i]]/.q->qQ),{i,Length[w1]}];
         If[FreeQ[w/.w2,q], Throw[True], Throw[False]]
        ]
     ]]          ];
      
neglect[ (_. + _. Pair[Momentum[q,___], Momentum[OPEDelta,___]])^_.
        FeynAmpDenominator[_PropagatorDenominator,
                           _PropagatorDenominator,
                          __PropagatorDenominator
                         ]
       ] := 0;


neglect[ (a_ /; qcheck[a]) * 
        FeynAmpDenominator[_PropagatorDenominator,
                           _PropagatorDenominator,
                          __PropagatorDenominator
                          ]
       ] := 0;

neglect[ (a_ /; qcheck[a]) * (b_ /; qcheck[b]) * 
        FeynAmpDenominator[_PropagatorDenominator,
                           _PropagatorDenominator,
                          __PropagatorDenominator
                          ]
       ] := 0;

 If[Head[exp] =!= Times, exp,
    Select1[exp,q] (neglect[Select2[exp,q]]/.neglect->Identity)
   ]
                        ];
End[];

If[$VeryVerbose > 0,WriteString["stdout", "UVPart | \n "]];
Null
