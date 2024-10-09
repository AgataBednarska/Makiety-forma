pageextension 50148 "Assembly Order N24" extends "Assembly Order"
{
    layout
    {
        modify(Lines)
        {
            Caption = 'Assembly Lines (Expense journal)';
        }
        addlast(Control2)
        {
            field("External Document No. N24"; Rec."External Document No. N24")
            {
                ApplicationArea = All;
                Editable = not Rec."Assemble to Order";
            }
            field("Transfers N24"; Rec."Item Transfer Entries N24")
            {
                ApplicationArea = All;
            }
        }
        addafter(Lines)
        {
            part(ResidueSubform; "AssyOrderResidueSubform N24")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
        addafter("No.")
        {
            field("Posting No. Series N24"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                Editable = not Rec."Assemble to Order";
            }
        }
        modify("ITI Gen. Bus. Posting Group")
        {
            Editable = false;
        }
    }

    actions
    {
        addlast("F&unctions")
        {
            action("PostExpenseAndRevenue N24")
            {
                ApplicationArea = All;
                Caption = 'Post Expense and Revenue';
                Image = PostInventoryToGL;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ToolTip = 'Post transfer of used items to in-production location and residue positive adjustment.';

                trigger OnAction()
                var
                    AssemblyMgtN24: Codeunit "AssemblyMgt N24";
                    ConfirmManagement: Codeunit "Confirm Management";
                    OrderAssembledErr: Label 'The Assembly Order %1 is completed', Comment = '%1 - Assembly Order';
                    PostTransferAdjustmentQst: Label 'Do you want to post transfer of used items to in-production location and residue positive adjustment?';
                begin
                    if Rec."Remaining Quantity" = 0 then
                        Error(OrderAssembledErr, Rec."No.");

                    if ConfirmManagement.GetResponse(PostTransferAdjustmentQst, false) then begin
                        AssemblyMgtN24.PostTransferLines(Rec);
                        AssemblyMgtN24.PostResidueLines(Rec);

                        CurrPage.Update();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.ResidueSubform.Page.SetAssemblyHeader(Rec);
    end;
}