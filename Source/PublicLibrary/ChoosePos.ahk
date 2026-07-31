#Requires AutoHotkey v2.0

; Cập nhật vị trí người chơi chọn theo thuộc tính "Tag"
Choosed_Pos(data_list) {
    ; Tạo Giao diện 
    bg := Gui("+AlwaysOnTop -Caption +ToolWindow") ;Nền
    bg.BackColor := "Black"
    bg.Tag := "idkguys"

    ; Biến lưu giá trị thay đổi
    current_object := unset
    current_drag := unset

    ; Chỉnh cài đặc màu
    WinSetTransColor("Green 128", bg)

    ; Hàm khi đè giao diện thì ...
    Allow_Drag(_, a, n, Hwnd) {
        current_ui := GuiCtrlFromHwnd(Hwnd).Tag

        ; Kiểm tra xem giao diện đó có cho phép đè ko?
        if (data_list.Has(current_ui)) {
            ; Cho phép kéo
            PostMessage(0x00A1, 2, 0, Hwnd)
        }
    }

    ; Hàm ngắt giao diện
    UnTrigger_ui() {
        ; Lấy dữ liệu hiện tại
        current_data := data_list[current_object.Tag]

        ; Lấy vị trí
        current_drag.GetPos(&x3, &y3)

        ; Cập nhật vị trí
        current_data.x2 := x3
        current_data.y2 := y3

        ; Cập nhật vị trí

        ; Ẩn màn hình chọn giao diện
        bg.Hide()
    }

    ; Gắn sự kiện đè thanh bất kì
    OnMessage(0x0201, Allow_Drag)

    ; Hàm cập nhật vị trí chọn
    return (gui_object) {
        ; Hiển thị giao diện
        bg.Show()

        ; Lưu biến 
        ten_ui := gui_object.Tag

        ; Cập nhật là đang xử lí giao diện này
        current_object := gui_object

        ; Dữ liệu về hộp kéo hiện tại
        current_box := data_list[ten_ui]
        current_vector := current_box.Size

        ; Lưu kích thước, vị trí
        x2 := current_vector.x2
        y2 := current_vector.y2
        w2 := current_vector.w2
        h2 := current_vector.h2

        ; Tạo Giao diện (hộp định vị trí)
        current_drag := bg.AddProgress("+Border Center cGreen x" . x2 . " y" . y2 . " w" . w2 . " h" . h2, 100)

        ; Khi người dùng nhấn enter trên bàn phím thì coi như chọn xong
        Hotkey("Enter", UnTrigger_ui)
    }
}