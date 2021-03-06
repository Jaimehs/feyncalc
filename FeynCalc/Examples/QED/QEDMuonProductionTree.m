(* ::Package:: *)



(* :Title: QEDMuonProductionTree                                            *)

(*
	 This software is covered by the GNU Lesser General Public License 3.
	 Copyright (C) 1990-2015 Rolf Mertig
	 Copyright (C) 1997-2015 Frederik Orellana
	 Copyright (C) 2014-2015 Vladyslav Shtabovenko
*)

(* :Summary:  Computation of the matrix element squared for muon
							production in QED at tree level                               *)

(* ------------------------------------------------------------------------ *)



(* ::Section:: *)
(*Load FeynCalc, FeynArts and PHI*)


If[ $FrontEnd === Null,
		$FeynCalcStartupMessages = False;
		Print["Computation of the matrix element squared for muon production in QED at tree level"];
];
If[$Notebooks === False, $FeynCalcStartupMessages = False];
$LoadTARCER = False;
$LoadPhi =$LoadFeynArts= True;
<<FeynCalc`
$FAVerbose = 0;


(* ::Section:: *)
(*Generate Feynman diagrams*)


topMuonProd = CreateTopologies[0, 2 -> 2];
diagsMuonProd =
		InsertFields[topMuonProd, {F[2, {1}], -F[2, {1}]} -> {F[2,
		{2}], -F[2, {2}]}, InsertionLevel -> {Classes}, Model -> "SM",
		ExcludeParticles -> {S[1], S[2], V[2]}];
Paint[diagsMuonProd, ColumnsXRows -> {1, 1}, Numbering -> None];


(* ::Section:: *)
(*Obtain corresponding amplitudes*)


ampMuonProd = Map[ReplaceAll[#, FeynAmp[_, _, amp_, ___] :> amp] &,
		Apply[List, FCPrepareFAAmp[CreateFeynAmp[diagsMuonProd,
		Truncated -> False],UndoChiralSplittings->True]]]/.{FAMass["Muon"]->MMu,
		InMom1->p1, InMom2->p2,OutMom1->k1,OutMom2->k2}


(* ::Section:: *)
(*Unpolarized process  e^- e^+ -> mu^- mu^+ *)


SetMandelstam[s, t, u, p1, p2, -k1, -k2, ME, ME, MMu, MMu];
sqAmpMuonProd = (Total[ampMuonProd] Total[(ComplexConjugate[ampMuonProd]//FCRenameDummyIndices)])//
		PropagatorDenominatorExplicit//Contract//FermionSpinSum[#, ExtraFactor -> 1/2^2]&//
		ReplaceAll[#, DiracTrace :> Tr] &//Contract//Simplify


masslessElectronsSqAmpMuonProd = (sqAmpMuonProd /. {ME -> 0})//Simplify


masslessElectronsMuonsSqAmpMuonProdPeskin = (8EL^4 (SP[p1,k1]SP[p2,k2]+SP[p1,k2]SP[p2,k1]+MMu^2 SP[p1,p2]))/(SP[p1+p2])^2//
		ReplaceAll[#,ME->0]&//ExpandScalarProduct//Simplify;
Print["Check with Peskin and Schroeder, Eq 5.10: ",
		If[(masslessElectronsMuonsSqAmpMuonProdPeskin-masslessElectronsSqAmpMuonProd)===0,
		"Correct.", "Mistake!"]];


masslessElectronsMuonsSqAmpMuonProd = (masslessElectronsSqAmpMuonProd /. {MMu -> 0})//Simplify


masslessElectronsMuonsSqAmpMuonProdPeskinMandelstam=((8EL^4/s^2)((t/2)^2+(u/2)^2))//Simplify;
Print["Check with Peskin and Schroeder, Eq 5.70: ",
			If[(masslessElectronsMuonsSqAmpMuonProdPeskinMandelstam-masslessElectronsMuonsSqAmpMuonProd)===0, "Correct.", "Mistake!"]];


(* ::Section:: *)
(*Polarized process e_R^- e_L^+ -> mu_R^- mu_L^+ *)


ampMuonProdElRPosLMuRAntiMuL=ampMuonProd/.{Spinor[-Momentum[k2],MMu,1]->GA[6].Spinor[-Momentum[k2],MMu,1],
		Spinor[Momentum[p1],ME,1]->GA[6].Spinor[Momentum[p1],ME,1]}


sqAmpMuonProdElRPosLMuRAntiMuL = ((((Total[ampMuonProdElRPosLMuRAntiMuL] Total[ComplexConjugate[ampMuonProdElRPosLMuRAntiMuL]//
		FCRenameDummyIndices]))//PropagatorDenominatorExplicit//Contract//FermionSpinSum[#,
		SpinorCollect -> True]&//ReplaceAll[#, DiracTrace :> Tr] &//Contract)/.{ME->0,MMu->0})//Simplify


sqAmpMuonProdElRPosLMuRAntiMuLPeskin=(16EL^4 (SP[p1,k2]SP[p2,k1]))/(SP[p1+p2])^2//
		ReplaceAll[#,{ME->0,MMu->0}]&//FCI//ExpandScalarProduct//Simplify;
Print["Check with Peskin and Schroeder, Eq 5.21: ",
			If[(sqAmpMuonProdElRPosLMuRAntiMuLPeskin-sqAmpMuonProdElRPosLMuRAntiMuL)===0, "Correct.", "Mistake!"]];
