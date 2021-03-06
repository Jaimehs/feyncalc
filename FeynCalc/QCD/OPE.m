(* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *)

(* :Title: OPEi*)

(* :Author: Rolf Mertig *)

(* ------------------------------------------------------------------------ *)
(* :History: File created on 22 June '97 at 23:00 *)
(* ------------------------------------------------------------------------ *)

(* :Summary:  the m *)

(* ------------------------------------------------------------------------ *)

OPEi::usage= "OPEi is a dummy index in OPESum.";
OPEj::usage= "OPEj is a dummy index in OPESum.";
OPEk::usage= "OPEk is a dummy index in OPESum.";
OPEl::usage= "OPEl is a dummy index in OPESum.";
OPEm::usage= "OPEm is a dummy index in OPESum.";
OPEn::usage= "OPEn is a dummy index in OPESum.";
OPEo::usage= "OPEo is a dummy index in OPESum.";
OPEDelta::usage= "OPEDelta is the Delta.";

(* ------------------------------------------------------------------------ *)

Begin["`OPE`Package`"]
End[]

Begin["`OPE`Private`"]

DataType[OPEi, PositiveInteger] = True;
DataType[OPEj, PositiveInteger] = True;
DataType[OPEk, PositiveInteger] = True;
DataType[OPEl, PositiveInteger] = True;
DataType[OPEm, PositiveInteger] = True;
DataType[OPEn, PositiveInteger] = True;
DataType[OPEo, PositiveInteger] = True;

ScalarProduct[OPEDelta, OPEDelta, ___Rule] = 0;
Pair[Momentum[OPEDelta,___], Momentum[OPEDelta,___]] = 0;

(* that is only for Partial* stuff *)
LorentzIndex[Momentum[OPEDelta]^p_.] := Momentum[OPEDelta]^p;

(* :Summary:  the variable selecting out the ope-insertions *)
OPEDelta/:
	MakeBoxes[OPEDelta, TraditionalForm] := "\[CapitalDelta]";

OPEi /:
	MakeBoxes[OPEi ,TraditionalForm] :=
		"i";

OPEj /:
	MakeBoxes[OPEj ,TraditionalForm] :=
		"j";

OPEk /:
	MakeBoxes[OPEk ,TraditionalForm] :=
		"k";

OPEl /:
	MakeBoxes[OPEl ,TraditionalForm] :=
		"l";

OPEm /:
	MakeBoxes[OPEm ,TraditionalForm] :=
		"m";

OPEn /:
	MakeBoxes[OPEn ,TraditionalForm] :=
		"n";
OPEo /:
	MakeBoxes[OPEo ,TraditionalForm] :=
		"o";

FCPrint[1,"OPE loaded."];
End[]


