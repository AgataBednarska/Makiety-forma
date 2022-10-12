tableextension 50107 "ITI Item" extends Item
{
    fields
    {
        field(50100; "Parent Item Category Code"; Code[20])
        {
            Caption = 'Parent Item Category Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category"."Parent Category" where(code = field("Item Category Code")));
        }
        modify("Item Category Code")
        {
            trigger OnAfterValidate()
            begin
                CalcFields("Parent Item Category Code");
            end;
        }
        field(50101; "Inventory at Date"; Decimal)
        {
            Caption = 'Inventory at Date';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Location Code" = FIELD("Location Filter"),
                                                                  "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Serial No." = FIELD("Serial No. Filter"),
                                                                  "Unit of Measure Code" = FIELD("Unit of Measure Filter"),
                                                                  "Posting Date" = field("Date Filter")));
        }
    }
}
