unit Processor.ReadmeMarkdown;

interface

uses
  System.SysUtils,
  System.StrUtils;

type
  TReadmeMarkdownProcessor = class
  private
  public
    class function ProcessReadme(const aSource: string; const aNewVersion: string)
      : string; static;
  end;

implementation

class function TReadmeMarkdownProcessor.ProcessReadme(const aSource,
  aNewVersion: string): string;
begin
  // ![ version ](https://img.shields.io/badge/version-%201.2-yellow.svg)
  Result := aSource;
end;

end.
