pageextension 50149 "ITI GetSalesInvoiceLines" extends "ITI Get Sales Invoice Lines"
{
    layout
    {
        addafter("Document No.")
        {
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }
}
