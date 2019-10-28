unit Info.CalendarRender;

interface

uses
  System.SysUtils;

type
  TCalendarRenderInfo = class
  public
    DayOfWeekFirst: byte;
    DayOfWeekLast: byte;
    Weeks: byte;
    constructor Create(aDayOfWeekFirst: byte; aDayOfWeekLast: byte;
      aWeeks: byte);
    function ToString: string; override;
  end;

implementation

constructor TCalendarRenderInfo.Create(aDayOfWeekFirst: byte;
  aDayOfWeekLast: byte; aWeeks: byte);
begin
  DayOfWeekFirst := aDayOfWeekFirst;
  DayOfWeekLast := aDayOfWeekLast;
  Weeks := aWeeks;
end;

function TCalendarRenderInfo.ToString: string;
begin
  Result := Format('[%d, %d, %d]', [DayOfWeekFirst, DayOfWeekLast, Weeks])
end;

end.
