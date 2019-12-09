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

  EProcessError = class(Exception);

implementation

class function TReadmeMarkdownProcessor.ProcessReadme(const aSource: string;
  const aNewVersion: string; const aSearchPattern: string): string;
var
  idx1: Integer;
  len: Integer;
  idx2: Integer;
begin
  // ![ version ](https://img.shields.io/badge/version-%201.2-yellow.svg)
  idx1 := aSearchPattern.IndexOf(aSource);
  if idx1 = -1 then
  raise EProcessError.Create
    ('No version pattern found in main README file. Please update configuration file.');
  len := length(aSearchPattern);
  idx2 := aSource.IndexOf('-', idx1 + len);
  if idx2 = -1 then
    raise EProcessError.Create
      ('Invalid format of version stored in main README');
  Result := aSource.Substring(0,idx1+len) + aNewVersion + aSource.Substring(idx2,9999999)
end;

end.
