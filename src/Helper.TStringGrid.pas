unit Helper.TStringGrid;

interface

uses
  System.JSON,
  System.SysUtils,
  System.Classes,
  System.DateUtils,
  System.Generics.Collections,
  Vcl.Grids;

type
  TStringGridHelper = class helper for TStringGrid
  private const
    Version = '1.7';
  private
    procedure DefineColumnsWithJson(jsStructure: TJSONArray;
      ColumnNames: TStringList);
    procedure FillDataRowsWithJson(jsData: TJSONArray;
      ColumnNames: TStringList);
  public
    procedure ColsWidth(aWidths: TArray<Integer>);
    procedure FillCells(aNewData: TArray < TArray < String >> );
    procedure ClearCells;
    procedure ClearDataRows;
    procedure FillWithJson(aJsonData: TJSONObject);
  end;

implementation

resourcestring
  StrErrorTooManyColumns = 'Too many data in width table ' +
    '(array size = %d, but grid has %d collumns)';
  StrErrorTooManyColumnsInRow = 'In row % too many data in width table ' +
    '(array size = %d, but grid has %d collumns)';

procedure TStringGridHelper.ClearCells;
var
  iRow: Integer;
  iCol: Integer;
begin
  for iRow := 0 to Self.RowCount - 1 do
    for iCol := 0 to Self.ColCount - 1 do
      Self.Cells[iCol, iRow] := '';
end;

procedure TStringGridHelper.ClearDataRows;
var
  iRow: Integer;
  iCol: Integer;
begin
  for iRow := Self.FixedRows to Self.RowCount - 1 do
    for iCol := 0 to Self.ColCount - 1 do
      Self.Cells[iCol, iRow] := '';
end;

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
  iRow: Integer;
  iCol: Integer;
begin
  ClearDataRows;
  for iRow := 0 to High(aNewData) do
  begin
    if ColCount < Length(aNewData[iRow]) then
      raise ERangeError.Create(Format(StrErrorTooManyColumnsInRow,
        [iRow + 1, Length(aNewData[iRow]), ColCount]));
  end;
  Self.RowCount := Length(aNewData) + Self.FixedRows;
  for iRow := 0 to High(aNewData) do
    for iCol := 0 to High(aNewData[iRow]) do
      Cells[iCol, Self.FixedRows + iRow] := aNewData[iRow, iCol];
end;

// "structure": [{"column": "", "caption": "", "width": }, ...]
procedure TStringGridHelper.DefineColumnsWithJson(jsStructure: TJSONArray;
  ColumnNames: TStringList);
var
  i: Integer;
  jsCoumnDef: TJSONObject;
begin
  ColumnNames.Clear;
  Self.FixedRows := 1;
  Self.FixedCols := 0;
  Self.ColCount := jsStructure.Count;
  for i := 0 to jsStructure.Count - 1 do
  begin
    jsCoumnDef := jsStructure.Items[i] as TJSONObject;
    ColumnNames.Add(jsCoumnDef.GetValue('column').Value);
    if (jsCoumnDef.GetValue('caption') is TJSONValue) then
      Self.Cells[i, 0] := jsCoumnDef.GetValue('caption').Value;
    if (jsCoumnDef.GetValue('width') is TJSONNumber) then
      Self.ColWidths[i] := jsCoumnDef.GetValue('width').GetValue<Integer>;
  end;
end;

// "data":[{"fieldname1": "", "fieldname1": "", ...}, ...]
procedure TStringGridHelper.FillDataRowsWithJson(jsData: TJSONArray;
  ColumnNames: TStringList);
var
  i: Integer;
  aRow: Integer;
  jsItem: TJSONObject;
  j: Integer;
  aCol: Integer;
begin
  Self.RowCount := Self.FixedRows + jsData.Count;
  for i := 0 to jsData.Count - 1 do
  begin
    aRow := Self.FixedRows + i;
    jsItem := jsData.Items[i] as TJSONObject;
    for j := 0 to jsItem.Count - 1 do
    begin
      aCol := ColumnNames.IndexOf(jsItem.Pairs[j].JsonString.Value);
      if (aCol >= 0) then
        Self.Cells[aCol, aRow] := jsItem.Pairs[j].JsonValue.Value;
    end;
  end;
end;

(*  Input structure:
  * {
 *   "structure": [{"column": "", "caption": "", "width": }, ...]
 *   "data":[{"fieldname1": "", "fieldname1": "", ...}, ...]
 * }
*)
procedure TStringGridHelper.FillWithJson(aJsonData: TJSONObject);
var
  ColumnNames: TStringList;
  jsStructure: TJSONArray;
  jsData: TJSONArray;
begin
  ColumnNames := TStringList.Create;
  try
    Assert(aJsonData.GetValue('structure') <> nil);
    Assert(aJsonData.GetValue('structure') is TJSONArray);
    jsStructure := aJsonData.GetValue('structure') as TJSONArray;
    DefineColumnsWithJson(jsStructure, ColumnNames);

    Assert(aJsonData.GetValue('data') <> nil);
    Assert(aJsonData.GetValue('data') is TJSONArray);
    jsData := aJsonData.GetValue('data') as TJSONArray;
    FillDataRowsWithJson(jsData, ColumnNames);

  finally
    ColumnNames.Free;
  end;
end;

end.
