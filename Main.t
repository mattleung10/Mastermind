%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer:  Matthew Leung
%Program Name:  Mastermind
%Date:  January 2017
%Course:  ICS3CU1  Final Project 15%
%Teacher:  M. Ianni
%Descriptions:  Final Program Name Here and a brief description of the game
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% files/code folder
include "files/code/includes.t"

loop
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % procedure to set all initial global variable with file scope
    % even if already set (located in MyGlobalVars.t)
    setInitialGameValues
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % A.      display title screen
    displayIntroWindow

    if IntroButtonPressed = "quit" then
	exit
    elsif IntroButtonPressed = "play" then
	YesToInstructions := "n"
    elsif IntroButtonPressed = "instructions" then
	YesToInstructions := "y"
    end if

    % B.      Ask user if they want instructions displayed on the screen
    % put "Do you wish to see instructions?  (Y/N or y/n) " ..
    % getch (YesToInstructions)

    if YesToInstructions = "y" or YesToInstructions = "Y" then
	displayInstructionWindow   % The Instructions
    end if

    % C.      Game

    winmain := Window.Open ("position:center;center,graphics:576;680,nobuttonbar,nocursor,title:Mastermind")
    View.Set ("offscreenonly") %eliminates flickering
    isMainOpen := true %main window is open

    fork music %calls the process that plays music

    drawInitialMain %this draws the game board, all the buttons, and everything the main
    %revealAnswer (50, 25, 13, 4, 16, 14, 12) %for testing purposes only

    for g : 1 .. 12 %12 tries to guess
	if g not= 1 then
	    View.Update
	    reDrawMain (g) %This procedure basically re-draws everything because the indicate guess procedure from the previous row must be erased
	    %revealAnswer (50, 25, 13, 4, 16, 14, 12) %for testing purposes only
	end if
	loop
	    View.Update %eliminates flickering
	    getMouseClick (mousex, mousey) %get the mouse click
	    if mousex >= 50 and mousey >= 25 + (g - 1) * (32 + 14) and mousex <= 226 and mousey <= 25 + g * (32 + 14) and colourSelected = true then
		%if click is within the board and a colour has been selected
		getRowCol (50, 25, 16, 14, 12, mousex, mousey, col, row, centrex, centrey)
		if isInside (50, 25, 13, 4, 16, 14, 12, mousex, mousey, col, row, centrex, centrey) = true then
		    if colourExists (g, userColour) = false then %if colour has not been used
			fillBoard (50, 25, 16, 14, 12, g, col, userColour)
			drawBoard (50, 25, 13, 4, 16, 14, 12, black) %re-draw the board
			input (g, col) := userColour
		    else %if colour has been used
			fillBoard (50, 25, 16, 14, 12, g, determineSameColourPos (g, userColour), 114) %fill in the previous colour position
			input (g, determineSameColourPos (g, userColour)) := -1 %previous position that the colour held made to -1 (meaning no colour or empty)
			fillBoard (50, 25, 16, 14, 12, g, col, userColour) %fill the board with new colour
			drawBoard (50, 25, 13, 4, 16, 14, 12, black) %re-draw the board
			input (g, col) := userColour %store that colour in the respective position in the array
		    end if
		end if
	    elsif mousex >= 300 and mousey >= maxy div 2 and mousex <= 400 and mousey <= maxy div 2 + 50 then
		%if check button is pressed
		isCheckButtonPressed := true
	    else
		%if click is within palette
		colourGetRowCol (300, 50, 500, mousex, mousey, col, row, centrex, centrey)
		if IsColourSelected (300, 50, 500, mousex, mousey, col, row, centrex, centrey) = true then
		    showColourInIndicatorBox (300, 200, row, col)
		    userColour := colours (row, col) %get the colour selected
		    colourSelected := true %colour has been selected
		end if
	    end if

	    if isCheckButtonPressed = true and isAnswerComplete (g) = true then %if the check button is pressed and the answer is complete then exit the loop
		exit
	    else
		isCheckButtonPressed := false %resets back to false; used to prevent the computer from checking instantly when the answer is complete
	    end if
	end loop
	check (g) %check the answer
	displayPegs (50, 25, 13, 4, 16, 14, 12, g) %display the pegs
	drawBoard (50, 25, 13, 4, 16, 14, 12, black) %re-draw the board

	correct := isAnswerCorrect (g)
	if correct = true then %if the answer is correct then exit the for loop
	    exit
	end if
    end for

    revealAnswer (50, 25, 13, 4, 16, 14, 12) %answer is revealed
    drawBoard (50, 25, 13, 4, 16, 14, 12, black) %re-draw the board

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Win/lose window

    winwl := Window.Open ("position:center;center,graphics:200;200,nobuttonbar,title:Results") %win/lose window
    Music.PlayFileStop %stops the music

    if correct = true then %put a message depending if the user won or lost the game
	put "Congratulations! You won the game!"
    else
	put "You lost!"
    end if

    YesNoButton %draws the Yes and No buttons
    
    %var key : string (1)
    put "\n\nPlay Again?" ..
    %getch (key)
    %exit when key = "N" or key = "n"
    
    delay (1000) %so that user does not accidentally click
    pressYesNoButton %checks if the Yes or No button was pressed
    
    if isYesButtonPressed = false and isNoButtonPressed = true then
	exit
    end if
    
    Window.Close (winwl) %window is closed and intro window is opened
    Window.Close (winmain)

end loop

Music.PlayFileStop %stops the music

if isMainOpen = true then %if main window was open, then close it
    Window.Close (winwl)
    Window.Close (winmain)
end if
