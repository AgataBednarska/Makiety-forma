pageextension 50067 "Item Registers N24" extends "Item Registers"
{
    actions
    {
        addlast(Reporting)
        {
            action("QuantityRegister N24")
            {
                Caption = 'Item Register - Quantity';
                ApplicationArea = All;
                Image = ItemRegisters;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    ItemRegister: Record "Item Register";
                    ItemRegisterQuantity: Report "Item Register - Quantity";
                begin
                    ItemRegister.SetRange("No.", Rec."No.");
                    ItemRegisterQuantity.SetTableView(ItemRegister);
                    ItemRegisterQuantity.Run();
                end;
            }
            action("ValueRegister N24")
            {
                Caption = 'Item Register - Value';
                ApplicationArea = All;
                Image = JobRegisters;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    ItemRegister: Record "Item Register";
                    ItemRegisterValue: Report "Item Register - Value";
                begin
                    ItemRegister.SetRange("No.", Rec."No.");
                    ItemRegisterValue.SetTableView(ItemRegister);
                    ItemRegisterValue.Run();
                end;
            }
        }
    }
}