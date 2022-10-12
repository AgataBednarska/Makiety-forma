codeunit 50119 "ITI T6661EventHandler"
{
    [EventSubscriber(ObjectType::table, Database::"Return Receipt Line", 'OnBeforeInsertInvLineFromRetRcptLineBeforeInsertTextLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromRetRcptLineBeforeInsertTextLine(var ReturnReceiptLine: Record "Return Receipt Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var IsHandled: Boolean)
    var
        SalesLine2: Record "Sales Line";
        ExtDocNoText: Label 'Ext. Document No. %1:';
    begin
        SalesLine2.copy(SalesLine);
        ReturnReceiptLine.CalcFields("External Document No.");
        SalesLine2."Line No." := NextLineNo;
        SalesLine2.Description := StrSubstNo(ExtDocNoText, ReturnReceiptLine."External Document No.");
        SalesLine2.Insert();

        NextLineNo := NextLineNo + 10000;
        SalesLine."Line No." := NextLineNo;
    end;
}
