tableextension 50104 "Assembly Setup N24" extends "Assembly Setup"
{
    fields
    {
        field(50100; "Item Journal Batch Residue N24"; Code[10])
        {
            Caption = 'Item Journal Batch for Residue';
            DataClassification = CustomerContent;

            trigger OnLookup()
            var
                ItemJournalTemplate: Record "Item Journal Template";
            begin
                "Item Journal Tmpl. Residue N24" := TemplateSelection(ItemJournalTemplate, Page::"Item Journal", 0);

                if "Item Journal Tmpl. Residue N24" = '' then
                    Error('');

                BatchSelection(ItemJournalTemplate.Name, "Item Journal Batch Residue N24");

                if "Item Journal Batch Residue N24" = '' then
                    Error('');
            end;

            trigger OnValidate()
            var
                ItemJnlBatch: Record "Item Journal Batch";
            begin
                if "Item Journal Batch Residue N24" = '' then
                    "Item Journal Tmpl. Residue N24" := ''
                else
                    ItemJnlBatch.Get("Item Journal Tmpl. Residue N24", "Item Journal Batch Residue N24");
            end;
        }

        field(50101; "Def. Location for Residue N24"; Code[10])
        {
            Caption = 'Default Location for Residue';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }

        field(50102; "Item Journal Tmpl. Residue N24"; Code[10])
        {
            Caption = 'Item Journal Template for Residue';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50103; "Def. Location for Material N24"; Code[20])
        {
            Caption = 'Default Location for Material';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(50104; "In-Production Location N24"; Code[20])
        {
            Caption = 'In-Production Location';
            DataClassification = CustomerContent;
            TableRelation = Location.Code;
        }
        field(50105; "Def.Gen.Bus.Post.Gr. Adjmt N24"; Code[20])
        {
            Caption = 'Def. Gen. Bus. Post. Gr. for Adjustments';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group".Code;
        }
    }

    procedure TemplateSelection(var ItemJournalTemplate: Record "Item Journal Template"; PageID: Integer; PageTemplate: Option Item,Transfer,"Phys. Inventory",Revaluation,Consumption,Output,Capacity,"Prod. Order") ItemJnlTemplateName: Code[10];
    var
        TypeOfJournalLbl: Label '%1 journal', Comment = '%1 - Journal type';
    begin
        ItemJournalTemplate.Reset();
        ItemJournalTemplate.SetRange("Page ID", PageID);
        ItemJournalTemplate.SetRange(Recurring, false);
        ItemJournalTemplate.SetRange(Type, PageTemplate);

        case ItemJournalTemplate.Count of
            0:
                begin
                    ItemJournalTemplate.Init();
                    ItemJournalTemplate.Recurring := false;
                    ItemJournalTemplate.Validate(Type, PageTemplate);
                    ItemJournalTemplate.Validate("Page ID");
                    ItemJournalTemplate.Name := Format(ItemJournalTemplate.Type, MaxStrLen(ItemJournalTemplate.Name));
                    ItemJournalTemplate.Description := StrSubstNo(TypeOfJournalLbl, ItemJournalTemplate.Type);
                    ItemJournalTemplate.Insert();

                    //Commit przeniesiony z poprzedniego rozszerzenia
                    Commit();
                end;
            1:
                ItemJournalTemplate.FindFirst();
            else
                Page.RunModal(0, ItemJournalTemplate);
        end;

        exit(ItemJournalTemplate.Name);
    end;

    procedure BatchSelection(ItemJnlTemplateName: Code[10]; var CurrentJnlBatchName: Code[10])
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.FilterGroup(2);
        ItemJnlBatch.SetRange("Journal Template Name", ItemJnlTemplateName);
        ItemJnlBatch.FilterGroup(0);

        if Page.RunModal(0, ItemJnlBatch) = Action::LookupOK then
            CurrentJnlBatchName := ItemJnlBatch.Name;
    end;
}