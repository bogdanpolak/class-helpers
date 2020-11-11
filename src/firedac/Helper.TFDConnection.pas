unit Helper.TFDConnection;

interface

uses
  System.Classes,
  FireDAC.Comp.Client;

type
  TFDConnectionHelper = class helper for TFDConnection
  private const
    Version = '1.8';
  public
    /// <summary>
    ///   Setts FireDAC connection definion using fluent method, which
    ///	  allows to write more compact code 
    /// </summary>
	/// <example> aConn := TFDConnection.Create(aOwner).WithConnectionDef(aName); </code>
    function WithConnectionDef(const aDefinitionName: string): TFDConnection;
    function GetTableNamesAsArray: TArray<String>;
    function GetFieldNamesAsArray(const aTableName: string): TArray<String>;
  end;

implementation

uses
  FireDAC.Phys.Intf;

function TFDConnectionHelper.WithConnectionDef(const aDefinitionName: string)
  : TFDConnection;
begin
  Self.ConnectionDefName := aDefinitionName;
  Result := Self;
end;

function TFDConnectionHelper.GetTableNamesAsArray: TArray<String>;
var
  sl: TStringList;
  i: Integer;
begin
  sl := TStringList.Create;
  try
    Self.GetTableNames('', '', '', sl, //.
      // TFDPhysObjectScopes = [osMy, osOther, osSystem]
      [osMy],
      // TFDPhysTableKinds = (tkSynonym, tkTable, tkView, tkTempTable, tkLocalTable)
      [tkSynonym, tkTable, tkView],
      // aFullName: Boolean
      True);
    SetLength(Result, sl.Count);
    for i := 0 to sl.Count - 1 do
      Result[i] := sl[i];
  finally
    sl.Free;
  end;
end;

function TFDConnectionHelper.GetFieldNamesAsArray(const aTableName: string)
  : TArray<String>;
var
  sl: TStringList;
  i: Integer;
begin
  sl := TStringList.Create;
  try
    Self.GetFieldNames('', '', aTableName, '', sl);
    SetLength(Result, sl.Count);
    for i := 0 to sl.Count - 1 do
      Result[i] := sl[i];
  finally
    sl.Free;
  end;
end;

end.
