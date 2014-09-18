(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* :Summary: *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`GSD`",{"HighEnergyPhysics`FeynCalc`"}];

GSD::"usage"=
"GSD[p] is transformed into DiracSlash[p,Dimension->D] by FeynCalcInternal.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

MakeContext["DeclareNonCommutative"][GSD];

GSD[DOT[x_,y__]] := Map[GSD, DOT[x,y]];
GSD[x_, y__] := DOT @@ Map[GSD, {x, y}];

GSD/:
  MakeBoxes[ GSD[a_/;FreeQ[a,Plus]],
             TraditionalForm ] := FeynCalc`Tbox["\[Gamma]", "\[CenterDot]", a];
GSD/:
  MakeBoxes[ GSD[a_/;!FreeQ[a,Plus]],
             TraditionalForm ] :=
  FeynCalc`Tbox["\[Gamma]", "\[CenterDot]", "(",a,")"];

gsg[a_]:=If[FreeQ[y, Plus], FeynCalc`Tbox["\[Gamma]", a],
                            FeynCalc`Tbox["\[Gamma]", "(",a,")"]
           ];

GSD/:
  MakeBoxes[ GSD[a_, b__],
             TraditionalForm
           ] := FeynCalc`Tbox@@Map[gsg, {a,b}]

End[];

If[$VeryVerbose > 0,WriteString["stdout", "GSD | \n "]];
Null
