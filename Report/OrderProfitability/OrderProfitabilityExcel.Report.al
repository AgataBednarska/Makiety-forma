report 50001 "Order Profitability Excel N24"
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
        OrderProfitability: Report "Order Profitability N24";
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        DateFormatTok: Label '<Year4><Month,2><Day,2><Hours24><Minutes,2><Seconds,2>', Locked = true;
        FilePathTok: Label '%1_%2.xlsx', Locked = true;
        OutStr: OutStream;
        RequestPageParameters: Text;
    begin
        RequestPageParameters := OrderProfitability.RunRequestPage();

        if RequestPageParameters = '' then
            exit;

        Clear(OrderProfitability);

        TempBlob.CreateOutStream(OutStr);

        OrderProfitability.SaveAs(RequestPageParameters, ReportFormat::Excel, OutStr);

        FileManagement.BLOBExport(TempBlob, StrSubstNo(FilePathTok, CurrReport.ObjectId(), Format(CurrentDateTime, 0, DateFormatTok)), true);

        CurrReport.Quit();
    end;
}