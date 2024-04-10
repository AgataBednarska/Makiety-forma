pageextension 50187 "Sales Shipment Lines N24" extends "Sales Shipment Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No. N24"; Rec."External Document No. N24")
            {
                ApplicationArea = All;
            }
        }
    }
}