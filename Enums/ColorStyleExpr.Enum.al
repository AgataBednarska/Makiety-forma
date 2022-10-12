enum 50000 "Color Style Expr. N24"
{
    Extensible = true;
    value(0; None)
    {
        Caption = ' ', Locked = true;
    }
    value(1; Standard)
    {
        Caption = 'Standard', Locked = true;
        // Standard
    }
    value(2; StandardAccent)
    {
        Caption = 'StandardAccent', Locked = true;
        // Blue
    }
    value(3; Strong)
    {
        Caption = 'Strong', Locked = true;
        // Bold
    }
    value(4; StrongAccent)
    {
        Caption = 'StrongAccent', Locked = true;
        // Blue + Bold
    }
    value(5; Attention)
    {
        Caption = 'Attention', Locked = true;
        // Red + Italic
    }
    value(6; AttentionAccent)
    {
        Caption = 'AttentionAccent', Locked = true;
        // Blue + Italic
    }
    value(7; Favorable)
    {
        Caption = 'Favorable', Locked = true;
        // Bold + Green
    }
    value(8; Unfavorable)
    {
        Caption = 'Unfavorable', Locked = true;
        // Bold + Italic + Red
    }
    value(9; Ambiguous)
    {
        Caption = 'Ambiguous', Locked = true;
        // Yellow
    }
    value(10; Subordinate)
    {
        Caption = 'Subordinate', Locked = true;
        // Grey
    }
}