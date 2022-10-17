tableextension 50001 "Vendor N24" extends Vendor
{
    fields
    {
        field(50000; "Employee N24"; Boolean)
        {
            Caption = 'Employee';
            DataClassification = CustomerContent;
        }
    }

    fieldgroups
    {
        addlast(DropDown; "VAT Registration No.") { }
    }
}