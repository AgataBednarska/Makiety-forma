enum 50101 "Sales Execution Status N24"
{
    AssignmentCompatibility = true;
    Extensible = true;

    value(0; PendingRealization) { Caption = 'Pending execution'; } //Oczekuje na realizacje
    value(1; AcceptedForRealization) { Caption = 'Accepted for execution'; } //Przyjęte do realizacji
    value(2; PendingMaterials) { Caption = 'Pending materials'; } //Oczekuje na materiał
    value(3; PreparingSketch) { Caption = 'Preparing sketch'; } //W przygotowaniu rysunku
    value(4; InProduction) { Caption = 'In production'; } //W trakcje produkcji
    value(5; Produced) { Caption = 'Produced'; } //Wyprodukowane
    value(6; Received) { Caption = 'Received'; } //Odebrane
    value(7; Storage) { Caption = 'Storage'; } //Magazynowane
    value(8; NotMounted) { Caption = 'Not mounted'; } //Niezamontowane
    value(9; Mounted) { Caption = 'Mounted'; } //Zamontowane
    value(10; Complaint) { Caption = 'Complaint'; } //Reklamacja
    value(11; Finished) { Caption = 'Finished'; } //Zakończone
}