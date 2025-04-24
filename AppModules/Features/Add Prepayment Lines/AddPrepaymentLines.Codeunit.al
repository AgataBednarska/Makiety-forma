codeunit 50114 "Add Prepayment Lines N24"
{
    Permissions = tabledata Item = r,
                tabledata "Sales Header" = r,
                tabledata "Sales & Receivables Setup" = r,
                tabledata "Sales Line" = im;

    procedure SelectMultipleItems(var SalesLine: Record "Sales Line")
    var
        ItemListPage: Page "Item List";
        PrepmtLineType: Enum "Prepmt. Line Type N24";
        ChoiceNumber: Integer;
        PrepmtLineTypeQst: Label 'Do you want to create a prepayment for VAT 23% or VAT 8%?';
        SelectionFilter: Text;
    begin
        if SalesLine.IsCreditDocType() then
            SelectionFilter := ItemListPage.SelectActiveItems()
        else
            SelectionFilter := ItemListPage.SelectActiveItemsForSale();

        if SelectionFilter = '' then
            exit;

        ChoiceNumber := StrMenu(StrSubstNo('%1,%2', PrepmtLineType::VAT23, PrepmtLineType::VAT8), 1, PrepmtLineTypeQst);

        if ChoiceNumber < 1 then
            exit;

        if ChoiceNumber = 1 then
            PrepmtLineType := "Prepmt. Line Type N24"::VAT23;

        if ChoiceNumber = 2 then
            PrepmtLineType := "Prepmt. Line Type N24"::VAT8;

        AddItems(SalesLine, SelectionFilter, PrepmtLineType);
    end;

    local procedure AddItems(var SalesLine: Record "Sales Line"; SelectionFilter: Text; PrepmtLineType: Enum "Prepmt. Line Type N24")
    var
        Item: Record Item;
        NewSalesLine: Record "Sales Line";
    begin
        SalesLine.InitNewLine(NewSalesLine);
        Item.SetFilter("No.", SelectionFilter);
        if Item.FindSet() then
            repeat
                AddItem(NewSalesLine, Item, PrepmtLineType);
            until Item.Next() = 0;
    end;

    local procedure AddItem(var SalesLine: Record "Sales Line"; var Item: Record Item; PrepmtLineType: Enum "Prepmt. Line Type N24")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.GetRecordOnce();

        if PrepmtLineType = "Prepmt. Line Type N24"::VAT23 then
            SalesReceivablesSetup.TestField("Prepmt VAT23 Account N24");

        if PrepmtLineType = "Prepmt. Line Type N24"::VAT8 then
            SalesReceivablesSetup.TestField("Prepmt VAT8 Account N24");

        SalesLine.Init();
        SalesLine."Line No." += 10000;
        SalesLine.Insert(true);

        SalesLine.Validate(Type, "Sales Line Type"::"G/L Account");

        if PrepmtLineType = "Prepmt. Line Type N24"::VAT23 then
            SalesLine.Validate("No.", SalesReceivablesSetup."Prepmt VAT23 Account N24");

        if PrepmtLineType = "Prepmt. Line Type N24"::VAT8 then
            SalesLine.Validate("No.", SalesReceivablesSetup."Prepmt VAT8 Account N24");

        SalesLine.Validate("Description", Item.Description);
        SalesLine.Validate(Quantity, 1);
        SalesLine.Modify(true);
    end;
}