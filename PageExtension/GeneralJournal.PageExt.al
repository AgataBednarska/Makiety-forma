pageextension 50032 "General Journal N24" extends "General Journal"
{
    layout
    {
        modify("Salespers./Purch. Code")
        {
            Visible = true;
        }
        modify("Applies-to Doc. Type")
        {
            Visible = true;
        }
        modify("Applies-to Doc. No.")
        {
            Visible = true;
        }
        modify("Applies-to Ext. Doc. No.")
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
        addlast(Control1)
        {
            field("Due Date N24"; Rec."Due Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action("CompensationProposal N24")
            {
                Caption = 'Compensation Proposal';
                ApplicationArea = All;
                Image = PrintAcknowledgement;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    CompensationProposal: Report "Compensation Proposal N24";
                begin
                    CompensationProposal.SetGenJnlLine(Rec);
                    CompensationProposal.RunModal();
                end;
            }
        }
    }
}
