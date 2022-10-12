tableextension 50104 "ITI AssemblySetup" extends "Assembly Setup"
{
    fields
    {
        field(50100; "Item Journal Batch for Residue"; Code[10])
        {
            Caption = 'Item Journal Batch for Residue';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                JnlSelected: Boolean;
                ItemJnlTemplate: Record "Item Journal Template";
                ItemJnlBatch: Record "Item Journal Batch";
            begin
                "Item Journal Tmpl. for Residue" := TemplateSelection(ItemJnlTemplate, PAGE::"Item Journal", 0);
                if "Item Journal Tmpl. for Residue" = '' then
                    Error('');
                BatchSelection(ItemJnlTemplate.name, "Item Journal Batch for Residue");
                if "Item Journal Batch for Residue" = '' then
                    Error('');
            end;

            trigger OnValidate()
            var
                ItemJnlBatch: Record "Item Journal Batch";
            begin
                if "Item Journal Batch for Residue" = '' then
                    "Item Journal Tmpl. for Residue" := ''
                else
                    ItemJnlBatch.Get("Item Journal Tmpl. for Residue", "Item Journal Batch for Residue");
            end;
        }

        field(50101; "Default Location for Residue"; Code[20])
        {
            Caption = 'Default Location for Residue';
            TableRelation = Location.Code;
            DataClassification = ToBeClassified;
        }

        field(50102; "Item Journal Tmpl. for Residue"; Code[10])
        {
            Caption = 'Item Journal Template for Residue';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50103; "Default Location for Material"; code[20])
        {
            Caption = 'Default Location for Material';
            TableRelation = Location.Code;
            DataClassification = ToBeClassified;
        }
        field(50104; "In-Production Location"; code[20])
        {
            Caption = 'In-Production Location';
            TableRelation = Location.Code;
            DataClassification = ToBeClassified;
        }
        field(50105; "Def.Gen.Bus.Post.Gr. for Adjmt"; code[20])
        {
            Caption = 'Def. Gen. Bus. Post. Gr. for Adjustments';
            TableRelation = "Gen. Business Posting Group".code;
            DataClassification = ToBeClassified;
        }
    }

    procedure TemplateSelection(var ItemJnlTemplate: Record "Item Journal Template"; PageID: Integer; PageTemplate: Option Item,Transfer,"Phys. Inventory",Revaluation,Consumption,Output,Capacity,"Prod. Order") ItemJnlTemplateName: code[10];
    var
        Text000: Label '%1 journal';
    begin
        ItemJnlTemplate.Reset();
        ItemJnlTemplate.SetRange("Page ID", PageID);
        ItemJnlTemplate.SetRange(Recurring, false);
        ItemJnlTemplate.SetRange(Type, PageTemplate);

        case ItemJnlTemplate.Count of
            0:
                begin
                    ItemJnlTemplate.Init();
                    ItemJnlTemplate.Recurring := false;
                    ItemJnlTemplate.Validate(Type, PageTemplate);
                    ItemJnlTemplate.Validate("Page ID");
                    ItemJnlTemplate.Name := Format(ItemJnlTemplate.Type, MaxStrLen(ItemJnlTemplate.Name));
                    ItemJnlTemplate.Description := StrSubstNo(Text000, ItemJnlTemplate.Type);
                    ItemJnlTemplate.Insert();
                    Commit();
                end;
            1:
                ItemJnlTemplate.FindFirst;
            else
                PAGE.RunModal(0, ItemJnlTemplate);
        end;

        exit(ItemJnlTemplate.Name);
    end;

    procedure BatchSelection(ItemJnlTemplateName: code[10]; var CurrentJnlBatchName: Code[10])
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.FilterGroup(2);
        ItemJnlBatch.SetRange("Journal Template Name", ItemJnlTemplateName);
        ItemJnlBatch.FilterGroup(0);
        if PAGE.RunModal(0, ItemJnlBatch) = ACTION::LookupOK then begin
            CurrentJnlBatchName := ItemJnlBatch.Name;
        end;
    end;
}
