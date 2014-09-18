(* :Summary: *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`SUNT`",{"HighEnergyPhysics`FeynCalc`"}];


SUNT::"usage"=
"SUNT[a] is the SU(N) T_a generator in
the fundamental representation."

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

fci := fci = MakeContext["FeynCalcInternal"];
MakeContext["DeclareNonCommutative"][SUNT];

SUNT /:
  MakeBoxes[ SUNT[a_], TraditionalForm] :=
    SubscripFeynCalc`Tbox["T", ToBoxes[a, TraditionalForm]];

SUNT /:
  MakeBoxes[
            SUNT[a_,b__], TraditionalForm
           ] := RowBox[ Map[SubscripFeynCalc`Tbox["T",
               ToBoxes[#, TraditionalForm]]&, {a, b}] ];

End[];

If[$VeryVerbose > 0,WriteString["stdout", "SUNT | \n "]];
Null
