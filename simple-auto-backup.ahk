/*
Simple webhook for discord
Creator: ndaruwibowo / frostytropis
Github: https://github.com/ndaruwibowo/simple-webhook-for-discord
License: MIT
Description:
Sending message with optional random image thru discord bot webhook.
*/
#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn

/*
UI stuff
*/
MainGui := Gui(,"Auto-Backup Sederhana",)
MainGui.SetFont("s12", "Calibri")
MainGui.Add("Text",,"File dan folder mana yang mau dicadangkan?")
selectedir := MainGui.AddEdit("r1 w230 ReadOnly", "")
MainGui.SetFont("s10", "Calibri")
MainGui.AddButton("x+10 h28 w60 vSelectDir", "Pilih").OnEvent("Click", Buttonselect)
MainGui.SetFont("s12", "Calibri")
MainGui.Add("Text","xs","Destinasinya ke mana?")
Destinationname := MainGui.AddEdit("r1 w230 ReadOnly", "")
MainGui.SetFont("s10", "Calibri")
MainGui.AddButton("x+10 h28 w60", "Pilih").OnEvent("Click", Destinationselect)
MainGui.SetFont("s12", "Calibri")
MainGui.Add("Text","xs","Setiap kapan mau dicadangkan?")
Num := MainGui.AddEdit("r1 w230 Number", "")
Num.OnEvent("Focus", HelpText)
MainGui.SetFont("s10", "Calibri")
MainGui.AddButton("x+10 h28 w60", "Mulai").OnEvent('Click', Whentostart)
MainGui.SetFont("S6", "Calibri")
MainGui.AddLink("xs+85 y+10", 'Created by M. Ndaru Wibowo - <a href="https://github.com/ndaruwibowo">GitHub Repo</a>')
MainGui.OnEvent("Close", Closeall)
MainGui.Show("AutoSize")

Buttonselect(*)
{
    selectedirname := DirSelect(, 1, "Pilih folder yang akan dicadangkan")
    if(selectedir = ""){
        Exit
    } else {
        selectedir.Value .= selectedirname
    }
}

Destinationselect(*)
{
    Destinationname.Value := DirSelect(, 1, "Pilih destinasi")
}

Whentostart(*)
{
	if (Num.Value = "") or (selectedir.Value = "") or (Destinationname.Value = ""){
	Msgbox "Lengkapi kolomnya gan!", "Peringatan!", "OK Icon!"
	exit
	} else {
    MainGui.Hide()
	Loop
        {
			DirCopy selectedir.Value, Destinationname.Value, 1
			sleepInterval := Num.Value * 60000
			Sleep sleepInterval
			ToolTip "Pencadangan selesai."
			Settimer ToolTip, -2000
    }
	}
}
HelpText(*)
{
ToolTip "Dalam hitungan menit"
Settimer ToolTip, -3000
}


Closeall(*)
{
ExitApp
}