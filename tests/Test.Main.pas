unit Test.Main;

interface

uses
  DUnitX.TestFramework,
  System.Classes,
  System.SysUtils,

  Helper.TDateTime;

{$M+}

type

  [TestFixture]
  TDate2019_10_24_T_21_15_59 = class(TObject)
  private
    fDate: TDateTime;
  public
    [Setup]
    procedure Setup;
  published
    procedure Test_AsYear;
    procedure Test_AsDay;
    procedure Test_AsMonth;
    procedure Test_DatePart;
    procedure Test_AsHour;
    procedure Test_AsMinute;
    procedure Test_AsSeconds;
  end;

implementation

// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TDate2019_10_24_T_21_15_59.Setup;
begin
  fDate := EncodeDate(2019,10,24) + EncodeTime(21,15,59,0);
end;

// -----------------------------------------------------------------------
// Tests section 1
// -----------------------------------------------------------------------
{$REGION 'Test section 1'}

procedure TDate2019_10_24_T_21_15_59.Test_AsYear;
begin
  Assert.AreEqual(2019, fDate.AsYear);
end;

procedure TDate2019_10_24_T_21_15_59.Test_AsMonth;
begin
  Assert.AreEqual(10, fDate.AsMonth);
end;

procedure TDate2019_10_24_T_21_15_59.Test_AsDay;
begin
  Assert.AreEqual(24, fDate.AsDay);
end;

procedure TDate2019_10_24_T_21_15_59.Test_DatePart;
begin
  Assert.AreEqual(double(43762), fDate.DatePart);
end;

procedure TDate2019_10_24_T_21_15_59.Test_AsHour;
begin
  Assert.AreEqual(21, fDate.AsHour);
end;

procedure TDate2019_10_24_T_21_15_59.Test_AsMinute;
begin
  Assert.AreEqual(15, fDate.AsMinute);
end;

procedure TDate2019_10_24_T_21_15_59.Test_AsSeconds;
begin
  Assert.AreEqual(59, fDate.AsSecond);
end;

  (*
    Minute: word;
    Second: word;
    TimePart: TDateTime;
    ToString(const Format: string = ''): string;
    AsFloat: double;
    DayOfWeek: word;
    DayOfWeekName: string;
    DayOfWeekShortName: string;
    DaysInMonth: word;
    IncMonth(incerment: word): TDateTime;
  *)

{$ENDREGION}

initialization

TDUnitX.RegisterTestFixture(TDate2019_10_24_T_21_15_59);

end.
