(* ::Package:: *)



(* :Title: EWMuonDecayTree                                                  *)

(*
	 This software is covered by the GNU Lesser General Public License 3.
	 Copyright (C) 1990-2015 Rolf Mertig
	 Copyright (C) 1997-2015 Frederik Orellana
	 Copyright (C) 2014-2015 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the matrix element squared for the decay
							of a muon into an electron, an electron anitnueutrino
				and a muon neutrino in Electroweak Theory at tree level.      *)

(* ------------------------------------------------------------------------ *)



(* ::Section:: *)
(*Load FeynCalc, FeynArts and PHI*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the matrix element squared for the decay of a muon into an electron, an electron anitnueutrino and a muon neutrino in Electroweak Theory at tree level."];
];
If[$Notebooks === False, $FeynCalcStartupMessages = False];
$LoadTARCER = False;
$LoadPhi =$LoadFeynArts= True;
<<FeynCalc`
$FAVerbose = 0;


(* ::Section:: *)
(*Generate Feynman diagrams*)


topMuonDecayTree = CreateTopologies[0, 1 -> 3];
diagsMuonDecayTree = InsertFields[topMuonDecayTree, {F[2, {2}]} -> {F[2,
		{1}],-F[1,{1}],F[1,{2}]}, InsertionLevel -> {Classes},
		Model -> "SM", ExcludeParticles -> {S[_], V[2]}];
Paint[diagsMuonDecayTree, ColumnsXRows -> {2, 1}, Numbering -> None];


(* ::Section:: *)
(*Obtain corresponding amplitudes*)


ampMuonDecayTree = (Map[ReplaceAll[#, FeynAmp[_, _, amp_, ___] :> amp] &,
		Apply[List, FCPrepareFAAmp[CreateFeynAmp[diagsMuonDecayTree,
		Truncated -> False]]]]//ChangeDimension[#,4]&)/.{InMom1->p,
		OutMom1->p1,OutMom2->p2,OutMom3->p3,FAMass["Muon"]->MMu}


(* ::Section:: *)
(*Unpolarized process  mu -> e^- nubar_e nu_mu*)


ScalarProduct[p1,p1]=ME;
ScalarProduct[p2,p2]=0;
ScalarProduct[p3,p3]=0;
sqAmpMuonDecayTree = Total[ampMuonDecayTree] (Total[ampMuonDecayTree]//ComplexConjugate//
		FCRenameDummyIndices)//PropagatorDenominatorExplicit//Contract//
		FermionSpinSum[#,ExtraFactor -> 1/2]&//ReplaceAll[#, DiracTrace :> Tr]&//Contract//Simplify


approxSqAmpMuonDecayTree = (sqAmpMuonDecayTree /. {ME -> 0,ScalarProduct[p1,p2]:>0,
		EL->Sqrt[8/Sqrt[2] GF MW^2SW^2]})//Simplify


approxSqAmpMuonDecayTreeKnown=64GF^2ScalarProduct[p,p2]ScalarProduct[p1,p3];
Print["Check with the literature: ",
			If[Simplify[approxSqAmpMuonDecayTree-approxSqAmpMuonDecayTreeKnown]===0, "Correct.", "Mistake!"]];

