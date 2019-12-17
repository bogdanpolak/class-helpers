﻿unit Helper.TDBGrid;

interface

uses
  Vcl.DBGrids,
  System.JSON;

type
  TDBGridHelper = class helper for TDBGrid
  public const
    SufixForAdditionalColumnWidth = '   ';
  private const
    Version = '1.3';
  public
    /// <summary>
    ///   Counts and sets the width of the grid columns in pixels
    /// </summary>
    /// <param name="CalcForNumberOfRows">
    ///   The number of rows for which widths are counted
    /// </param>
    function AutoSizeColumns(const CalcForNumberOfRows: integer = 25): integer;
    procedure LoadColumnsFromJson(aStoredColumns: TJSONArray);
  end;

implementation

uses
  Data.DB, System.Math, System.Classes;

function TDBGridHelper.AutoSizeColumns(const CalcForNumberOfRows
  : integer = 25): integer;
var
  DataSet: TDataSet;
  Bookmark: TBookmark;
  Count, i: integer;
  ColumnsWidth: array of integer;
begin
  SetLength(ColumnsWidth, self.Columns.Count);
  for i := 0 to self.Columns.Count - 1 do
    if self.Columns[i].Visible then
      ColumnsWidth[i] := self.Canvas.TextWidth(self.Columns[i].Title.Caption +
        SufixForAdditionalColumnWidth)
    else
      ColumnsWidth[i] := 0;
  if self.DataSource <> nil then
    DataSet := self.DataSource.DataSet
  else
    DataSet := nil;
  if (DataSet <> nil) and DataSet.Active then
  begin
    Bookmark := DataSet.GetBookmark;
    DataSet.DisableControls;
    try
      Count := 0;
      DataSet.First;
      while not DataSet.Eof and (Count < CalcForNumberOfRows) do
      begin
        for i := 0 to self.Columns.Count - 1 do
          if self.Columns[i].Visible then
            ColumnsWidth[i] := Max(ColumnsWidth[i],
              self.Canvas.TextWidth(self.Columns[i].Field.DisplayText +
              SufixForAdditionalColumnWidth));
        Inc(Count);
        DataSet.Next;
      end;
    finally
      DataSet.GotoBookmark(Bookmark);
      DataSet.FreeBookmark(Bookmark);
      DataSet.EnableControls;
    end;
  end;
  Count := 0;
  for i := 0 to self.Columns.Count - 1 do
    if self.Columns[i].Visible then
    begin
      self.Columns[i].Width := ColumnsWidth[i];
      Inc(Count, ColumnsWidth[i]);
    end;
  Result := Count - self.ClientWidth;
end;

procedure TDBGridHelper.LoadColumnsFromJson(aStoredColumns: TJSONArray);
begin

end;

end.
