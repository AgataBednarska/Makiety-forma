codeunit 50116 "Competitiv. Item Mgt. N24"
{
    Permissions = tabledata Item = rm,
                    tabledata "Lot No. Information" = rmi;
    procedure ReadExcelSheet(var TempExcelBuff: Record "Excel Buffer" temporary)
    var
        FileManagement: Codeunit "File Management";
        InStr: InStream;
        NoExcelFileFoundLbl: Label 'No excel file found.';
        UploadExcelMsg: Label 'Choose excel file to upload (.xlsx, .xls)';
        FileName: Text;
        FromFile: Text;
        SheetName: Text;
    begin
        if not UploadIntoStream(UploadExcelMsg, '', '', FromFile, InStr) then
            exit;

        if FromFile <> '' then begin
            FileName := FileManagement.GetFileName(FromFile);
            SheetName := TempExcelBuff.SelectSheetsNameStream(InStr);
        end
        else
            Error(NoExcelFileFoundLbl);

        TempExcelBuff.Reset();
        TempExcelBuff.DeleteAll();
        TempExcelBuff.OpenBookStream(InStr, SheetName);
        TempExcelBuff.ReadSheet();
    end;

    procedure ImportExcelData(var TempExcelBuff: Record "Excel Buffer" temporary)
    var
        LotNoInformation: Record "Lot No. Information";
        MaxRowNo: Integer;
        RowNo: Integer;
        ExcelImportedSuccLbl: Label 'Excel Imported Sucessfully';
    begin
        RowNo := 0;
        MaxRowNo := 0;

        TempExcelBuff.Reset();
        if TempExcelBuff.FindLast() then
            MaxRowNo := TempExcelBuff."Row No.";

        for RowNo := 2 to MaxRowNo do begin
            LotNoInformation.SetRange("Item No.", GetValueAtCell(TempExcelBuff, RowNo, 2));
            LotNoInformation.SetRange("Lot No.", GetValueAtCell(TempExcelBuff, RowNo, 1));

            if LotNoInformation.IsEmpty() then begin
                LotNoInformation.Init();
                LotNoInformation.Validate("Item No.", GetValueAtCell(TempExcelBuff, RowNo, 2));
                LotNoInformation.Validate("Lot No.", GetValueAtCell(TempExcelBuff, RowNo, 1));
                Evaluate(LotNoInformation."Length N24", GetValueAtCell(TempExcelBuff, RowNo, 3));
                Evaluate(LotNoInformation."Width N24", GetValueAtCell(TempExcelBuff, RowNo, 4));
                Evaluate(LotNoInformation."Cubic Meters N24", GetValueAtCell(TempExcelBuff, RowNo, 5));
                LotNoInformation.Validate("Comments N24", GetValueAtCell(TempExcelBuff, RowNo, 6));
                LotNoInformation.Validate("Vendor N24", GetValueAtCell(TempExcelBuff, RowNo, 7));
                Evaluate(LotNoInformation."Size N24", GetValueAtCell(TempExcelBuff, RowNo, 8));
                LotNoInformation.Validate("Shade N24", GetValueAtCell(TempExcelBuff, RowNo, 9));
                LotNoInformation.Validate("No. Of Original SLAB N24", GetValueAtCell(TempExcelBuff, RowNo, 10));

                LotNoInformation.Insert(true);
            end
            else begin
                LotNoInformation.FindFirst();
                LotNoInformation.Validate("Item No.", GetValueAtCell(TempExcelBuff, RowNo, 2));
                LotNoInformation.Validate("Lot No.", GetValueAtCell(TempExcelBuff, RowNo, 1));
                Evaluate(LotNoInformation."Length N24", GetValueAtCell(TempExcelBuff, RowNo, 3));
                Evaluate(LotNoInformation."Width N24", GetValueAtCell(TempExcelBuff, RowNo, 4));
                Evaluate(LotNoInformation."Cubic Meters N24", GetValueAtCell(TempExcelBuff, RowNo, 5));
                LotNoInformation.Validate("Comments N24", GetValueAtCell(TempExcelBuff, RowNo, 6));
                LotNoInformation.Validate("Vendor N24", GetValueAtCell(TempExcelBuff, RowNo, 7));
                Evaluate(LotNoInformation."Size N24", GetValueAtCell(TempExcelBuff, RowNo, 8));
                LotNoInformation.Validate("Shade N24", GetValueAtCell(TempExcelBuff, RowNo, 9));
                LotNoInformation.Validate("No. Of Original SLAB N24", GetValueAtCell(TempExcelBuff, RowNo, 10));

                LotNoInformation.Modify(true);
            end;
        end;

        Message(ExcelImportedSuccLbl);
    end;

    local procedure GetValueAtCell(var TempExcelBuff: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer): Text
    begin
        TempExcelBuff.Reset();
        if TempExcelBuff.Get(RowNo, ColNo) then
            exit(TempExcelBuff."Cell Value as Text")
        else
            exit('');
    end;
}