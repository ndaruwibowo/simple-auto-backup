#Requires AutoHotkey v2.0
#SingleInstance Force
#Warn
selectedfile := FileSelect("MD1",,"Select folders and files")
For Index, Value in selectedfile
    Strloc .= "|" Value
Loop Parse Strloc, "|"
    Loop Files, A_LoopField, "DF"
        {
            ErrorCount := CopyFilesAndFolders(A_LoopFileFullPath, A_MyDocuments "\testingbackup")
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
                        ErrorCount += 1
                        ; Report each problem folder by name.
                        MsgBox "Could not copy " A_LoopFilePath " into " DestinationFolder
                    }
                }
                return ErrorCount
            }
        }