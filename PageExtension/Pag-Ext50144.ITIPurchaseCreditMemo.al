pageextension 50144 "ITI PurchaseCreditMemo" extends "Purchase Credit Memo"
{
    layout
    {
        modify("Vendor Authorization No.")
        {
            Importance = Additional;
        }
        modify("ITI SAFT Ext. Document No.")
        {
            Importance = Promoted;
            ShowMandatory = true;
        }
    }
}
