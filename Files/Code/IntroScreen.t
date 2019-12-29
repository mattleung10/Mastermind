%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer: Matthew Leung
%Date:
%Course:  ICS3CU1
%Teacher:  Mr. Ianni
%Program Name:  Mastermind
%Descriptions:  Demos how to implement a button and a process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% displays a intro banner

process displayBanner

    var x := maxrow div 2
    var y := maxcol div 2

    % loop
    %     locate (2, y)
    %     colour (black)
    %     put "MASTERMIND"
    %     exit when isIntroWindowOpen = false
    % end loop

end displayBanner

% main procedure to handle the intro window
procedure displayIntroWindow

    % flag that intro screen is open - global var isIntroWindowOpen
    isIntroWindowOpen := true
    % Open the window
    var winID : int
    winID := Window.Open ("position:top;center,graphics:600;400,title:Introduction Window")
    Draw.FillBox (0, 0, maxx, maxy, 53) %background colour
    colourback (53)
    Draw.FillBox (180, 310, 430, 380, white)
    Pic.Draw (logo, 180, 310, picMerge)
    locatexy (maxx div 2 - 85, maxy div 2 - 150)
    put "Created by Matthew Leung"

    fork displayBanner


    % create a button
    var playIntroWindowButton := GUI.CreateButtonFull (maxx div 2 - 50, maxy div 2 + 50 - 20, 100, "Play", PlayIntroWindowButtonPressed, 50, " ", true)
    var quitIntroWindowButton := GUI.CreateButton (maxx div 2 - 27, maxy div 2 - 50 - 20, 0, "Quit", QuitIntroWindowButtonPressed)
    var instructionsIntroWindowButton := GUI.CreateButton (maxx div 2 - 47, maxy div 2 - 20, 0, "Instructions", InstructionsIntroWindowButtonPressed)
    
    % Window will continue until quit button is pressed
    loop
	exit when GUI.ProcessEvent or isIntroWindowOpen = false
    end loop
    % release the button
    GUI.Dispose (quitIntroWindowButton)
    %close/release the window
    Window.Close (winID)




end displayIntroWindow
