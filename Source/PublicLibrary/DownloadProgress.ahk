#Requires AutoHotkey v2.0

#Include "Support_1.ahk"

Progess_Download(link_down, link_name, link_api, real_width, real_height) {
    ; Hệ thống 
    stream := ComObject("ADODB.Stream")
    stream.Type := 1

    ; Kích thước
    kick_thuoc_w := Integer(real_width/8)
    kick_thuoc_h := Integer(real_height/10)
    kick_thuoc_w2 := Integer(kick_thuoc_w/1.2)
    kick_thuoc_h2 := Integer(kick_thuoc_h/4)

    ; Giao diện đại diện đang tải
    giao_dien_tai := Gui()
    text_ui := giao_dien_tai.AddText("w" . kick_thuoc_w . " h" . kick_thuoc_h/4, "Đang tải xuống dữ liệu cấu trúc")
    giao_dien_tai.AddProgress("cBlack w" . (kick_thuoc_w2 + 4) . " h" . (kick_thuoc_h2 + 4), 100).GetPos(&x_pos1, &y_pos1)

    progress_ui := giao_dien_tai.AddProgress("Cgreen w" . kick_thuoc_w2 . " h" . kick_thuoc_h2 . " x" . x_pos1 + 2. " y" . y_pos1 + 2. " Range0-100", 0)

    ; Link file dữ liệu
    link_zip := link_name . ".zip"

    ; gởi yêu cầu lên máy chủ yêu cầu trả về thông tin file
    web_data := ComObject("WinHttp.WinHttpRequest.5.1")
    web_data.Open("GET", link_api, false)
    web_data.Send()

    ; Nhận kích thước file
    RegExMatch(web_data.ResponseText, '"size":\s*(\d+)', &text_return)
    total := Integer(text_return[1]) * 1024

    ; Hiển thị giao diện đang tải file
    giao_dien_tai.Show("w" . kick_thuoc_w . " h" . kick_thuoc_h)

    ; Hàm cập nhật giao diện tiến trình tải xuống
    Update_Download() {
        currentBytes := FileGetSize(link_zip)

        ; Kiểm tra xem lấy được dữ liệu file ko?
        if (currentBytes) {
            ; Cập nhật phần trăm
            progress_ui.Value := Integer(100*currentBytes/total)
        }
    }

    ; Cập nhật tiến trình tải
    SetTimer(Update_Download, 100)

    ; Cài đặt file
    Downnload_FileRaw(link_down, link_zip)

    ; Xóa bộ đếm tiến trình tải
    SetTimer(Update_Download, 0)

    ; Xóa giao diện tải
    giao_dien_tai.Destroy()

    ; Kiểm tra xem tải được ko?
    if (!FileExist(link_zip) || FileGetSize(link_zip) == 0) {
        MsgBox("lỗi ko tải được file :((")
        ExitApp()
    }

    ; Giải nén
    giai_nen := ComObject("Shell.Application")
    file_unzip := giai_nen.NameSpace(link_zip).Items().Item(0).Path

    ; Gỉai nén xong thì ném vào kho dữ liệu
    DirCreate(link_name)
    giai_nen.NameSpace(link_name).CopyHere(giai_nen.NameSpace(file_unzip).Items(), 4 | 16)

    ; Xóa file zip
    if (FileExist(link_zip)) {
        FileDelete(link_zip)
    }
}