#Requires AutoHotkey v2.0

save_link := "DataLimbusMacro\config.ini"
load_data := FileExist(save_link)

real_width := SysGet(78)
real_height:= SysGet(79)

if (!load_data) {
    FileAppend("", "config.ini", "UTF-16")
}

base_config := IniRead("config.ini", "LocationFile", "UiApp", "NoDataFound")

if (base_config == "NoDataFound") {
    IniWrite("No ESix", "config.ini", "LocationFile", "UiApp")
    base_config := "No ESix"
}

if (base_config == "No ESix") {
    width_ui := Integer(real_width/5)
    height_ui := Integer(real_height/4)

    board_link := Gui("", "Chọn thư mục dữ liệu")   
    board_link.AddPicture("w" . Integer(width_ui/2) . " h" . Integer(height_ui/1.8), "icon_on_lost_link.png")

    button_link := board_link.AddButton("", "...")
    button_link.OnEvent("Click", (*) => (
        open_fileUi := DirSelect()
        (open_fileUi != "") && save_link := open_fileUi
    ))

    button_accept := board_link.AddButton("", "✓")
    button_accept.Text := ""

    button_accept.GetPos(&X_Accept, &Y_Accept, &Wit_Accept, &Hei_Accept)
    text_button := board_link.AddText(
        "w" . Wit_Accept . " h" . Hei_Accept . " x" . X_Accept . " y" . Y_Accept . 
        " +BackgroundTrans", 
        "✓"
    )

    check_link(*) {
        (save_link == "") ? (
            button_accept.Text := "X"

            Sleep(1000)

            button_accept.Text := "✓"
        ) : (
            IniWrite(save_link, "config.ini", "LocationFile", "UiApp")

            button_accept.OnEvent("Click", check_link, 0)
            board_link.Destroy()
        )
    }

    button_accept.OnEvent("Click", check_link, 1)

    text_button.Visible := true
    button_accept.Visible := true
    board_link.Show("w" . width_ui . " h" . height_ui)
}