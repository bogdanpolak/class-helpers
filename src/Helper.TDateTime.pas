unit Helper.TDateTime;

interface

type
  TDateTimeHelper = record helper for TDateTime
  private const
    Version = '1.6';
  private
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
    function IncMonth(incerment: integer): TDateTime;
    /// <summary>
    ///   Returns first day in current month
    /// </summary>
    function FirstDayInMonth: TDateTime;
    /// <summary>
    ///   Returns last day in current month
    /// </summary>
    function LastDayInMonth: TDateTime;
    /// <summary>
    ///   Returns info to render Calendar = DayOfTheWeek for LastDayInMonth
    /// </summary>
    function DayOfWeekFirstDayInMonth: word;
    /// <summary>
    ///   Returns info to render Calendar = DayOfTheWeek for FirstDayInMonth
    /// </summary>
    function DayOfWeekLastDayInMonth: word;
    /// <summary>
    ///   Returns numbers of weeks included starting week and last week in
    ///   month (even if first and last are started partly only)
    /// </summary>
    function NumberOfWeeksInMonth: word;
    function AsStringDateISO: string;
    procedure SetDateISO (const aDateISO: string);
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
  Result:= '';
end;

procedure TDateTimeHelper.SetDateISO (const aDateISO: string);
begin
end;

end.
