unit Helper.TDataSet;

interface

uses
  System.SysUtils,
  System.RTTI,
  System.Generics.Collections,
  Data.DB;

type
  TDataSetHelper = class helper for TDataSet
  private const
    Version = '1.4';
  public
    procedure WhileNotEof(proc: TProc);
    procedure ForEachRow(proc: TProc);
    function GetMaxIntegerValue(const fieldName: string): integer;
    function CreateDataSource: TDataSource;
    function LoadData<T: class, constructor>: TObjectList<T>;
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
  Result := TDataSource.Create(self);
  Result.DataSet := self;
end;

procedure TDataSetHelper.ForEachRow(proc: TProc);
begin
  WhileNotEof(proc);
end;

function TDataSetHelper.LoadData<T>: TObjectList<T>;
var
  dataList: TObjectList<T>;
  item: T;
  RttiContext: TRttiContext;
  itemType: TRttiType;
  itemField: TRttiField;
begin
  dataList := TObjectList<T>.Create(True);
  WhileNotEof(
    procedure
    var
      i: integer;
    begin
      item := T.Create();
      itemType := RttiContext.GetType(item.ClassType);
      for i := 0 to FieldCount - 1 do
      begin
        itemField := itemType.GetField(Fields[i].fieldName);
        if itemField <> nil then
          itemField.SetValue(TObject(item), TValue.From(Fields[i].Value));
      end;
      dataList.Add(item);
    end);
  Result := dataList;
end;

end.
