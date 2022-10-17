codeunit 50007 "SalesMgt N24"
{
    procedure RemoveInvoicedOrdersOfPostedInvoice(SalesInvHdrNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
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

        SalesHeader.SetFilter("No.", OrderNoFilter);
        DeleteInvoicedSalesOrders.SetTableView(SalesHeader);
        DeleteInvoicedSalesOrders.UseRequestPage := false;
        DeleteInvoicedSalesOrders.Run();
    end;

    procedure InsertCommentsToPostedSaleslines(var SalesHeader: Record "Sales Header"; SalesInvHeader: Record "Sales Invoice Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; DocumentType: Option Invoice,"Credit Memo"; var LastLineNo: Integer)
    var
        SalesLine: Record "Sales Line";
        CommentsHeaderLbl: Label 'Advance concerns order lines:';
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then begin
            LastLineNo += 10000;

            case DocumentType of
                DocumentType::Invoice:
                    InsertSalesInvCommentLine(SalesInvHeader, LastLineNo, CommentsHeaderLbl);
                DocumentType::"Credit Memo":
                    InsertSalesCrMemoCommentLine(SalesCrMemoHeader, LastLineNo, CommentsHeaderLbl);
            end;

            repeat
                LastLineNo += 10000;

                case DocumentType of
                    DocumentType::Invoice:
                        InsertSalesInvCommentLine(SalesInvHeader, LastLineNo, SalesLine.Description);
                    DocumentType::"Credit Memo":
                        InsertSalesCrMemoCommentLine(SalesCrMemoHeader, LastLineNo, SalesLine.Description);
                end;
            until SalesLine.Next() = 0;
        end;
    end;

    local procedure InsertSalesInvCommentLine(SalesInvHeader: Record "Sales Invoice Header"; LineNo: Integer; Comment: Text[100])
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        SalesInvLine.Init();
        SalesInvLine."Document No." := SalesInvHeader."No.";
        SalesInvLine."Line No." := LineNo;
        SalesInvLine."Sell-to Customer No." := SalesInvHeader."Sell-to Customer No.";
        SalesInvLine."Bill-to Customer No." := SalesInvHeader."Bill-to Customer No.";
        SalesInvLine.Type := SalesInvLine.Type::" ";
        SalesInvLine."Posting Date" := SalesInvHeader."Posting Date";
        SalesInvLine.Description := Comment;
        SalesInvLine.Insert();
    end;

    local procedure InsertSalesCrMemoCommentLine(SalesCrMemoHeader: Record "Sales Cr.Memo Header"; LineNo: Integer; Comment: Text[100])
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        SalesCrMemoLine.Init();
        SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
        SalesCrMemoLine."Line No." := LineNo;
        SalesCrMemoLine."Sell-to Customer No." := SalesCrMemoHeader."Sell-to Customer No.";
        SalesCrMemoLine."Bill-to Customer No." := SalesCrMemoHeader."Bill-to Customer No.";
        SalesCrMemoLine.Type := SalesCrMemoLine.Type::" ";
        SalesCrMemoLine."Posting Date" := SalesCrMemoHeader."Posting Date";
        SalesCrMemoLine.Description := Comment;
        SalesCrMemoLine.Insert();
    end;
}