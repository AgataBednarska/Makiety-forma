tableextension 50106 "Assembly Line N24" extends "Assembly Line"
{
    fields
    {
        field(50100; "External Document No. N24"; Code[35])
        {
            CalcFormula = lookup("Assembly Header"."External Document No. N24" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50101; "Quantity Transferred N24"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Location Code" = field("Location Code"), "Entry Type" = const(transfer), "External Document No." = field("External Document No. N24"), "Item No." = field("No.")));
            Caption = 'Quantity Transferred';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
    }
}