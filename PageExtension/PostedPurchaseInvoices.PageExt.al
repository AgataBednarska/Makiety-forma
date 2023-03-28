pageextension 50114 "Posted Purchase Invoices N24" extends "Posted Purchase Invoices"
{
    actions
    {
        addlast(navigation)
        {
            action("FindByLineFilters N24")
            {
                ApplicationArea = All;
                Caption = 'Find by Line Filters';
                Image = Find;
                Promoted = true;
                PromotedCategory = Category8;
                ToolTip = 'Sets filter on document No. based on documents found by header and line filters.';

                trigger OnAction()
                var
                    FindByLine: Report "FindPurchHdrsByLineFilter N24";
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