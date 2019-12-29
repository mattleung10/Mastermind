%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Programmer:  Matthew Leung
%Date:  January 2017
%Course: ICS3U1
%Teacher:  Mr. Ianni
%Program Name:  Mastermind
%Descriptions:  Contains the subprograms that Main.t will call
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Widely used subprograms

proc drawCircles (ix, iy, ir, ic, r, vd, hd, icolour : int) %lower left x; lower left y; rows; columns; radius; vertical distance; horizontal distance; colour
    %this is used to draw multiple circles
    var x : int := ix + r
    var y : int := iy + r
    for j : 1 .. ir %draw the rows
	x := ix + r
	for i : 1 .. ic %draw the columns
	    Draw.Oval (x, y, r, r, icolour)
	    x := x + 2 * r + hd %x increases by diameter + hd
	end for
	y := y + 2 * r + vd %y increases by diameter + hd
    end for
end drawCircles

proc drawFillCircles (ix, iy, ir, ic, r, vd, hd, icolour : int) %same as drawCircles, but will draw filled circles instead
    var x : int := ix + r
    var y : int := iy + r
    for j : 1 .. ir %draw the rows
	x := ix + r
	for i : 1 .. ic %draw the columns
	    Draw.FillOval (x, y, r, r, icolour)
	    x := x + 2 * r + hd
	end for
	y := y + 2 * r + vd
    end for
end drawFillCircles

proc getRowCol (ix, iy, r, vd, hd : int, var mx, my, col, row, cx, cy : int)
    var ibutton : int
    const d : int := 2 * r %diameter

    col := (mx - ix) div (d + hd) + 1 %Calculates the column number
    cx := ix + (col - 1) * (d + hd) + r %Calculates centrex

    row := (my - iy) div (d + vd) + 1 %Calculates the row number
    cy := iy + (row - 1) * (d + vd) + r %Calculates centrey
end getRowCol

fcn isInside (ix, iy, ir, ic, r, vd, hd, mx, my, col, row, cx, cy : int) : boolean %checks if the click is inside a circle (of the circles created by drawCircles)
    var ingrid : boolean
    const d : int := 2 * r %diameter
    const xr : int := (mx - ix) mod (d + hd) %remainder for x
    const yr : int := (my - iy) mod (d + vd) %remainder for y

    if xr < d and yr < d and xr not= 0 and yr not= 0 and col <= ic and row <= ir and sqrt ((mx - cx) ** 2 + (my - cy) ** 2) < r then
	%a click on the line does not count, so I used the distance of a line formula to check
	ingrid := true
    else
	ingrid := false
    end if
    result ingrid
end isInside

proc getMouseClick (var mx, my : int) %gets the coordinates of mouse click
    var ibutton : int
    loop
	Mouse.Where (mx, my, ibutton)
	if ibutton = 1 then %If left click mouse is down
	    exit
	end if
    end loop
end getMouseClick

proc initializeArray (var a : array 1 .. *, 1 .. * of int) %initalize a 2D array to -1
    for i : 1 .. upper (a, 1)
	for j : 1 .. upper (a, 2)
	    a (i, j) := -1 %set array values to -1
	end for
    end for
end initializeArray

proc initialize3DArray (var a : array 1 .. *, 1 .. *, 1 .. * of int) %initalize a 3D array to -1
    for i : 1 .. upper (a, 1)
	for j : 1 .. upper (a, 2)
	    for k : 1 .. upper (a, 3)
		a (i, j, k) := -1
	    end for
	end for
    end for
end initialize3DArray

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subprograms for the Board

proc drawBoard (ix, iy, ir, ic, r, vd, hd, icolour : int) %draw the main gameboard
    const pr : int := r div 3 %radius of the key pegs
    var x : int := (ic * (r * 2 + hd) + ix)
    var y : int := iy

    drawCircles (ix, iy, ir, ic, r, vd, hd, icolour) %draws the basic holes on the board where the user will put colours in

    for i : 1 .. (ir - 1) %draw the pegs; last/top row (answer row) does not contain pegs
	drawCircles (x, y, 2, 2, pr, 2 * pr, 2 * pr, icolour)
	y := y + 2 * r + vd
    end for
end drawBoard

proc drawInitialBoard (ix, iy, ir, ic, r, vd, hd, icolour : int) %draws the initial gameboard
    const pr : int := r div 3 %radius of the key pegs
    var x : int := (ic * (r * 2 + hd) + ix)
    var y : int := iy

    drawFillCircles (ix, iy, ir, ic, r, vd, hd, 114) %fills in the holes with brown colour
    drawCircles (ix, iy, ir, ic, r, vd, hd, icolour)

    for i : 1 .. (ir - 1) %draw the pegs
	drawFillCircles (x, y, 2, 2, pr, 2 * pr, 2 * pr, 114) %fills in the holes with brown colour
	drawCircles (x, y, 2, 2, pr, 2 * pr, 2 * pr, icolour)
	y := y + 2 * r + vd
    end for
end drawInitialBoard

proc fillBoard (ix, iy, r, vd, hd, row, col, iColour : int) %fills the board with the colour that the user selected
    Draw.FillOval (ix + (col - 1) * (r * 2 + hd) + r, iy + (row - 1) * (r * 2 + vd) + r, r, r, iColour)
end fillBoard

proc revealAnswer (ix, iy, ir, ic, r, vd, hd : int) %reveals the answer to the user
    var cx : int := ix + r
    const cy : int := iy + (ir - 1) * (2 * r + vd) + r %the centrey value is constant
    for i : 1 .. 4
	Draw.FillOval (cx, cy, r, r, answer (i)) %displays circles with the answer code colours
	cx += 2 * r + hd
    end for
end revealAnswer

fcn colourExists (guess, c : int) : boolean %checks if the user has already chosen a colour and put it to the board
    var exist : boolean
    for i : 1 .. 4 %search the input array
	if input (guess, i) = c then
	    exist := true
	    exit
	else
	    exist := false
	end if
    end for
    result exist
end colourExists

fcn determineSameColourPos (guess, c : int) : int %determines the position (column) that the same colour occupies
    var a : int
    for i : 1 .. 4 %search in the input array
	if input (guess, i) = c then
	    a := i
	end if
    end for
    result a
end determineSameColourPos

fcn isAnswerComplete (guess : int) : boolean %determines if the user has inputted a complete answer
    var complete : boolean
    for i : 1 .. 4
	if input (guess, i) = -1 then %if there is a -1 in the array, that means that the answer is not complete, since the array was initialized to -1
	    complete := false
	    exit
	else
	    complete := true
	end if
    end for
    result complete
end isAnswerComplete

proc hideAnswer (ix, iy, ir, ic, r, vd, hd : int) %hides the answer
    var cx : int := ix + r
    const cy : int := iy + (ir - 1) * (2 * r + vd) + r %centrey is constant
    for i : 1 .. 4
	Draw.FillOval (cx, cy, r, r, 8)
	Font.Draw ("?", cx - 4, cy - 5, font2, black) %puts grey circles with question marks inside
	cx += 2 * r + hd
    end for
end hideAnswer

proc indicateGuess (ix, iy, ir, ic, r, vd, hd, guess : int) %shows which row the user should put the colours into
    var y : int := iy + (guess - 1) * (r * 2 + vd) - (vd div 2)
    Draw.FillBox (0, y, ix + ic * (r * 2 + vd) + r * 2, y + r * 2 + vd, 186)
end indicateGuess

proc reDrawBoard (ix, iy, ir, ic, r, vd, hd, icolour, guess : int)
    var x : int := ix + r
    var y : int := iy + r
    const pr : int := r div 3
    drawInitialBoard (ix, iy, ir, ic, r, vd, hd, icolour) %re-draw initial board
    for j : 1 .. (guess - 1) %draw the rows
	x := ix + r
	for i : 1 .. ic %draw the columns
	    Draw.FillOval (x, y, r, r, input (j, i))
	    x := x + 2 * r + hd
	end for
	y := y + 2 * r + vd
    end for

    %similar to drawCircles, creating circles with the peg colour
    for k : 1 .. (guess - 1)
	x := ic * (r * 2 + hd) + ix + pr
	y := (k - 1) * (r * 2 + vd) + iy + pr
	for i : 1 .. 2
	    x := ic * (r * 2 + hd) + ix + pr
	    for j : 1 .. 2
		Draw.FillOval (x, y, pr, pr, pegs (i, j, k)) %circles are drawn according to peg colour
		x := x + 4 * pr
	    end for
	    y := y + 4 * pr
	end for
    end for
    drawBoard (ix, iy, ir, ic, r, vd, hd, icolour)
end reDrawBoard

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subprograms for the Palette and Check Button

proc drawPalette (x1, y1, x2 : int) %draw the palette
    const r : int := (x2 - x1) div 13
    var px : int := x1 + 2 * r
    var py : int := y1 + 2 * r
    Draw.FillBox (x1, y1, x1 + r * 13, y1 + r * 7, 8) %palette background
    Draw.Box (x1, y1, x1 + r * 13, y1 + r * 7, black)

    for i : 1 .. 2 %draw the rows
	px := x1 + 2 * r
	for j : 1 .. 4 %draw the columns
	    Draw.FillOval (px, py, r, r, colours (i, j)) %colours according to values stored in array colours
	    px += 3 * r
	end for
	py += 3 * r
    end for

    drawCircles (x1 + r, y1 + r, 2, 4, r, r, r, black) %draw the borders
end drawPalette

fcn IsColourSelected (x1, y1, x2, mx, my, col, row, cx, cy : int) : boolean %checks if user has selected a colour from the palette
    const r : int := (x2 - x1) div 13
    result isInside (x1 + r, y1 + r, 2, 4, r, r, r, mx, my, col, row, cx, cy) %this function is basically isInside but created for the palette
end IsColourSelected

proc colourGetRowCol (x1, y1, x2 : int, var mx, my, col, row, cx, cy : int) %getRowCol created for the palette
    const r : int := (x2 - x1) div 13
    getRowCol (x1 + r, y1 + r, r, r, r, mx, my, col, row, cx, cy)
end colourGetRowCol

proc checkButton (x1, y1, w, h : int) %creates the check button
    Draw.FillBox (x1, y1, x1 + w, y1 + h, 8)
    Draw.Box (x1, y1, x1 + w, y1 + h, black) %drawing a box for the button
    Font.Draw ("Check", 329, y1 + h div 2 - 3, font1, black) %title
end checkButton

proc colourToRowCol (var r, c : int) %colour code to row and column
    for i : 1 .. upper (colours, 1)
	for j : 1 .. upper (colours, 2)
	    if userColour = colours (i, j) then
		r := i
		c := j
	    end if
	end for
    end for
end colourToRowCol

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subprograms for the Colour Indicator Box

proc drawIndicatorBox (x1, y1 : int) %draws a box showing what colour the user selected
    locatexy (x1 + 15, y1 + 85)
    Draw.FillBox (x1, y1, x1 + 150, y1 + 100, 8)
    Draw.Box (x1, y1, x1 + 150, y1 + 100, black) %drawing a box for the button
    Font.Draw ("Colour Selected", 327, 280, font1, black) %title
end drawIndicatorBox

proc showColourInIndicatorBox (x1, y1, row, col : int) %shows the colour in the indicator box
    const cs : int := colours (row, col) %cs is colour selected
    Draw.FillOval (x1 + 75, y1 + 40, 30, 30, cs)
    Draw.Oval (x1 + 75, y1 + 40, 30, 30, black) %border
end showColourInIndicatorBox

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subprograms relating to the code and key pegs

proc generateCode %randomly generate the code which will be guessed by user
    var r1, r2 : int
    var appear : boolean %if the colour has appeared already in the array answer

    for i : 1 .. upper (answer) %generate upper (answer) unique codes
	if i = 1 then %first colour is always unique
	    answer (i) := colours (Rand.Int (1, upper (colours, 1)), Rand.Int (1, upper (colours, 2)))
	else
	    loop
		r1 := Rand.Int (1, upper (colours, 1)) %randomly generate values for row and column for colours array
		r2 := Rand.Int (1, upper (colours, 2))
		for j : 1 .. (i - 1) %checks if the colour generated is unique (has not been stored in answer array)
		    if answer (j) = colours (r1, r2) then
			appear := true
			exit %if colour has appeared, set appear to true and exit
		    else
			appear := false
		    end if
		end for

		if appear = false then %if colour has not appeared, then store it in the answer array
		    answer (i) := colours (r1, r2)
		    exit
		end if
	    end loop
	end if
    end for
end generateCode

proc check (guess : int)
    var pr, pw, pn : int := 0 %red pegs; white pegs; empty/none pegs
    var pcol, prow : int %column number; row number
    for i : 1 .. upper (pegs, 1)
	for j : 1 .. upper (pegs, 2)
	    pegs (i, j, guess) := -1
	end for
    end for

    for i : 1 .. 4 %checks the 4 codes the user inputted
	for j : 1 .. 4 %compares the 4 codes the user inputted with the 4 codes of the answer
	    if input (guess, i) = answer (j) and i not= j then %if colour appears in the answer but is not in the right position
		pw += 1
	    elsif input (guess, i) = answer (j) and i = j then %if colour appears in the answer and is in the right position
		pr += 1
	    end if
	end for
    end for

    %FILLING THE KEY PEGS
    %In the hierarchy, red pegs (if any) are displayed first, then white pegs (if any), and then empty/blank pegs
    pcol := 1 %pegs are displayed 2 by 2, so column and row starts at 1
    prow := 1
    if pr > 0 then %if there are red pegs
	for i : 1 .. pr %fills pegs array with pr red pegs
	    if pcol not= 2 then %start with first column
		pegs (prow, pcol, guess) := 12 %red colour code is 12
		pcol += 1
	    else %if column number is 2 then row number increases by 1 and column number is made 1 again
		pegs (prow, pcol, guess) := 12
		prow += 1
		pcol := 1
	    end if
	end for
    end if
    if pw > 0 then %if there are white pegs
	for i : 1 .. pw %fills pegs array with pw white pegs
	    if pcol not= 2 then
		pegs (prow, pcol, guess) := 0 %white colour code is 0
		pcol += 1
	    else
		pegs (prow, pcol, guess) := 0
		prow += 1
		pcol := 1
	    end if
	end for
    end if
    for i : 1 .. 2
	for j : 1 .. 2
	    if pegs (i, j, guess) = -1 then %the remaining pegs are empty if they are neither white nor red
		pegs (i, j, guess) := 114 %brown (hole colour) colour code is 114
	    end if
	end for
    end for
end check

proc displayPegs (ix, iy, ir, ic, r, vd, hd, guess : int) %displays the pegs; will be called in Main.t after check procedure
    const pr : int := r div 3
    var x : int := ic * (r * 2 + hd) + ix + pr
    var y : int := (guess - 1) * (r * 2 + vd) + iy + pr

    %similar to drawCircles, creating circles with the peg colour
    for i : 1 .. 2
	x := ic * (r * 2 + hd) + ix + pr
	for j : 1 .. 2
	    Draw.FillOval (x, y, pr, pr, pegs (i, j, guess)) %circles are drawn according to peg colour
	    x := x + 4 * pr
	end for
	y := y + 4 * pr
    end for
end displayPegs

fcn isAnswerCorrect (guess : int) : boolean %checks if the answer is correct
    var correct : boolean
    for i : 1 .. 2
	for j : 1 .. 2
	    if pegs (i, j, guess) not= 12 then %if all the key pegs are red then the answer is correct
		correct := false
		exit
	    else
		correct := true
	    end if
	end for
    end for
    result correct
end isAnswerCorrect


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Miscellaneous Subprograms

process music %plays music
    Music.PlayFileLoop ("Sounds/Katyusha.mp3")
end music

proc YesNoButton %draws the Yes and No buttons on the win/lose screen
    const w : int := 200 div 10
    Draw.FillBox (w, 40, 4 * w, 70, 8)
    Draw.Box (w, 40, 4 * w, 70, black)
    Font.Draw ("Yes", w * 2 - 2, 50, font1, black)
    
    Draw.FillBox (w * 6, 40, 9 * w, 70, 8)
    Draw.Box (w * 6, 40, w * 9, 70, black)
    Font.Draw ("No", w * 7, 50, font1, black)
end YesNoButton

proc pressYesNoButton %checks if the Yes or No button was pressed
    loop
	getMouseClick (mousex, mousey)
	if mousex >= 20 and mousex <= 4 * 20 and mousey >= 40 and mousey <= 70 then
	    isYesButtonPressed := true
	    isNoButtonPressed := false
	    exit
	elsif mousex >= 20 * 6 and mousex <= 9 * 20 and mousey >= 40 and mousey <= 70 then
	    isNoButtonPressed := true
	    isYesButtonPressed := false
	    exit
	end if
    end loop
end pressYesNoButton

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subprograms for drawing the Main

proc drawInitialMain %this draws the game board, all the buttons, and the main
    Pic.Draw (WoodBG, 0, 0, picMerge)
    Draw.FillBox (300, 550, 550, 620, white)
    Pic.Draw (logo, 300, 550, picMerge)
    Draw.Box (300, 550, 550, 620, black)
    generateCode
    initializeArray (input)
    initialize3DArray (pegs)
    indicateGuess (50, 25, 13, 4, 16, 14, 12, 1) %shows which guess
    drawInitialBoard (50, 25, 13, 4, 16, 14, 12, black)
    hideAnswer (50, 25, 13, 4, 16, 14, 12)
    drawBoard (50, 25, 13, 4, 16, 14, 12, black) %re-draw the board
    drawPalette (300, 50, 500)
    drawIndicatorBox (300, 200)
    checkButton (300, maxy div 2, 100, 50)
end drawInitialMain

proc reDrawMain (guess : int)
%The code below basically re-draws everything because the indicate guess procedure from the previous row must be erased
    Pic.Draw (WoodBG, 0, 0, picMerge)
    Draw.FillBox (300, 550, 550, 620, white)
    Pic.Draw (logo, 300, 550, picMerge)
    Draw.Box (300, 550, 550, 620, black)
    drawPalette (300, 50, 500)
    drawIndicatorBox (300, 200)
    colourToRowCol (row, col)
    showColourInIndicatorBox (300, 200, row, col)
    checkButton (300, maxy div 2, 100, 50)
    indicateGuess (50, 25, 13, 4, 16, 14, 12, guess) %shows which guess; that was why I had to re-draw everything here
    reDrawBoard (50, 25, 13, 4, 16, 14, 12, black, guess)
    hideAnswer (50, 25, 13, 4, 16, 14, 12)
    drawBoard (50, 25, 13, 4, 16, 14, 12, black) %re-draw the board
end reDrawMain
