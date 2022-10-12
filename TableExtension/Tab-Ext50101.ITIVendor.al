tableextension 50101 "ITI Vendor" extends Vendor
{
    fields
    {
        field(77100; "ITI Employee"; Boolean)
        {
            Caption = 'Employee';
            DataClassification = ToBeClassified;
        }
    }

    fieldgroups
    {
        addlast(DropDown; "VAT Registration No.") { }
    }
}
