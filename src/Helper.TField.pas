unit Helper.TField;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.DB;

type
  TFieldHelper = class helper for TField
  private const
    Version = '1.6';
  private
  public
    function SetBlobFromBase64String(const aBase64Str: String): TBlobField;
  end;

implementation

uses
  System.NetEncoding;

function TFieldHelper.SetBlobFromBase64String(const aBase64Str: String)
  : TBlobField;
begin
  if not(Self is TBlobField) then
    raise EDatabaseError.Create('Invalid field type.' +
      ' Method LoadFromBase64String is supported only for blob fields');
  Result := (Self as TBlobField);
  Result.Value := TNetEncoding.Base64.DecodeStringToBytes(aBase64Str);
end;

end.
