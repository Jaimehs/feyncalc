(* :Title: Dirac.mt															*)

(*
	This software is covered by the GNU Lesser General Public License 3.
	Copyright (C) 1990-2015 Rolf Mertig
	Copyright (C) 1997-2015 Frederik Orellana
	Copyright (C) 2014-2015 Vladyslav Shtabovenko
*)

(* :Summary:  Unit tests for functions in the "Dirac" directory				*)

(* ------------------------------------------------------------------------ *)

Needs["FeynCalc`"];

ClearAll[tests];
tests = FileNames["*.test",FileNameJoin[{ParentDirectory@$FeynCalcDirectory, "Tests", "Dirac"}]]
Get/@tests;

stingCompare[a_,b_]:=If[ToString[a]===ToString[b],True,False];

$BreitMaison = False;
Map[Test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],TestID->#[[1]]]&,
	Join@@(ToExpression/@Names["Tests`Dirac`fcstAnti5*"])];
$BreitMaison = False;

Map[Test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],TestID->#[[1]]]&,
	Join@@(ToExpression/@Names["Tests`Dirac`fcstChisholm*"])];

Map[Test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],TestID->#[[1]]]&,
	Join@@(ToExpression/@Names["Tests`Dirac`fcstDiracOrder*"])];

Map[Test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],TestID->#[[1]]]&,
	Join@@(ToExpression/@Names["Tests`Dirac`fcstDiracReduce*"])];

Map[Test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],TestID->#[[1]]]&,
		Join[Tests`Dirac`fcstDiracSimplify]];

Map[Test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],(#[[4]]),TestID->#[[1]],
		MessagesEquivalenceFunction->stingCompare]&,
		Join[Tests`Dirac`fcstDiracSimplifyDotWarnings]];


$BreitMaison=False;

Map[Test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],TestID->#[[1]]]&,
	Join@@(ToExpression/@Names["Tests`Dirac`fcstDiracTrick*"])];

$BreitMaison=False;
$Larin=False;
$West=False;

Map[Test[ToExpression[(#[[2]])],ToExpression[(#[[3]])],TestID->#[[1]]]&,
		Join[	Tests`Dirac`fcstTr,
				Tests`Dirac`fcstTrAllFreeNoGamma5,
				Tests`Dirac`fcstTrAllFreeOneGamma5NDR]];
