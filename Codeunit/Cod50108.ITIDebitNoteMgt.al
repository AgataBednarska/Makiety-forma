codeunit 50108 "ITI DebitNoteMgt"
{
    procedure TestLineVAT(SalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");

        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) and
           (SalesHeader."Debit Note") and
           (SalesLine."VAT %" <> 0)
        then
            Error(DebitNoteVATPercentErr);
    end;

    procedure TestHeaderVAT(SalesHeader: Record "Sales Header");
    var
        SalesLine: Record "Sales line";
    begin
        if (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) and
           (SalesHeader."Debit Note")
        then begin
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetFilter("VAT %", '<>0');
            if not SalesLine.IsEmpty() then
                Error(DebitNoteVATPercentErr);
        end;
    end;

    procedure ValidatePostingNoSeries(var Rec: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        CantChangeNoSeriesForDebitNoteErr: Label 'Can''t change the No. Series, when Debit Note is selected!';
    begin
        if Rec."Document Type" <> Rec."Document Type"::Invoice then
            EXIT;

        SalesSetup.Get();
        IF (Rec."Debit Note") AND
           (Rec."Posting No. Series" <> SalesSetup."Posted Debit Note Nos.") THEN
            ERROR(CantChangeNoSeriesForDebitNoteErr);
        Rec."Debit note" := (Rec."Posting No. Series" = SalesSetup."Posted Debit Note Nos.");
    end;

    procedure ValidateDebitNote(var Rec: Record "Sales Header");
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        SalesSetup.GET;
        IF Rec."Debit note" then begin
            SalesSetup.TestField("Posted Debit Note Nos.");
            Rec."Posting No. Series" := SalesSetup."Posted Debit Note Nos.";
        end else begin
            SalesHeader := Rec;
            SalesSetup.GET;
            SalesHeader.TestNoSeries;
            if NoSeriesMgt.LookupSeries(GetPostingNoSeriesCode(Rec), SalesHeader."Posting No. Series") then
                SalesHeader.VALIDATE("Posting No. Series")
            else
                //SalesHeader.VALIDATE("Posting No. Series", '');
                error('');
            Rec := SalesHeader;
        end;
    end;

    local procedure GetPostingNoSeriesCode(var Rec: Record "Sales Header") PostingNos: Code[20]
    // Copy of function in T36. No events handling
    var
        SalesSetup: Record "Sales & Receivables Setup";
    // IsHandled: Boolean;
    begin
        // GetSalesSetup;
        // IsHandled := false;
        // OnBeforeGetPostingNoSeriesCode(Rec, SalesSetup, PostingNos, IsHandled);
        // if IsHandled then
        //     exit;

        SalesSetup.GET;

        if Rec.IsCreditDocType then
            PostingNos := SalesSetup."Posted Credit Memo Nos."
        else
            PostingNos := SalesSetup."Posted Invoice Nos.";

        // OnAfterGetPostingNoSeriesCode(Rec, PostingNos);
    end;

    var
        DebitNoteVATPercentErr: Label 'VAT must be 0% on lines of Debit Note. Check VAT Posting groups';

}