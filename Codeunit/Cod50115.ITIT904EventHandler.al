codeunit 50115 "ITI T904EventHandler"
{
    [EventSubscriber(ObjectType::table, database::"Assemble-to-Order Link", 'OnBeforeAsmHeaderModify', '', false, false)]
    local procedure OnBeforeAsmHeaderModify(var AssemblyHeader: Record "Assembly Header"; var SalesLine: Record "Sales Line")
    var
        AssyMgt: Codeunit "ITI AssemblyManagement";
    begin
        AssyMgt.UpdateAssemblyLinesWithDefaultLocation(AssemblyHeader);
        AssyMgt.SetHeaderDimensionsFromInventoryAdjmtAccount(AssemblyHeader, true);
    end;

    [EventSubscriber(ObjectType::table, database::"Assemble-to-Order Link", 'OnAfterUpdateAsm', '', false, false)]
    // local procedure OnBeforeAsmHeaderInsert(var AssemblyHeader: Record "Assembly Header")
    local procedure OnAfterUpdateAsm(AsmHeader: Record "Assembly Header")
    var
        AssyMgt: Codeunit "ITI AssemblyManagement";
    begin
        AsmHeader."External Document No." := AssyMgt.GetATOExternalDocumentNo(AsmHeader);
        AsmHeader.Modify();
    end;
}
