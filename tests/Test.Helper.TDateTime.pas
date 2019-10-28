unit Test.Helper.TDateTime;

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
    fExpected: TDateTime;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure Test_AsYear;
    procedure Test_AsDay;
    procedure Test_AsMonth;
    procedure Test_DatePart;
    procedure Test_AsHour;
    procedure Test_AsMinute;
    procedure Test_AsSeconds;
    procedure Test_TimePart;
    procedure Test_ToString_Empty;
    procedure Test_ToString_yymmdd;
    procedure Test_AsFloat;
    procedure Test_DayOfWeek;
    procedure Test_DayOfWeekName;
    procedure Test_DayOfWeekShortName;
    procedure Test_DaysInMonth;
    procedure Test_IncMonth_5;
  end;

implementation

// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TDate2019_10_24_T_21_15_59.Setup;
begin
  fDate := EncodeDate(2019,10,24) + EncodeTime(21,15,59,0);
  FormatSettings.DateSeparator := '-';
  FormatSettings.ShortDateFormat := 'yyyy/mm/dd';
end;

procedure TDate2019_10_24_T_21_15_59.TearDown;
begin
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

procedure TDate2019_10_24_T_21_15_59.Test_TimePart;
begin
  fExpected := 21*(1/24) + 15*(1/24/60) + 59*(1/24/60/60);
  Assert.AreEqual(fExpected, fDate.TimePart, 0.00000001);
end;

procedure TDate2019_10_24_T_21_15_59.Test_ToString_Empty;
begin
  Assert.AreEqual('2019-10-24', fDate.ToString());
end;

procedure TDate2019_10_24_T_21_15_59.Test_ToString_yymmdd;
begin

  Assert.AreEqual('24 '+FormatSettings.ShortMonthNames[10]+' 2019',
    fDate.ToString('dd mmm yyyy'));
end;

procedure TDate2019_10_24_T_21_15_59.Test_AsFloat;
begin
  Assert.AreEqual(double(43762.886099537), fDate.AsFloat, 0.00000001);
end;

procedure TDate2019_10_24_T_21_15_59.Test_DayOfWeek;
begin
  Assert.AreEqual(5, fDate.DayOfWeek);
end;

procedure TDate2019_10_24_T_21_15_59.Test_DayOfWeekName;
begin
  Assert.AreEqual(FormatSettings.LongDayNames[5], fDate.DayOfWeekName);
end;

procedure TDate2019_10_24_T_21_15_59.Test_DayOfWeekShortName;
begin
  Assert.AreEqual(FormatSettings.ShortDayNames[5], fDate.DayOfWeekShortName);
end;

procedure TDate2019_10_24_T_21_15_59.Test_DaysInMonth;
begin
  Assert.AreEqual(31, fDate.DaysInMonth);
end;

procedure TDate2019_10_24_T_21_15_59.Test_IncMonth_5;
begin
  Assert.AreEqual(Int(EncodeDate(2020,3,24)), Int(fDate.IncMonth(5)) );
end;

  (*
    : string;
    : word;
    (incerment: word): TDateTime;
  *)

{$ENDREGION}

initialization

TDUnitX.RegisterTestFixture(TDate2019_10_24_T_21_15_59);

end.
