/// <summary>
/// WARNING!
/// --------
/// THERE IS NO TRANSFERFIELDS BETWEEN Transfer Header AND Transfer Receipt Header / Transfer Shipment Header IN THE BASE APP!
/// --------
/// IT HAS TO BE HANDLED MANUALLY!
/// </summary>
tableextension 50123 "Transfer Shipment Header N24" extends "Transfer Shipment Header"
{
    fields
    {
    }

    procedure CopyFieldsFromTransferHeader(var TransferHeader: Record "Transfer Header"; var TransferShipmentHeader: Record "Transfer Shipment Header")
    begin
        // TransferShipmentHeader.XYZ := TransferHeader.XYZ;
    end;
}