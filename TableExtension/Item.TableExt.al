tableextension 50007 "Item N24" extends Item
{
    fields
    {
        modify("Item Category Code")
        {
            trigger OnAfterValidate()
            begin
                CalcFields("Parent Item Category Code N24");
            end;
        }
        field(50000; "Parent Item Category Code N24"; Code[20])
        {
            Caption = 'Parent Item Category Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category"."Parent Category" where(Code = field("Item Category Code")));
        }
        field(50001; "Inventory at Date N24"; Decimal)
        {
            Caption = 'Inventory at Date';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("No."),
                                                                  "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                  "Location Code" = field("Location Filter"),
                                                                  "Drop Shipment" = field("Drop Shipment Filter"),
                                                                  "Variant Code" = field("Variant Filter"),
                                                                  "Lot No." = field("Lot No. Filter"),
                                                                  "Serial No." = field("Serial No. Filter"),
                                                                  "Unit of Measure Code" = field("Unit of Measure Filter"),
                                                                  "Posting Date" = field("Date Filter")));
        }
    }
}