; jump between windows according to direction
MoveAndFocus(direction) {
	; get the original window id
	WinGet, original_winid, ,A
	; get the original position of mouse
    MouseGetPos, original_x, original_y
	; get the window size
	WinGetActiveStats, title, width, height, x, y
	if (direction == "right") {
		MouseMove, width, height / 2, 0
		dx = 30
		dy = 0
	} else if (direction == "left") {
		MouseMove, 0, height / 2, 0
		dx = -30
		dy = 0
	} else if (direction == "up") {
		MouseMove, width / 2, 0, 0
		dx = 0
		dy = -30
	} else if (direction == "down") {
		MouseMove, width / 2, height, 0
		dx = 0
		dy = 30
	} else {
		return
	}
	
	while(true) {
		MouseGetPos, before_x, before_y, cur_winid
		WinGetClass, cur_winclass, ahk_id %cur_winid%
		
		; if we are on another window that's not the desktop
		if (cur_winclass != "WorkerW" && cur_winclass != "Shell_TrayWnd" && cur_winid != original_winid) {
			WinActivate, ahk_id %cur_winid%
			break
		}

		; move mouse to the right repeatly
		MouseMove, %dx%, %dy%, 0, R
		
		; stop if we cannot move further
		MouseGetPos, after_x, after_y
		expect_x := before_x + dx
		expect_y := before_y + dy
		if (Abs(after_x - expect_x) > 0 || Abs(after_y - expect_y) > 0) {
			MouseMove, %original_x%, %original_y%, 0
			break
		}
	}
}

CapsLock & h::
MoveAndFocus("left")
Return
CapsLock & l::
MoveAndFocus("right")
Return
CapsLock & j::
MoveAndFocus("down")
Return
CapsLock & k::
MoveAndFocus("up")
Return
