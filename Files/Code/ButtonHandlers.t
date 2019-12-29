% Button File - code to handle button events
% Intro Window Procedures
procedure QuitIntroWindowButtonPressed
    isIntroWindowOpen := false
    IntroButtonPressed := "quit"
    GUI.Quit
    GUI.ResetQuit
end QuitIntroWindowButtonPressed

procedure PlayIntroWindowButtonPressed
    isIntroWindowOpen := false
    IntroButtonPressed := "play"
    GUI.Quit
    GUI.ResetQuit
end PlayIntroWindowButtonPressed

procedure InstructionsIntroWindowButtonPressed
    isIntroWindowOpen := false
    IntroButtonPressed := "instructions"
    GUI.Quit
    GUI.ResetQuit
end InstructionsIntroWindowButtonPressed

