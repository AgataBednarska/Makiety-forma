tableextension 50022 "Value Entry N24" extends "Value Entry"
{
    fields
    {
        field(50000; "Item Category Code N24"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            FieldClass = FlowField;
            CalcFormula = lookup(item."Item Category Code" where("No." = field("Item No.")));
        }
    }
}