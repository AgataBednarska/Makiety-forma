pageextension 50132 "ITI GeneralJournal" extends "General Journal"
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
        addlast(control1)
        {
            field("Due Date"; Rec."Due Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action(CompensationProposal)
            {
                Caption = 'Compensation Proposal';
                ApplicationArea = All;
                Image = PrintAcknowledgement;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    CompensationProposal: Report "Compensation Proposal";
                begin
                    CompensationProposal.SetGenJnlLine(Rec);
                    CompensationProposal.RUNMODAL;
                end;
            }
        }
    }
}
