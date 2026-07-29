#Requires AutoHotkey v2.0
DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")

type_skill := "Corrosion"
pack_select := [
    ["Flat-broke Gamblers"],
    ["Hell's Chicken"],
    ["To be Cleaved"],
    ["To be Pierced"],
    ["Piercers & Penetrators"]
]

array_ui := {
    mirror_dugeon: [0, 0],
}

#Include "CheckData.ahk"
#Include "Running.ahk"