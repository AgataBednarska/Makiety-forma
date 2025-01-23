tableextension 50161 "Lot No. Information N24" extends "Lot No. Information"
{
    fields
    {
        field(50100; "Length N24"; Decimal)
        {
            Caption = 'Length';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 3;
        }
        field(50101; "Width N24"; Decimal)
        {
            Caption = 'Width';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 3;
        }
        field(50102; "Cubic Meters N24"; Decimal)
        {
            Caption = 'Cubic Meters';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
        }
        field(50103; "Comments N24"; Text[100])
        {
            Caption = 'Comments';
            DataClassification = CustomerContent;
        }
        field(50104; "Vendor N24"; Text[100])
        {
            Caption = 'Vendor';
            DataClassification = CustomerContent;
        }
        field(50105; "Size N24"; Boolean)
        {
            Caption = 'Size';
            DataClassification = CustomerContent;
        }
        field(50106; "Shade N24"; Text[6])
        {
            Caption = 'Shade';
            DataClassification = CustomerContent;
        }
        field(50107; "Storage Place N24"; Text[16])
        {
            Caption = 'Storage Place';
            DataClassification = CustomerContent;
        }
        //Narazie bez przenoszenia informacji gdziekowliek - pole tylko informacyjnie na liscie inf o nr partii
        field(50108; "No. Of Original SLAB N24"; Code[50])
        {
            Caption = 'No. Of Original SLAB';
            DataClassification = CustomerContent;
        }
    }
}