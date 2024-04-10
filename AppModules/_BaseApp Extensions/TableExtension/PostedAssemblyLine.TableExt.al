tableextension 50166 "Posted Assembly Line N24" extends "Posted Assembly Line"
{
    fields
    {
        field(50100; "External Document No. N24"; Code[35])
        {
            CalcFormula = lookup("Posted Assembly Header"."External Document No. N24" where("No." = field("Document No.")));
            Caption = 'External Document No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50101; "Quantity Transferred N24"; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Location Code" = field("Location Code"), "Entry Type" = const(Transfer), "External Document No." = field("External Document No. N24"), "Item No." = field("No.")));
            Caption = 'Quantity Transferred';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
