tableextension 50120 "Posted Assembly Header N24" extends "Posted Assembly Header"
{
    fields
    {
        field(50100; "External Document No. N24"; Code[35])
        {
            Caption = 'External Document No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50101; "Item Transfer Entries N24"; Integer)
        {
            CalcFormula = count("Item Ledger Entry" where("Entry Type" = const(transfer), "External Document No." = field("External Document No. N24")));
            Caption = 'Item Transfer Entries';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
