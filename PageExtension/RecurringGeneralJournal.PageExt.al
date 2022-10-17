pageextension 50033 "Recurring General Journal N24" extends "Recurring General Journal"
{
    layout
    {
        modify("Salespers./Purch. Code")
        {
            Visible = true;
        }
        addbefore("ITI VAT Settlement Date")
        {
            field("ITI Doc. Receipt/Sales Date N24"; Rec."ITI Doc. Receipt/Sales Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Document No.")
        {
            field("ITI SAFT Ext. Document No. N24"; Rec."ITI SAFT Ext. Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}