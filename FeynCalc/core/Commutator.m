(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`Commutator`",{"HighEnergyPhysics`FeynCalc`"}];

Commutator::"usage"=
"Commutator[x, y] = c  defines the commutator between the non-commuting \
objects x and y.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

MakeContext[DataType, NonCommutative];

Commutator /: Set[Commutator[a_, b_] , c_] := Block[{nd, com},
                   nd = (RuleDelayed @@ {HoldPattern @@ {com[a, b]}, c}
                        ) /. com -> Commutator ;
                If[FreeQ[DownValues[Commutator], nd],
                   PrependTo[DownValues[Commutator], nd]
                  ];
                  c];


Commutator/: MakeBoxes[Commutator[a_, b_],
             TraditionalForm
            ] := RowBox[ {"[","\[NoBreak]", FeynCalc`Tbox[a] ,"\[NoBreak]", ",",
                          FeynCalc`Tbox[b], "\[NoBreak]", "]"}];

End[];


If[$VeryVerbose > 0,WriteString["stdout", "Commutator | \n "]];
Null
