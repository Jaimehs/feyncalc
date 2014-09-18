(* ------------------------------------------------------------------------ *)
(* ------------------------------------------------------------------------ *)

(* :Summary:  head for gauge-parameters *)

(* ------------------------------------------------------------------------ *)

BeginPackage["HighEnergyPhysics`FeynCalc`GaugeXi`",{"HighEnergyPhysics`FeynCalc`"}];

GaugeXi::"usage"= "GaugeXi is a head for gauge parameters.";

(* ------------------------------------------------------------------------ *)

Begin["`Private`"];

   GaugeXi /:
   MakeBoxes[GaugeXi[a_], TraditionalForm] :=
    SubscripFeynCalc`Tbox["\[Xi]", FeynCalc`Tbox[a]];
   GaugeXi /:
   MakeBoxes[GaugeXi, TraditionalForm] :=
    TagBox["\[Xi]", TraditionalForm]

End[];

If[$VeryVerbose > 0,WriteString["stdout", "GaugeXi | \n "]];
Null
