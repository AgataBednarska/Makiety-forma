codeunit 50116 "ITI T905EventHandler"
{
    [EventSubscriber(ObjectType::codeunit, codeunit::"Assembly Line Management", 'OnBeforeUpdateExistingLine', '', false, false)]
    local procedure RunOnBeforeUpdateExistingLine(var AsmHeader: Record "Assembly Header"; OldAsmHeader: Record "Assembly Header"; CurrFieldNo: Integer; var AssemblyLine: Record "Assembly Line"; UpdateDueDate: Boolean; UpdateLocation: Boolean; UpdateQuantity: Boolean; UpdateUOM: Boolean; UpdateQtyToConsume: Boolean; UpdateDimension: Boolean; var IsHandled: Boolean)
    var
        UpdateLineErr: Label 'You could not update %1 because assembly order is in progress or completed';
        AssyMgt: Codeunit "ITI AssemblyManagement";

        AssemblySetup: Record "Assembly Setup";
    begin
        AssemblySetup.get();
        If AssemblyLine."Location Code" = AssemblySetup."In-Production Location" then begin
            If UpdateLocation then
                Error(UpdateLineErr, AssemblyLine.FieldCaption("Location Code"));
            if UpdateQuantity then
                Error(UpdateLineErr, AssemblyLine.FieldCaption("Quantity"));
            if UpdateUOM then
                Error(UpdateLineErr, AssemblyLine.FieldCaption("Unit of Measure Code"));
        end;
    end;

    [EventSubscriber(ObjectType::codeunit, codeunit::"Assembly Line Management", 'OnBeforeUpdateAssemblyLines', '', false, false)]
    local procedure OnBeforeUpdateAssemblyLines(var AsmHeader: Record "Assembly Header"; OldAsmHeader: Record "Assembly Header"; FieldNum: Integer; ReplaceLinesFromBOM: Boolean; CurrFieldNo: Integer; CurrentFieldNum: Integer)
    var
        AssyMgt: Codeunit "ITI AssemblyManagement";
    begin
        AssyMgt.UpdateResidueDimensionsFromAssemblyHeader(AsmHeader);
    end;
}
