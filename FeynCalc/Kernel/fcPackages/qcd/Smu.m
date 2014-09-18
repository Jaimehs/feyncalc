

(* :Title: Smu*)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)
(* :History: File created on 22 June '97 at 23:00 *)
(* ------------------------------------------------------------------------ *)

(* :Summary:  the s_n for  OPEInt*)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`qcd`Smu`",{"HighEnergyPhysics`FeynCalc`"}];

Smu::"usage"= "Smu  is ...";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];
   

Smu/: MakeBoxes[Smu,TraditionalForm]:= SubscripFeynCalc`Tbox["S", "\[Mu]"];

End[];

If[$VeryVerbose > 0,WriteString["stdout", "Smu | \n "]];
Null
