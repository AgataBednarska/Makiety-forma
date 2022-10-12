codeunit 50109 "ITI ReportReplacement"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnAfterSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        case ReportId of
            //     Report::"Standard Sales - Invoice",
            //     Report::"ITI Sales - Invoice":
            //         NewReportId := Report::"ITI Sales-Invoice Forma";
            //     report::"Standard Sales - Credit Memo",
            //     report::"ITI Sales - Credit Memo":
            //         NewReportId := report::"ITI Sales-CrMemo Forma";
            //     report::"Standard Sales - Draft Invoice":
            //         NewReportId := report::"ITI Sales-DraftInvoice Forma";
            //     report::"Standard Sales - Order Conf.":
            //         NewReportId := report::"ITI Sales-OrderConf Forma";
            //     report::"Standard Sales - Pro Forma Inv":
            //         NewReportId := report::"ITI Sales-ProFormaInv Forma";
            //     report::"Standard Sales - Quote":
            //         NewReportId := report::"ITI Sales-Quote Forma";
            Report::"Customer/Item Sales":
                NewReportId := Report::"Customer/Item Sales with Total";
        end;
    end;
}
