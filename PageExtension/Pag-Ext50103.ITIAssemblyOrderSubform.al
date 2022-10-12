pageextension 50103 "ITI Assembly Order Subform" extends "Assembly Order Subform"
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
                AssemblySetup.get();
                if Rec."Location Code" = AssemblySetup."In-Production Location" then
                    Rec.validate("Quantity to Consume", Rec.Quantity);
            end;
        }
        modify("Quantity per")
        {
            //Visible = not IsAssembleToOrder;
            Visible = false;
        }
        modify("Variant Code")
        {
            Visible = false;
        }
        addafter(Quantity)
        {
            field("Transferred Quantity"; Rec."Quantity Transferred")
            {
                ApplicationArea = All;
            }
        }
        addafter("Location Code")
        {
            field(InProduction; IsInProduction())
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
        Rec.CalcFields("External Document No.");
        Rec.CalcFields("Quantity Transferred");
    end;

    procedure SetIsAssembleToOrder(IsATO: Boolean)
    begin
        IsAssembleToOrder := IsATO;
    end;

    local procedure IsInProduction(): Boolean
    var
        AssemblySetup: Record "Assembly Setup";
    begin
        AssemblySetup.get();
        exit(Rec."Location Code" = AssemblySetup."In-Production Location");
    end;

    var
        IsAssembleToOrder: Boolean;
}
