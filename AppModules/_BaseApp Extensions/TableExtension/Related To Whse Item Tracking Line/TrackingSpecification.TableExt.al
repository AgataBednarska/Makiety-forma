tableextension 50143 "Tracking Specification N24" extends "Tracking Specification"
{
    fields
    {
        field(50100; "Length N24"; Decimal)
        {
            Caption = 'Length';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 3;
            trigger OnValidate()
            begin
                if (Rec."Length N24" = 0) or (Rec."Width N24" = 0) then
                    exit;

                Rec.Validate("Cubic Meters N24", Rec."Length N24" * Rec."Width N24");
            end;
        }
        field(50101; "Width N24"; Decimal)
        {
            Caption = 'Width';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 3;
            trigger OnValidate()
            begin
                if (Rec."Length N24" = 0) or (Rec."Width N24" = 0) then
                    exit;

                Rec.Validate("Cubic Meters N24", Rec."Length N24" * Rec."Width N24");
            end;
        }
        field(50102; "Cubic Meters N24"; Decimal)
        {
            Caption = 'Cubic Meters';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                RoundCubicMeters();

                Rec.Validate("Quantity (Base)", "Cubic Meters N24");
            end;
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
            TableRelation = Vendor.Name;
            ValidateTableRelation = false;
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
    }
    procedure SetVendorBasedOnPurchaseHeader()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if Rec."Vendor N24" <> '' then
            exit;

        if Rec."Source Type" <> Database::"Purchase Line" then
            exit;

        PurchaseHeader.SetLoadFields("Buy-from Vendor Name", "Buy-from Vendor No.");
        if not PurchaseHeader.Get(Rec."Source Subtype", Rec."Source ID") then
            exit;

        if PurchaseHeader."Buy-from Vendor Name" = '' then
            exit;

        Rec."Vendor N24" := PurchaseHeader."Buy-from Vendor Name";
    end;

    local procedure RoundCubicMeters()
    var
        PurchaseHeader: Record "Purchase Header";
        Vendor: Record Vendor;
    begin
        if Rec."Cubic Meters N24" = 0 then
            exit;

        if Rec."Source Type" <> Database::"Purchase Line" then
            exit;

        PurchaseHeader.SetLoadFields("Buy-from Vendor No.");
        if not PurchaseHeader.Get(Rec."Source Subtype", Rec."Source ID") then
            exit;

        if not Vendor.Get(PurchaseHeader."Buy-from Vendor No.") then
            exit;

        if Vendor."Square Meters Rounding N24" = 0 then
            exit;

        Rec."Cubic Meters N24" := Round(Rec."Cubic Meters N24", Vendor."Square Meters Rounding N24");
    end;
}