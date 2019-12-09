unit Processor.ReadmeMarkdown;

interface

uses
  System.SysUtils,
  System.StrUtils;

type
  TReadmeMarkdownProcessor = class
  private
  public
    class function ProcessReadme(const aSource: string;
      const aNewVersion: string; const aSearchPattern: string): string; static;
  end;

implementation

uses
  Processor.Utils;

class function TReadmeMarkdownProcessor.ProcessReadme(const aSource: string;
  const aNewVersion: string; const aSearchPattern: string): string;
var
  idx1: Integer;
  len: Integer;
  idx2: Integer;
  idx3: Integer;
begin
  // ---------------------------------------------------------------------
  // ![ version ](https://img.shields.io/badge/version-%201.2-yellow.svg)
  //              ^----------- search pattern -------^
  // ---------------------------------------------------------------------
  idx1 := aSource.IndexOf(aSearchPattern);
  len := length(aSearchPattern);
  if idx1 = -1 then
    raise Processor.Utils.EProcessError.Create
      ('No version pattern found in main README file. Please update configuration file.');
  idx2 := aSource.IndexOf('-', idx1 + len);
  idx3 := aSource.IndexOf('-', idx2+1);
  if (idx2 = -1) or (idx3 = -1) then
    raise Processor.Utils.EProcessError.Create
      ('Invalid format of version stored in main README');
  Result := aSource.Substring(0, idx2+1) + '%20'+aNewVersion +
    aSource.Substring(idx3, 9999999);
  writeln('      Bumped README.md version to: '+aNewVersion)
end;

end.
