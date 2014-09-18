(* :Title: DiracTrick *)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)

(* :Summary: contraction and simplification rules for gamma matrices *)

(* ------------------------------------------------------------------------ *)

(* NonCommQ replaced with NonCommFreeQ everywhere due to change (fix) of
   definitions of these functions. F.Orellana, 13/9-2002 *)

DiracTrick::"usage"=
"DiracTrick[exp] contracts gamma matrices with each other and
performs several simplifications (no expansion, use DiracSimplify for this).";

(* ------------------------------------------------------------------------ *)


Begin["`DiracTrick`Private`"];


DiracGamma = FeynCalc`DiracGamma;

PairContract = MakeContext["PairContract"];

noncommQ := noncommQ = MakeContext["NonCommFreeQ"];
exscalpro := exscalpro = MakeContext["ExpandScalarProduct"];

Options[DiracTrick] = {FeynCalc`Expanding -> False};

scev[a_, b_] := scev[a, b] = exscalpro[Pair[a,b]];
coneins[x_]  := x /. Pair -> PairContract /. PairContract -> Pair;

(*By definition:*)
DiracTrick[]=1;

(* for time-saving reasons: here NO FCI*)
(* RM20120113: added FreeQ, and changed y___ to y__ ..., this fixed 
http://www.feyncalc.org/forum/0677.html
*)
DiracTrick[y__ /; FreeQ[{y}, Rule],z_/;Head[z]=!=Rule] :=
     drS[y, z]/.drS -> ds //.dr->drCOs /. drCO -> ds/.  dr->ds/.dr->DOT(*]*);

(*
	Main algorithm:
	1) Simplify expressions involving projectors and slashes (DOT ->  drS)
	2) Check the scheme and then simplify the expressions involving g^5 (drS /. drS ->  ds)
	3) Simplify expressions involving contractions of gamma matrices with momenta or other gammas (ds //. dr -> drCOs)
	4) Again check the sceme and simplify the expressions involving g^5 (twice) (drCO -> ds /.  dr -> ds /.  dr -> DOT)
*)

DiracTrick[x_,r___?OptionQ] :=(
  If[(FeynCalc`Expanding/. {r} /. Options[DiracTrick]) === True,
     Expand[ FeynCalc`FCI[x] /. 
                  DOT -> drS /. drS -> ds //. dr -> drCOs/.
                  drCO -> ds /.  dr -> ds /.  dr -> DOT
           ],
             FeynCalc`FCI[x] (*/. Dot -> DOT*) /. (*Pair -> PairContract /.*)
                  DOT -> drS /.drS -> ds //. dr -> drCOs/.
                  drCO -> ds /.  dr -> ds /. dr -> DOT (*/.
                  PairContract -> Pair*)
    ]
);

(*
	RM20120113: commented out, not clear why this should be needed
SetAttributes[DiracTrick, Flat];
*)



(*If we are not using the BM scheme, we keep the projectors as they are*)
ds[x__] := FeynCalc`MemSet[ds[x], dr[x]] /; ((!FreeQ2[{x}, {DiracGamma[6], DiracGamma[7]}]) &&
            (Head[DiracGamma[6]]===DiracGamma) && $BreitMaison === True) =!= True;
                                (*Condition added 19/1-2003 by F.Orellana to not have
                                  definition below cause infinite recursion.*)

(*If we are using the BM scheme, all g^5 in the projectors should be spelled out!*)
ds[x__] := FeynCalc`MemSet[ds[x], dr[x]/.DiracGamma[6]->(1/2 + DiracGamma[5]/2)/.
                  DiracGamma[7]->(1/2 - DiracGamma[5]/2)] /; ((!FreeQ2[{x}, {DiracGamma[6], DiracGamma[7]}]) &&
            (Head[DiracGamma[6]]===DiracGamma) && $BreitMaison === True) === True;

(* drdef *)

ds[] = dr[]=1;
dr[a___,y_SUNT w_,b___] := dr[a, y, w, b](* /; Head[y] === SUNT*);
dr[a___,y_ w_,b___] := coneins[y ds[a,w,b]]/;(noncommQ[y]&&FreeQ[y,dr]);
dr[a___,y_ ,b___]   := coneins[y ds[a,b] ] /;(noncommQ[y]&&FreeQ[y,dr]);

dr[a_spinor, b___, c_spinor, d_spinor, e___, f_spinor, g___]:=
 dr[a, b, c] dr[d, e, f, g];

(*Causes infinite recursion!! See above. 19/1-2003 F.Orellana*)
(*dr[a__]:=( ds[a]/.DiracGamma[6]->(1/2 + DiracGamma[5]/2)/.
                  DiracGamma[7]->(1/2 - DiracGamma[5]/2)
         )/;(!FreeQ2[{a}, {DiracGamma[6], DiracGamma[7]}]) &&
            (Head[DiracGamma[6]]===DiracGamma) && $BreitMaison === True;*)


(*These relations between g^5 and the projectors hold in all dimensions and all schemes*)
dr[b___,DiracGamma[5],DiracGamma[5],c___]:= ds[ b,c ];
dr[b___,DiracGamma[5],DiracGamma[6],c___]:= ds[b,DiracGamma[6],c];
dr[b___,DiracGamma[5],DiracGamma[7],c___]:=-ds[b,DiracGamma[7],c];
dr[b___,DiracGamma[6], DiracGamma[5], c___]:=ds[b,DiracGamma[6],c];
dr[b___,DiracGamma[7],DiracGamma[5],c___] := -ds[b, DiracGamma[7], c];

(*These are the usual projector properties. They also hold in all schemes*)
dr[b___,DiracGamma[6], DiracGamma[7], c___] := 0;
dr[b___,DiracGamma[7], DiracGamma[6], c___] := 0;
dr[b___,DiracGamma[6],DiracGamma[6],c___] :=  ds[b, DiracGamma[6], c];
dr[b___,DiracGamma[7],DiracGamma[7],c___] :=  ds[b, DiracGamma[7], c];

(*What happends if we have a projector in front of a g^mu? *)
dr[b___,DiracGamma[6],DiracGamma[x_[c__],di___],d___ ]:=
	ds[ b,DiracGamma[x[c],di], DiracGamma[7],d ];
dr[b___,DiracGamma[7],DiracGamma[x_[c__],di___],d___ ] :=
   ds[ b,DiracGamma[x[c],di],DiracGamma[6],d ];


(*In 4 dimensions g^5 always anticommutes with all the other gamma matrices*)
dr[b___,DiracGamma[5],c:DiracGamma[_[_]].. ,d___] :=
   (-1)^Length[{c}] ds[ b,c,DiracGamma[5],d];

(*In D dimensions it depends on the scheme we are using!
  Careful: The following three definitions are scheme dependent!!! *)

(*In the native scheme, g^5 anticommutes with all the other gamma matrices in all dimensions*)
dr[b___,DiracGamma[5],c:DiracGamma[_[__],_].. ,d___] :=
   ( (-1)^Length[{c}] ds[ b,c,DiracGamma[5],d ] ) /;
      ($BreitMaison =!= True && $Larin =!= True);

(*In the BM scheme, the anticommutator is not zero*)
dr[b___,DiracGamma[5],DiracGamma[x_[y__],d_Symbol -4] ,f___] :=
   (ds[ b,DiracGamma[x[y],d-4],DiracGamma[5],f ] ) /;
      ($BreitMaison === True && $Larin =!= True);

dr[b___,DiracGamma[5],DiracGamma[x_[y__],d_Symbol] ,f___] :=
   ( 2 ds[b,DiracGamma[x[y],d-4],DiracGamma[5],f] -
     ds[b,DiracGamma[x[y],d],DiracGamma[5],f] ) /;
      ($BreitMaison === True && $Larin =!= True);


(* o.k., some 4 years after the proposal of M.B., here it is: *)
drS[b___,DiracGamma[7],DiracGamma[_[__],___] + (n_. mass_),
    xy:DiracGamma[_[__],___].. , DiracGamma[6], c___] :=
(n mass drS[b, xy, DiracGamma[6], c]) /; NumberQ[n] &&
   OddQ[Length[{xy}]] && noncommQ[mass];

drS[b___,DiracGamma[6],DiracGamma[_[__],___] + (n_. mass_ ),
   xy:DiracGamma[_[__],___].. , DiracGamma[7], c___] :=
(n mass drS[b, xy, DiracGamma[7], c]) /; NumberQ[n] &&
  OddQ[Length[{xy}]] && noncommQ[mass];

drS[b___,DiracGamma[6],DiracGamma[_[__],___] + (n_. mass_ ),
   xy:DiracGamma[_[__],___].. , DiracGamma[6], c___] :=
(n mass drS[b, xy, DiracGamma[6], c]) /; NumberQ[n] &&
  EvenQ[Length[{xy}]] && noncommQ[mass];

drS[b___,DiracGamma[7],DiracGamma[_[__],___] + (n_. mass_ ),
   xy:DiracGamma[_[__],___].. , DiracGamma[7], c___] :=
(n mass drS[b, xy, DiracGamma[7], c]) /; NumberQ[n] &&
  EvenQ[Length[{xy}]] && noncommQ[mass];

drS[b___,DiracGamma[6],DiracGamma[v_[w__],di___] + (n_. mass_ ),
    DiracGamma[6], c___] :=
(n mass drS[b, DiracGamma[6], c] )/; NumberQ[n] && noncommQ[mass];

drS[b___,DiracGamma[7],DiracGamma[v_[w__],di___] + (n_. mass_ ),
    DiracGamma[7], c___] :=
(n mass drS[b, DiracGamma[7], c] )/; NumberQ[n] && noncommQ[mass];

drS[b___,DiracGamma[6],DiracGamma[v_[w__],di___] + (n_. mass_ ),
    DiracGamma[7], c___] :=
drS[b, DiracGamma[v[w],di], DiracGamma[7], c] /; NumberQ[n] &&
  noncommQ[mass];

drS[b___,DiracGamma[7],DiracGamma[v_[w__],di___] + (n_. mass_),
    DiracGamma[6], c___] :=
drS[b, DiracGamma[v[w],di], DiracGamma[6], c] /; NumberQ[n] &&
  noncommQ[mass];

drS[b___,DiracGamma[6],DiracGamma[v_[w__],di___] + (n_. mass_ ),
    xy:DiracGamma[_[_]].. ,DiracGamma[7], c___] :=
drS[b, DiracGamma[v[w],di], xy, DiracGamma[7], c] /; NumberQ[n] &&
       EvenQ[Length[{xy}]] && noncommQ[mass];

drS[b___,DiracGamma[7],DiracGamma[v_[w__],di___] + (n_. mass_ ),
    xy:DiracGamma[_[__],___].. ,DiracGamma[6], c___] :=
drS[b, DiracGamma[v[w],di], xy, DiracGamma[6], c] /; NumberQ[n] &&
       EvenQ[Length[{xy}]] && noncommQ[mass];

drS[b___,DiracGamma[6],DiracGamma[v_[w__],di___] + (n_. mass_ ),
    xy:DiracGamma[_[__],___].. ,DiracGamma[6], c___] :=
drS[b, DiracGamma[v[w],di], xy, DiracGamma[6], c] /; NumberQ[n] &&
       OddQ[Length[{xy}]] && noncommQ[mass];

drS[b___,DiracGamma[7],DiracGamma[v_[w__],di___] + (n_. mass_),
    xy:DiracGamma[_[__],___].. ,DiracGamma[7], c___] :=
drS[b, DiracGamma[v[w],di], xy, DiracGamma[7], c] /; NumberQ[n] &&
       OddQ[Length[{xy}]] && noncommQ[mass];


(*g^mu g_mu in 4 dimensions*)
dr[b___,DiracGamma[LorentzIndex[c_]],
        DiracGamma[LorentzIndex[c_]],d___] := 4 ds[ b,d ];

(*g^mu g_mu in D dimensions*)
dr[b___,DiracGamma[LorentzIndex[c_,di_],di_],
        DiracGamma[LorentzIndex[c_,di_],di_],d___] := di ds[ b,d ];

(*g^mu g_mu, where the first matrix is in D and the second in D-4 dimensions*)
dr[b___,DiracGamma[LorentzIndex[c_,di_],di_],
        DiracGamma[LorentzIndex[c_,di_ -4],di_ -4],d___]:=(di-4) ds[ b,d ];

(*g^mu g_mu, where the first matrix is in 4 and the second in D-4 dimensions*)
dr[b___,DiracGamma[LorentzIndex[c_]],
        DiracGamma[LorentzIndex[c_,di_ -4],di_ -4],d___] := 0;

(*g^mu g_mu, where the first matrix is in 4 and the second in D dimensions*)
dr[b___,DiracGamma[LorentzIndex[c_]],
        DiracGamma[LorentzIndex[c_,di_ ],di_ ],d___] := 4 ds[ b,d ];



fdim[]=4;    (* fdimdef *)
fdim[dimi_]:=dimi;
dcheck[dii_, diii__] := dimcheck[dii, diii] =
If[Head[dii]===Symbol, True, If[Union[{dii, diii}]==={dii}, True, False]];

(*g^mu g^nu g_mu for arbitrary dimensions*)
dr[b___,DiracGamma[LorentzIndex[c_,dI___],dI___],
        DiracGamma[x_[y__],di1___],
        DiracGamma[LorentzIndex[c_,dI___],dI___],d___
  ] := ( (2-fdim[dI]) ds[b,DiracGamma[x[y],di1],d] ) /; dcheck[dI, di1];

(*g^mu g^nu g^rho g_mu for arbitrary dimensions*)
dr[b___,DiracGamma[LorentzIndex[c_,dI___],dI___],
        DiracGamma[x1_[y1__],d1___], DiracGamma[x2_[y2__],d2___],
        DiracGamma[LorentzIndex[c_,dI___],dI___],d___
  ] := ((4 PairContract[x1[y1],x2[y2]] ds[b,d] +
         (fdim[dI]-4) ds[b,DiracGamma[x1[y1],d1], DiracGamma[x2[y2],d2], d]
        ) /. PairContract -> Pair
       ) /; dcheck[dI, d1, d2];

(*g^mu g^nu g^rho g^sigma g_mu for arbitrary dimensions*)
dr[b___,DiracGamma[LorentzIndex[c_,dI___],dI___],
        DiracGamma[x1_[y1__],d1___], DiracGamma[x2_[y2__],d2___],
        DiracGamma[x3_[y3__],d3___],
        DiracGamma[LorentzIndex[c_,dI___],dI___],d___
  ] := (-2 ds[b,DiracGamma[x3[y3],d3], DiracGamma[x2[y2],d2],
                DiracGamma[x1[y1],d1],
            d] -
        (fdim[dI]-4) ds[b,DiracGamma[x1[y1],d1],
                          DiracGamma[x2[y2],d2],
                          DiracGamma[x3[y3],d3],
                      d]
       ) /; dcheck[dI, d1,d2,d3];

(*g^mu g^nu g^rho g^sigma g^tau g_mu for arbitrary dimensions*)
dr[b___,DiracGamma[LorentzIndex[c_,dI___],dI___],
        DiracGamma[x1_[y1__],d1___], DiracGamma[x2_[y2__],d2___],
        DiracGamma[x3_[y3__],d3___], DiracGamma[x4_[y4__],d4___],
        DiracGamma[LorentzIndex[c_,dI___],dI___],d___
   ] := ( 2 ds[b,DiracGamma[x3[y3],d3], DiracGamma[x2[y2],d2],
                   DiracGamma[x1[y1],d1], DiracGamma[x4[y4],d4],
                 d] +
            2 ds[b,DiracGamma[x4[y4],d4], DiracGamma[x1[y1],d1],
                   DiracGamma[x2[y2],d2], DiracGamma[x3[y3],d3],
                 d] +
       (fdim[dI]-4) ds[b,DiracGamma[x1[y1],d1], DiracGamma[x2[y2],d2],
                         DiracGamma[x3[y3],d3], DiracGamma[x4[y4],d4],
                     d]
         ) /; dcheck[dI, d1,d2,d3,d4];

(*g^mu g^nu g^rho g^sigma g^tau g^kappa g_mu for arbitrary dimensions*)
dr[b___,DiracGamma[LorentzIndex[c_,dI___],dI___],
        DiracGamma[x1_[y1__],d1___], DiracGamma[x2_[y2__],d2___],
        DiracGamma[x3_[y3__],d3___], DiracGamma[x4_[y4__],d4___],
        DiracGamma[x5_[y5__],d5___],
        DiracGamma[LorentzIndex[c_,dI___],dI___],d___
  ] := ( 2 ds[b,DiracGamma[x2[y2],d2], DiracGamma[x3[y3],d3],
                DiracGamma[x4[y4],d4], DiracGamma[x5[y5],d5],
                DiracGamma[x1[y1],d1],
            d] -
         2 ds[b,DiracGamma[x1[y1],d1], DiracGamma[x4[y4],d4],
                DiracGamma[x3[y3],d3], DiracGamma[x2[y2],d2],
                DiracGamma[x5[y5],d5],
            d] -
         2 ds[b,DiracGamma[x1[y1],d1], DiracGamma[x5[y5],d5],
                DiracGamma[x2[y2],d2], DiracGamma[x3[y3],d3],
                DiracGamma[x4[y4],d4],
            d] -
      (fdim[dI]-4) ds[b,DiracGamma[x1[y1],d1], DiracGamma[x2[y2],d2],
                        DiracGamma[x3[y3],d3], DiracGamma[x4[y4],d4],
                        DiracGamma[x5[y5],d5],
                    d] ) /; dcheck[dI, d1,d2,d3,d4,d5];

(* Slash(p)*Slash(p), where p in the first slash is in D1 and in the second one in D2 dimensions.
   The dimensions of the gammas (no g^5 here!) doesn't matter  *)
dr[b___,DiracGamma[Momentum[c_,dim1___],___],
        DiracGamma[Momentum[c_,dim2___],___],d___ ] :=
        scev[Momentum[c,dim1],Momentum[c,dim2]] ds[b,d];

(* Slash(p)*[odd # of gammas (no g^5 here!)]*Slash(p), everything is in 4 dimensions  *)
dr[ b___,DiracGamma[LorentzIndex[c_]],d:DiracGamma[_[_]].. ,
         DiracGamma[LorentzIndex[c_]],f___ ] :=
    -2 ds @@ Join[ {b},Reverse[{d}],{f} ] /; OddQ[Length[{d}]];

(*Slash(p) Slash(k) Slash(p), where gamma (no g^5 here!) in the first slash is in D1 dimensions, in the second one D2 dimensions and in the third one
in D3 dimensions. The momentum vectors are all in 4 dimensions*)
dr[ b___,DiracGamma[Momentum[c__],dim___],
         DiracGamma[Momentum[x__],dii___],
         DiracGamma[Momentum[c__],di___],d___ ] := (
2 scev[Momentum[c],Momentum[x]] ds[b,DiracGamma[Momentum[c],dim],d]
- scev[Momentum[c],Momentum[c]] ds[b,DiracGamma[Momentum[x],dii],d]
                                                  );


(* #################################################################### *)
(*                             Main33                                 *)
(* #################################################################### *)

(* If we have a mixed expression with gamma and SU(N) matrices, factor the SU(N) matrices out *)
   dr[ a___,b_,c:SUNT[i_].. ,d___] :=
     dr[ a, c, b, d ] /; FreeQ2[b, {SUNT}];

   HoldPattern[dr[ a___,b_ dr[c:(SUNT[_])..], d___]]:=
     ( dr[c] dr[a, b, d] )/;FreeQ[{a, b, d}, SUNT];

   dr[ SUNT[i_], b___ ] := (SUNT[i] ds[b]) /; FreeQ[{b}, SUNT];

   dr[ b__, SUNT[i_] ] := (SUNT[i] ds[b]) /; FreeQ[{b}, SUNT];

   dr[ a__, b:SUNT[_].. ]:=(ds[b] ds[a])/; FreeQ[{a}, SUNT];

   dr[ b:SUNT[_].., a__ ]:=(ds[b] ds[a])/; FreeQ[{a}, SUNT];



(* #################################################################### *)
(*                             Main33a                                 *)
(* #################################################################### *)

(*Properties of the charge conjugation matrix for spinors. *)

   dr[ a___, ChargeConjugationMatrix, ChargeConjugationMatrix, b___ ] :=
     -dr[a, b];
   dr[ a___, ChargeConjugationMatrix, DiracGamma[5], b___ ] :=
     dr[a, DiracGammaT[5], ChargeConjugationMatrix, b];
   dr[ a___, ChargeConjugationMatrix, DiracGamma[6], b___ ] :=
     dr[a, DiracGammaT[6], ChargeConjugationMatrix, b];
   dr[ a___, ChargeConjugationMatrix, DiracGamma[7], b___ ] :=
     dr[a, DiracGammaT[7], ChargeConjugationMatrix, b];

   dr[ a___, ChargeConjugationMatrix, DiracGamma[x_], b___ ] :=
     -dr[a, DiracGammaT[x], ChargeConjugationMatrix, b] /; !NumberQ[x];

   dr[ a___, ChargeConjugationMatrix, DiracGammaT[x_], b___ ] :=
     -dr[a, DiracGamma[x], ChargeConjugationMatrix, b] /; !NumberQ[x];


(* #################################################################### *)
(*                             Main34                                 *)
(* #################################################################### *)

   drCOs[x___] := FeynCalc`MemSet[ drCOs[x], drCO[x] ];    (*drCOsdef*)
(* Dirac contraction rules *) (*drCOdef*)

(*g^mu g^i1 .... g^in g_mu, where all matrices are in D-4 dimensions*)
   drCO[ b___,DiracGamma[LorentzIndex[c_,di_Symbol-4],di_Symbol-4],
         d:DiracGamma[_[_,di_Symbol-4], di_Symbol-4].. ,
         DiracGamma[LorentzIndex[c_,di_Symbol-4],di_Symbol-4],f___
       ]:= (drCO @@  ( { b, DiracGamma[LorentzIndex[c,di-4], di-4],
                         d, DiracGamma[LorentzIndex[c,di-4], di-4],
                         f } /. di -> (di + 4)
                     )) /. di -> (di-4);
(*g^mu ... g^nu g_mu, where g^mu and g_mu are in D-4 dimensions and g^nu is in D dimensions*)
   drCO[ b___,DiracGamma[lv_[c_,di_Symbol-4],di_Symbol-4], w___,
              DiracGamma[ww_[y__],dim___],
              DiracGamma[lv_[c_,di_Symbol-4],di_Symbol-4], z___] :=
   (Print["rdCOCheck"];
         -drCO[ b, DiracGamma[lv[c,di-4],di-4],w,
             DiracGamma[lv[c,di-4],di-4],
             DiracGamma[ww[y],dim],z
        ] + 2 drCO[b, DiracGamma[ww[y],di-4], w,z] )/.drCO->ds;

(*g^mu g^i1 ... g^in g^nu g_mu, where all the matrices (no g^5 here!) are in D dimensions and n is odd*)
   drCO[ b___,DiracGamma[LorentzIndex[c_]],d:DiracGamma[_[__]].. ,
         DiracGamma[x_[y__]],DiracGamma[LorentzIndex[c_]],f___ ] :=
       ( 2 ds @@ Join[ {b},Reverse[{d}],{DiracGamma[x[y]],f} ] +
         2 ds[ b,DiracGamma[x[y]],d,f ]
        ) /; OddQ[Length[{d}]];

(*g^mu g^i1 ... g^in g_mu, where g^mu is in D1 dimensions, g_mu in D3 dimensions and g^ii (no g^5 here!) are in thearbitrary dimensions*)
   drCO[ b___,DiracGamma[c_, di___],d:DiracGamma[_[__],___].. ,
         DiracGamma[c_,dim___],f___
       ] :=
        Block[ {drCOij, drCOld = Length[{d}]},
     (-1)^drCOld scev[c,c] ds[b,d,f]
     + 2 Sum[(-1)^(drCOij+1) coneins[ Pair[c,{d}[[drCOij,1]] ]
            * ds@@Join[{b},Drop[{d},{drCOij,drCOij}],{DiracGamma[c,dim],f}]
                                    ],{drCOij,1,drCOld}
            ]
              ]/;((Length[{d}]>0)&&FreeQ[c,LorentzIndex]&&
                 (!NumberQ[c]) && !MatchQ[{di}, {_Symbol -4}]);


(* #################################################################### *)
(*                             Main35                                 *)
(* #################################################################### *)

(*g^mu g^i1 ... g^in g_mu, where g^mu and g_mu are in D1 dimensions, while g^ii (no g^5 here!) are in D2 dimensions*)
   drCO[ b___,DiracGamma[LorentzIndex[c_,di_Symbol],di_Symbol],
         d:DiracGamma[_[_,dim___],dim___].. ,
         DiracGamma[LorentzIndex[c_,di_Symbol],di_Symbol],f___
       ]:=
   Block[{idrCO,jdrCO,lddrCO = Length[{d}]},
        (-1)^lddrCO ( di - 2 lddrCO ) ds[b,d,f] -
          4 (-1)^lddrCO  Sum[ (-1)^(jdrCO-idrCO) *
         coneins[ Pair[{d}[[idrCO,1]],{d}[[jdrCO,1]] ] *
                  ds@@Join[ {b},Drop[ Drop[{d},{idrCO,idrCO}],
                                     {jdrCO-1,jdrCO-1}
                                    ],{f}
                          ]
                ],
                       {idrCO,1,lddrCO-1},{jdrCO,idrCO+1,lddrCO}
                            ]/.Pair->scev
         ] /;(Length[{d}]>5);

(*g^mu g^nu ...  g_mu where g^mu is in D1 dimensions, g_mu is in D3 dimensions and g^nu is in D2 dimensions*)
   drCO[ b___,DiracGamma[lv_[c_,dim___],dim___],
              DiracGamma[vl_[x__],dii___],d___,
              DiracGamma[lv_[c_,di___],di___],f___
       ]:=(-ds[b, DiracGamma[vl[x],dii],
                  DiracTrick[DiracGamma[lv[c,dim],dim],d,
                     DiracGamma[lv[c,di],di]], f
                ] + 2 coneins[Pair[vl[x], lv[c,dim]] *
                              ds[ b,d,DiracGamma[lv[c,di],di],f ]
                             ]
           ) /; {dim} =!= {di};



(* ************************************************************** *)
 SetAttributes[drS, Flat];
(* ************************************************************** *)
 SetAttributes[dr, Flat];   (* quite important!!! *)
(* ************************************************************** *)

End[];

If[$VeryVerbose > 0,WriteString["stdout", "DiracTrick | \n "]];
Null
