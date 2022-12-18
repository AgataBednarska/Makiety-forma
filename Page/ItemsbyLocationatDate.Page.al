page 50001 "Items by Location at Date N24"
{
    Caption = 'Items by Location at Date';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    SaveValues = true;
    SourceTable = Item;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(ShowInTransit; ShowInTransit)
                {
                    ApplicationArea = Location;
                    Caption = 'Show Items in Transit';
                    ToolTip = 'Specifies the items in transit between locations.';

                    trigger OnValidate()
                    begin
                        ShowInTransitOnAfterValidate();
                    end;
                }
                field(ShowColumnName; ShowColumnName)
                {
                    ApplicationArea = Location;
                    Caption = 'Show Column Name';
                    ToolTip = 'Specifies that the names of columns are shown in the matrix window.';

                    trigger OnValidate()
                    begin
                        ShowColumnNameOnAfterValidate();
                    end;
                }
                field(MATRIX_CaptionRange; MATRIX_CaptionRange)
                {
                    ApplicationArea = Location;
                    Caption = 'Column Set';
                    Editable = false;
                    ToolTip = 'Specifies the range of values that are displayed in the matrix window, for example, the total period. To change the contents of the field, choose Next Set or Previous Set.';
                }
                field(InventoryAtDate; InventoryAtDate)
                {
                    Caption = 'Inventory at Date';
                    ApplicationArea = Location;

                    trigger OnValidate();
                    var
                        DateRangeToTok: Label '..%1', Locked = true;
                    begin
                        InventoryDateFilter := StrSubstNo(DateRangeToTok, InventoryAtDate);

                        if InventoryAtDate = 0D then
                            InventoryDateFilter := '';

                        SetInventoryDateFilter();

                        SetColumns(SetWantedForMatrix::Initial);
                    end;
                }
            }
            part(MatrixForm; "Items by Loc. at Date Mtx N24")
            {
                ApplicationArea = Location;
                ShowFilter = true;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Previous Set")
            {
                ApplicationArea = Location;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                begin
                    SetColumns(SetWantedForMatrix::Previous);
                end;
            }
            action("Next Set")
            {
                ApplicationArea = Location;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                begin
                    SetColumns(SetWantedForMatrix::Next);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        TempMatrixLocation.GetLocationsIncludingUnspecifiedLocation(false, false);
    end;

    trigger OnOpenPage()
    begin
        SetColumns(SetWantedForMatrix::Initial);
    end;

    var
        MatrixRecords: array[32] of Record Location;
        TempMatrixLocation: Record Location temporary;
        MatrixRecordRef: RecordRef;
        ShowColumnName: Boolean;
        ShowInTransit: Boolean;
        InventoryAtDate: Date;
        SetWantedForMatrix: Enum "SetWantedForMatrix N24";
        MATRIX_CurrSetLength: Integer;
        UnspecifiedLocationCodeTxt: Label 'UNSPECIFIED', Comment = 'Code for unspecified location';
        InventoryDateFilter: Text;
        MATRIX_CaptionRange: Text;
        MATRIX_PKFirstRecInCurrSet: Text;
        MATRIX_CaptionSet: array[32] of Text[80];

    procedure SetColumns(SetWantedForMatrixValue: Enum "SetWantedForMatrix N24")
    var
        MatrixMgt: Codeunit "Matrix Management";
        CaptionFieldNo: Integer;
        CurrentMatrixRecordOrdinal: Integer;
        JoinTwoValuesTok: Label '%1%2', Locked = true;
    begin
        SetTempMatrixLocationFilters();

        Clear(MATRIX_CaptionSet);
        Clear(MatrixRecords);
        CurrentMatrixRecordOrdinal := 1;

        MatrixRecordRef.GetTable(TempMatrixLocation);
        MatrixRecordRef.SetTable(TempMatrixLocation);

        if ShowColumnName then
            CaptionFieldNo := TempMatrixLocation.FieldNo(Name)
        else
            CaptionFieldNo := TempMatrixLocation.FieldNo(Code);

        MatrixMgt.GenerateMatrixData(MatrixRecordRef, SetWantedForMatrixValue, ArrayLen(MatrixRecords), CaptionFieldNo, MATRIX_PKFirstRecInCurrSet,
          MATRIX_CaptionSet, MATRIX_CaptionRange, MATRIX_CurrSetLength);

        if MATRIX_CaptionSet[1] = '' then begin
            MATRIX_CaptionSet[1] := UnspecifiedLocationCodeTxt;
            MATRIX_CaptionRange := StrSubstNo(JoinTwoValuesTok, MATRIX_CaptionSet[1], MATRIX_CaptionRange);
        end;

        if MATRIX_CurrSetLength > 0 then begin
            TempMatrixLocation.SetPosition(MATRIX_PKFirstRecInCurrSet);
            TempMatrixLocation.Find();
            repeat
                MatrixRecords[CurrentMatrixRecordOrdinal].Copy(TempMatrixLocation);

                CurrentMatrixRecordOrdinal := CurrentMatrixRecordOrdinal + 1;
            until (CurrentMatrixRecordOrdinal > MATRIX_CurrSetLength) or (TempMatrixLocation.Next() <> 1);
        end;

        UpdateMatrixSubform();
    end;

    local procedure SetTempMatrixLocationFilters()
    begin
        TempMatrixLocation.SetRange("Use As In-Transit", ShowInTransit);
    end;

    local procedure ShowColumnNameOnAfterValidate()
    begin
        SetColumns(SetWantedForMatrix::Same);
    end;

    local procedure ShowInTransitOnAfterValidate()
    begin
        SetColumns(SetWantedForMatrix::Initial);
    end;

    local procedure UpdateMatrixSubform()
    begin
        CurrPage.MatrixForm.Page.Load(MATRIX_CaptionSet, MatrixRecords, TempMatrixLocation, MATRIX_CurrSetLength);
        CurrPage.MatrixForm.Page.SetRecord(Rec);
        CurrPage.MatrixForm.Page.SetPostingDateFilter(InventoryDateFilter);
        CurrPage.Update(false);
    end;

    procedure SetInventoryDateFilter()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        FilterTokens: Codeunit "Filter Tokens";
    begin
        Rec.FilterGroup(2);
        FilterTokens.MakeDateFilter(InventoryDateFilter);
        ItemLedgerEntry.SetFilter("Posting Date", InventoryDateFilter);
        InventoryDateFilter := ItemLedgerEntry.GetFilter("Posting Date");
        Rec.FilterGroup(0);
    end;
}