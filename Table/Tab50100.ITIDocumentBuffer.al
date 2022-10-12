table 50100 "ITI Document Buffer"
{
    Caption = 'Document Buffer';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            // Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(10; "Document No."; Code[20])
        {
            // Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(20; "Item No."; Code[20])
        {
            // Caption = 'Item No.';
            DataClassification = ToBeClassified;
        }
        field(21; "Item Description"; Text[100])
        {
            // Caption = 'Item Description';
            DataClassification = ToBeClassified;
        }
        field(22; "Item Category Code"; Code[20])
        {
            // Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
        }
        field(23; Quantity; Decimal)
        {
            // Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(24; Amount; Decimal)
        {
            // Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(25; "Date Text"; Text[512])
        {
            // Caption = 'Posting Date';
            DataClassification = ToBeClassified;
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
        DocumentBuffer: Record "ITI Document Buffer" temporary;
    begin
        DocumentBuffer.Copy(Rec, true);
        If DocumentBuffer.FindLast() then
            "Entry No." := DocumentBuffer."Entry No." + 1
        else
            "Entry No." := 1;
    end;
}
