unit Helper.TDataSet;

interface

uses
  Data.DB, System.SysUtils;

type
  TDataSetHelper = class helper for TDataSet
  private const
    Version = '1.3';
  public
    procedure WhileNotEof(proc: TProc);
    procedure ForEachRow(proc: TProc);
    function GetMaxIntegerValue(const fieldName: string): integer;
    function CreateDataSource: TDataSource;
  end;

implementation

function TDataSetHelper.GetMaxIntegerValue(const fieldName: string): integer;
var
  MaxValue: integer;
  CurrentValue: integer;
begin
  MaxValue := 0;
  self.WhileNotEof(
    procedure
    begin
      CurrentValue := self.FieldByName(fieldName).AsInteger;
      if CurrentValue > MaxValue then
        MaxValue := CurrentValue;
    end);
  Result := MaxValue;
end;

procedure TDataSetHelper.WhileNotEof(proc: TProc);
var
  Bookmark: TBookmark;
begin
  Bookmark := self.GetBookmark;
  // stworzenie zakładki
  self.DisableControls;
  try
    self.First;
    while not self.Eof do
    begin
      proc();
      self.Next;
    end;
  finally
    if self.BookmarkValid(Bookmark) then
      self.GotoBookmark(Bookmark);
    self.FreeBookmark(Bookmark);
    self.EnableControls;
  end;
end;

function TDataSetHelper.CreateDataSource: TDataSource;
begin
  Result := TDataSource.Create(Self);
  Result.DataSet := Self;
end;

procedure TDataSetHelper.ForEachRow(proc: TProc);
begin
  WhileNotEof(proc);
end;

end.
