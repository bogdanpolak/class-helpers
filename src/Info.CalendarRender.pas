unit Info.CalendarRender;

interface

type
  TCalendarRenderInfo = class
  public
    DayOfWeekFirst: byte;
    DayOfWeekLast: byte;
    Weeks: byte;
    constructor Create(aDayOfWeekFirst: byte; aDayOfWeekLast: byte;
      aWeeks: byte);
  end;

implementation

constructor TCalendarRenderInfo.Create(aDayOfWeekFirst: byte;
  aDayOfWeekLast: byte; aWeeks: byte);
begin
  DayOfWeekFirst := aDayOfWeekFirst;
  DayOfWeekLast := aDayOfWeekLast;
  Weeks := aWeeks;
end;

end.
