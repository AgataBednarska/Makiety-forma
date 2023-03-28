tableextension 50103 "Item ledger Entry N24" extends "Item ledger Entry"
{
    keys
    {
        key(Quantity; "Location Code", "Entry Type", "External Document No.", "Item No.")
        {
            SumIndexFields = Quantity;
        }
        key(Quantity2; "Item No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Location Code", "Drop Shipment", "Variant Code", "Lot No.", "Serial No.", "Unit of Measure Code", "Posting Date", Quantity)
        {
            SumIndexFields = Quantity;
        }
    }
}