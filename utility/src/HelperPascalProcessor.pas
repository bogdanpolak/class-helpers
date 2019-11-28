unit HelperPascalProcessor;

interface

uses
  System.SysUtils,
  System.StrUtils;

type
  THelperPascalProcessor = class
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

class function THelperPascalProcessor.FindSignature(const aSource,
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

class function THelperPascalProcessor.TextLength(const aSource: string;
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

class function THelperPascalProcessor.ProcessUnit(const aSource: string;
  const aNewVersion: string): string;
var
  idx1: integer;
  len1: integer;
  aReleseDate: string;
  idx2: integer;
  len2: integer;
  aReleaseVersion: string;
  aNewDate: string;
  aNewSource: string;
begin
  idx1 := FindSignature(aSource, 'ReleaseDate');
  len1 := TextLength(aSource, idx1);
  aReleseDate := aSource.Substring(idx1, len1);
  idx2 := FindSignature(aSource, 'ReleaseVersion');
  len2 := TextLength(aSource, idx2);
  aReleaseVersion := aSource.Substring(idx2, len2);
  if len1 = 0 then
  begin
    writeln('Error!!! No sugnature with ReleaseDate constant');
    Halt(3);
  end;
  if len2 = 0 then
  begin
    writeln('Error!!! No sugnature with ReleaseDate constant');
    Halt(3);
  end;
  aNewDate := FormatDateTime('yyyy-mm-dd', Now);
  aNewSource := aSource.Substring(0, idx1) + aNewDate +
    aSource.Substring(idx1 + len1, idx2 - idx1 - len1) + aNewVersion +
    aSource.Substring(idx2 + len2, 99999);
  write('      ');
  if aSource <> aNewSource then
    writeln(Format('Updated. Version: %s -> %s  (Release Date: %s -> %s)',
      [aReleaseVersion, aNewVersion, aReleseDate, aNewDate]))
  else
    writeln('No changes. Nothing to update');
  Result := aNewSource;
end;

end.
