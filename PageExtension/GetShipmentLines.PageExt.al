pageextension 50062 "Get Shipment Lines N24" extends "Get Shipment Lines"
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