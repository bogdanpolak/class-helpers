unit Helper.TDateTime;

interface

type
  TDateTimeHelper = record helper for TDateTime
  const
    // * --------------------------------------------------------------------
    ReleaseDate = '2019.08.30';
    ReleaseVersion = '1.0';
    // * --------------------------------------------------------------------
  public
    function AsYear: word;
    function AsMonth: word;
    function AsDay: word;
    function DatePart: TDateTime;
    function AsHour: word;
    function AsMinute: word;
    function AsSecond: word;
    function TimePart: TDateTime;
    function ToString(const Format: string = ''): string;
    function AsFloat: double;
    function DayOfWeek: word;
    function DayOfWeekName: string;
    function DayOfWeekShortName: string;
    function DaysInMonth: word;
    function IncMonth(incerment: word): TDateTime;
  end;

implementation

uses
  System.SysUtils,
  System.DateUtils;

function TDateTimeHelper.AsFloat: Double;
begin
  Result := Self;
end;

function TDateTimeHelper.AsDay: Word;
begin
  Result := System.DateUtils.DayOf(Self);
end;

function TDateTimeHelper.DatePart: TDateTime;
begin
  Result := Int(Self);
end;

function TDateTimeHelper.AsHour: word;
begin
  Result := HourOf(Self);
end;

function TDateTimeHelper.AsMinute: word;
begin
  Result := MinuteOf(Self);
end;

function TDateTimeHelper.AsSecond: word;
begin
  Result :=SecondOf(Self);
end;

function TDateTimeHelper.TimePart: TDateTime;
begin
  Result := Frac(Self);
end;

function TDateTimeHelper.DayOfWeek: Word;
begin
  Result := System.SysUtils.DayOfWeek(Self);
end;

function TDateTimeHelper.DayOfWeekName: string;
begin
  Result := System.SysUtils.FormatDateTime ('dddd',Self);
end;

function TDateTimeHelper.DayOfWeekShortName: string;
begin
  Result := System.SysUtils.FormatDateTime ('ddd',Self)
end;

function TDateTimeHelper.DaysInMonth: word;
begin
  Result := System.DateUtils.DaysInMonth(Self);
end;

function TDateTimeHelper.AsMonth: Word;
begin
  Result := System.DateUtils.MonthOf(Self);
end;

function TDateTimeHelper.AsYear: Word;
begin
  Result := System.DateUtils.YearOf(Self);
end;

function TDateTimeHelper.ToString(const Format: string = ''): string;
begin
  if Format <> '' then
    Result := System.SysUtils.FormatDateTime(Format, Self)
  else
    Result := System.SysUtils.DateToStr(Self);
end;

function TDateTimeHelper.IncMonth(incerment: word): TDateTime;
begin
  Result := System.SysUtils.IncMonth(Self,incerment);
end;

end.

