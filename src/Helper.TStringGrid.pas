unit Helper.TStringGrid;

interface

uses
  System.JSON,
  System.SysUtils,
  System.DateUtils,
  Vcl.Grids;

type
  TStringGridHelper = class helper for TStringGrid
  const
    // ♥ ------------------------------------------------------------------ ♥
    ReleaseDate = '2019.11.30';
    ReleaseVersion = '1.1';
    // ♥ ------------------------------------------------------------------ ♥
  public
    procedure ColsWidth(aWidths: TArray<Integer>);
  end;

implementation

resourcestring
  StrErrorTooManyColumns = 'Too many data in width table ' +
    '(array size = %d, but grid has %d collumns)';

procedure TStringGridHelper.ColsWidth(aWidths: TArray<Integer>);
var
  i: Integer;
begin
  if ColCount < Length(aWidths) then
    raise ERangeError.Create(Format(StrErrorTooManyColumns,
      [Length(aWidths), ColCount]));
  for i := 0 to High(aWidths) do
    ColWidths[i] := aWidths[i];
end;

end.
