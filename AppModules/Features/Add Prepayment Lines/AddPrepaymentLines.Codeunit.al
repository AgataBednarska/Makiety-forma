codeunit 50114 "Add Prepayment Lines N24"
{
    procedure SelectMultipleItems(var SalesLine: Record "Sales Line")
    var
        ItemListPage: Page "Item List";
        SelectionFilter: Text;
    begin
        if SalesLine.IsCreditDocType() then
            SelectionFilter := ItemListPage.SelectActiveItems()
        else
            SelectionFilter := ItemListPage.SelectActiveItemsForSale();

        if SelectionFilter <> '' then
            AddItems(SalesLine, SelectionFilter);
    end;

    local procedure AddItems(var SalesLine: Record "Sales Line"; SelectionFilter: Text)
    var
        Item: Record Item;
        SalesHeader: Record "Sales Header";
        NewSalesLine: Record "Sales Line";
    begin
        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        SalesLine.InitNewLine(NewSalesLine);
        Item.SetFilter("No.", SelectionFilter);
        if Item.FindSet() then
            repeat
                AddItem(NewSalesLine, SalesHeader, Item);
            until Item.Next() = 0;
    end;

    local procedure AddItem(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; var Item: Record Item)
    var
        GeneralPostingSetup: Record "General Posting Setup";
    begin
        GeneralPostingSetup.Get(SalesHeader."Gen. Bus. Posting Group", Item."Gen. Prod. Posting Group");
        GeneralPostingSetup.TestField("Sales Account");

        SalesLine.Init();
        SalesLine."Line No." += 10000;
        SalesLine.Validate(Type, "Sales Line Type"::"G/L Account");
        SalesLine.Validate("No.", GeneralPostingSetup.GetSalesAccount());
        SalesLine.Validate("Description", Item.Description);
        SalesLine.Validate(Quantity, 1);
        SalesLine.Insert(true);
    end;
}