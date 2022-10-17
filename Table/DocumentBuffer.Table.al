table 50000 "Document Buffer N24"
{
    Caption = 'Document Buffer';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(10; "Document No."; Code[20])
        {
        }
        field(20; "Item No."; Code[20])
        {
        }
        field(21; "Item Description"; Text[100])
        {
        }
        field(22; "Item Category Code"; Code[20])
        {
        }
        field(23; Quantity; Decimal)
        {
        }
        field(24; Amount; Decimal)
        {
        }
        field(25; "Date Text"; Text[512])
        {
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

        If TempDocumentBuffer.FindLast() then
            "Entry No." := TempDocumentBuffer."Entry No." + 1
        else
            "Entry No." := 1;
    end;
}
