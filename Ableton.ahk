;;
;; Author: Nathan McCallum (1vasari)
;;
;; This file is the AutoHotkey script for my Ableton Live configuration. It
;; attempts to emulate the philosophy of the vim text editor by providing as much
;; functionality as possible via the keyboard rather than the mouse.
;;
;;

;;
;; Don't look at environment variables or take input from them.
;;
#NoEnv

;;
;; Force AutoHotkey to run only on singular instance of the script at a time.
;;
#SingleInstance force

SetTitleMatchMode, fast
SetTitleMatchMode, 2
SetWorkingDir %A_ScriptDir%

#Persistent

;;
;; Only apply keybindings to Ableton Live.
;;
#IfWinActive ahk_exe Ableton Live 9 Suite.exe

	;;
	;; Hit ` to suspend the script.
	;;
	`::
		Suspend Toggle
	Return

	;;
	;; Use tab to switch between devices/sample view in the details panel
	;;
	Tab::+Tab

	+i::Send, ^!i ;; Toggle I/O
	+o::Send, ^!o ;; Toggle Overview
	+p::Send, ^`, ;; Open preferences
	+s::Send, ^!s ;; Toggle Sends
	+f::F11       ;; Toggle fullscreen
	+b::Send, ^!b ;; Toggle Browser
	+m::Send, ^!m ;; Toggle Mixer
	+e::Send, ^+r ;; Export Audio
	+r::Send, ^!r ;; Toggle Return Tracks
	+d::Send, ^!l ;; Toggle Detail View
	+t::FocusTimeline() ;; Return focus to the cursor on the timeline
	+g::Send, ^g ;; Group tracks/devices

	w::Send, ^s ;; Save
	r::F9 ;; Record
	t::Send, ^t ;; New Audio Track
	y::Send, ^y ;; Redo
	u::Send, ^z ;; Undo
	s::Send, ^e ;; Split
	e::Send, ^d ;; Duplicate (I remember it as 'extend')
	f::Send, ^f ;; Find
	g::Send, ^j ;; Glue
	z::Send, 0  ;; Disable clip
	m::Send, ^+t ;; New MIDI Track
	q::Send, ^+u ;; Quantize
	n::Send, ^+m ;; Create MIDI Clip
	i::Send, ^i ;; Insert time
	a::Send, ^a ;; Select all
    d::Delete ;; Delete thing (clips, tracks, devices, etc)

	;;
	;; Cut
	;;
	x::
		Send, ^x
		Send, {Left} ;; Clear selection, return to normal cursor
	Return

	;;
	;; Copy
	;;
	c::
		Send, ^c
		Send, {Left} ;; Clear selection, return to normal cursor
	Return

	;;
	;; Paste
	;;
	v::
		Send, ^v
		Send, {Left} ;; Clear selection, return to normal cursor
	Return

	;; Note: SciTE4AutoHotkey doesn't properly highlight the following line,
	;; so to clarify... all it's doing is binding Ctrl+L to ';'
	`;::Send, ^l

	;;
	;; The classic Vim JKHL arrow keys
	;;
	j::Down
	k::Up
	h::Left
	l::Right

	;;
	;; Move the grid controls to somewhere easier to reach than the number row (I'm lazy, yes).
	;;
	,::Send, ^2 ;; Reduce grid density
	.::Send, ^1 ;; Increase grid density
	/::Send, ^4 ;; Toggle disable grid

	;;
	;; Zoom in and out with Ctrl + mousewheel and Shift >/< (in/out)
	;;
	^WheelUp::
	+>::
		Send {NumpadAdd}
	Return

	^WheelDown::
	+<::
		Send {NumpadSub}
	Return

	;;
	;; Holding Right click allows the timeline surface to be dragged around.
	;; Ctrl left clicking shows the context menu (macOS style)
	;;
	RButton::
		Send {Ctrl Down}
		Send {Alt Down}
		Send {LButton Down}
	Return

	RButton Up::
		Send {Ctrl Up}
		Send {Alt Up}
		Send {LButton Up}
	Return

	^LButton::
		Send {RButton}
	Return

	;;
	;; Now for adding Plugins!
	;;

	AddPlugin(plugin_name) {
		Send, ^f
		Send, %plugin_name%
		Sleep, 200 ;; Sleep while the search query completes
		Send, {Down}{Enter}
		Send, ^!b
		FocusTimeline()
	}

	FocusTimeline() {
		PixelSearch, ArrowX, ArrowY, 0, 0, A_ScreenWidth, 200, 0xf47711, 0, Fast RGB

		if ErrorLevel {
			MsgBox, Fuck a duck
		} else {
			MouseClick, Left, A_ScreenWidth / 2, ArrowY, 1, 0
		}
	}

	p & e::AddPlugin("EQ Eight")
	p & c::AddPlugin("Compressor")
	p & r::AddPlugin("Reverb")
	p & t::AddPlugin("Tuner")
	p & d::AddPlugin("Ping Pong Delay")
	p & g::AddPlugin("Guitar Rig 5")
    p & u::AddPlugin("Utility")

#IfWinActive
