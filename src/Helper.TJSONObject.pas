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
    ReleaseDate = '2019.11.04';
    ReleaseVersion = '1.1';
    // * --------------------------------------------------------------------
  public
    function fieldAvaliable(const fieldName: string): Boolean;
    function IsValidIsoDateUtc(const Field: string): Boolean;
    function GetFieldInt(const Field: string): integer;
    function GetFieldDateIsoUtc(const Field: string): TDateTime;
    function GetFieldOrEmpty(const Field: string): string;
  end;

implementation

function TJSONObjectHelper.fieldAvaliable(const fieldName: string)
  : Boolean;
begin
  Result := Assigned(Self.Values[fieldName]) and not Self.Values
    [fieldName].Null;
end;

{ TODO 2: [Helper] TJSONObject Class helpper and this method has two responsibilities }
// Warning! In-out var parameter
// extract separate:  GetIsoDateUtc
function TJSONObjectHelper.IsValidIsoDateUtc(const Field: string): Boolean;
var
  dt: TDateTime;
begin
  dt := 0;
  try
    dt := System.DateUtils.ISO8601ToDate(Self.Values[Field].Value, False);
    Result := True;
    // dummy code for no warning message - unused dt variable
    if dt=-9999999 then
      raise EAbort.Create('');
  except
    on E: Exception do
      Result := False;
  end
end;

function TJSONObjectHelper.GetFieldDateIsoUtc(const Field: string): TDateTime;
begin
  Result := System.DateUtils.ISO8601ToDate(Self.Values[Field].Value, False);
end;

function TJSONObjectHelper.GetFieldInt(const Field: string): integer;
begin
  Result := (Self.Values[Field] as TJSONNumber).AsInt;
end;


function TJSONObjectHelper.GetFieldOrEmpty(const Field: string): string;
var
  jv: TJSONValue;
begin
  jv := Self.Values[Field];
  if (jv=nil) or (jv.Null) then
    Result := ''
  else
    Result := jv.Value;
end;

end.
