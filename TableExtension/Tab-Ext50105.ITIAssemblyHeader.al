tableextension 50105 "ITI AssemblyHeader" extends "Assembly Header"
{
    fields
    {
        field(50100; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
        }
        field(50101; "Item Transfer Entries"; Integer)
        {
            Caption = 'Item Transfer Entries';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Item Ledger Entry" where("Entry Type" = const(transfer), "External Document No." = field("External Document No.")));
        }
    }
}
