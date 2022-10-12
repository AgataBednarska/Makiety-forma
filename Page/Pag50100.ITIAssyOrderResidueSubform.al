page 50100 "ITI AssyOrderResidueSubform"
{

    Caption = 'Item Journal (Revenue journal)';
    PageType = ListPart;
    SourceTable = "Item Journal Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the date when the related document was created.';
                    Visible = false;
                    Editable = false;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = Basic, Suite;
                    // OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.';
                    // ToolTip = 'Specifies the type of transaction that will be posted from the item journal line.';
                    Editable = false;
                }
                field("Price Calculation Method"; Rec."Price Calculation Method")
                {
                    // Visibility should be turned on by an extension for Price Calculation
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the method that will be used for price calculation in the journal line.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies a document number for the journal line.';
                    ShowMandatory = true;
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                    Visible = false;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the number of the item on the journal line.';

                    trigger OnValidate()
                    begin
                        ItemJnlMgt.GetItem(Rec."Item No.", ItemDescription);
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        Rec.Validate("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                    end;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    // ToolTip = 'Specifies the variant of the item on the line.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies a description of the item on the journal line.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    // ToolTip = 'Specifies the code for the inventory location where the item on the journal line will be registered.';
                    Editable = false;

                    // trigger OnValidate()
                    // var
                    //     Item: Record Item;
                    //     WMSManagement: Codeunit "WMS Management";
                    // begin
                    //     if "Location Code" <> '' then
                    //         if Item.Get("Item No.") then
                    //             Item.TestField(Type, Item.Type::Inventory);
                    //     WMSManagement.CheckItemJnlLineLocation(Rec, xRec);
                    // end;
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    ApplicationArea = Warehouse;
                    // ToolTip = 'Specifies the bin where the items are picked or put away.';
                    Visible = false;
                }
                field("Salespers./Purch. Code"; Rec."Salespers./Purch. Code")
                {
                    ApplicationArea = Suite;
                    // ToolTip = 'Specifies the code for the salesperson or purchaser who is linked to the sale or purchase on the journal line.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    // ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    // ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the number of units of the item to be included on the journal line.';
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';
                }
                field("Unit Amount"; Rec."Unit Amount")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the price of one unit of the item on the journal line.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the line''s net amount.';
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the discount amount of this entry on the line.';
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';
                }
                field("Applies-to Entry"; Rec."Applies-to Entry")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies if the quantity on the journal line must be applied to an already-posted entry. In that case, enter the entry number that the quantity will be applied to.';
                }
                field("Applies-from Entry"; Rec."Applies-from Entry")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the number of the outbound item ledger entry, whose cost is forwarded to the inbound item ledger entry.';
                    Visible = false;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = BasicEU;
                    // ToolTip = 'Specifies the type of transaction that the document represents, for the purpose of reporting to INTRASTAT.';
                    Visible = false;
                }
                field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = BasicEU;
                    // ToolTip = 'Specifies the transport method, for the purpose of reporting to INTRASTAT.';
                    Visible = false;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the country/region of the address.';
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = Basic, Suite;
                    // ToolTip = 'Specifies the reason code, a supplementary source code that enables you to trace the entry.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    // ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    // ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible2;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible3;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);

                        // OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 3);
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible4;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);

                        // OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 4);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible5;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);

                        // OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 5);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible6;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);

                        // OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 6);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible7;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);

                        // OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 7);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Visible = DimVisible8;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);

                        // OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, 8);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Residue)
            {
                Caption = 'Residue';
                Image = ItemSubstitution;


                action(GetResidueLines)
                {
                    Caption = 'Get residue lines';
                    ToolTip = 'Creates new records per residue with unit amount (75% of material amount)';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = TransferToLines;

                    trigger OnAction()
                    var
                        AssyMgt: Codeunit "ITI AssemblyManagement";
                    begin
                        AssyMgt.UpdateResidueJournalLines(AssemblyHeader, Rec);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        AssemblySetup: Record "Assembly Setup";
    begin
        AssemblySetup.get();
        AssemblySetup.TestField("Item Journal Batch for Residue");
        AssemblySetup.TestField("Default Location for Residue");
        SetDimensionsVisibility;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        AssyMgt: Codeunit "ITI AssemblyManagement";
    begin
        AssyMgt.SetNewResidueRecord(Rec, AssemblyHeader);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Validate("Dimension Set ID", AssemblyHeader."Dimension Set ID");
    end;

    procedure SetAssemblyHeader(pAssemblyHeader: Record "Assembly Header")
    begin
        AssemblyHeader := pAssemblyHeader;
    end;

    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);
    end;

    var
        AssemblyHeader: Record "Assembly Header";

        ItemJnlMgt: Codeunit ItemJnlManagement;
        ItemDescription: Text[100];
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
}
