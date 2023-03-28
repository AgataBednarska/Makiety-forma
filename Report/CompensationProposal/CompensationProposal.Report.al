report 50102 "Compensation Proposal N24"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/CompensationProposal/CompensationProposal.rdlc';
    UsageCategory = None;

    dataset
    {
        dataitem(GenJournalLine; "Gen. Journal Line")
        {
            DataItemTableView = sorting("Document No.")
                                where("Account Type" = filter(Customer | Vendor));
            RequestFilterFields = "Document No.";
            column(ProposalMainTitle; ProposalMainTitle)
            {
            }
            column(CustomerLine; CustomerLine)
            {
            }
            column(Part_I_Text; Part_I_Txt)
            {
            }
            column(Part_II_Text; Part_II_Txt)
            {
            }
            column(Part_III_Text; Part_III_Txt)
            {
            }
            column(Part_IV_Text; Part_IV_Txt)
            {
            }
            column(CompanyInfoText; CompanyInfoText)
            {
            }
            column(ContractorInfoText; ContractorInfoText)
            {
            }
            column(MonetaryClaimText1; MonetaryClaimText1)
            {
            }
            column(MonetaryClaimText2; MonetaryClaimText2)
            {
            }
            column(CompanyNameText; CompanyNameText)
            {
            }
            column(ContractorNameText; ContractorNameText)
            {
            }
            column(TotalText; TotalLbl)
            {
            }
            column(Text001; UsingThisProposalLbl)
            {
            }
            column(Text002; CompensationContainsLbl)
            {
            }
            column(Text008; TotalAmountLbl)
            {
            }
            column(Text009; CompensationProposalMsg)
            {
            }
            column(Text010; OnbehalfofLbl)
            {
            }
            column(Text011; ResponsiblePersonLbl)
            {
            }
            column(Text012; SignatureLbl)
            {
            }
            column(Account_Type; AccountType)
            {
            }
            column(Account_No; GenJournalLine."Account No.")
            {
            }
            column(Posting_Date; Format(GenJournalLine."Posting Date"))
            {
            }
            column(Document_No; GenJournalLine."Document No.")
            {
            }
            column(Currency_Code; GenJournalLine."Currency Code")
            {
            }
            column(Amount; GenJournalLine.Amount)
            {
            }
            column(AppDocType; AppDocType)
            {
            }
            column(AppDocNo; AppDocNo)
            {
            }
            column(AmountInclVAT; AmountInclVAT)
            {
            }
            column(Document_Type_Caption; GenJournalLine.FieldCaption("Document Type"))
            {
            }
            column(Document_No_Caption; GenJournalLine.FieldCaption("Document No."))
            {
            }
            column(Currency_Code_Caption; GenJournalLine.FieldCaption("Currency Code"))
            {
            }
            column(Account_No_Caption; GenJournalLine.FieldCaption("Account No."))
            {
            }
            column(Amount_Caption; AmountForCompensationTxt)
            {
            }
            column(Remaining_Amount_Caption; RemainingAmountLbl)
            {
            }
            column(External_Doc_No; GenJournalLine."External Document No.")
            {
            }
            column(External_Doc_No_Caption; GenJournalLine.FieldCaption("External Document No."))
            {
            }

            trigger OnAfterGetRecord();
            begin
                ProposalMainTitle := StrSubstNo(ProposalMainTitleLbl, GenJournalLine."Document No.", GenJournalLine."Posting Date");

                MakeContractorText();

                AppDocType := Format("Applies-to Doc. Type");
                AppDocNo := "Applies-to Doc. No.";

                MonetaryClaimText1 := StrSubstNo(MonetaryClaim1Lbl, CompanyNameText, ContractorNameText);
                MonetaryClaimText2 := StrSubstNo(MonetaryClaim2Lbl, ContractorNameText, CompanyNameText);

                AccountType := "Account Type".AsInteger();
            end;

            trigger OnPreDataItem();
            begin
                SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            end;
        }
    }

    trigger OnPreReport();
    begin
        CompanyInformation.Get();

        if CompanyInformation.Name <> '' then begin
            CompanyInfoText := CopyStr(CompanyInfoText + CompanyInformation.Name, 1, MaxStrLen(CompanyInfoText));
            CompanyNameText := CopyStr(CompanyNameText + CompanyInformation.Name, 1, MaxStrLen(CompanyNameText));
        end;

        if CompanyInformation."Name 2" <> '' then begin
            CompanyInfoText := CopyStr(CompanyInfoText + ', ' + CompanyInformation."Name 2", 1, MaxStrLen(CompanyInfoText));
            CompanyNameText := CopyStr(CompanyNameText + ' ' + CompanyInformation."Name 2", 1, MaxStrLen(CompanyNameText));
        end;

        if CompanyInformation.City <> '' then
            CompanyInfoText := CopyStr(CompanyInfoText + ', ' + CompanyInformation.City, 1, MaxStrLen(CompanyInfoText));

        if CompanyInformation.Address <> '' then
            CompanyInfoText := CopyStr(CompanyInfoText + ', ' + CompanyInformation.Address, 1, MaxStrLen(CompanyInfoText));

        if CompanyInformation."Address 2" <> '' then
            CompanyInfoText := CopyStr(CompanyInfoText + ', ' + CompanyInformation."Address 2", 1, MaxStrLen(CompanyInfoText));

        CompanyInfoText := CopyStr(CompanyInfoText + ' ' + AndLbl, 1, MaxStrLen(CompanyInfoText));
    end;

    var
        CompanyInformation: Record "Company Information";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Customer: Record Customer;
        GenJnlLine: Record "Gen. Journal Line";
        Vendor: Record Vendor;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CustomerLine: Boolean;
        AppDocNo: Code[35];
        AmountInclVAT: Decimal;
        AccountType: Enum "Gen. Journal Account Type";
        AmountForCompensationTxt: Label 'Amount for Compensation';
        AndLbl: Label 'and';
        CompensationContainsLbl: Label 'Compensation contains and applies to the following:';
        CompensationProposalMsg: Label 'If you confirm Compensation Proposal, please sign it and return one copy back.';
        MonetaryClaim1Lbl: Label '1.   Monetary claim of company %1 to company %2 on basis of these documents:', Comment = '%1 - CompanyNameText, %2 - ContractorNameText';
        MonetaryClaim2Lbl: Label '2.   Monetary claim of company %1 to company %2 on basis of these documents:', Comment = '%1 - CompanyNameText, %2 - ContractorNameText';
        OnbehalfofLbl: Label 'On behalf of';
        Part_I_Txt: Label 'I.', Locked = true;
        Part_II_Txt: Label 'II.', Locked = true;
        Part_III_Txt: Label 'III.', Locked = true;
        Part_IV_Txt: Label 'IV.', Locked = true;
        ProposalMainTitleLbl: Label 'Compensation Proposal No. %1 of %2', Comment = '%1 - GenJournalLine."Document No.", %2 - GenJournalLine."Posting Date"';
        RemainingAmountLbl: Label 'Remaining Amount';
        ResponsiblePersonLbl: Label 'Responsible Person: ____________________________';
        SignatureLbl: Label '(name, surname, signature)';
        TotalAmountLbl: Label 'Total amount in this compensation proposal is:';
        TotalLbl: Label 'Total:';
        UsingThisProposalLbl: Label 'Using this proposal we confirm that all legally required conditions have been satisfied for compensation of monetary claims between:';
        AppDocType: Text[30];
        CompanyNameText: Text[100];
        ContractorNameText: Text[100];
        CompanyInfoText: Text[250];
        ContractorInfoText: Text[250];
        MonetaryClaimText1: Text[250];
        MonetaryClaimText2: Text[250];
        ProposalMainTitle: Text[250];

    procedure SetGenJnlLine(TempGenJnlLine: Record "Gen. Journal Line");
    begin
        GenJnlLine := TempGenJnlLine;
    end;

    procedure MakeContractorText();
    begin
        if not Customer.Get(GenJournalLine."Account No.") then
            Customer.Init();

        if not Vendor.Get(GenJournalLine."Account No.") then
            Vendor.Init();

        ContractorInfoText := '';
        ContractorNameText := '';

        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer then begin
            if Customer.Name <> '' then begin
                ContractorInfoText := CopyStr(ContractorInfoText + Customer.Name, 1, MaxStrLen(ContractorInfoText));
                ContractorNameText := CopyStr(ContractorNameText + Customer.Name, 1, MaxStrLen(ContractorNameText));
            end;
            if Customer."Name 2" <> '' then begin
                ContractorInfoText := CopyStr(ContractorInfoText + ', ' + Customer."Name 2", 1, MaxStrLen(ContractorInfoText));
                ContractorNameText := CopyStr(ContractorNameText + ' ' + Customer."Name 2", 1, MaxStrLen(ContractorNameText));
            end;

            if Customer.City <> '' then
                ContractorInfoText := CopyStr(ContractorInfoText + ', ' + Customer.City, 1, MaxStrLen(ContractorInfoText));

            if Customer.Address <> '' then
                ContractorInfoText := CopyStr(ContractorInfoText + ', ' + Customer.Address, 1, MaxStrLen(ContractorInfoText));
            if Customer."Address 2" <> '' then
                ContractorInfoText := CopyStr(ContractorInfoText + ', ' + Customer."Address 2", 1, MaxStrLen(ContractorInfoText));

            CustLedgEntry.Reset();
            CustLedgEntry.SetRange("Document Type", GenJournalLine."Applies-to Doc. Type");
            CustLedgEntry.SetRange("Document No.", GenJournalLine."Applies-to Doc. No.");
            if CustLedgEntry.FindFirst() then
                CustLedgEntry.CalcFields("Remaining Amount");

            AmountInclVAT := CustLedgEntry."Remaining Amount";
            CustomerLine := true;
            GenJournalLine.Amount := -GenJournalLine.Amount;
        end;

        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor then begin
            if Vendor.Name <> '' then begin
                ContractorInfoText := CopyStr(ContractorInfoText + Vendor.Name, 1, MaxStrLen(ContractorInfoText));
                ContractorNameText := CopyStr(ContractorNameText + Vendor.Name, 1, MaxStrLen(ContractorNameText));
            end;
            if Vendor."Name 2" <> '' then begin
                ContractorInfoText := CopyStr(ContractorInfoText + ', ' + Vendor."Name 2", 1, MaxStrLen(ContractorInfoText));
                ContractorNameText := CopyStr(ContractorNameText + ' ' + Vendor."Name 2", 1, MaxStrLen(ContractorNameText));
            end;

            if Vendor.City <> '' then
                ContractorInfoText := CopyStr(ContractorInfoText + ', ' + Vendor.City, 1, MaxStrLen(ContractorInfoText));

            if Vendor.Address <> '' then
                ContractorInfoText := CopyStr(ContractorInfoText + ', ' + Vendor.Address, 1, MaxStrLen(ContractorInfoText));

            if Vendor."Address 2" <> '' then
                ContractorInfoText := CopyStr(ContractorInfoText + ', ' + Vendor."Address 2", 1, MaxStrLen(ContractorInfoText));

            VendorLedgerEntry.Reset();
            VendorLedgerEntry.SetRange("Document Type", GenJournalLine."Applies-to Doc. Type");
            VendorLedgerEntry.SetRange("Document No.", GenJournalLine."Applies-to Doc. No.");
            if VendorLedgerEntry.FindFirst() then
                VendorLedgerEntry.CalcFields("Remaining Amount");

            AmountInclVAT := -VendorLedgerEntry."Remaining Amount";
            CustomerLine := false;
        end;
    end;
}