pageextension 50167 "ITI ItemRegisters" extends "Item Registers"
{
    actions
    {
        addlast(Reporting)
        {
            action(QuantityRegister)
            {
                Caption = 'Item Register - Quantity';
                ApplicationArea = All;
                Image = ItemRegisters;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    ItemRegister: record "Item Register";
                    ItemRegisterQuantity: report "Item Register - Quantity";
                begin
                    ItemRegister.setrange("No.", Rec."No.");
                    ItemRegisterQuantity.SetTableView(ItemRegister);
                    ItemRegisterQuantity.Run();
                end;
            }
            action(ValueRegister)
            {
                Caption = 'Item Register - Value';
                ApplicationArea = All;
                Image = JobRegisters;
                Promoted = true;
                PromotedCategory = Report;

                trigger OnAction()
                var
                    ItemRegister: record "Item Register";
                    ItemRegisterValue: report "Item Register - Value";
                begin
                    ItemRegister.setrange("No.", Rec."No.");
                    ItemRegisterValue.SetTableView(ItemRegister);
                    ItemRegisterValue.Run();
                end;
            }
        }
    }
}
