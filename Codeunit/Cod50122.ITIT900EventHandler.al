codeunit 50122 "ITI T900EventHandler"
{
    [EventSubscriber(ObjectType::Table, database::"Assembly Header", 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure RunOnAfterValidateItemNo(var Rec: Record "Assembly Header")
    begin
        AssyMgt.SetHeaderDimensionsFromInventoryAdjmtAccount(Rec, true);
        AssyMgt.SetResidueDimensionsFromInventoryAdjmtAccount(Rec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Assembly Header", 'OnAfterValidateEvent', 'ITI Gen. Bus. Posting Group', false, false)]
    local procedure RunOnAfterValidateGenBusPostingGroup(var Rec: Record "Assembly Header")
    begin
        AssyMgt.SetHeaderDimensionsFromInventoryAdjmtAccount(Rec, true);
        AssyMgt.SetResidueDimensionsFromInventoryAdjmtAccount(Rec);
    end;


    var
        AssyMgt: Codeunit "ITI AssemblyManagement";
}
