Global`$TAKE = 9;
(* Mathematica Package *)
(* structure and comments copied from JLink` *)

(* Created by the Wolfram Workbench 18.09.2014 *)

BeginPackage["FeynCalc`"]


FCPrint::usage =
"FCPrint[level, x] outputs Print[x] if the value of $VeryVerbose
is larger than level.";

NonCommutative::usage=
"NonCommutative is a data type which may be used, e.g.,  as:
DataType[x, NonCommutative] = True.";

UseWriteString::usage =
"UseWriteString is an option for FCPrint. If set to True,
the expression is printed via WriteString instead of Print.";  

WriteStringOutput::usage =
"UseWriteStringOutput an option for FCPrint. It specifies, to which 
stream WriteString should output the expression"; 

$NonComm::usage=
"$NonComm contains a list of all non-commutative heads present.";

$VeryVerbose::usage=
"$VeryVerbose is a global variable with default setting 0. \
If set to 1, 2, ..., less and more intermediate comments and informations \
are displayed during calculations.";


(* just for debugging *)
$VeryVerbose = 2;


(* If we don't turn this message off, user will get shadowing warnings if a Global` symbol
   has the same name as any Package` symbols. It's not a valid warning, because Package`
   is never on ContextPath at the same time as Global`.
*)
`Private`shdwWasOn = (Head[General::shdw] =!= $Off)
Off[General::shdw]

(*********************  Try to locate the JLink .mx file  *********************)

`Package`$feynCalcDir = DirectoryName[FindFile[$Input]]
(* $jlinkDir is captured in mx file so we need to restore its value after loading the mx. Store a copy. *)
System`Private`savedFeynCalcDir = `Package`$feynCalcDir

(* FeynCalc includes its Mathematica code in both a platform- and version-specific .mx file as well as .m files.
   For speed, we want to load the .mx file if appropriate, otherwise we fall back to reading the .m files.
   The test to load the .mx file is whether the version of Mathematica that built the .mx file is the same
   as the one the user is running. The !ValueQ[`Private`foundMX] part tests that this
   is not a re-load of the file within a session, which must use the .m files instead of .mx, otherwise the
   handful of globals that FeynCalc uses that are protected by If[!ValueQ[foo], foo = defaultvalue] would
   get reset to their defaults.
*)
If[SyntaxQ["10.0"] && ToExpression["10.0"] == $VersionNumber && !ValueQ[`Private`foundMX],
        Quiet[
            Check[
                    `Private`foundMX =
                        (Get[ToFileName[{`Package`$feynCalcDir, "Kernel", "SystemResources", $SystemID}, "FeynCalc.mx"]] === Null),
                (* If messages generated (e.g. DumpGet::bgcorr), leave foundMX=False. *)
                    `Private`foundMX = False
            ]
        ],
(* else *)
    `Private`foundMX = False
];


`Package`$feynCalcDir = System`Private`savedFeynCalcDir


(***************************  Information Context  ***************************)

FeynCalc`Information`$Version = 10.0;

(***************************  Information Context  ***************************)

(* *************************  functions used in this file need to be defined here ******************* *)

If[!ValueQ[$VeryVerbose], $VeryVerbose = 0];

Options[FCPrint] = {    
    UseWriteString -> False,
    WriteStringOutput ->"stdout"
}

FCPrint[level_, x__, opts:OptionsPattern[]] :=
    If[ $VeryVerbose >= level,
        If[ OptionValue[UseWriteString],
            WriteString[OptionValue[WriteStringOutput],x],
            Print[x]
        ]
    ];
SetAttributes[FCPrint, HoldAll];

(* *************************  functions used from now on ******************* *)


(* Read .m files if no appropriate FeynCalc.mx was found. *)
(* TODO: implement this *)
If[!`Private`foundMX,

        (*******************  Read in the implementation files.  **********************)
        (* need to do this first, otherwise $NonComm does not get built correctly *)

		(* need to provide an initial value *)
        If[!ValueQ[$NonComm], $NonComm = {}];
        
        (* this is the list of packages which has to be loadded first *)
        `Private`implementationFiles`fcPackagesLoadFirst =
        				FileNameJoin[{`Package`$feynCalcDir, "Kernel", "fcPackages", "core", #}]& /@ 
        					{
        						"DataType.m", 
        						"DeclareNonCommutative.m"
        					};

		(*  get the list of all .m files in the fcPackages subdirectory *)
        `Private`implementationFiles`fcPackages =
						FileNames["*.m", { FileNameJoin[{`Package`$feynCalcDir, "Kernel", "fcPackages"}]}, Infinity];
        (* but put the fcPackagesLoadFirst ones in front *)
        `Private`implementationFiles`fcPackages = 
        				Join[
        					`Private`implementationFiles`fcPackagesLoadFirst, 
        					Complement[
        							`Private`implementationFiles`fcPackages, 
        							`Private`implementationFiles`fcPackagesLoadFirst
        					]
        				];

		(* alwyas load all FeynCalc packages *)					 
Print["Length = ", Length @ `Private`implementationFiles`fcPackages];
						Do[ FCPrint[2, "loading ", i]; Get @ i,
							{i, Take[`Private`implementationFiles`fcPackages, Global`$TAKE]}];

        `Private`implementationFiles`Phi=
						FileNames["*.m", { FileNameJoin[{`Package`$feynCalcDir, "Kernel", "Phi"}]}, Infinity];
]

Print["`Private`implementationFiles`fcPackages = ", `Private`implementationFiles`fcPackages ]


EndPackage[]