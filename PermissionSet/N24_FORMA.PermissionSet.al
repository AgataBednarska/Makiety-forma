permissionset 50100 "N24_FORMA N24"
{
    Access = Internal;
    Assignable = true;
    Caption = 'Forma System', Locked = true;

    Permissions =
         codeunit "App Mgt. Shared N24" = X,
         codeunit "AssemblyMgt N24" = X,
         codeunit "Constants N24" = X,
         codeunit "Custom Events N24" = X,
         codeunit "ExternalDocumentNoMgt N24" = X,
         codeunit "FinancialMgt N24" = X,
         codeunit "Installation Mgt. N24" = X,
         codeunit "PurchaseMgt N24" = X,
         codeunit "SalesMgt N24" = X,
         codeunit "Security Helper N24" = X,
         codeunit "Shared Functions N24" = X,
         codeunit "Shared Labels N24" = X,
         codeunit "Single Instance N24" = X,
         codeunit "Upgrade Mgt. N24" = X,
         page "AssyOrderResidueSubform N24" = X,
         page "Items by Loc. at Date Mtx N24" = X,
         page "Items by Location at Date N24" = X,
         page "N24_Forma_System N24" = X,
         report "Bank Exch. Diff. Report N24" = X,
         report "Calc.Post Bank Exch. Diff. N24" = X,
         report "Compensation Proposal N24" = X,
         report "Customer/Item Sales Total N24" = X,
         report "FindPurchHdrsByLineFilter N24" = X,
         report "Order Profitability Excel N24" = X,
         report "Order Profitability N24" = X,
         table "Document Buffer N24" = X,
         tabledata "Document Buffer N24" = RIMD;
}