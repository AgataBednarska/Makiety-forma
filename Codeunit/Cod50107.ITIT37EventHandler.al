codeunit 50107 "ITI T37EventHandler"
{
    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEvent(VAR Rec: Record "Sales Line")
    var
        DebitNoteMgt: Codeunit "ITI DebitNoteMgt";
    begin
        case Rec."Document Type" of
            Rec."Document Type"::Invoice:
                DebitNoteMgt.TestLineVAT(Rec);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEvent(VAR Rec: Record "Sales Line")
    var
        DebitNoteMgt: Codeunit "ITI DebitNoteMgt";
    begin
        case Rec."Document Type" of
            Rec."Document Type"::Invoice:
                DebitNoteMgt.TestLineVAT(Rec);
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Sales Line", 'OnBeforeValidateEvent', 'Qty. to Assemble to Order', false, false)]
    local procedure RunOnBeforeValidateQuantityEvent(VAR Rec: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        if Rec."Qty. to Assemble to Order" > 0 then begin
            SalesHeader.get(rec."Document Type", rec."Document No.");
            SalesHeader.TestField("External Document No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'No.', false, false)]
    local procedure OnBeforeValidateNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        SalesHeader: Record "Sales Header";
    begin
        if Rec.Type = Rec.Type::Item then
            if SalesHeader.get(Rec."Document Type", Rec."Document No.") then
                SalesHeader.TestField("Location Code");
    end;
}
