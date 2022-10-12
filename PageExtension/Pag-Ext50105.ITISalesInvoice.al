pageextension 50105 "ITI Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        modify("Sell-to Customer No.")
        {
            Importance = Promoted;
        }
        addbefore("Sell-to")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Debit Note"; Rec."Debit Note")
            {
                ApplicationArea = All;
                Importance = Standard;

                trigger OnValidate();
                var
                    DebitNoteMgt: Codeunit "ITI DebitNoteMgt";
                begin
                    if (Rec."Document Type" = Rec."Document Type"::Invoice) and
                    (rec."Debit Note")
                    then
                        DebitNoteMgt.TestHeaderVAT(Rec);
                end;

            }

        }
        addafter("Work Description")
        {
            group(CommentsGroup)
            {
                Caption = 'Comments';
            }
        }
        movefirst(CommentsGroup; WorkDescription)

    }
}
