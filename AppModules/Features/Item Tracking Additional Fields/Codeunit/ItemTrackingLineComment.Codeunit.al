/// <summary>
/// Kod został trochę zmodernizowany i przerobiony na potrzeby modyfikacji. Poniżej znajdują się źródła:
/// Source: https://d365-businesscentral.blogspot.com/2023/07/business-central-add-custom-fields-to.html
/// GitHub: https://github.com/anilsgit01/BlogPosts/tree/main
/// </summary>
codeunit 50115 "Item Tracking Line Comment N24"
{
    SingleInstance = true;

    var
        ModifyRun: Boolean;
        Size: Boolean;
        CubicMeters: Decimal;
        Length: Decimal;
        Width: Decimal;
        Shade: Text[6];
        StoragePlace: Text[16];
        Comments: Text[100];
        Vendor: Text[100];

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", OnAfterCreateLotInformation, '', false, false)]
    local procedure ItemTrackingLines_OnAfterCreateLotInformation(var LotNoInfo: Record "Lot No. Information"; var TrackingSpecification: Record "Tracking Specification")
    begin
        SetAdditionalFieldsOnLotNoInfo(LotNoInfo, TrackingSpecification);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnRegisterChangeOnChangeTypeInsertOnBeforeInsertReservEntry, '', false, false)]
    local procedure ItemTrackingLines_OnRegisterChangeOnChangeTypeInsertOnBeforeInsertReservEntry(var TrackingSpecification: Record "Tracking Specification"; var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; FormRunMode: Option)
    begin
        SetGlobalVariablesFromTrackingSpecification(NewTrackingSpecification, false);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnRegisterChangeOnChangeTypeModifyOnBeforeCheckEntriesAreIdentical, '', false, false)]
    local procedure ItemTrackingLines_OnRegisterChangeOnChangeTypeModifyOnBeforeCheckEntriesAreIdentical(var ReservEntry1: Record "Reservation Entry"; var ReservEntry2: Record "Reservation Entry"; var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; var IdenticalArray: array[2] of Boolean)
    begin
        SetGlobalVariablesFromTrackingSpecification(NewTrackingSpecification, true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", OnAfterSetDates, '', false, false)]
    local procedure CreateReservEntry_OnAfterSetDates(var ReservationEntry: Record "Reservation Entry")
    begin
        AssignCustomFieldsToReservEntry(ReservationEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", OnCreateReservEntryExtraFields, '', false, false)]
    local procedure CreateReservEntry_OnCreateReservEntryExtraFields(var InsertReservEntry: Record "Reservation Entry"; OldTrackingSpecification: Record "Tracking Specification"; NewTrackingSpecification: Record "Tracking Specification")
    begin
        AssignCustomFieldsFromTrackingSpecificationToReservEntry(InsertReservEntry, NewTrackingSpecification);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterCopyTrackingSpec, '', false, false)]
    local procedure ItemTrackingLines_OnAfterCopyTrackingSpec(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification")
    begin
        PassFieldsBetweenSourceAndDestinationTrackingSpecOnInsertAndModify(SourceTrackingSpec, DestTrkgSpec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterMoveFields, '', false, false)]
    local procedure ItemTrackingLine_OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        AssignCustomFieldsFromTrackingSpecificationToReservEntry(ReservEntry, TrkgSpec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", OnAfterEntriesAreIdentical, '', false, false)]
    local procedure ItemTrackingLines_OnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        if ModifyRun then begin
            SetCustomFieldsInIdenticalArrayAndCompare(ReservEntry2, ReservEntry1, IdenticalArray);
            exit;
        end;

        SetCustomFieldsInIdenticalArrayAndCompare(ReservEntry1, ReservEntry2, IdenticalArray);
    end;

    local procedure SetAdditionalFieldsOnLotNoInfo(var LotNoInfo: Record "Lot No. Information"; var TrackingSpecification: Record "Tracking Specification")
    begin
        LotNoInfo."Length N24" := TrackingSpecification."Length N24";
        LotNoInfo."Width N24" := TrackingSpecification."Width N24";
        LotNoInfo."Cubic Meters N24" := TrackingSpecification."Cubic Meters N24";
        LotNoInfo."Comments N24" := TrackingSpecification."Comments N24";
        LotNoInfo."Vendor N24" := TrackingSpecification."Vendor N24";
        LotNoInfo."Size N24" := TrackingSpecification."Size N24";
        LotNoInfo."Shade N24" := TrackingSpecification."Shade N24";
        LotNoInfo."Storage Place N24" := TrackingSpecification."Storage Place N24";

        LotNoInfo.Modify(false);
    end;

    local procedure SetGlobalVariablesFromTrackingSpecification(var NewTrackingSpecification: Record "Tracking Specification"; IsModify: Boolean)
    begin
        ModifyRun := IsModify;

        Length := NewTrackingSpecification."Length N24";
        Width := NewTrackingSpecification."Width N24";
        CubicMeters := NewTrackingSpecification."Cubic Meters N24";
        Comments := NewTrackingSpecification."Comments N24";
        Vendor := NewTrackingSpecification."Vendor N24";
        Size := NewTrackingSpecification."Size N24";
        Shade := NewTrackingSpecification."Shade N24";
        StoragePlace := NewTrackingSpecification."Storage Place N24";
    end;

    local procedure AssignCustomFieldsToReservEntry(var ReservationEntry: Record "Reservation Entry")
    begin
        ReservationEntry."Length N24" := Length;
        ReservationEntry."Width N24" := Width;
        ReservationEntry."Cubic Meters N24" := CubicMeters;
        ReservationEntry."Comments N24" := Comments;
        ReservationEntry."Vendor N24" := Vendor;
        ReservationEntry."Size N24" := Size;
        ReservationEntry."Shade N24" := Shade;
        ReservationEntry."Storage Place N24" := StoragePlace;
    end;

    local procedure AssignCustomFieldsFromTrackingSpecificationToReservEntry(var InsertReservEntry: Record "Reservation Entry"; var NewTrackingSpecification: Record "Tracking Specification")
    begin
        InsertReservEntry."Length N24" := NewTrackingSpecification."Length N24";
        InsertReservEntry."Width N24" := NewTrackingSpecification."Width N24";
        InsertReservEntry."Cubic Meters N24" := NewTrackingSpecification."Cubic Meters N24";
        InsertReservEntry."Comments N24" := NewTrackingSpecification."Comments N24";
        InsertReservEntry."Vendor N24" := NewTrackingSpecification."Vendor N24";
        InsertReservEntry."Size N24" := NewTrackingSpecification."Size N24";
        InsertReservEntry."Shade N24" := NewTrackingSpecification."Shade N24";
        InsertReservEntry."Storage Place N24" := NewTrackingSpecification."Storage Place N24";
    end;

    local procedure PassFieldsBetweenSourceAndDestinationTrackingSpecOnInsertAndModify(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification")
    begin
        SourceTrackingSpec."Length N24" := DestTrkgSpec."Length N24";
        SourceTrackingSpec."Width N24" := DestTrkgSpec."Width N24";
        SourceTrackingSpec."Cubic Meters N24" := DestTrkgSpec."Cubic Meters N24";
        SourceTrackingSpec."Comments N24" := DestTrkgSpec."Comments N24";
        SourceTrackingSpec."Vendor N24" := DestTrkgSpec."Vendor N24";
        SourceTrackingSpec."Size N24" := DestTrkgSpec."Size N24";
        SourceTrackingSpec."Shade N24" := DestTrkgSpec."Shade N24";
        SourceTrackingSpec."Storage Place N24" := DestTrkgSpec."Storage Place N24";
    end;

    local procedure SetCustomFieldsInIdenticalArrayAndCompare(var ReservEntry1: Record "Reservation Entry"; var ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        if IdenticalArray[2] then
            IdenticalArray[2] := (ReservEntry1."Length N24" = ReservEntry2."Length N24") and
                                (ReservEntry1."Width N24" = ReservEntry2."Width N24") and
                                (ReservEntry1."Cubic Meters N24" = ReservEntry2."Cubic Meters N24") and
                                (ReservEntry1."Comments N24" = ReservEntry2."Comments N24") and
                                (ReservEntry1."Vendor N24" = ReservEntry2."Vendor N24") and
                                (ReservEntry1."Size N24" = ReservEntry2."Size N24") and
                                (ReservEntry1."Shade N24" = ReservEntry2."Shade N24") and
                                (ReservEntry1."Storage Place N24" = ReservEntry2."Storage Place N24");
    end;
}