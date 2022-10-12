codeunit 50105 "ITI CU80EventHandler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', FALSE, FALSE)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean)
    begin
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Invoice:
                TestInvoiceFields(SalesHeader);
        end;
    end;

    procedure TestInvoiceFields(var SalesHeader: Record "Sales Header");
    var
        DebitNoteMgt: Codeunit "ITI DebitNoteMgt";
    begin
        DebitNoteMgt.TestHeaderVAT(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterCheckSalesDoc', '', false, false)]
    local procedure OnAfterCheckSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean)
    var
        AssyMgt: Codeunit "ITI AssemblyManagement";
    begin
        SalesHeader.TestField("External Document No.");
        if SalesHeader."Document Type" = "Sales Document Type"::Order then
            AssyMgt.TestATOReleased(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean)
    begin
        if SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice then
            RemoveInvoicedOrdersOfPostedInvoice(SalesInvHdrNo);
    end;

    local procedure RemoveInvoicedOrdersOfPostedInvoice(SalesInvHdrNo: Code[20])
    var
        SalesHeaders: Record "Sales Header";
        SalesInvLine: Record "Sales Invoice Line";
        DeleteInvoicedSalesOrders: Report "Delete Invoiced Sales Orders";
        OrderNoFilter: Text;
    begin
        SalesInvLine.SetRange("Document No.", SalesInvHdrNo);
        if SalesInvLine.FindSet() then
            repeat
                if SalesInvLine."Order No." <> '' then
                    if StrPos(OrderNoFilter, SalesInvLine."Order No.") = 0 then
                        if OrderNoFilter = '' then
                            OrderNoFilter := SalesInvLine."Order No."
                        else
                            OrderNoFilter += '|' + SalesInvLine."Order No.";
            until SalesInvLine.Next() = 0;
        if OrderNoFilter = '' then
            exit;

        SalesHeaders.SetFilter("No.", OrderNoFilter);
        DeleteInvoicedSalesOrders.SetTableView(SalesHeaders);
        DeleteInvoicedSalesOrders.UseRequestPage := false;
        DeleteInvoicedSalesOrders.Run();
    end;
}
