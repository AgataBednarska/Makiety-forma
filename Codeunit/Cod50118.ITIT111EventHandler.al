codeunit 50118 "ITI T111EventHandler"
{
    [EventSubscriber(ObjectType::table, Database::"Sales Shipment Line", 'OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromShptLineBeforeInsertTextLine(var SalesShptLine: Record "Sales Shipment Line"; var SalesLine: Record "Sales Line"; var NextLineNo: Integer; var Handled: Boolean)
    var
        SalesLine2: Record "Sales Line";
        ExtDocNoText: Label 'Ext. Document No. %1:';
    begin
        SalesLine2.copy(SalesLine);
        SalesShptLine.CalcFields("External Document No.");
        SalesLine2."Line No." := NextLineNo;
        SalesLine2.Description := StrSubstNo(ExtDocNoText, SalesShptLine."External Document No.");
        SalesLine2.Insert();

        NextLineNo := NextLineNo + 10000;
        SalesLine."Line No." := NextLineNo;
    end;
}
