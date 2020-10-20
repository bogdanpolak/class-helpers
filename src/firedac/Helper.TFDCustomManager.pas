unit Helper.TFDCustomManager;

interface

uses
  FireDAC.Comp.Client;

type
  TFDCustomManagerHelper = class helper for TFDCustomManager
  private const
    Version = '1.7';
  public
    /// <summary>
    ///   Reads list of registered FireDAC connection definitions
    /// </summary>
    function GetConnectionDefNames: TArray<string>;
  end;

implementation

function TFDCustomManagerHelper.GetConnectionDefNames: TArray<string>;
var
  i: Integer;
begin
  SetLength(Result, Self.ConnectionDefs.Count);
  for i := 0 to Self.ConnectionDefs.Count-1 do
    Result[i] := Self.ConnectionDefs.Items[i].Name;
end;

end.
