(* ------------------------------------------------------------------------ *)

Commutator::"usage"=
"Commutator[x, y] = c  defines the commutator between the non-commuting \
objects x and y.";

(* ------------------------------------------------------------------------ *)

Begin["`Commutator`Private`"];

Commutator /: Set[Commutator[a_, b_] , c_] := Block[{nd, com},
                   nd = (RuleDelayed @@ {HoldPattern @@ {com[a, b]}, c}
                        ) /. com -> Commutator ;
                If[FreeQ[DownValues[Commutator], nd],
                   PrependTo[DownValues[Commutator], nd]
                  ];
                  c];


Commutator/: MakeBoxes[Commutator[a_, b_],
             TraditionalForm
            ] := RowBox[ {"[","\[NoBreak]", FeynCalc`FeynCalc`Tbox[a] ,"\[NoBreak]", ",",
                          FeynCalc`FeynCalc`Tbox[b], "\[NoBreak]", "]"}];

End[];
