%Display Intstruction


proc displayInstructionWindow
    wininstruct := Window.Open ("position:center;center,graphics:850;680,nobuttonbar,nocursor,title:Instructions")
    cls
    Draw.FillBox (0, 0, maxx, maxy, 53) %background
    Text.ColourBack (53)
    var stream : int
    open : stream, "files/text/instructions.txt", get

    if stream > 0 then

	var Lines : string
	loop
	    exit when eof (stream)
	    get : stream, Lines : *
	    put Lines

	end loop
	close : stream
    else
	put "Unable to open file."

    end if

    var anyKey : string (1)

    put "\n\n   PRESS ANY KEY TO CONTINUE:  " ..
    getch (anyKey)

    Window.Close (wininstruct)
end displayInstructionWindow
