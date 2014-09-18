(* ************************************************************** *)
(*                                                                *)
(*                      FCBoxes.m                                 *)
(*                                                                *)
(* ************************************************************** *)

(* 
   Author:              F.Orellana 2000

   Mathematica Version: 3.0 

   Requirements:        FeynCalc > 3, PHI 

   Description:         The definitions in this file modifies the
                        way QuantumFields are displayed, so that
                        outputs of calculations with PHI look nicer.  
   
*)

(* ************************************************************** *)

(* Box definitions for FeynCalc *)

ClearAll[HighEnergyPhysics`FeynCalc`QuantumField`QuantumField];

BeginPackage["HighEnergyPhysics`FeynCalc`QuantumField`",
             {"HighEnergyPhysics`FeynCalc`"}];

Begin["`Private`"];

MakeContext[ExplicitSUNIndex];

QuantumField /: 
MakeBoxes[ QuantumField[a_][_], TraditionalForm
            ] := FeynCalc`Tbox[a](*[[1]]*);

QuantumField /: 
MakeBoxes[ QuantumField[f_, lo_[mu_,___]][_], TraditionalForm
            ] := SubscripFeynCalc`Tbox[FeynCalc`Tbox[f](*[[1]]*), FeynCalc`Tbox[mu]] /; 
                   lo === LorentzIndex ||
                   lo === HighEnergyPhysics`Phi`Objects`UIndex;

QuantumField /: 
   MakeBoxes[ QuantumField[f_, lori:lo_[_,___].., suni:sun_[_]..
                          ][_], TraditionalForm
            ] := 
SubSuperscriptBox[FeynCalc`Tbox[f](*[[1]]*), FeynCalc`Tbox[lori], FeynCalc`Tbox[suni]]/; 
           MatchQ[lo, LorentzIndex | Momentum | HighEnergyPhysics`Phi`Objects`UIndex] && 
                  (sun === SUNIndex || sun === ExplicitSUNIndex);

QuantumField /: 
   MakeBoxes[ QuantumField[
    HighEnergyPhysics`FeynCalc`PartialD`PartialD[pa_], a_,
 lori___HighEnergyPhysics`FeynCalc`LorentzIndex`LorentzIndex |
 lori___HighEnergyPhysics`Phi`Objects`UIndex,
 suni___HighEnergyPhysics`FeynCalc`SUNIndex`SUNIndex |
 suni___HighEnergyPhysics`FeynCalc`ExplicitSUNIndex`ExplicitSUNIndex
                          ][_],
              TraditionalForm] :=
RowBox[{SubscripFeynCalc`Tbox["\[PartialD]" , FeynCalc`Tbox[pa]],
SubSuperscriptBox[FeynCalc`Tbox[a](*[[1]]*), FeynCalc`Tbox[lori], FeynCalc`Tbox[suni]]
                        }];

QuantumField /: 
   MakeBoxes[ QuantumField[
    HighEnergyPhysics`FeynCalc`PartialD`PartialD[pa_]^m_, a_,
 (*lori___HighEnergyPhysics`FeynCalc`Momentum`Momentum,*)
 lori___HighEnergyPhysics`FeynCalc`LorentzIndex`LorentzIndex |
 lori___HighEnergyPhysics`Phi`Objects`UIndex,
 suni___HighEnergyPhysics`FeynCalc`SUNIndex`SUNIndex |
 suni___HighEnergyPhysics`FeynCalc`ExplicitSUNIndex`ExplicitSUNIndex
                          ][_],
              TraditionalForm] :=
              RowBox[{SuperscriptBox[FeynCalc`Tbox[PartialD[pa]],FeynCalc`Tbox[m]],
SubSuperscriptBox[FeynCalc`Tbox[a](*[[1]]*), FeynCalc`Tbox[lori], FeynCalc`Tbox[suni]]
                      }];

QuantumField /: 
   MakeBoxes[ QuantumField[
    pa__HighEnergyPhysics`FeynCalc`PartialD`PartialD, a_,
 (*lori___HighEnergyPhysics`FeynCalc`Momentum`Momentum,*)
 lori___HighEnergyPhysics`FeynCalc`LorentzIndex`LorentzIndex |
 lori___HighEnergyPhysics`Phi`Objects`UIndex,
 suni___HighEnergyPhysics`FeynCalc`SUNIndex`SUNIndex |
 suni___HighEnergyPhysics`FeynCalc`ExplicitSUNIndex`ExplicitSUNIndex
                          ][_],
              TraditionalForm
            ] := RowBox[{FeynCalc`Tbox[pa],
SubSuperscriptBox[FeynCalc`Tbox[a](*[[1]]*), FeynCalc`Tbox[lori], FeynCalc`Tbox[suni]]
                        }];

(*----------------------------------------------------------------*)

QuantumField /: 
   MakeBoxes[ QuantumField[f_,suni:sun_[_]..
                          ][_], TraditionalForm] := 
      SuperscriptBox[FeynCalc`Tbox[f](*[[1]]*),FeynCalc`Tbox[suni]] /;
      (sun === SUNIndex || sun === ExplicitSUNIndex);
      
QuantumField /: 
   MakeBoxes[ QuantumField[f_,suni:sun_[_]..
                          ], TraditionalForm
            ] := SuperscriptBox[FeynCalc`Tbox[f](*[[1]]*),FeynCalc`Tbox[suni]
                                  ] /;
       (sun === SUNIndex || sun === ExplicitSUNIndex);

(*----------------------------------------------------------------*)

(* Modified original FeynCalc definitions*)

QuantumField[f___,g_/;Head[g]=!=List,{lilo___}] :=
 QuantumField@@Join[{f,g},LorentzIndex/@{lilo}];

QuantumField[f___,g_/;Head[g]=!=List,{lilo___},{suli___}] :=
 QuantumField@@Join[{f,g},LorentzIndex/@{lilo},SUNIndex/@{suli}];

QuantumField[f___,g_/;Head[g]=!=List,{lilo___},{suli___}, {ui___}] :=
 QuantumField@@Join[{f,g},LorentzIndex/@{lilo},SUNIndex/@{suli},
                          HighEnergyPhysics`Phi`Objects`UIndex/@{ui}];

QuantumField[f1_QuantumField] := f1;

  
QuantumField /: 
   MakeBoxes[ QuantumField[a_][_], TraditionalForm
            ] := FeynCalc`Tbox[a](*[[1]]*);

QuantumField /: 
   MakeBoxes[ QuantumField[a_], TraditionalForm
            ] := FeynCalc`Tbox[a](*[[1]]*);

QuantumField /: 
   MakeBoxes[ QuantumField[f_, lo_[mu_,___]], TraditionalForm
            ] := SubscripFeynCalc`Tbox[FeynCalc`Tbox[f](*[[1]]*), FeynCalc`Tbox[mu]] /; 
                   lo === LorentzIndex ||
                   lo === HighEnergyPhysics`Phi`Objects`UIndex;

QuantumField /:
    MakeBoxes[
      QuantumField[f_,
        lol : (((HighEnergyPhysics`FeynCalc`LorentzIndex`LorentzIndex|
                 HighEnergyPhysics`Phi`Objects`UIndex)[_, ___])..)],
        TraditionalForm] := SubscripFeynCalc`Tbox[FeynCalc`Tbox[f][[1(*, 1*)]], FeynCalc`Tbox[lol]];

QuantumField /: 
   MakeBoxes[ QuantumField[f_, lori:lo_[_,___].., suni:sun_[_]..
     ], TraditionalForm
 ] := SubSuperscriptBox[FeynCalc`Tbox[f](*[[1]]*), FeynCalc`Tbox[lori], FeynCalc`Tbox[suni]
        ] /; MatchQ[lo, LorentzIndex | Momentum | HighEnergyPhysics`Phi`Objects`UIndex
               ] && (sun === SUNIndex || sun === ExplicitSUNIndex);

QuantumField /: 
   MakeBoxes[ QuantumField[f_, lori:lo_[_,___].., suni:sun_[_]..
    ][_], TraditionalForm
 ] := SubSuperscriptBox[FeynCalc`Tbox[f](*[[1]]*), FeynCalc`Tbox[lori], FeynCalc`Tbox[suni]] /;
        MatchQ[lo, LorentzIndex | Momentum | HighEnergyPhysics`Phi`Objects`UIndex] && 
                    (sun === SUNIndex || sun === ExplicitSUNIndex);
QuantumField /: 
   MakeBoxes[ QuantumField[
    HighEnergyPhysics`FeynCalc`PartialD`PartialD[pa_], a_,
 lori___HighEnergyPhysics`FeynCalc`LorentzIndex`LorentzIndex |
 lori___HighEnergyPhysics`Phi`Objects`UIndex,
 suni___HighEnergyPhysics`FeynCalc`SUNIndex`SUNIndex |
 suni___HighEnergyPhysics`FeynCalc`ExplicitSUNIndex`ExplicitSUNIndex
                          ],
              TraditionalForm
       ] := RowBox[{SubscripFeynCalc`Tbox["\[PartialD]" , FeynCalc`Tbox[pa]],
        SubSuperscriptBox[FeynCalc`Tbox[a](*[[1]]*), FeynCalc`Tbox[lori], FeynCalc`Tbox[suni]]
                        }];

QuantumField /: 
   MakeBoxes[ QuantumField[
    HighEnergyPhysics`FeynCalc`PartialD`PartialD[pa_]^m_, a_,
 (*lori___HighEnergyPhysics`FeynCalc`Momentum`Momentum,*)
 lori___HighEnergyPhysics`FeynCalc`LorentzIndex`LorentzIndex |
 lori___HighEnergyPhysics`Phi`Objects`UIndex,
 suni___HighEnergyPhysics`FeynCalc`SUNIndex`SUNIndex |
 suni___HighEnergyPhysics`FeynCalc`ExplicitSUNIndex`ExplicitSUNIndex
                          ],
              TraditionalForm
  ] := RowBox[{SuperscriptBox[FeynCalc`Tbox[PartialD[pa]],FeynCalc`Tbox[m]],
    SubSuperscriptBox[FeynCalc`Tbox[a](*[[1]]*), FeynCalc`Tbox[lori], FeynCalc`Tbox[suni]]
                      }];

QuantumField /: 
   MakeBoxes[ QuantumField[
    pa__HighEnergyPhysics`FeynCalc`PartialD`PartialD, a_,
 (*lori___HighEnergyPhysics`FeynCalc`Momentum`Momentum,*)
 lori___HighEnergyPhysics`FeynCalc`LorentzIndex`LorentzIndex |
 lori___HighEnergyPhysics`Phi`Objects`UIndex,
 suni___HighEnergyPhysics`FeynCalc`SUNIndex`SUNIndex |
 suni___HighEnergyPhysics`FeynCalc`ExplicitSUNIndex`ExplicitSUNIndex
                          ],
              TraditionalForm
            ] := RowBox[{FeynCalc`Tbox[pa],
                 SubSuperscriptBox[FeynCalc`Tbox[a](*[[1]]*),
                 FeynCalc`Tbox[lori], FeynCalc`Tbox[suni]]
                        }];

(* ************************************************************** *)

End[];

(* ************************************************************** *)

(* Additional definitions from Objects.m *)

QuantumField[ders___PartialD,a__, lors___LorentzIndex,
      iis___SUNIndex|iis___ExplicitSUNIndex][
      isosp_SUNIndex|isosp_ExplicitSUNIndex]:=
  QuantumField[ders,a,lors,isosp,iis];

QuantumField[
ders___PartialD, a__, lors___LorentzIndex,
        iis___SUNIndex|iis___ExplicitSUNIndex][ui_UIndex] :=
    QuantumField[ders, a, lors, iis, ui];

HighEnergyPhysics`Phi`Objects`Private`setLeftRightComponents;

(* ************************************************************** *)
