%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer:  Matthew Leung
%Date:
%Course:  ICS3CU1
%Teacher:
%Program Name:  Mastermind
%Descriptions:  Final Program Name Here and a brief description of the game
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   MyGlobalVars.t
%   All global variables are coded in this file.
%   These will have FILE scope.
%   These must be document thoroughly - Descriptive name,
%   where used and for what purpose

% Main program variables

var YesToInstructions : string (1)

var colours : array 1 .. 2, 1 .. 4 of int %array of colours avaliable to be selected in the game

for i : 1 .. 2 %initialization of the colours array; colour codes will be stored inside
    %The colours array does not need to be initialized again since the values inside will not change
    %This initialization will not be in setInitialGameValues
    for j : 1 .. 4
	if i = 1 then
	    if j <= 2 then
		colours (i, j) := j + 12 %colour codes 13 and 14
	    elsif j = 3 then
		colours (i, j) := 7 %colour code 7
	    else
		colours (i, j) := 42 %colour code 42
	    end if
	else
	    colours (i, j) := j + 8 %colour codes 9 to 12
	end if
    end for
end for

var answer : array 1 .. 4 of int %array for the answer

var mousex, mousey : int %x coordinate for mouse click; y coordinate for mouse click
var row, col, centrex, centrey : int
var userColour : int %colour that the user has selected

var input : array 1 .. 12, 1 .. 4 of int %array for user guesses

var pegs : array 1 .. 2, 1 .. 2, 1 .. 12 of int %array for the key pegs

var colourSelected : boolean := false %stores the result from the IsColourSelected function

var isCheckButtonPressed : boolean %if the check button has been pressed

var isMainOpen : boolean %if the main run window is open

var correct : boolean %if answer is correct

var isYesButtonPressed : boolean
var isNoButtonPressed : boolean

%Opening/closing the windows
var wininstruct : int %instruction window
var winwl : int %win/lose window
var winmain : int %main window

%Fonts and Pictures
var WoodBG : int := Pic.FileNew ("Images/WoodBG.bmp")
var logo : int := Pic.FileNew ("Images/MastermindLogo.bmp")
var font1 := Font.New ("Times:12")
var font2 := Font.New ("Arial:12")

%Introduction Window
var isIntroWindowOpen : boolean % Flag for Introduction Window state open or closed
var isFontWindowOpen : boolean
var IntroButtonPressed : string %which button was pressed in the IntroScreen



proc setInitialGameValues

    isIntroWindowOpen := false
    isFontWindowOpen := false
    colourSelected := false
    isCheckButtonPressed := false
    isMainOpen := false
    correct := false
    isYesButtonPressed := false
    isNoButtonPressed := false

end setInitialGameValues
