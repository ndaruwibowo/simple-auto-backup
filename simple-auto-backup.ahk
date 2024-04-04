#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn

MainGui := Gui(,"Auto-Backup Sederhana",)
MainGui.SetFont("s12", "Calibri")
MainGui.Add("Text",,"File dan folder mana yang mau dicadangkan?")
Selectedfilesandfolders := MainGui.AddEdit("r1 w230 ReadOnly", "")
MainGui.SetFont("s10", "Calibri")
MainGui.AddButton("x+10 h28 w60 vSelectfile", "Pilih").OnEvent("Click", Buttonfileselect)
MainGui.SetFont("s12", "Calibri")
MainGui.Add("Text","xs","Destinasinya ke mana?")
Destinationname := MainGui.AddEdit("r1 w230 ReadOnly", "")
MainGui.SetFont("s10", "Calibri")
MainGui.AddButton("x+10 h28 w60", "Pilih").OnEvent("Click", Destinationselect)
MainGui.SetFont("s12", "Calibri")
MainGui.Add("Text","xs","Setiap kapan mau dicadangkan?")
Num := MainGui.AddEdit("r1 w140 Number", "")
Interval := MainGui.AddDropDownList("x+10 r3 w80 vIntervalchoices", ["detik", "menit", "jam"])
MainGui.SetFont("s10", "Calibri")
MainGui.AddButton("x+10 h28 w60", "Mulai").OnEvent('Click', Whentostart)
MainGui.SetFont("S6", "Calibri")
MainGui.AddLink("xs+85 y+10", 'Created by M. Ndaru Wibowo - <a href="https://github.com/ndaruwibowo">GitHub Repo</a>')
MainGui.OnEvent("Close", Closeall)
MainGui.Show("AutoSize")

Buttonfileselect(*)
{
    unparsedfilesandfolders := Fileselect("MD3",,"Pilih satu atau beberapa file dan folder")
    For Index, val in unparsedfilesandfolders
        Selectedfilesandfolders.Value .= "|" val
}

Destinationselect(*)
{
    Destinationname.Value := DirSelect(A_MyDocuments, 1, "Select destination")
}

Whentostart(*)
{
    Loop
        {
            Switch
            {
                case "detik": Interval := 1000
                case "menit": Interval := 60000
                case "jam": Interval := 3600000
            }
            sleepInteval := (Num * Interval)
            Sleep sleepInteval
            Loop Parse Selectedfilesandfolders.Value, "|"
                {
                    Loop Files, A_LoopField, "DF"
                        {
                            global ErrorCount := CopyFilesAndFolders(A_LoopFileFullPath, Destinationname.Value)
                                if ErrorCount != 0
                                    MsgBox ErrorCount " files/folders could not be copied."
                
                                    CopyFilesAndFolders(SourcePattern, DestinationFolder, DoOverwrite := true)
                                    ; Copies all files and folders matching SourcePattern into the folder named DestinationFolder and
                                    ; returns the number of files/folders that could not be copied.
                                    {
                                        global ErrorCount := 0
                                        ; First copy all the files (but not the folders):
                                        try
                                        FileCopy SourcePattern, DestinationFolder, DoOverwrite
                                        catch as Err
                                        ErrorCount := Err.Extra
                                        ; Now copy all the folders:
                                        Loop Files, SourcePattern, "D"  ; D means "retrieve folders only".
                                        {
                                            try
                                            DirCopy A_LoopFilePath, DestinationFolder "\" A_LoopFileName, DoOverwrite
                                            catch
                                            {
                                                global ErrorCount += 1
                                                ; Report each problem folder by name.
                                                MsgBox "Could not copy " A_LoopFilePath " into " DestinationFolder
                                            }
                                        }
                                        return ErrorCount
                                    }
                            }
                }
    }
}
Closeall(*)
{
ExitApp
}