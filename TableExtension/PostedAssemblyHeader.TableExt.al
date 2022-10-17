tableextension 50020 "Posted Assembly Header N24" extends "Posted Assembly Header"
{
    fields
    {
        field(50000; "External Document No. N24"; Code[35])
        {
            Caption = 'External Document No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50001; "Item Transfer Entries N24"; Integer)
        {
            Caption = 'Item Transfer Entries';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("Item Ledger Entry" where("Entry Type" = const(transfer), "External Document No." = field("External Document No. N24")));
        }
    }
}
