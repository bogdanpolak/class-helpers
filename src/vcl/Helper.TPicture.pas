unit Helper.TPicture;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Graphics;

type
  TPictureHelper = class helper for TPicture
  private const
    Version = '1.7';
  public
    procedure AssignBytes(const aBytes: TBytes);
  end;

implementation

procedure TPictureHelper.AssignBytes(const aBytes: TBytes);
begin

end;

end.
