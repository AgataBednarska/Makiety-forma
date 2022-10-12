codeunit 50002 "Shared Functions N24"
{
    SingleInstance = true;

    /// <summary>
    /// The standard CU Calendar Management includes CheckDateFormulaPositive which checks if the DateFormula has a positive value and throws an error if not
    /// </summary>
    procedure CheckDateFormulaNegative(CurrentDateFormula: DateFormula)
    var
        DateFormulaCannotBePositiveErr: Label 'The date formula %1 cannot be positive.', Comment = '%1 - Date formula';
    begin
        if CalcDate(CurrentDateFormula) > Today then
            Error(DateFormulaCannotBePositiveErr, CurrentDateFormula);
    end;
}