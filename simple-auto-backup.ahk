#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn

MainGui := Gui(,"Auto-Backup Sederhana",)
MainGui.SetFont("s12", "Calibri")
MainGui.Add("Text",,"File atau folder mana yang mau dicadangkan?")
MainGui.SetFont("s10", "Calibri")
MainGui.AddButton("xs+50 h28 w80 vSelectfile", "Pilih file").OnEvent("Click", Buttonfileselect)
MainGui.AddButton("x+20 h28 w90 vSelectfolder", "Pilih folder").OnEvent("Click", Buttonfolderselect)
MainGui.SetFont("s12", "Calibri")
MainGui.Add("Text","xs","Destinasinya ke mana?")
Destinationname := MainGui.AddEdit("r1 w230 ReadOnly", "")
MainGui.SetFont("s10", "Calibri")
MainGui.AddButton("x+10 h28 w60", "Pilih").OnEvent("Click", Destinationselect)
MainGui.SetFont("s12", "Calibri")
MainGui.Add("Text","xs","Kapan mau dicadangkan?")
Timetobackup := MainGui.AddDateTime(" vTimetobackup w230", "Time")
MainGui.SetFont("s10", "Calibri")
MainGui.AddButton("x+10 h28 w60", "Atur").OnEvent('Click', Whentostart)
MainGui.SetFont("S6", "Calibri")
MainGui.AddLink("xs+85 y+10", 'Created by M. Ndaru Wibowo - <a href="https://github.com/ndaruwibowo">GitHub Repo</a>')
MainGui.OnEvent("Close", Closeall)
Fileselected := MainGui.AddListbox("xs r1 w230 ReadOnly Hidden")
Folderselected := MainGui.AddEdit("r1 w230 ReadOnly Hidden")
MainGui.Show("AutoSize")

Buttonfileselect(*)
{
    global Fileselected := Fileselect("M3",,"Pilih satu atau beberapa file")
    if (Fileselected.Length = 0)
    {
        ControlSetText("Pilih file", "Button1")
    } else {
        ControlSetText("File terpilih", "Button1")
        global Folderselected := ""
        ControlSetText("Pilih folder", "Button2")
    }
}

Buttonfolderselect(*)
{
    global Folderselected := FileSelect("D3",, "Select folder that will be backed up","")
    if (Folderselected = "")
    {
        ControlSetText("Pilih folder", "Button2")
    } else {
        ControlSetText("Folder terpilih", "Button2")
        global Fileselected := ""
        ControlSetText("Pilih file", "Button1")
    }
    
}

Destinationselect(*)
{
    Destinationname.Value := DirSelect(A_MyDocuments, 1, "Select destination")
}

Whentostart(*)
{
Exit
}

Closeall(*)
{
ExitApp
}