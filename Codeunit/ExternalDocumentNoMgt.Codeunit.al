codeunit 50010 "ExternalDocumentNoMgt N24"
{
    procedure ExternalDocumentNoWasUsed(ExternalDocumentNo: Code[35]; ShowMessage: Boolean): Boolean
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        DocCount: Integer;
        DocList2ValuesTok: Label '\• %1 %2', Locked = true;
        DocList3ValuesTok: Label '\• %1, %2 %3', Locked = true;
        FoundDocMsg: Label 'External Document No. %1 has been found in %2 documents:\', Comment = '%1 - Ext. Doc. No, %2 - No. of documents';
        DocList: Text;
    begin
        if ExternalDocumentNo = '' then
            exit(false);

        SalesHeader.SetRange("External Document No.", ExternalDocumentNo);
        if SalesHeader.FindSet() then
            repeat
                DocCount += 1;
                DocList += StrSubstNo(DocList3ValuesTok, SalesHeader.TableCaption, SalesHeader."Document Type", SalesHeader."No.");
            until SalesHeader.Next() = 0;

        SalesInvHeader.SetRange("External Document No.", ExternalDocumentNo);
        if SalesInvHeader.FindSet() then
            repeat
                DocCount += 1;
                DocList += StrSubstNo(DocList2ValuesTok, SalesInvHeader.TableCaption, SalesInvHeader."No.");
            until SalesHeader.Next() = 0;

        SalesCrMemoHeader.SetRange("External Document No.", ExternalDocumentNo);
        if SalesCrMemoHeader.FindSet() then
            repeat
                DocCount += 1;
                DocList += StrSubstNo(DocList2ValuesTok, SalesCrMemoHeader.TableCaption, SalesCrMemoHeader."No.");
            until SalesHeader.Next() = 0;

        if DocCount > 0 then begin
            if ShowMessage then
                Message(StrSubstNo(FoundDocMsg, ExternalDocumentNo, DocCount) + DocList);

            exit(true);
        end else
            exit(false);
    end;

    procedure InsertSalesLineForExternalDocumentNo(var SalesLine: Record "Sales Line"; ExternalDocNo: Code[35]; var NextLineNo: Integer)
    var
        SalesLine2: Record "Sales Line";
        ExtDocNoLbl: Label 'Ext. Document No. %1:', Comment = '%1 - Ext. Document No.';
    begin
        SalesLine2.Copy(SalesLine);
        SalesLine2."Line No." := NextLineNo;
        SalesLine2.Description := StrSubstNo(ExtDocNoLbl, ExternalDocNo);
        SalesLine2.Insert();

        NextLineNo := NextLineNo + 10000;
        SalesLine."Line No." := NextLineNo;
    end;

    procedure CheckExternalDocNoAlreadyExistsAndCreatenewSalesLine(var ToSalesLine: Record "Sales Line"; OldDocType: Option; OldDocNo: Code[20])
    var
        ReturnReceiptHeader: Record "Return Receipt Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesLine2: Record "Sales Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        ExtDocNo: Code[35];
        ExtDocNoLbl: Label 'Ext. Document No. %1:', Comment = '%1 - Ext. Document No.';
        FromDocType: Option "Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo";
    begin
        case (OldDocType - 1) of
            FromDocType::"Sales Shipment":
                if SalesShipmentHeader.Get(OldDocNo) then
                    ExtDocNo := SalesShipmentHeader."External Document No.";
            FromDocType::"Sales Invoice":
                if SalesInvoiceHeader.Get(OldDocNo) then
                    ExtDocNo := SalesInvoiceHeader."External Document No.";
            FromDocType::"Sales Return Receipt":
                if ReturnReceiptHeader.Get(OldDocNo) then
                    ExtDocNo := ReturnReceiptHeader."External Document No.";
            FromDocType::"Sales Credit Memo":
                if SalesCrMemoHeader.Get(OldDocNo) then
                    ExtDocNo := SalesCrMemoHeader."External Document No.";
        end;

        if ExtDocNo <> '' then begin
            SalesLine2.Copy(ToSalesLine);
            SalesLine2."Line No." -= 1000;
            SalesLine2.Description := StrSubstNo(ExtDocNoLbl, ExtDocNo);
            SalesLine2.Insert();
        end;
    end;
}