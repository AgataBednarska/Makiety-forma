pageextension 50021 "User Setup N24" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("Allow Skip Bank Ldg. Entry N24"; Rec."Allow Skip Bank Ldg. Entry N24")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}