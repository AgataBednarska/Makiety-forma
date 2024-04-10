tableextension 50167 "Value Entry N24" extends "Value Entry"
{
    fields
    {
        field(50100; "Item Category Code N24"; Code[20])
        {
            CalcFormula = lookup(Item."Item Category Code" where("No." = field("Item No.")));
            Caption = 'Item Category Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Item Category";
        }
    }
}