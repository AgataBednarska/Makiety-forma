tableextension 50021 "Posted Assembly Line N24" extends "Posted Assembly Line"
{
    fields
    {
        field(50000; "External Document No. N24"; Code[35])
        {
            Caption = 'External Document No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Posted Assembly Header"."External Document No. N24" where("No." = FIELD("Document No.")));
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
