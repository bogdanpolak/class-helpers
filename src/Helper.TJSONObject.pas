unit Helper.TJSONObject;

interface

uses
  System.JSON,
  System.SysUtils,
  System.DateUtils;

type
  TJSONObjectHelper = class helper for TJSONObject
  private const
    Version = '1.6';
  public
    /// <summary>
    ///   Checks is JSON object has field (key) provided through parameter and its value is not NULL
    /// </summary>
    function IsFieldAvailable(const fieldName: string): Boolean;
    /// <summary>
    ///   Checks is JSON object field (fieldName) is valid UTC date in ISO8601 format
    /// </summary>
    function IsValidIsoDate(const fieldName: string): Boolean;
    /// <summary>
    ///   Gets JSON object field (fieldName) value as integer
    /// </summary>
    function GetFieldInt(const fieldName: string): integer;
    /// <summary>
    ///   Gets JSON object field (fieldName) value as date in ISO8601 format
    /// </summary>
    function GetFieldIsoDate(const fieldName: string): TDateTime;
    /// <summary>
    ///   Gets JSON object field (fieldName) value as date or returns empty string if field value is NULL
    /// </summary>
    function GetFieldOrEmpty(const fieldName: string): string;
  end;

implementation

function TJSONObjectHelper.IsFieldAvailable(const fieldName: string): Boolean;
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
var
  aVal: string;
  dt: TDateTime;
  isValueWithTime: Boolean;
begin
  aVal := Self.Values[fieldName].Value;
  // * ISO8601ToDate - returns invalid date time for strings containg only
  //     ISO date (returns decimal values with time) (spoted in 10.3 version)
  dt := System.DateUtils.ISO8601ToDate(aVal, False);
  isValueWithTime := aVal.Contains('T');
  if not(isValueWithTime) and (Frac(dt)>0) then
    Result := Int(dt)
  else
    Result := dt
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
  if (jv = nil) or (jv.Null) then
    Result := ''
  else
    Result := jv.Value;
end;

end.
