codeunit 50110 "ITI CU442 EventHandler"
{
    Permissions = tabledata 113 = rimd,
                  tabledata 115 = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post Prepayments", 'OnAfterCreateLinesOnBeforeGLPosting', '', false, false)]
    local procedure OnAfterCreateLinesOnBeforeGLPosting(var SalesHeader: Record "Sales Header"; SalesInvHeader: Record "Sales Invoice Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var TempPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer" temporary; DocumentType: Option Invoice,"Credit Memo"; var LastLineNo: Integer)
    var
        SalesLine: Record "Sales Line";
        CommentsHeader: Label 'Advance concerns order lines:';
    begin
        Salesline.SetRange("Document Type", SalesHeader."Document Type");
        Salesline.SetRange("Document No.", SalesHeader."No.");
        If SalesLine.FindSet() then begin
            LastLineNo += 10000;
            case DocumentType of
                DocumentType::Invoice:
                    InsertSalesInvCommentLine(SalesInvHeader, LastLineNo, CommentsHeader);
                DocumentType::"Credit Memo":
                    InsertSalesCrMemoCommentLine(SalesCrMemoHeader, LastLineNo, CommentsHeader);
            end;

            repeat
                LastLineNo += 10000;
                case DocumentType of
                    DocumentType::Invoice:
                        InsertSalesInvCommentLine(SalesInvHeader, LastLineNo, SalesLine.Description);
                    DocumentType::"Credit Memo":
                        InsertSalesCrMemoCommentLine(SalesCrMemoHeader, LastLineNo, SalesLine.Description);
                end;
            until SalesLine.next = 0;
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
