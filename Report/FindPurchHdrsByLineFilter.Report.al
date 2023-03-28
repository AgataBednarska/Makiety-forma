report 50106 "FindPurchHdrsByLineFilter N24"
{
    ApplicationArea = All;
    Caption = 'Find Purchase Headers by Line Filter';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(PurchInvHeader; "Purch. Inv. Header")
        {
            dataitem(PurchInvLine; "Purch. Inv. Line")
            {
                RequestFilterFields = Description;

                trigger OnAfterGetRecord()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                begin
                    if not TempPurchInvHeader.Get("Document No.") then begin
                        PurchInvHeader.Get("Document No.");
                        TempPurchInvHeader := PurchInvHeader;
                        TempPurchInvHeader.Insert();
                    end;
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;
    }

    trigger OnPostReport()
    var
        DocumentNoFilter: Text;
    begin
        if TempPurchInvHeader.FindSet() then begin
            DocumentNoFilter := TempPurchInvHeader."No.";

            if TempPurchInvHeader.Next() <> 0 then
                repeat
                    DocumentNoFilter += '|' + TempPurchInvHeader."No.";
                until TempPurchInvHeader.Next() = 0;

            FilteredPurchInvHeader.SetFilter("No.", DocumentNoFilter);
        end;
    end;

    procedure GetFilteredPurchInvHeader(var RecPurchInvHeader: Record "Purch. Inv. Header")
    begin
        FilteredPurchInvHeader.CopyFilter("No.", RecPurchInvHeader."No.");
    end;

    var
        FilteredPurchInvHeader: Record "Purch. Inv. Header";
        TempPurchInvHeader: Record "Purch. Inv. Header" temporary;
}