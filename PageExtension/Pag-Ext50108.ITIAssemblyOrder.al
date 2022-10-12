pageextension 50108 "ITI AssemblyOrder" extends "Assembly Order"
{
    layout
    {
        modify(Lines)
        {
            Caption = 'Assembly Lines (Expense journal)';
        }
        addlast(Control2)
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
                Editable = NOT Rec."Assemble to Order";
            }
            field("Transfers"; Rec."Item Transfer Entries")
            {
                ApplicationArea = All;
            }
        }
        addafter(Lines)
        {
            part(ResidueSubform; "ITI AssyOrderResidueSubform")
            {
                SubPageLink = "Document No." = field("No.");
            }
        }
        addafter("No.")
        {
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = All;
                Editable = NOT Rec."Assemble to Order";
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
            action(PostExpenseAndRevenue)
            {
                Caption = 'Post Expense and Revenue';
                ToolTip = 'Post transfer of used items to in-production location and residue positive adjustment';
                ApplicationArea = All;
                Image = PostInventoryToGL;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PostTransferAdjustmentQst: Label 'Do you want to post transfer of used items to in-production location and residue positive adjustment?';
                    AssyMgt: Codeunit "ITI AssemblyManagement";
                    OrderAssembledErr: Label 'The Assembly Order %1 is completed';
                begin
                    IF Rec."Remaining Quantity" = 0 then
                        Error(OrderAssembledErr, Rec."No.");
                    IF Confirm(PostTransferAdjustmentQst, false) then begin
                        AssyMgt.PostTransferLines(Rec);
                        AssyMgt.PostResidueLines(Rec);
                        CurrPage.Update();
                    end;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.Lines.Page.SetIsAssembleToOrder(Rec.IsAsmToOrder());
        CurrPage.ResidueSubform.Page.SetAssemblyHeader(Rec);
    end;

    var
        AssemblySetup: Record "Assembly Setup";
}
