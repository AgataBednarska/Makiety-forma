pageextension 50003 "Assembly Order Subform N24" extends "Assembly Order Subform"
{
    layout
    {
        movebefore("Unit Cost"; "Unit of Measure Code")
        modify(Quantity)
        {
            Editable = true;

            trigger OnAfterValidate();
            var
                AssemblySetup: Record "Assembly Setup";
            begin
                AssemblySetup.Get();

                if Rec."Location Code" = AssemblySetup."In-Production Location N24" then
                    Rec.Validate("Quantity to Consume", Rec.Quantity);
            end;
        }
        modify("Quantity per")
        {
            Visible = false;
        }
        modify("Variant Code")
        {
            Visible = false;
        }
        addafter(Quantity)
        {
            field("Transferred Quantity N24"; Rec."Quantity Transferred N24")
            {
                ApplicationArea = All;
            }
        }
        addafter("Location Code")
        {
            field("InProduction N24"; IsInProduction())
            {
                Caption = 'In production';
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields("External Document No. N24");
        Rec.CalcFields("Quantity Transferred N24");
    end;

    local procedure IsInProduction(): Boolean
    var
        AssemblySetup: Record "Assembly Setup";
    begin
        AssemblySetup.Get();
        exit(Rec."Location Code" = AssemblySetup."In-Production Location N24");
    end;
}