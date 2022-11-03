table 50000 "Document Buffer N24"
{
    Caption = 'Document Buffer';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(20; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(21; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
        }
        field(22; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
        }
        field(23; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(24; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(25; "Date Text"; Text[512])
        {
            Caption = 'Date Text';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        TempDocumentBuffer: Record "Document Buffer N24" temporary;
    begin
        TempDocumentBuffer.Copy(Rec, true);

        if TempDocumentBuffer.FindLast() then
            "Entry No." := TempDocumentBuffer."Entry No." + 1
        else
            "Entry No." := 1;
    end;
}