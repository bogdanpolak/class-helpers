unit Helper.TBytes;

interface

uses
  System.SysUtils;

type
  TBytesHelper = record helper for TBytes
  private
  public
    // ---------------------
    // Base / utility methods:
    function GetSize: Integer;
    procedure SetSize(aSize: Integer);
    property Size: Integer read GetSize write SetSize;
    procedure InitialiseFromBase64String(const aBase64Str: String);
  end;

implementation

function TBytesHelper.GetSize: Integer;
begin
  Result := Length(Self);
end;

procedure TBytesHelper.SetSize(aSize: Integer);
begin
  SetLength(Self, aSize);
end;

procedure TBytesHelper.InitialiseFromBase64String(const aBase64Str: String);
begin
end;

end.
