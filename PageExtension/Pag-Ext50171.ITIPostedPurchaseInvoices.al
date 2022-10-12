pageextension 50171 "ITI PostedPurchaseInvoices" extends "Posted Purchase Invoices"
{
    actions
    {
        addlast(navigation)
        {
            action(FindByLineFilters)
            {
                Caption = 'Find by Line Filters';
                ToolTip = 'Sets filter on document No. based on documents found by header and line filters.';
                ApplicationArea = All;
                Image = Find;
                Promoted = true;
                PromotedCategory = Category8;

                trigger OnAction()
                var
                    FindByLine: Report "ITI FindPurchHdrsByLineFilter";
                begin
                    FindByLine.SetTableView(Rec);
                    FindByLine.RunModal();
                    FindByLine.GetFilteredPurchInvHeader(Rec);
                    Rec.FindSet();
                end;
            }
        }
    }
}
