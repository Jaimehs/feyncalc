

(* :Title: Select2 *)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)
(* :History: File created on 22 June '97 at 23:00 *)
(* ------------------------------------------------------------------------ *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`general`Select2`",{"HighEnergyPhysics`FeynCalc`"}];

Select2::"usage"=
"Select2[expr, a, b, ...] is equivalent to
Select[expr, !FreeQ2[#, {a,b, ...}]&], except the
special cases: Select2[a, b] returns 1 and 
Select2[a,a] returns a (where a is not a product or
a sum).";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];
   
FreeQ2 = MakeContext["FreeQ2"];

Select2[0,_] := 0;

Select2[a_, b__] := If[(Head[a] === Plus) ||
                       (Head[a] === Times) ||
                       (Head[a] === List),
                       select2[a,b],
                       select2[a duMmM1 duMmM2, b] /. 
                            {duMmM1 :> 1, duMmM2 :> 1}
                      ];

select2[x_, b_ /; Head[b] =!= List
                   ]  := Select[x, !FreeQ[#, b]&];
select2[x_, b_List ]  := Select[x, !FreeQ2[#, b]&];
select2[x_, b_, c__]  := Select[x, !FreeQ2[#, Flatten[{b, c}]]&];

End[];


If[$VeryVerbose > 0,WriteString["stdout", "Select2 | \n "]];
Null
