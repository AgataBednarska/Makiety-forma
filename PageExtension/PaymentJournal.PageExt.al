pageextension 50134 "Payment Journal N24" extends "Payment Journal"
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
        addafter("Applies-to Doc. Type")
        {
            field("Applies-to Doc. No. N24"; Rec."Applies-to Doc. No.")
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
                ApplicationArea = All;
                Caption = 'Compensation Proposal';
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