/// <summary>
/// WARNING!
/// --------
/// THERE IS NO TRANSFERFIELDS BETWEEN Transfer Header AND Transfer Receipt Header / Transfer Shipment Header IN THE BASE APP!
/// --------
/// IT HAS TO BE HANDLED MANUALLY!
/// </summary>
tableextension 50122 "Transfer Receipt Header N24" extends "Transfer Receipt Header"
{
    fields
    {
    }

    procedure CopyFieldsFromTransferHeader(var TransRcptHeader: Record "Transfer Receipt Header"; var TransHeader: Record "Transfer Header")
    begin
        // TransRcptHeader.XYZ := XYZ;
    end;
}