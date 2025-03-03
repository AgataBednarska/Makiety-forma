tableextension 50146 "Vendor N24" extends Vendor
{
    fields
    {
        field(50100; "Employee N24"; Boolean)
        {
            Caption = 'Employee';
            DataClassification = CustomerContent;
        }
        field(50101; "Square Meters Rounding N24"; Decimal)
        {
            Caption = 'Rounding Square Meters';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MaxValue = 0.1;
            MinValue = 0;
        }
    }

    fieldgroups
    {
        addlast(DropDown; "VAT Registration No.") { }
    }
}