codeunit 50106 "ITI T36EventHandler"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'Posting No. Series', false, false)]
    local procedure OnBeforeValidatePostingNoSeries(var Rec: Record "Sales Header")
    var
        DebitNoteMgt: Codeunit "ITI DebitNoteMgt";
    begin
        DebitNoteMgt.ValidatePostingNoSeries(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeValidateEvent', 'External Document No.', false, false)]
    local procedure OnBeforeValidateExternalDocumentNo(var Rec: Record "Sales Header")
    var
        ExternalDocumentNoMgt: Codeunit "ITI ExternalDocumentNoMgt";
        UpdateQst: Label 'Field %1 will not be updated on related assembly orders.\Do you want to continue?';
        ATOLink: Record "Assemble-to-Order Link";
    begin
        ExternalDocumentNoMgt.WasUsed(Rec."External Document No.", true);

        ATOLink.SetRange("Document Type", Rec."Document Type");
        ATOLink.SetRange("Document No.", Rec."No.");
        If ATOLink.FindFirst() then
            If not Confirm(UpdateQst, false, Rec.FieldCaption("External Document No.")) then
                Error('');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure RunOnBeforeInsertEvent(var Rec: Record "Sales Header")
    begin
        Rec."Assigned User ID" := UserId;
    end;
}
