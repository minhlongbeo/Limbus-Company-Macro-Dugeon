#Requires AutoHotkey v2.0

; Địa chỉ file hiện tại
Parent := A_ScriptDir

; Kích thước màn hình
real_width := SysGet(78)
real_height := SysGet(79)
board_width := Integer(real_width/3.75)
board_height := Integer(real_height/3)

; Các thuộc tính
main_point := false
track_on2 := false

; Tạo giao diện macro
base_ui := Gui()
base_ui.BackColor := "Black"

; Tạo ảnh cài đặc (chỉnh sửa cài đặc)
block_gear_size := Integer(board_width/10)
gear_option := "w" . block_gear_size . " h" . block_gear_size . " y0 x" . (board_width - block_gear_size)

;-----------------------------------------------------------------------------------------------------------------
; Bánh răng 2
gear2 := base_ui.AddPicture(gear_option, "DataLimbusMacro\on_entergear.png")
gear2.Visible := false
; Bánh răng 1
gear1 := base_ui.AddPicture(gear_option, "DataLimbusMacro\gear.png")

; Ngắt kích hoạt bánh răng
On_UnTrigger() {
    gear1.Visible := true
    gear2.Visible := false
}

; tải hệ thống (thay đổi vị trí giao diện)
#Include "..\PublicLibrary\ChoosePos.ahk"

; Hàm tải giao diện những nút sẽ có để tùy chỉnh vị trí
PreCreate_UiPos(Data) {
    mini_board_width := Integer(board_width/1.5)
    mini_board_hieght := Integer(board_height/1.5)
    
    ; Kích thước
    Text_Width := Integer(mini_board_width/2)
    Text2_Width := Integer(Text_Width/1.81)
    Text_Height := Integer(mini_board_hieght/5)
    Text2_Height := Integer(Text2_Height/1.81)

    ; Tạo giao diện to
    board2 := Gui()

    ; Tạo hệ thống tùy chỉnh vị trí ui
    current_machine := Choosed_Pos(Data)

    ; Vị trí
    indexss := 0

    ; Kiểm tra xem đến giới hạn 1 trang chưa ?
    if (ObjOwnPropCount(Data) > 1) {
        ; Tạo nút tiến tới
        Next_Ui := board2.AddButton(
            "w" . Integer(mini_board_width/10) . " h" . Integer(mini_board_hieght/5) . 
            " x" . (mini_board_width - Integer(mini_board_width/10)) . " y" . (mini_board_hieght - Integer(mini_board_hieght/5)),
            "->"
        )

        ; Tạo nút lùi lại
        Undo_Ui := board2.AddButton(
            "w" . Integer(mini_board_width/10) . " h" . Integer(mini_board_hieght/5) . 
            " x" . (mini_board_width - Integer(mini_board_width/10)) . " y" . (mini_board_hieght - Integer(mini_board_hieght/5)),
            "<-"
        )
    }

    ; Duyệt và tạo giao diện tương ứng với dữ liệu
    for key, value in Data.ObjOwnProp() {
        current_y := (0.5 + indexss)*Text_Height

        ; Tạo nút chỉnh
        board2.AddText(
            "w" . Text_Width . " h" . Text_Height . 
            " x0 y" . current_y, 
            key
        ) ; Chữ

        ; Tạo 4 giao diện ghi chỉ số
        board2.AddText(
            "w" . Text2_Width . " h" . Text2_Height . 
            " x" . Text_Width . " y" . current_y,
            value
        )

        ; Cập nhật vị trí giao diện
        indexss += 1

        ; Kiểm tra xem đến giới hạn 1 trang chưa ?
        if (indexss += 5) {
            ; Cập nhật lại
            indexss := 0
        }
    }

    ; Kích hoạt bánh răng
    On_Trigger(*) {
        gear2.Visible := true
        gear1.Visible := false

        ; Hiện bảng
        board2.Show("w" . mini_board_width . " h" . mini_board_width)
    }

    ; Cập nhật sự kiện nhấn chuột vào bánh răng kích hoạt
    gear1.OnEvent("Click", On_Trigger)
}

; Sự kiện di chuột vào bánh răng
gear2.OnEvent("Click", On_UnTrigger)
;-----------------------------------------------------------------------------------------------------------------

; Tạo ảnh dưới góc bảng giao diện
image_height := Integer(board_height/150)
base_ui.AddPicture("+BackgroundTrans w" . board_width . " h" . image_height . " x0 y" . Integer(board_height - 2*image_height), "DataLimbusMacro\BaseUi.png")

; Hàm kích hoạt macro
Trigger_Macro_Button(func) {
    MsgBox("hehe giờ chư có gì để làm")   
}

; Hiển thị
base_ui.Show("w" . board_width . " h" . board_height)