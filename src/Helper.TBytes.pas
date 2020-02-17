unit Helper.TBytes;

interface

uses
  System.SysUtils;

type
  TBytesHelper = record helper for TBytes
    // ---------------------
    // Base / utility methods:
    function GetSize: Integer;
    procedure SetSize(aSize: Integer);
    property Size: Integer read GetSize write SetSize;
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

end.
