

(* :Title: Convolute *)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)
(* :History: File created on 10 March '98 at 15:33 *)
(* ------------------------------------------------------------------------ *)

(* :Summary:  Convolute convolutes *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`fctables`Convolute`",{"HighEnergyPhysics`FeynCalc`"}];

Convolute::"usage"=
"Convolute[f[x], g[x], x] convolutes f[x] and g[x], i.e.,
Integrate2[ DeltaFunction[x - x1 x2] f[x1] g[x2],
                        {x1, 0, 1}, {x2, 0, 1}
          ].
Convolute[exp, {x1, x2}] assumes that exp is polynomial in x1 and x2.";

Bracket::"usage"= "Bracket is an option for Convolute.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];
   

MakeContext[Collect2, ConvoluteTable, 
            DeltaFunction, Epsilon, Expanding,
            FinalSubstitutions, CF,CA,Tf,Nf,
            Factoring, Factor2, FreeQ2, Integrate2,
            Polarization, PlusDistribution, PowerSimplify,
            SelectFree, SelectNotFree,Series2, 
            SplittingFunction, Zeta2];

spe[y__] := spe[y] = 
            If[!FreeQ2[{y}, {Log, PolyLog, PlusDistribution}] &&
              FreeQ2[{y}, {CF,CA,Tf,Nf}],
               Collect2[Plus[y], {Log, PolyLog, PlusDistribution},
                        Factoring -> False],
               Plus[y]
              ];

logfix[y_, y1_, y2_] := y /. {Log[y1 (1-y1)] :> (Log[y1] + Log[1-y1]),
                              Log[y2 (1-y2)] :> (Log[y2] + Log[1-y2])
                             }; 

Options[Convolute] = {Bracket -> {Epsilon},
(*
                      ConvoluteTable -> True,
*)
(*
                      Series2 -> False,
*)
(*
                      Print -> False,
*)
                      FinalSubstitutions -> {PlusDistribution->Identity}
(*
                      FinalSubstitutions -> { 
                      Log[-1+1/C_] :> (Log[1-C] - Log[C]),
                      PolyLog[2,C_] :> (-PolyLog[2,1-C] +
HighEnergyPhysics`general`Zeta2`Zeta2 - Log[C] Log[1-C])}
*)
                     };

cvs[aa_Plus,b__] := cvs[#,b]& /@ aa;
cvs[w_/;Head[w]=!=Plus, {x_,y_},opt___Rule] := 
 SelectFree[w, {x,y}] cvsav[SelectNotFree[w,{x,y}],{x,y},opt];

cvsav[v_,{xx_, yy_}, opt___Rule] := (cvsav[v,{xx,yy},opt] =
 Convolute[SelectNotFree[v,xx], SelectFree[v,xx]/.yy->xx,xx, 
           Bracket -> {False, False}, opt
          ]                         ) /;
     FreeQ[SelectNotFree[v,xx], yy] ;


Convolute[exp_, {x_, y_}, opt___Rule] := Block[{r,bra},
   bra = Bracket /. {opt} /. Options[Convolute];
   r = cvs[Expand[Expand[exp,x],y],{x,y}];
   r = r /. (FinalSubstitutions /. {opt} /. Options[Convolute]);
   r = r//Expand;
   r = Expand[Collect2[r,{Log,PolyLog,PlusDistrbution,DeltaFunction}]];
   r = r /. Log[x] PlusDistribution[1/(1-x)] :> Log[x]/(1-x);
   If[Head[r]===Plus, r = Apart[#,x]& /@ r, r = Apart[r,x]];
   r = Collect2[r, SelectFree[Variables[r], {Zeta2,x}],
                 Factoring -> False,
                 Expanding -> False];

   r = r /. Plus -> spe;
   r = r /. spe -> Plus;
   r = Collect2[r, bra, Factoring -> False];
   r];

 

Convolute[f_, g_/;Head[g] =!= List, opt___Rule] :=
  Convolute[f, g, Global`x, opt];

Convolute[if_, ig_, x_,opt___Rule] :=  Block[
{fix1,fix2,fix3,fix4,
 x1, x2, rr,f,g,br,tablelookup, tablelabel = False,tay},
  br= Flatten[{Bracket /. {opt} /. Options[Convolute]}];
  If[(Series2 /. {opt} /. Options[Convolute]) === True, 
     tay[z_Plus] := tay /@ z;
     tay[z_ /;Head[z]=!=Plus] := If[!FreeQ[z, (1-x)^(_. Epsilon -1)],
                                    z,
                                    If[FreeQ[z, Epsilon],z,
                                       Series2[z,Epsilon,2]
                                      ]                                   
                                   ]
    ,
     tay = Identity
    ];

If[br =!= {False, False},
  fix1 = {Log[1-x]^2/(1-x)   :> PlusDistribution[Log[1-x]^2/(1-x)],
          Log[1-x]^2/(x-1)   :>-PlusDistribution[Log[1-x]^2/(1-x)],
          Log[1-x]/(1-x)     :> PlusDistribution[Log[1-x]/(1-x)],
          Log[1-x]/(x-1)     :> -PlusDistribution[Log[1-x]/(1-x)],
          Log[(1-x) x]/(1-x) :> PlusDistribution[Log[(1-x) x]/(1-x)],
          Log[(1-x) x]/(x-1) :>-PlusDistribution[Log[(1-x) x]/(1-x)]
         };
  fix2 = {1/(1-x) :> PlusDistribution[1/(1-x)],
          1/(x-1) :> -PlusDistribution[1/(1-x)],
          PlusDistribution[Log[x]/(1-x)] :> Log[x]/(1-x),
          Log[1-x] PlusDistribution[1/(1-x)] :> 
          PlusDistribution[Log[(1-x)]/(1-x)],
          Log[x] PlusDistribution[1/(1-x)] :> Log[x]/(1-x),
          Log[(1-x) x] PlusDistribution[1/(1-x)] :> 
          PlusDistribution[Log[(1-x)]/(1-x)] + Log[x]/(1-x),
          PlusDistribution[Log[(1-x) x]/(1-x)] :> 
          PlusDistribution[Log[(1-x)]/(1-x)] + Log[x]/(1-x)
         };
  fix3 = PlusDistribution[w_] :> 
          PlusDistribution[w/.PlusDistribution->Identity];
(* get of rid of "fake distributions" *)
  fix4 = {Log[x]^a_. PlusDistribution[Log[1-x]/(1-x)] :> 
           Log[x]^a Log[1-x]/(1-x),
          Log[x]^a_. PlusDistribution[1/(1-x)] :>
           Log[x]^a / (1-x)
         };
 
  f = Expand[Apart[logfix[if,x,x]//PowerSimplify//tay,x],x
            ]/.fix1/.fix2/.fix3/.fix4; 
  g = Expand[Apart[logfix[ig,x,x]//PowerSimplify//tay,x], x
            ]/.fix1/.fix2/.fix3/.fix4; 
 ,
  f = tay[if]; g = tay[ig]
  ];

 rr = Catch[
(* linearity *)
  If[Head[f] === Plus, 
     Throw[Convolute[#,g,x,  
                     Bracket -> {False, False}, opt]& /@ f],
     If[Head[g] === Plus,
        Throw[Convolute[f,#,x,  
                     Bracket -> {False, False}, opt]& /@ g]
       ]
    ];
  If[(Head[f] =!= Plus) && (SelectFree[f,x]=!=1),
     Throw[SelectFree[f,x] Convolute[f/SelectFree[f,x],g,x,
                            Bracket -> {False, False}, opt]]
    ];
  If[(Head[g] =!= Plus) && (SelectFree[g,x]=!=1),
     Throw[SelectFree[g,x] Convolute[f,g/SelectFree[g,x],x,
                            Bracket -> {False, False}, opt]]
    ];

If[!FreeQ[f, DeltaFunction[1-x]], 
    Throw[g (f /. DeltaFunction[1-x]->1 /. x -> 1)]];
If[!FreeQ[g, DeltaFunction[1-x]], 
    Throw[f (g /. DeltaFunction[1-x]->1 /. x -> 1)]];

(*do always table-look up for now ,  fix maybe later ... *)
If[(*(ConvoluteTable /. {opt} /. Options[Convolute]) === True,*)
   True,
   If[(tablelookup = ConvoluteTable[f,g,x]) =!= False[__], 
      tablelabel = True; Throw[tablelookup]
     ];
  ];
(* BROKEN !!, will not be used *)

(* calculate it ... *)
   x1 = Unique["Global`x"];
   x2 = Unique["Global`x"];
   rr = Integrate2[ DeltaFunction[x - x1 x2] *
                    logfix[
                    (f /. x -> x1) (g /. x -> x2), x1, x2
                          ],
                    {x1, 0, 1}, {x2, 0, 1}
                  ];
If[$VeryVerbose >1, Print["exiting Integrate2"]];
   If[!FreeQ[rr, PolyLog],
      rr = rr /. PolyLog[2, ix_Symbol] :> (Zeta2 - PolyLog[2, 1-ix] -
                                       Log[ix] Log[1-ix]
                                      );
     ];
   rr = rr /. { Log[1/ix_] :> (-Log[ix]), 
                Log[-1/ix_] :> (-Log[-ix])};
 rr];

   rr = rr /. (FinalSubstitutions /. {opt} /. Options[Convolute]) /.
               (x-1)^(-1) :> (-1/(1-x));
 
If[br =!={False, False} && tablelabel =!= True,
(* for cancelling *)
   rr = rr /. (FinalSubstitutions /. {opt} /. Options[Convolute]);
   rr = rr//Expand;
   rr = Expand[Collect2[rr,{Log,PolyLog,PlusDistribution,DeltaFunction}]];
   rr = rr /. Log[x] PlusDistribution[1/(1-x)] :> Log[x]/(1-x);
   If[Head[rr]===Plus, rr = Apart[#,x]& /@ rr, rr = Apart[rr,x]];
   rr = Collect2[rr, SelectFree[Variables[rr], {Zeta2,x}], 
                 Factoring -> False,
                 Expanding -> False];

   rr = rr /. Plus -> spe;
   rr = rr /. spe -> Plus;
   If[(br =!= {}) && (br =!= {False, False}),
      rr = Collect2[rr, br, Factoring -> False];
     ];
  If[br === {False,False}, 
   If[((Print /. {opt} /. Options[Convolute]) === All
      ) && $Notebooks,
      Print[FeynCalc`Tbox[if," * ",ig, "  =  ", rr]]
     ],
   If[(((Print /. {opt} /. Options[Convolute]) === All
       ) ||
       ((Print /. {opt} /. Options[Convolute]) === All
       )
      ) && $Notebooks,
      Print[FeynCalc`Tbox[if," *  ",ig, "  =  ", rr]]
     ];
    ];
(*tablelabel*)
  ];
                             rr];

(* special cases *)
Convolute["agq", "Pgg",x_:Global`x] := Convolute["Pgg", "agq",x];
Convolute["Pgg", "agq",x_:Global`x] := (
CF*Nf*Tf*(-16/3 + 32/(3*x) + (16*x)/3 + 
      (-32/3 + 32/(3*x) + (16*x)/3)*Log[1 - x] + 
      (-32/3 + 32/(3*x) + (16*x)/3)*Log[x]) + 
   CA*CF*(-140/3 + 440/(9*x) - (4*x)/3 - (272*x^2)/9 - 32*Zeta2 + 
      (32*Zeta2)/x + 16*x*Zeta2 + 
      (-56/3 + 64/(3*x) - (116*x)/3 - (32*x^2)/3)*Log[1 - x] + 
      (32 - 32/x - 16*x)*Log[1 - x]^2 + 
      (280/3 + 184/(3*x) + (124*x)/3 + (32*x^2)/3)*Log[x] + 
      (64 + 16*x)*Log[1 - x]*Log[x] + (16 + 16/x + 16*x)*Log[x]^2 + 
      (96 - 32/x)*PolyLog[2, 1 - x]) ) /; 
       (Polarization /. Options[SplittingFunction]) === 0;
 
Convolute["aqq", "Pgq",x_:Global`x] := Convolute["Pgq", "aqq", x];
Convolute["Pgq", "aqq",x_:Global`x] := (
CF^2*(8 - 16/x + 36*x + 32*Zeta2 - (32*Zeta2)/x - 16*x*Zeta2 + 
     (-40 + 24/x + 16*x)*Log[1 - x] + (16 - 16/x - 8*x)*Log[1 - x]^2 + 
     (-56 - 8*x)*Log[x] + (-16 + 8*x)*Log[1 - x]*Log[x] + 
     (-8 + 4*x)*Log[x]^2 + (-48 + 32/x + 24*x)*PolyLog[2, 1 - x])
                                       ) /;
       (Polarization /. Options[SplittingFunction]) === 0;
 
Convolute["Pgg", "Pgq",x_:Global`x] := Convolute["Pgq", "Pgg", x];
Convolute["Pgq", "Pgg",x_:Global`x] := (
CF*Nf*Tf*(64/3 - 64/(3*x) - (32*x)/3) + 
   CA*CF*(208/3 - 320/(3*x) + (136*x)/3 + (64*x^2)/3 + 
      (-64 + 64/x + 32*x)*Log[1 , x] + (-64 - 64/x - 64*x)*Log[x])
                                       ) /;
       (Polarization /. Options[SplittingFunction]) === 0;
 
Convolute["Pqq", "Pgq",x_:Global`x] := Convolute["Pgq", "Pqq",x];
Convolute["Pgq", "Pqq",x_:Global`x] := (
CF^2*(32 - 8*x + (-64 + 64/x + 32*x)*Log[1 - x] + 
     (32 - 16*x)*Log[x])               ) /;
       (Polarization /. Options[SplittingFunction]) === 0;
(*
conv[f_,g_]:= SPL[Integrate2[PowerExpand@
  SPL[1/x1 (f/.x->x1) (g /. x->(x/x1))] ,{x1,x,1}] /. Hold[Integrate3]->
      Integrate]//Expand;
*)

End[];



If[$VeryVerbose > 0,WriteString["stdout", "Convolute | \n "]];
Null
