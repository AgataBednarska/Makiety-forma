/// <summary>
/// WARNING!
/// --------
/// THERE IS NO TRANSFERFIELDS BETWEEN Warehouse Shipment Header AND Posted Whse. Shipment Header IN THE BASE APP!
/// --------
/// IT HAS TO BE HANDLED MANUALLY!
/// </summary>
tableextension 50138 "Posted Whse. Shipment Hdr N24" extends "Posted Whse. Shipment Header"
{
    fields
    {
    }

    procedure AddAdditionalInformationToPostedWhseShipmentHeader(var PostedWhseShipmentHeader: Record "Posted Whse. Shipment Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        // PostedWhseShipmentHeader.XYZ := WarehouseShipmentHeader.XYZ;
    end;
}