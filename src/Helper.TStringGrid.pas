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
    procedure FillCells(aNewData: TArray < TArray < String >> );
  end;

implementation

resourcestring
  StrErrorTooManyColumns = 'Too many data in width table ' +
    '(array size = %d, but grid has %d collumns)';
  StrErrorTooManyColumnsInRow = 'In row % too many data in width table ' +
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

procedure TStringGridHelper.FillCells(aNewData: TArray < TArray < String >> );
var
  i: Integer;
  iRow: Integer;
  iCol: Integer;
begin
  for iRow := 0 to High(aNewData) do
  begin
    if ColCount < Length(aNewData[iRow]) then
      raise ERangeError.Create(Format(StrErrorTooManyColumnsInRow,
        [iRow + 1, Length(aNewData[iRow]), ColCount]));
  end;
  Self.RowCount := Length(aNewData) + Self.FixedRows;
  for iRow := 0 to High(aNewData) do
    for iCol := 0 to High(aNewData[iRow]) do
      Cells[iCol, Self.FixedRows+iRow] := aNewData[iRow,iCol];
end;

end.
