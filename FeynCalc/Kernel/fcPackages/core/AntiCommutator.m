
AntiCommutator::"usage" =
"AntiCommutator[x, y] = c  defines the anti-commutator of the \
non-commuting objects x and y. \
Settings of AntiCommutator (e.g.AntiCommutator[a,b]=c) \
are recognized by DotSimplify.";

(* ------------------------------------------------------------------------ *)

Begin["`AntiCommutator`Private`"];

AntiCommutator /: Set[AntiCommutator[a_, b_] , c_] := Block[ {nd, acom},
                                                          nd = (RuleDelayed @@ {HoldPattern @@ {acom[a, b]}, c}
                                                                ) /. acom -> AntiCommutator;
                                                          If[ FreeQ[DownValues[AntiCommutator], nd],
                                                              PrependTo[DownValues[AntiCommutator], nd]
                                                          ];
                                                          c
                                                      ];
  AntiCommutator /:
   MakeBoxes[
    AntiCommutator[a_, b_], TraditionalForm
            ] := FeynCalc`Tbox["{", a, ",", "\[MediumSpace]", b, "}"];

End[]; 