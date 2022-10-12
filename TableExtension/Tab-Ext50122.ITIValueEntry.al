tableextension 50122 "ITI ValueEntry" extends "Value Entry"
{
    fields
    {
        field(50100; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            FieldClass = FlowField;
            CalcFormula = lookup(item."Item Category Code" where("No." = field("Item No.")));
        }
    }
}