unit Helper.TDateTime;

interface

type
  TDateTimeHelper = record helper for TDateTime
  private const
    Version = '1.9';
    UndefinedDateTime = -1.7E+308; // Near minimum value for Double (TDateTime is an alias for Double)
  private
  public
    /// <summary>
    /// Returns current date without time part
    /// - Time part is set to 00:00:00
    /// </summary>
    class function Today: TDateTime; static;
    /// <summary>
    /// Creates a new TDateTime with specified date components
    /// - If all parameters are zero (default), returns undefined date (UndefinedDateTime constant)
    /// - If any parameter is non-zero, encodes the date with provided values
    /// - Throws exception if date components are invalid
    /// </summary>
    class function New(aYear: integer = 0; aMonth: integer = 0; aDay: integer = 0): TDateTime; static;
    /// <summary>
    /// Adds time to the current date
    /// - Hour must be 0-23
    /// - Minute must be 0-59
    /// - Second must be 0-59 (default: 0)
    /// - Throws exception if time components are invalid
    /// </summary>
    function At(aHour: integer; aMinute: integer; aSecond: integer = 0): TDateTime;
    /// <summary>
    /// Checks if the date is undefined (equals UndefinedDateTime constant)
    /// - Returns true if date value equals UndefinedDateTime
    /// - Returns false otherwise
    /// </summary>
    function IsUndefined: boolean;
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
    function IncMonth(incerment: integer): TDateTime;
    /// <summary>
    /// Returns first day in current month
    /// </summary>
    function FirstDayInMonth: TDateTime;
    /// <summary>
    /// Returns last day in current month
    /// </summary>
    function LastDayInMonth: TDateTime;
    /// <summary>
    /// Returns info to render Calendar = DayOfTheWeek for LastDayInMonth
    /// </summary>
    function DayOfWeekFirstDayInMonth: word;
    /// <summary>
    /// Returns info to render Calendar = DayOfTheWeek for FirstDayInMonth
    /// </summary>
    function DayOfWeekLastDayInMonth: word;
    /// <summary>
    /// Returns numbers of weeks included starting week and last week in
    /// month (even if first and last are started partly only)
    /// </summary>
    function NumberOfWeeksInMonth: word;
    /// <summary>
    /// Returns numbers of current date and time in ISO format. If there
    /// is only date part defined then it return only date as ISO
    /// </summary>
    function AsStringDateISO: string;
    /// <summary>
    /// Set current date and time from ISO format string. Supported are
    /// date onlny, date with time, date with time with time zone.
    /// Sample ISO date: 2020-02-10T17:35:24.521+0200
    /// </summary>
    procedure SetDateISO(const aDateISO: string);
  end;

implementation

uses
  System.SysUtils,
  System.Math,
  System.DateUtils;

function TDateTimeHelper.AsFloat: double;
begin
  Result := Self;
end;

function TDateTimeHelper.AsDay: word;
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
  Result := SecondOf(Self);
end;

function TDateTimeHelper.TimePart: TDateTime;
begin
  Result := Frac(Self);
end;

function TDateTimeHelper.DayOfWeek: word;
begin
  Result := System.SysUtils.DayOfWeek(Self);
end;

function TDateTimeHelper.DayOfWeekName: string;
begin
  Result := System.SysUtils.FormatDateTime('dddd', Self);
end;

function TDateTimeHelper.DayOfWeekShortName: string;
begin
  Result := System.SysUtils.FormatDateTime('ddd', Self)
end;

function TDateTimeHelper.DaysInMonth: word;
begin
  Result := System.DateUtils.DaysInMonth(Self);
end;

function TDateTimeHelper.AsMonth: word;
begin
  Result := System.DateUtils.MonthOf(Self);
end;

function TDateTimeHelper.AsYear: word;
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

function TDateTimeHelper.IncMonth(incerment: integer): TDateTime;
begin
  Result := System.SysUtils.IncMonth(Self, incerment);
end;

function TDateTimeHelper.FirstDayInMonth: TDateTime;
begin
  Result := EncodeDate(Self.AsYear, Self.AsMonth, 1);
end;

function TDateTimeHelper.LastDayInMonth: TDateTime;
begin
  Result := Self.FirstDayInMonth.IncMonth(1) - 1;
end;

function TDateTimeHelper.DayOfWeekFirstDayInMonth: word;
begin
  Result := DayOfTheWeek(Self.FirstDayInMonth);
end;

function TDateTimeHelper.DayOfWeekLastDayInMonth: word;
begin
  Result := DayOfTheWeek(Self.LastDayInMonth);
end;

function TDateTimeHelper.NumberOfWeeksInMonth: word;
begin
  Result := System.Math.Ceil((LastDayInMonth - FirstDayInMonth -
    (7 - DayOfWeekFirstDayInMonth) - DayOfWeekLastDayInMonth + 1) / 7) + 1;
end;

function TDateTimeHelper.AsStringDateISO: string;
begin
  if Frac(Self) = 0 then
    Result := FormatDateTime('yyyy-mm-dd', Self)
  else
    Result := DateToISO8601(Self, true);
end;

procedure TDateTimeHelper.SetDateISO(const aDateISO: string);
begin
  Self := ISO8601ToDate(aDateISO);
end;

class function TDateTimeHelper.Today: TDateTime;
begin
  Result := Date();
end;

class function TDateTimeHelper.New(aYear: integer = 0; aMonth: integer = 0; aDay: integer = 0): TDateTime;
begin
  if (aYear = 0) and (aMonth = 0) and (aDay = 0) then
    Result := UndefinedDateTime
  else
  begin
    try
      Result := EncodeDate(aYear, aMonth, aDay);
    except
      on E: Exception do
        raise Exception.CreateFmt('Invalid date components: Year=%d, Month=%d, Day=%d. %s',
          [aYear, aMonth, aDay, E.Message]);
    end;
  end;
end;

function TDateTimeHelper.At(aHour: integer; aMinute: integer; aSecond: integer = 0): TDateTime;
var
  TimePart: TDateTime;
begin
  if (aHour < 0) or (aHour > 23) then
    raise Exception.CreateFmt('Invalid hour value: %d. Must be between 0 and 23', [aHour]);
  if (aMinute < 0) or (aMinute > 59) then
    raise Exception.CreateFmt('Invalid minute value: %d. Must be between 0 and 59', [aMinute]);
  if (aSecond < 0) or (aSecond > 59) then
    raise Exception.CreateFmt('Invalid second value: %d. Must be between 0 and 59', [aSecond]);
  
  try
    TimePart := EncodeTime(aHour, aMinute, aSecond, 0);
    Result := Int(Self) + TimePart;
  except
    on E: Exception do
      raise Exception.CreateFmt('Failed to encode time: Hour=%d, Minute=%d, Second=%d. %s',
        [aHour, aMinute, aSecond, E.Message]);
  end;
end;

function TDateTimeHelper.IsUndefined: boolean;
begin
  Result := (Self = UndefinedDateTime);
end;

end.
