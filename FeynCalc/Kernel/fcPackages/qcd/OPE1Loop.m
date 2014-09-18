

(* :Title: OPE1Loop*)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)
(* :History: File created on 28 August '98 at 16:54 *)
(* ------------------------------------------------------------------------ *)

(* :Summary:  *)
            

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`qcd`OPE1Loop`",
             {"HighEnergyPhysics`FeynCalc`"}];

OPE1Loop::"usage"=
"OPE1Loop[q1, amp].  OPE1Loop[{q1,q2}, amp] does sub-loop 
decomposition.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];
   

MakeContext["Contract", "Contract3"];
DiracTrace := DiracTrace = MakeContext["DiracTrace"];
Tr2 := Tr2 = MakeContext["Tr2"];

MakeContext[
FCPrint,
Cases2,
ChangeDimension,
Collecting,
Collect2,
Contract,
Dimension,
Eps,
EpsContract,
EpsEvaluate,
ExpandScalarProduct,
Expand2,
Factoring,
Factor1,
FeynCalcInternal,
FeynCalcExternal,
FeynCalcForm,
FeynAmpDenominator,
FeynAmpDenominatorSimplify,
FreeQ2,
GluonVertex,
InitialSubstitutions,
FinalSubstitutions,
LorentzIndex,
Momentum,
MomentumExpand,
NumericalFactor,
OPE,
OPEi,
OPEj,
OPEDelta,
OPESum,
OPESumSimplify,
Pair,
Power2,
PowerSimplify, 
ScalarProductCancel,
Select1,
Select2,
SubLoop,
SUNFToTraces,
SUNNToCACF,
SUNSimplify,
TID,
PropagatorDenominator,
Trick,
Write2
];
FeynAmpDenominatorCombine := FeynAmpDenominatorCombine = 
               MakeContext["FeynAmpDenominatorCombine"];
FeynAmpDenominatorSplit := FeynAmpDenominatorSplit = 
               MakeContext["FeynAmpDenominatorSplit"];
Explicit := Explicit = MakeContext["Explicit"];
Twist2GluonOperator := Twist2GluonOperator = 
  MakeContext["Twist2GluonOperator"];
Twist2QuarkOperator := Twist2QuarkOperator = 
  MakeContext["Twist2QuarkOperator"];

(*
Unprotect[Power]; 0^_ = 0; Protect[Power];
*)

Options[OPE1Loop] = 
{Collecting -> True,        Dimension -> D, SubLoop -> False,
 FinalSubstitutions -> {},  InitialSubstitutions -> {},
 SUNFToTraces -> True,
 SUNNToCACF -> True
};

OPE1Loop[qq_,amp_]:=OPE1Loop[False, qq,amp];

OPE1Loop[any___, qq_Plus,a___Rule] := Map[ ope1[any,#,a]&, qq 
                                    ] /. ope1 -> OPE1Loop;

OPE1Loop[qq_,amp_,opt1_,opt___Rule] := 
  OPE1Loop[False, qq,amp,opt1,opt]/; !FreeQ[opt1,Rule] && qq=!=False;

OPE1Loop[name_, {ka1_, ka2_}, amp_, opts___Rule] :=
If[FreeQ2[amp, {ka1, ka2}] ||  
 ((Head[amp] =!= Times) && (Head[amp] =!= FeynAmpDenominator)),
   amp,
PairFix[
 OPE1Loop[name, ka2,
           OPE1Loop[name, ka1, amp//. PropagatorDenominator[
               (any_.) -Momentum[ka1,di___], m_] :>
                     PropagatorDenominator[-any + Momentum[ka1,di], m], 
                    SubLoop -> True, opts
                   ]//. PropagatorDenominator[
               (any_.) -Momentum[ka2,di___], m_] :>
                     PropagatorDenominator[
               -any +Momentum[ka2,di], m], SubLoop -> True,
     opts],{ka1,ka2}]];

PairFix[exp_, {ka__}] := Block[{tt},
FCPrint[3,"entering PairFix"];
 pf = Table[Pair[Momentum[{ka}[[j]], di___], Momentum[{ka}[[j]], di___]
                ]^n_Integer?Negative, {j, Length[{ka}]}
           ];
 If[FreeQ2[exp, pf], exp,
    pf = Table[Pair[Momentum[{ka}[[j]], di___], Momentum[{ka}[[j]], di___]
                   ]^n_Integer?Negative -> (
          FeynAmpDenominator[PropagatorDenominator[
                 Momentum[{ka}[[j]],di], 0]]^(-n)),
              {j, Length[{ka}]}
              ];
FCPrint[3,"exiting PairFix"];
    FeynAmpDenominatorCombine[exp /. pf]
  ]                          ];
            

OPE1Loop[grname_,k_ /; Head[k] =!= List, 
         integ_ /; Head[integ] =!= Plus,opts___Rule
        ] := Block[
{collecting, contrac,amp,dim,powexp,feyncan, feyncanon, subloop, fsc,
 opsumdoit, qp1, subfactor=1, ampp, fad, fap, trf = {},
 sunntocacf, sunftotraces, fds1, fscrule
},
 Global`INTEG = integ;
If[FreeQ[integ,k](* || (!FreeQ[integ, (_. +_. Pair[Momentum[k,___], _]
                                    )^(hw_/;Head[hw] =!=Integer)
                            ]
                     )*) ||
                     (!FreeQ2[integ, {(_. +_. Pair[Momentum[k,___], _]
                                      )^(hw_Integer?Negative),
                                      Power2[
                                      (_. +_. Pair[Momentum[k,___], _]
                                      ), (hw_Integer?Negative)
                                            ]
                                     }
                             ]
                     ) || 
   FreeQ[Select1[Select1[integ, FeynAmpDenominator],
                 {((_.) + (_.) Pair[Momentum[_,___], _])^
                  (hw_/;Head[hw] =!=Integer),
                  Power2[((_.) + (_.) Pair[Momentum[_,___], _]),
                         (hw_/;Head[hw] =!=Integer)
                        ]
                 }], k] ||
     (* NEWWWWW *)
   (Length[Select2[Cases2[integ, PropagatorDenominator],k]]>2)
(*then*)
  , 
FCPrint[1,"nononononon"];
fds1 = Identity;
amp = FeynAmpDenominatorCombine[integ]
(* else *)
,

FCPrint[1,"yeSSSSSSSS"];

dim = Dimension /. {opts} /. Options[OPE1Loop];
collecting = Collecting /. {opts} /. Options[OPE1Loop];
subloop = SubLoop /. {opts} /. Options[OPE1Loop];
sunntocacf = SUNNToCACF /. {opts} /. Options[OPE1Loop];
sunftotraces = SUNFToTraces /. {opts} /. Options[OPE1Loop];
If[subloop === True,
        fscrule = {1/Pair[Momentum[k,di_], Momentum[k,di_]] :>
                   fsc[Momentum[k,di]],
                   1/Pair[Momentum[k,di_], Momentum[k,di_]]^2 :>
                   fsc[Momentum[k,di], Momentum[k,di]]
                  }; 
   fsc[w_]   := 1/FeynAmpDenominator[PropagatorDenominator[w, 0]];
   fsc[w_, w_] := 1/FeynAmpDenominator[PropagatorDenominator[w, 0],
                                       PropagatorDenominator[w, 0]];
   tdec[w_, ka_] := Block[{tem},
                     tem = 
                   TID[w, ka,ScalarProductCancel -> False,
                       Collecting -> False, Contract->True
                      ];
(*Global`TEM = tem;*)
                    tem = tem /. fscrule
;tem                     ];

   fds1[a_] := a //. PropagatorDenominator[
               (any_.) -Momentum[k,di___], m_] :>
                     PropagatorDenominator[
               -any +Momentum[k,di], m];
   ,
   tdec = tdec1loop;
   fsc[w_] := ExpandScalarProduct[Pair[w, w]];
   fsc[w_,w_] := ExpandScalarProduct[Pair[w, w]^2];
   fds1[a_] := FeynAmpDenominatorSimplify[a, k];
  ];

If[subloop === True, amp = ChangeDimension[integ, dim]];

If[subloop =!= True,
amp = ChangeDimension[integ//FeynCalcInternal, dim]//Trick;
   If[CheckContext["DiracTrace"],
      amp = amp /. DiracTrace -> Tr2
     ];
   amp = FeynAmpDenominatorCombine[amp];

amp0 = amp;
If[!FreeQ[amp,OPE], amp = Coefficient[ Expand2[amp, OPE], OPE]];

amp1 = amp;
contrac[yy_] := Contract[yy, EpsContract->False];
FCPrint[1,"sunsimplifying"];
amp = SUNSimplify[amp, SUNFToTraces -> sunftotraces, 
                  SUNNToCACF -> sunntocacf];
FCPrint[1,"contracting"];
If[FreeQ[amp, Eps] && !FreeQ[amp, LorentzIndex],
   amp = Contract3[amp] /. Contract3 -> contrac;
  ];

FCPrint[1,"contracting 2"];
   amp = Contract[amp/.GluonVertex[aa__] :> 
          GluonVertex[aa, Explicit->True], EpsContract -> False];
If[CheckContext["Twist2GluonOperator"],
   glopex[a__] := Twist2GluonOperator[a, Explicit -> True, 
                                   Dimension -> dim];
   FCPrint[1,"inserting gluon operator"];
   amp = amp  /. Twist2GluonOperator -> glopex;
   FCPrint[1,"contracting again "];
   amp = Contract[amp, EpsContract -> False];
  ];
If[CheckContext["Twist2QuarkOperator"],
   quex[a__] := Twist2QuarkOperator[a, Explicit -> True, 
                                   Dimension -> dim];
   FCPrint[1,"inserting quark operator"];
   amp = amp  /. Twist2QuarkOperator -> quex;
   FCPrint[1,"contracting again "];
   amp = Contract[amp, EpsContract -> False];
  ];

FCPrint[1,"expanding scalar products"];
amp = amp //. Pair -> ExpandScalarProduct;

If[!FreeQ[amp, OPESum],
   FCPrint[1,"OPESumSimplify 1"];
   amp = OPESumSimplify[amp]
  ];
FCPrint[1,"OPESumSimplify 1 done"];

amp = Expand2[amp//EpsEvaluate, k];

(*Global`AMP2 = amp;*)
(*
powexp[x_] := x /. (-y_)^po_ :> (-1)^po y^po /. (-1)^(2 _Symbol) -> 1;
amp = powexp[amp];
*)

If[subloop === False && !FreeQ[amp, OPESum],
opsumdoit[a_,b_] := opsumdoit[a,b] = 
If[!MatchQ[Select2[a,k] /. Power2->Power, 
    (_. Pair[Momentum[OPEDelta,dim], Momentum[k,dim]])^
                             (w_/;Head[w]=!=Integer) *
    (_. Pair[Momentum[OPEDelta,dim], Momentum[pe_,dim]] + 
     _. Pair[Momentum[OPEDelta,dim], Momentum[k,dim]])^
                             (v_/;Head[v]=!=Integer) 
          ],
   OPESum[a,b],
 ( PowerSimplify[
             Apart[Select1[a, {OPEi, OPEj}] *
     Sum[((a/Select1[a,{OPEi,OPEj}])/.Power2->Power) //.
         {(-1)^(n_Integer?EvenQ m_. + aa_) :> (-1)^aa
         }, b
        ]
              ] ]/. ((pl_Plus)^(w_/;Head[w] =!= Integer) :>
                      Power2[pl,w])
 )/.(-1)^(n_Integer?EvenQ m_. + aa_.) :> (-1)^aa
 ];

(*
amp = amp /. OPESum -> opsumdoit;
*)

(*Global`amp3 = amp;*)

ops[null1] = ops[null2] = 0;
ops[a_ OPESum[xa_,xb_]]  := 
 a/(Select2[a dUM, k]) OPESum[xa Select2[a dUM,k],xb];

amp = Map[ops, amp + null1 + null2] /. ops -> Identity;
amp = fds1[amp]//PowerSimplify;

];

FCPrint[2, "collecting w.r.t. k"];
amp = Collect2[amp, k, Factoring -> False];

qup1[x_] := If[Head[x] =!= Times, qp1[x],
               Select1[x, k] qp1[Select2[x, k]]
              ];
qp1[x_] := fds1[ ScalarProductCancel[x,k]
               ];

rli = {};
nn = 0;
nn = qup1[amp];
amp = nn;
(*Global`AMP3 = amp;*)
(* If[$Dialog === True, Dialog[amp] ]; *)
(*FALSCH*)
amp = Collect2[amp, k, Factoring -> False];

subfactor = 1
(* Else *)
,

amp = FeynAmpDenominatorSplit[integ, k];
If[(Head[amp] === Times) || (Head[amp] === FeynAmpDenominator), 
   subfactor = Select1[amp, k];
FCPrint[2,"subfactor = ",subfactor//InputForm];
   ampp = amp;
   amp = amp / subfactor;
   amp = MomentumExpand[amp];
   amp = amp /. FeynAmpDenominator[
                  PropagatorDenominator[_. + _. Momentum[k,___],0]
                                  ] :> 0;
(* do a translation eventually *)
   If[MatchQ[MomentumExpand[Select2[amp, FeynAmpDenominator]],
      FeynAmpDenominator[PropagatorDenominator[_Plus,_],___]]
      ,
      fad = Select2[amp, FeynAmpDenominator];  
(* k - p *)
      fap = fad[[1,1]];
      fap = fap  /. Momentum[aa_, ___] :> aa;
      If[NumericalFactor[Select2[fap, k]] === -1, fap  = - fap];
      trf = k -> (-k + (fap - k));
      amp = EpsEvaluate[ExpandScalarProduct[amp /. trf]];
      amp = Expand2[amp, k];
     ];

  ];
(* subloop *)];
(*
Print["checkeckekckekkck       asfasdfasfasdfasfasfasdfasfasfasdf"];
If[$Dialog === True, Dialog[amp]];
*)

nn = 0;
If[Head[amp] =!= Plus,
   nn = fds1[tdec[amp, k]];
,
   lamp = Length[amp];
   For[j = 1, j <= lamp, j++, 
       FCPrint[1,"QPC2 ",j, " out of ",lamp];
       nn = nn + fds1[tdec[amp[[j]],k]];
      ]
  ];
amp = EpsEvaluate[nn];
amp4 = amp;
If[collecting === False, 
   amp = Expand[amp],
   If[collecting === True,
      amp = Collect2[amp, {LorentzIndex, k}],
      amp = Collect2[amp, collecting]
     ]
  ];
If[subloop === True,
   If[trf =!= {},
      amp = EpsEvaluate[ExpandScalarProduct[amp /. trf]];
     ];
   amp = Expand2[amp, k];
   amp = FeynAmpDenominatorCombine[amp subfactor],
   amp = amp /. Power2  -> Power
  ];
 amp]];

(* only valid for Subloop === False !!!! *)
tdec1loop[x_, k_] := (*tdec[x] = *)Block[{te, dufa, re = x, nok, kkk, qqq, 
                                     ePS,pAIR},
 SetAttributes@@{pAIR, Orderless};
                  te = Expand2[x, k]/.Power2->Power;
                  If[ Head[te] === Plus, te = Map[tdec[#,k]&, te] ];
                  If[FreeQ[te, (a_ /; (Head[a]=!=Integer) && 
                                     !FreeQ[a, k])^
                               (z_ /; Head[z]=!=Integer)
                          ],
                  If[te =!= 0,
                     te  = dufa te;
                     nok = Select[te, FreeQ[#, k]&] /. dufa -> 1;
                     kkk = qqq[Select[te,!FreeQ[#, k]&]] ; 
(* fool the pattern matcher *)
                     kkk = kkk /.{(Pair[Momentum[k, dim], a_]^2 :>
                           (Pair[Momentum[k, dim], a] *
                            pAIR[Momentum[k, dim], a]
                           )      ),
                                  (Eps[a___, Momentum[k, dim], b___]^2 :>
                           (Eps[a,Momentum[k, dim], b] *
                            ePS[a, Momentum[k, dim], b]
                           )     )} ;
  re = nok ExpandScalarProduct[( kkk /. {
(* Bmu k_mu (k, kp)*)
               qqq[(fun_[b___, Momentum[k, ___], c___] /;
                                ((fun===Pair) || (fun === Eps))
                   ) *
      FeynAmpDenominator[
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim] + anyp_, 0]
                        ]
                  ] :>
                      ((-1/2) fun[b, anyp, c] *
                        FeynAmpDenominator[
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim] + anyp, 0]
                                          ]
                      ) /; FreeQ[{b, c}, k],
(* Bmunu k_mu k_nu (k, kp)*)
               qqq[(fun1_[b___, Momentum[k, ___], c___] /;
                    ((fun1 === Pair) || (fun1 === Eps) || 
                     (fun1 === pAIR) || (fun1 === ePS))
                   ) *
                   (fun2_[bb___, Momentum[k, ___], cc___] /;
                    ((fun2 === Pair) || (fun2 === Eps) || 
                     (fun2 === pAIR) || (fun2 === ePS))
                   ) *
      FeynAmpDenominator[
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim] + anyp_, 0]
                        ]
                  ] :>
                 ( muUUu = LorentzIndex[Unique[$MU], dim];
         (-1)/(4 (1-dim)) (
               - Pair[anyp, anyp]*
(* gmunu *)
                  Contract[(fun1[b, muUUu, c] fun2[bb, muUUu, cc]
                           ) /. {pAIR :> Pair, ePS :> Eps}, 
                          EpsContract->False
                          ] +
                  dim fun1[b, anyp, c] *
                      fun2[bb, anyp, cc]
                          ) *
                        FeynAmpDenominator[
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim] + anyp, 0]
                                          ]
                 ) /; FreeQ[{b, c}, k],

(* Bmu112 k_mu (k,k, kp)*)
              qqq[(fun_[b___, Momentum[k, ___], c___] /; 
                                ((fun===Pair) || (fun === Eps))
                  ) *
      FeynAmpDenominator[
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim] + anyp_, 0]
                        ]
                 ]:> ((-1) / 2  fun[b, anyp, c] *
                          ( 1/fsc[anyp] * 
                             FeynAmpDenominator[
                             PropagatorDenominator[Momentum[k, dim], 0],
                             PropagatorDenominator[Momentum[k, dim]  + 
                                                   anyp, 0]
                                              ] + 
                             FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim]  + 
                                                      anyp, 0]
                                               ]
                    )) /; FreeQ[{b, c}, k],
(* Bmu1122 k_mu (k,k, kp,kp)*)
              qqq[(fun_[b___, Momentum[k, ___], c___] /;
                                ((fun===Pair) || (fun === Eps))
                  ) *
      FeynAmpDenominator[
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim] + anyp_, 0],
        PropagatorDenominator[Momentum[k, dim] + anyp_, 0]
                        ]
                 ]:> ((-1) / 2 fun[b, anyp, c] *
                          ( FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                  anyp, 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                  anyp, 0]
                                               ]
                         )) /; FreeQ[{b, c}, k],

(* Bmunu112 k_mu k_nu (k,k, kp)*)
              qqq[( fun1_[b___, Momentum[k, ___], c___] /;
                   ((fun1===Pair)   || (fun1 === Eps) || 
                    (fun1 === pAIR) || (fun1 === ePS))
                  ) *
                  (fun2_[bb___, Momentum[k, ___], cc___] /;
                   ((fun2===Pair)   || (fun2 === Eps) || 
                    (fun2 === pAIR) || (fun2 === ePS))
                  ) *
      FeynAmpDenominator[
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim] + anyp_, 0]
                        ]
                 ]:> (*g_munu*) ( muUUu = LorentzIndex[Unique[$MU], dim];
                      Contract[(fun1[b, muUUu, c] *
                                fun2[bb, muUUu, cc]) /. 
                                 {pAIR :> Pair, ePS :> Eps},
                                EpsContract -> False] *
                      (1/(1-dim) (- 1/2 * FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                      anyp, 0]
                                                           ] + 
        1/4 Pair[anyp, anyp] FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                     anyp, 0]
                                        ] 
                                 )
                      ) + 
                     (*pmu pnu*)(Contract[(fun1[b, anyp,c] fun2[bb,anyp,cc]
                                          ) /. {pAIR :> Pair, ePS :> Eps}, 
                                          EpsContract -> False
                                          ] *
                                (1 / (4 (1-dim)
                                     ) (-dim *
                                FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim] +
                                                      anyp, 0]
                                                  ] + 
                                        4/fsc[anyp] *
                                         FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim] +
                                                      anyp, 0]
                                                           ] - 
                                        2 dim /fsc[anyp] *
                                         FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim] +
                                                      anyp, 0]
                                                           ]
                                )       )
                                )
                              ) /; FreeQ[{b,c,bb,cc}, k],
(* Bmunu1122 k_mu k_nu (k,k, kp,kp)*)
              qqq[(fun1_[b___, Momentum[k, ___], c___] /;
                   ((fun1===Pair) || (fun1 === Eps) || 
                    (fun1 === pAIR) || (fun1 === ePS))
                  ) *
                  (fun2_[bb___, Momentum[k, ___], cc___] /;
                   ((fun2===Pair) || (fun2 === Eps) || 
                    (fun2 === pAIR) || (fun2 === ePS))
                  ) *
      FeynAmpDenominator[
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim], 0],
        PropagatorDenominator[Momentum[k, dim] + anyp_, 0],
        PropagatorDenominator[Momentum[k, dim] + anyp_, 0]
                        ]
                 ]:> (*g_munu*) 
( muUUu = LorentzIndex[Unique[$MU], dim];
                      Contract[(fun1[b, muUUu, c] fun2[bb, muUUu, cc]
                               ) /. {pAIR :> Pair, ePS :> Eps},
                               EpsContract -> False] *
                      (-1/(4(1-dim))  *
                                 ( 2/fsc[anyp] * 
                                  FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                      anyp, 0]
                                                     ] +
                                  4* 
                                  FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                      anyp, 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                      anyp, 0]
                                                     ] -
                                   Pair[anyp, anyp]*
                                FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                      anyp, 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                      anyp, 0]
                                                        ]
                                 )
                      ) +
                      (*pmu pnu*)
                      Contract[(fun1[b, anyp, c] *
                                fun2[bb, anyp, cc]
                               ) /. {pAIR :> Pair, ePS :> Eps}, 
                               EpsContract -> False] *
                      ( 
                            1/(4 (1-dim)) (
                          2 dim /fsc[anyp, anyp] *
                         FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                      anyp, 0]
                                           ] + 
                          4/fsc[anyp] FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                      anyp, 0]
                                                              ]  -
                            dim*
                           FeynAmpDenominator[
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim], 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                      anyp, 0],
                                PropagatorDenominator[Momentum[k, dim]  +
                                                      anyp, 0]
                                             ]  
                                            )
                      )
)
 

             } /. qqq -> Identity /. {pAIR :> Pair, ePS :> Eps} )]
                     ];
  ];
              (re /. dufa -> 1)];

End[];

If[$VeryVerbose > 0,WriteString["stdout", "OPE1Loop | \n "]];
Null
