pageextension 50197 "ITI UserSetupExt" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field(ITIAllowSkipBankLdgEntry; "ITI Allow Skip Bank Ldg. Entry")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}