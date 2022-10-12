report 50106 "Compensation Proposal"
{
    // version NAVPL8.00.01

    DefaultLayout = RDLC;
    RDLCLayout = './src/report/RDLC/CompensationProposal.rdlc';

    dataset
    {
        dataitem(GenJournalLine; "Gen. Journal Line")
        {
            // DataItemTableView = SORTING("Document No.", "Posting Date", "Currency Code")
            //                     WHERE(Compensation = CONST(Yes),
            //                           "Account Type"=FILTER(Customer|Vendor));
            DataItemTableView = SORTING("Document No.")
                                WHERE("Account Type" = FILTER(Customer | Vendor));
            RequestFilterFields = "Document No.";
            column(ProposalMainTitle; ProposalMainTitle)
            {
            }
            column(CustomerLine; CustomerLine)
            {
            }
            column(Part_I_Text; Part_I_Text)
            {
            }
            column(Part_II_Text; Part_II_Text)
            {
            }
            column(Part_III_Text; Part_III_Text)
            {
            }
            column(Part_IV_Text; Part_IV_Text)
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
            column(TotalText; TotalText)
            {
            }
            column(Text001; Text001)
            {
            }
            column(Text002; Text002)
            {
            }
            column(Text008; Text008)
            {
            }
            column(Text009; Text009)
            {
            }
            column(Text010; Text010)
            {
            }
            column(Text011; Text011)
            {
            }
            column(Text012; Text012)
            {
            }
            column(Account_Type; AccountType)
            {
            }
            column(Account_No; GenJournalLine."Account No.")
            {
            }
            column(Posting_Date; FORMAT(GenJournalLine."Posting Date"))
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
            column(Document_Type_Caption; GenJournalLine.FIELDCAPTION("Document Type"))
            {
            }
            column(Document_No_Caption; GenJournalLine.FIELDCAPTION("Document No."))
            {
            }
            column(Currency_Code_Caption; GenJournalLine.FIELDCAPTION("Currency Code"))
            {
            }
            column(Account_No_Caption; GenJournalLine.FIELDCAPTION("Account No."))
            {
            }
            column(Amount_Caption; AmountForCompensationText)
            {
            }
            column(Remaining_Amount_Caption; RemainingAmountCaption)
            {
            }
            column(External_Doc_No; GenJournalLine."External Document No.")
            {
            }
            column(External_Doc_No_Caption; GenJournalLine.FIELDCAPTION("External Document No."))
            {
            }

            trigger OnAfterGetRecord();
            begin
                ProposalMainTitle := STRSUBSTNO(ProposalMainTitleLbl, GenJournalLine."Document No.", GenJournalLine."Posting Date");
                MakeContractorText;
                AppDocType := FORMAT("Applies-to Doc. Type");
                AppDocNo := "Applies-to Doc. No.";

                MonetaryClaimText1 := STRSUBSTNO(Text003, CompanyNameText, ContractorNameText);
                MonetaryClaimText2 := STRSUBSTNO(Text004, ContractorNameText, CompanyNameText);

                AccountType := "Account Type".AsInteger();
            end;

            trigger OnPreDataItem();
            begin
                SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CompanyInfo.GET;
        IF CompanyInfo.Name <> '' THEN BEGIN
            CompanyInfoText := CompanyInfoText + CompanyInfo.Name;
            CompanyNameText := CompanyNameText + CompanyInfo.Name;
        END;
        IF CompanyInfo."Name 2" <> '' THEN BEGIN
            CompanyInfoText := CompanyInfoText + ', ' + CompanyInfo."Name 2";
            CompanyNameText := CompanyNameText + ' ' + CompanyInfo."Name 2";
        END;
        IF CompanyInfo.City <> '' THEN
            CompanyInfoText := CompanyInfoText + ', ' + CompanyInfo.City;
        IF CompanyInfo.Address <> '' THEN
            CompanyInfoText := CompanyInfoText + ', ' + CompanyInfo.Address;
        IF CompanyInfo."Address 2" <> '' THEN
            CompanyInfoText := CompanyInfoText + ', ' + CompanyInfo."Address 2";
        CompanyInfoText := CompanyInfoText + ' ' + Text013;
    end;

    var
        GenJnlLine: Record "Gen. Journal Line";
        ProposalMainTitleLbl: label 'Compensation Proposal No. %1 of %2';
        Part_I_Text: label 'I.', Locked = true;
        Part_II_Text: label 'II.', Locked = true;
        Part_III_Text: label 'III.', Locked = true;
        Part_IV_Text: label 'IV.', Locked = true;
        TotalText: label 'Total:';
        Text001: label 'Using this proposal we confirm that all legally required conditions have been satisfied for compensation of monetary claims between:';
        Text002: label 'Compensation contains and applies to the following:';
        Text003: label '1.   Monetary claim of company %1 to company %2 on basis of these documents:';
        Text004: label '2.   Monetary claim of company %1 to company %2 on basis of these documents:';
        Text008: label 'Total amount in this compensation proposal is:';
        Text009: label 'If you confirm Compensation Proposal, please sign it and return one copy back.';
        Text010: label 'On behalf of';
        Text011: label 'Responsible Person: ____________________________';
        Text012: label '(name, surname, signature)';
        Text013: label 'and';
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        Vendor: Record Vendor;
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        AppDocNo: Code[35];
        AmountInclVAT: Decimal;
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        ProposalMainTitle: Text[250];
        CompanyInfoText: Text[250];
        CompanyNameText: Text[100];
        ContractorInfoText: Text[250];
        ContractorNameText: Text[100];
        AppDocType: Text[30];
        MonetaryClaimText1: Text[250];
        MonetaryClaimText2: Text[250];
        CustomerLine: Boolean;
        AmountForCompensationText: label 'Amount for Compensation';
        RemainingAmountCaption: label 'Remaining Amount';

    procedure SetGenJnlLine(TempGenJnlLine: Record "Gen. Journal Line");
    begin
        GenJnlLine := TempGenJnlLine;
    end;

    procedure MakeContractorText();
    begin
        IF NOT Customer.GET(GenJournalLine."Account No.") THEN
            Customer.INIT;
        IF NOT Vendor.GET(GenJournalLine."Account No.") THEN
            Vendor.INIT;
        ContractorInfoText := '';
        ContractorNameText := '';
        IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer THEN BEGIN
            IF Customer.Name <> '' THEN BEGIN
                ContractorInfoText := ContractorInfoText + Customer.Name;
                ContractorNameText := ContractorNameText + Customer.Name;
            END;
            IF Customer."Name 2" <> '' THEN BEGIN
                ContractorInfoText := ContractorInfoText + ', ' + Customer."Name 2";
                ContractorNameText := ContractorNameText + ' ' + Customer."Name 2";
            END;
            IF Customer.City <> '' THEN
                ContractorInfoText := ContractorInfoText + ', ' + Customer.City;
            IF Customer.Address <> '' THEN
                ContractorInfoText := ContractorInfoText + ', ' + Customer.Address;
            IF Customer."Address 2" <> '' THEN
                ContractorInfoText := ContractorInfoText + ', ' + Customer."Address 2";

            CustLedgEntry.RESET;
            CustLedgEntry.SETRANGE("Document Type", GenJournalLine."Applies-to Doc. Type");
            CustLedgEntry.SETRANGE("Document No.", GenJournalLine."Applies-to Doc. No.");
            IF CustLedgEntry.FINDFIRST THEN
                CustLedgEntry.CALCFIELDS("Remaining Amount");
            AmountInclVAT := CustLedgEntry."Remaining Amount";
            CustomerLine := TRUE;
            GenJournalLine.Amount := -GenJournalLine.Amount;
        END;

        IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor THEN BEGIN
            IF Vendor.Name <> '' THEN BEGIN
                ContractorInfoText := ContractorInfoText + Vendor.Name;
                ContractorNameText := ContractorNameText + Vendor.Name;
            END;
            IF Vendor."Name 2" <> '' THEN BEGIN
                ContractorInfoText := ContractorInfoText + ', ' + Vendor."Name 2";
                ContractorNameText := ContractorNameText + ' ' + Vendor."Name 2";
            END;
            IF Vendor.City <> '' THEN
                ContractorInfoText := ContractorInfoText + ', ' + Vendor.City;
            IF Vendor.Address <> '' THEN
                ContractorInfoText := ContractorInfoText + ', ' + Vendor.Address;
            IF Vendor."Address 2" <> '' THEN
                ContractorInfoText := ContractorInfoText + ', ' + Vendor."Address 2";

            VendLedgEntry.RESET;
            VendLedgEntry.SETRANGE("Document Type", GenJournalLine."Applies-to Doc. Type");
            VendLedgEntry.SETRANGE("Document No.", GenJournalLine."Applies-to Doc. No.");
            IF VendLedgEntry.FINDFIRST THEN
                VendLedgEntry.CALCFIELDS("Remaining Amount");
            AmountInclVAT := -VendLedgEntry."Remaining Amount";
            CustomerLine := FALSE;
        END;
    end;
}

