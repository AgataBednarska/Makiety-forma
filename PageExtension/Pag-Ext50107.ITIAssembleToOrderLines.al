pageextension 50107 "ITI AssembleToOrderLines" extends "Assemble-to-Order Lines"
{
    layout
    {
        modify(Quantity)
        {
            Editable = true;
            trigger OnAfterValidate();
            begin
                Rec.validate("Quantity to Consume", Rec.Quantity);
            end;
        }
        modify("Quantity per")
        {
            Visible = false;
        }
    }
}
