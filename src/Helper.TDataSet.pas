unit Helper.TDataSet;

interface

uses
  Data.DB, System.SysUtils;

type
  THelperDataSet = class helper for TDataSet
  const
    // * --------------------------------------------------------------------
    ReleaseDate = '2019.08.30';
    ReleaseVersion = '1.0';
    // * --------------------------------------------------------------------
  public
    procedure WhileNotEof(proc: TProc);
    procedure ForEachRow(proc: TProc);
    function GetMaxIntegerValue(const fieldName: string): integer;

  end;

implementation

function THelperDataSet.GetMaxIntegerValue(const fieldName: string): integer;
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

procedure THelperDataSet.WhileNotEof(proc: TProc);
var
  Bookmark: TBookmark;
begin
  Bookmark := self.GetBookmark;
  // stworzenie zak³adki
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

procedure THelperDataSet.ForEachRow(proc: TProc);
begin
  WhileNotEof(proc);
end;

end.
