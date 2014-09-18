

(* :Title: A0ToB0 *)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)
(* :History: created 4 March '97 at 14:34 *)
(* ------------------------------------------------------------------------ *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`fctables`A0ToB0`",
             {"HighEnergyPhysics`FeynCalc`"}];

A0ToB0::"usage" =
"A0ToB0 is an option for A0. If set to True, A0[m^2] is expressed
by (1+ B0[0,m^2,m^2])*m^2.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

End[];
EndPackage[];

If[$VeryVerbose > 0,WriteString["stdout", "A0ToB0 | \n "]];
Null
