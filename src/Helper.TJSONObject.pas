unit Helper.TJSONObject;

interface

uses
  System.JSON,
  System.SysUtils,
  System.DateUtils;

type
  TJSONObjectHelper = class helper for TJSONObject
  const
    // * --------------------------------------------------------------------
    ReleaseDate = '2019-12-05';
    ReleaseVersion = '1.2';
    // * --------------------------------------------------------------------
  public
    function IsFieldAvailable(const fieldName: string): Boolean;
    function IsValidIsoDate(const fieldName: string): Boolean;
    function GetFieldInt(const fieldName: string): integer;
    function GetFieldIsoDate(const fieldName: string): TDateTime;
    function GetFieldOrEmpty(const fieldName: string): string;
  end;

implementation

function TJSONObjectHelper.IsFieldAvailable(const fieldName: string)
  : Boolean;
begin
  Result := Assigned(Self.Values[fieldName]) and not Self.Values
    [fieldName].Null;
end;

function TJSONObjectHelper.IsValidIsoDate(const fieldName: string): Boolean;
begin
  try
    System.DateUtils.ISO8601ToDate(Self.Values[fieldName].Value, False);
    Result := True;
  except
    on E: Exception do
      Result := False;
  end
end;

function TJSONObjectHelper.GetFieldIsoDate(const fieldName: string): TDateTime;
begin
  Result := System.DateUtils.ISO8601ToDate(Self.Values[fieldName].Value, False);
end;

function TJSONObjectHelper.GetFieldInt(const fieldName: string): integer;
begin
  Result := (Self.Values[fieldName] as TJSONNumber).AsInt;
end;


function TJSONObjectHelper.GetFieldOrEmpty(const fieldName: string): string;
var
  jv: TJSONValue;
begin
  jv := Self.Values[fieldName];
  if (jv=nil) or (jv.Null) then
    Result := ''
  else
    Result := jv.Value;
end;

end.
