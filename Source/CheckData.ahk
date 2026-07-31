#Requires AutoHotkey v2.0

Parent := A_ScriptDir

save_link_Config := Parent . "\config.ini"
save_link_forceImage := Parent . "\ForceImage" 

real_width := SysGet(78)
real_height:= SysGet(79)
; Dùng hệ thống giao diện cập nhật tiến trình tải file
#Include "..\PublicLibrary\DownloadProgress.ahk"

; Kiểm tra xem có file tùy chỉnh cài đặt
if (!FileExist(save_link_Config)) {
    FileAppend("", save_link_Config, "UTF-16")
}

; Kiểm tra xem có file giao diện bắt buộc
if (!FileExist(save_link_forceImage)) {
    Progess_Download(
        "https://github.com/minhlongbeo/Limbus-Company-Macro-Dugeon/archive/refs/heads/ForceImage.zip",
        save_link_forceImage,
        "https://api.github.com/repos/minhlongbeo/Limbus-Company-Macro-Dugeon",
        real_width,
        real_height
    )
}

; Đọc file tùy chỉnh cài đặt
base_config := IniRead(save_link_Config, "LocationFile", "UiApp", "No ESix")

; Nếu file tùy chỉnh cài đặc chưa có đường link dẫn tới giao diện macro
if (base_config == "No ESix") {
    link_ui_macro := ""

    ; Kích thước màn hình giao diện (chọn đường link dẫn tới giao diện macro)
    width_ui := Integer(real_width/5)
    height_ui := Integer(real_height/4)

    ; Kích thước, vị trí ảnh (Limbus company)
    w_size_image := Integer(width_ui/1.5)
    h_size_image := Integer(height_ui/2.3)
    x_position_image := Integer(width_ui*0.16) 
    Y_position_image := Integer(height_ui/15)

    ; Tạo
    board_link := Gui("", "Chọn thư mục dữ liệu")   
    button_link := board_link.AddButton(
        "+Border Center +0x200 +Right " . 
        "x" . x_position_image . " y" . h_size_image + 2*Y_position_image .
        " w" . w_size_image . " h" . Y_position_image, 
        "..."
    )
    button_accept := board_link.AddButton(
        "+Border Center +0x200" . 
        " w" . Integer(width_ui/10) . " h" . Integer(height_ui/10) .
        " x" . x_position_image + w_size_image - Integer(width_ui/10), 
        "✓"
    )

    slect_folder(*) {
        global link_ui_macro
        open_fileUi := DirSelect()

        if (open_fileUi != "") {
            link_ui_macro := open_fileUi 
            button_link.Text := open_fileUi
        }
    }

    ; Cập nhật sự kiện ("Chọn đường dẫn")
    button_link.OnEvent("Click", slect_folder)

    ; Lấy kích thước nút nhấn
    button_accept.GetPos(&X_Accept, &Y_Accept, &Wit_Accept, &Hei_Accept)

    ; Tạo hàm sự kiện (Nhấn đã chọn xong đường dẫn file giao diện cho macro)
    check_link(*) {
        if (link_ui_macro == "") {
            button_accept.Text := "X"

            Sleep(1000)

            button_accept.Text := "✓"
        } else {
            IniWrite(link_ui_macro, save_link_Config, "LocationFile", "UiApp")

            button_accept.OnEvent("Click", check_link, 0)
            board_link.Destroy()
        }
    }

    ; Cập nhật sự kiện Nhấn nút
    button_accept.OnEvent("Click", check_link)

    current_image := save_link_forceImage . "\icon_on_lost_link.png"

    ; Tạo ảnh limbus cho đẹp
    board_link.AddPic(
        "+BackgroundTrans " . "x" . x_position_image . " y" . Y_position_image . " w" . w_size_image . " h" . h_size_image,
        current_image
    )

    ; Hiển thị
    board_link.Show("w" . width_ui . " h" . height_ui)
}