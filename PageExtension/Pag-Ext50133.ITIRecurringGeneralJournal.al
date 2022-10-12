pageextension 50133 "ITI RecurringGeneralJournal" extends "Recurring General Journal"
{
    layout
    {
        modify("Salespers./Purch. Code")
        {
            Visible = true;
        }
        addbefore("ITI VAT Settlement Date")
        {
            field("ITI Doc. Receipt/Sales Date"; Rec."ITI Doc. Receipt/Sales Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Document No.")
        {
            field("ITI SAFT Ext. Document No."; Rec."ITI SAFT Ext. Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
