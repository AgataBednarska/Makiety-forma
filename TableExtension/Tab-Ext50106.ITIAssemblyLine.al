tableextension 50106 "ITI AssemblyLine" extends "Assembly Line"
{
    fields
    {
        field(50100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            FieldClass = FlowField;
            CalcFormula = lookup("Assembly Header"."External Document No." where("Document Type" = FIELD("Document Type"), "No." = FIELD("Document No.")));
        }
        field(50101; "Quantity Transferred"; Decimal)
        {
            Caption = 'Quantity Transferred';
            Editable = false;
            DecimalPlaces = 0 : 5;
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Location Code" = field("Location Code"), "Entry Type" = const(transfer), "External Document No." = field("External Document No."), "Item No." = field("No.")));
        }
    }
}
