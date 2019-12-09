unit Processor.PascalUnit;

interface

uses
  System.SysUtils,
  System.StrUtils;

type
  TPascalUnitProcessor = class
  const
    Aphostrophe = '''';
  private
    class function FindSignature(const aSource, FieldName: string)
      : integer; static;
    class function TextLength(const aSource: string; aTextStartIdx: integer)
      : integer; static;
  public
    class function ProcessUnit(const aSource: string; const aNewVersion: string)
      : string; static;
  end;

implementation

uses
  Processor.Utils;

class function TPascalUnitProcessor.FindSignature(const aSource,
  FieldName: string): integer;
var
  idx1: integer;
  i: integer;
begin
  idx1 := aSource.IndexOf(FieldName);
  if idx1 >= 0 then
  begin
    i := aSource.IndexOf(Aphostrophe, idx1);
    if i >= 0 then
      Exit(i + 1);
  end;
  Result := -1;
end;

class function TPascalUnitProcessor.TextLength(const aSource: string;
  aTextStartIdx: integer): integer;
var
  j: integer;
begin
  if aTextStartIdx > 0 then
  begin
    j := aSource.IndexOf(Aphostrophe, aTextStartIdx);
    if j > aTextStartIdx then
      Exit(j - aTextStartIdx);
  end;
  Result := 0;
end;

class function TPascalUnitProcessor.ProcessUnit(const aSource: string;
  const aNewVersion: string): string;
var
  idx2: integer;
  len2: integer;
  aReleaseVersion: string;
  aNewSource: string;
begin
  idx2 := FindSignature(aSource, 'Version');
  len2 := TextLength(aSource, idx2);
  aReleaseVersion := aSource.Substring(idx2, len2);
  if len2 = 0 then
    raise EProcessError.Create('No found Version const in class helper.');
  aNewSource := aSource.Substring(0, idx2) + aNewVersion +
    aSource.Substring(idx2 + len2, 99999);
  write('      ');
  if aSource <> aNewSource then
    writeln(Format('Updated. Version: %s -> %s', [aReleaseVersion,
      aNewVersion]))
  else
    writeln('No changes. Nothing to update');
  Result := aNewSource;
end;

end.
