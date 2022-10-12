codeunit 50111 "ITI CU240EventHandler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ItemJnlManagement, 'OnBeforeLookupName', '', false, false)]
    local procedure OnBeforeLookupName(var ItemJnlBatch: Record "Item Journal Batch")
    var
        AssemblySetup: Record "Assembly Setup";
    begin
        AssemblySetup.get();
        IF ItemJnlBatch."Journal Template Name" = AssemblySetup."Item Journal Tmpl. for Residue" then begin
            ItemJnlBatch.FilterGroup(2);
            ItemJnlBatch.SetFilter("Name", '<>%1', AssemblySetup."Item Journal Batch for Residue");
            ItemJnlBatch.FilterGroup(0);
        end;
    end;
}
