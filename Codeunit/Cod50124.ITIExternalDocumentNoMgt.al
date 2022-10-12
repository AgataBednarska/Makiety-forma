codeunit 50124 "ITI ExternalDocumentNoMgt"
{
    trigger OnRun()
    begin

    end;

    procedure WasUsed(ExternalDocumentNo: Code[35]; ShowMessage: Boolean): Boolean
    var
        DocList: Text;
        SalesHeader: Record "Sales Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        DocCount: Integer;
        FoundDocMsg: Label 'External Document No. %1 has been found in %2 documents:\';
    begin
        if ExternalDocumentNo = '' then
            exit(false);

        SalesHeader.SetRange("External Document No.", ExternalDocumentNo);
        if SalesHeader.FindSet() then
            repeat
                DocCount += 1;
                DocList += StrSubstNo('\• %1, %2 %3', SalesHeader.TableCaption, SalesHeader."Document Type", SalesHeader."No.");
            until SalesHeader.Next() = 0;

        SalesInvHeader.SetRange("External Document No.", ExternalDocumentNo);
        if SalesInvHeader.FindSet() then
            repeat
                DocCount += 1;
                DocList += StrSubstNo('\• %1 %2', SalesInvHeader.TableCaption, SalesInvHeader."No.");
            until SalesHeader.Next() = 0;

        SalesCrMemoHeader.SetRange("External Document No.", ExternalDocumentNo);
        if SalesCrMemoHeader.FindSet() then
            repeat
                DocCount += 1;
                DocList += StrSubstNo('\• %1 %2', SalesCrMemoHeader.TableCaption, SalesCrMemoHeader."No.");
            until SalesHeader.Next() = 0;

        If DocCount > 0 then begin
            if ShowMessage then
                Message(strsubstno(FoundDocMsg, ExternalDocumentNo, DocCount) + DocList);
            exit(true);
        end else
            exit(false);
    end;

    var
        myInt: Integer;
}