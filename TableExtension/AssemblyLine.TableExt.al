tableextension 50006 "Assembly Line N24" extends "Assembly Line"
{
    fields
    {
        field(50000; "External Document No. N24"; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Assembly Header"."External Document No. N24" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
        }
        field(50001; "Quantity Transferred N24"; Decimal)
        {
            Caption = 'Quantity Transferred';
            Editable = false;
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Location Code" = field("Location Code"), "Entry Type" = const(transfer), "External Document No." = field("External Document No. N24"), "Item No." = field("No.")));
        }
    }
}