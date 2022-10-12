report 50101 "Order Profitability - Excel"
{
    ApplicationArea = All;
    Caption = 'Order Profitability - Excel';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    UseRequestPage = false;

    trigger OnPostReport()
    begin
        RunAsExcel();
    end;

    procedure RunAsExcel()
    var
        OrderProfitability: Report "Order Profitability";
        RequestPageParameters: Text;
        OutStr: OutStream;
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
    begin
        RequestPageParameters := OrderProfitability.RunRequestPage();
        if RequestPageParameters = '' then
            exit;
        Clear(OrderProfitability);
        TempBlob.CreateOutStream(OutStr);
        OrderProfitability.SaveAs(RequestPageParameters, ReportFormat::Excel, OutStr);
        FileManagement.BLOBExport(TempBlob, StrSubstNo('%1_%2.xlsx', CurrReport.ObjectId(), Format(CURRENTDATETIME, 0, '<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>')), true);
        CurrReport.Quit();
    end;
}
