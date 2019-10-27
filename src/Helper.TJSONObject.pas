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
    ReleaseDate = '2019.08.30';
    ReleaseVersion = '1.0';
    // * --------------------------------------------------------------------
  public
    function fieldAvaliable(const fieldName: string): Boolean;
    function IsValidIsoDateUtc(const Field: string; var dt: TDateTime): Boolean;
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
function TJSONObjectHelper.IsValidIsoDateUtc(const Field: string;
  var dt: TDateTime): Boolean;
begin
  dt := 0;
  try
    dt := System.DateUtils.ISO8601ToDate(Self.Values[Field].Value, False);
    Result := True;
  except
    on E: Exception do
      Result := False;
  end
end;

end.
