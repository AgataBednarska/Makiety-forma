codeunit 50113 "ITI T901EventHandler"
{
    [EventSubscriber(ObjectType::Table, database::"Assembly Line", 'OnAfterCopyFromItem', '', false, false)]
    local procedure OnAfterCopyFromItem(var AssemblyLine: Record "Assembly Line"; Item: Record Item; AssemblyHeader: Record "Assembly Header")
    begin
        SetDefaultMaterialLocation(AssemblyLine);
    end;

    local procedure SetDefaultMaterialLocation(var AssemblyLine: Record "Assembly Line")
    var
        AssemblySetup: Record "Assembly Setup";
    begin
        if AssemblySetup.get() then
            if AssemblySetup."Default Location for Material" <> '' then
                AssemblyLine.Validate("Location Code", AssemblySetup."Default Location for Material");
    end;

    [EventSubscriber(ObjectType::Table, database::"Assembly Line", 'OnBeforeValidateEvent', 'Location Code', false, false)]
    local procedure RunOnBeforeValidateLocationCodeEvent(var Rec: Record "Assembly Line"; var xRec: Record "Assembly Line"; CurrFieldNo: Integer)
    var
        AssyMgt: codeunit "ITI AssemblyManagement";
    begin
        ValidateInProdAssemblyLine(Rec, xRec);
    end;

    [EventSubscriber(ObjectType::Table, database::"Assembly Line", 'OnBeforeValidateEvent', 'Quantity', false, false)]
    local procedure RunOnBeforeValidateQuantityEvent(var Rec: Record "Assembly Line"; var xRec: Record "Assembly Line"; CurrFieldNo: Integer)
    var
        AssyMgt: codeunit "ITI AssemblyManagement";
    begin
        ValidateInProdAssemblyLine(Rec, xRec);
    end;

    local procedure ValidateInProdAssemblyLine(var Rec: Record "Assembly Line"; var xRec: Record "Assembly Line")
    var
        UpdateFieldQst: label 'This action may lead to an inconsistency in stock because item was transferred to production already.\Do you want to continue?';
        AssemblySetup: Record "Assembly Setup";
    begin
        AssemblySetup.get();
        If (Rec."Location Code" = AssemblySetup."In-Production Location") or
            (xRec."Location Code" = AssemblySetup."In-Production Location") then begin
            if (Rec.Quantity <> xRec.Quantity) or
                (Rec."Location Code" <> xRec."Location Code") then
                if not Confirm(UpdateFieldQst, false) then
                    error('');
        end;
    end;
}
