#Requires AutoHotkey v2.0
DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")

; Thông tin (pack)
type_skill := "Corrosion"
pack_select := [
    ["Flat-broke Gamblers"],
    ["Hell's Chicken"],
    ["To be Cleaved"],
    ["To be Pierced"],
    ["Piercers & Penetrators"]
]

; Thông tin về vị trí nút bấm
array_ui := {
    mirror_dugeon: [0, 0],
}

; Kiểm lỗi
#Include "Source\CheckData.ahk"

; Tạo giao diện chính
#Include "Source\MainUi.ahk"

; Tạo giao diện chọn vị trí nút
PreCreate_UiPos(array_ui)

; Tạo hệ thống
#Include "Source\Running.ahk"

; Chạy macro (khi người dùng bấm bắt đầu)
Trigger_Macro_Button(Running_Macro)