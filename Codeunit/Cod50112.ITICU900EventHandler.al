codeunit 50112 "ITI CU900EventHandler"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assembly-Post", 'OnAfterPost', '', false, false)]
    local procedure OnAfterPost(var AssemblyHeader: Record "Assembly Header")
    var
        AssyMgt: Codeunit "ITI AssemblyManagement";
    begin
        //AssyMgt.PostResidueLines(AssemblyHeader);
    end;
}
