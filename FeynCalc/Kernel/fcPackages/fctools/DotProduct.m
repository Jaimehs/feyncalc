

(* :Title: DotProduct *)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)
(* :History: File created on 16 December '98 at 16:48 *)
(* ------------------------------------------------------------------------ *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`fctools`DotProduct`",{"HighEnergyPhysics`FeynCalc`"}];

DotProduct::"usage"=
"DotProduct[x, y] denotes the three-dimensional dot-product.
If x and y have Head List, DotProduct[x, a] (where a is a vector)
performs Sum[ x[[k]] a[[k]], {k, 0, 3}].";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];
   

MakeContext[CrossProduct, ThreeVector];

DotProduct[ThreeVector[b_], ThreeVector[a_]] := 
 DotProduct[ThreeVector[a], ThreeVector[b]] /;
   !OrderedQ[{b,a}];

DotProduct[x_List, {a1_ /; Head[a1] =!= List, 
                    a2_ /; Head[a2] =!= List, 
                    a3_ /; Head[a3] =!= List}
          ] := x[[1]] a1 + x[[2]] a2 + x[[3]] a3;

(* linearity *)
DotProduct[a_Plus, b_] := Map[DotProduct[#, b]&, a];
DotProduct[b_, a_Plus] := Map[DotProduct[b, #]&, a];
DotProduct[(n_/;NumberQ[n]) a_, b_] := n DotProduct[a, b];
DotProduct[b_, (n_/;NumberQ[n]) a_] := n DotProduct[b, a];
DotProduct[(n_DotProduct) a_, b_] := n DotProduct[a, b];
DotProduct[b_, (n_DotProduct) a_] := n DotProduct[b, a];

(* CrossProduct orders already its arguments *)
DotProduct[c_ThreeVector, CrossProduct[a_, b_]] := 
DotProduct[a, CrossProduct[b, c]] /; OrderedQ[{a,b,c}];

DotProduct[CrossProduct[a_, b_], c_ThreeVector] := 
DotProduct[c, CrossProduct[a, b]];

DotProduct[b_ThreeVector, CrossProduct[c_, a_]] := 
DotProduct[a, CrossProduct[b, c]] /; OrderedQ[{a,b,c}];

DotProduct /: MakeBoxes[DotProduct[a_,b_], TraditionalForm] :=
 FeynCalc`Tbox[a,"\[CenterDot]",b];

End[];


If[$VeryVerbose > 0,WriteString["stdout", "DotProduct | \n "]];
Null
