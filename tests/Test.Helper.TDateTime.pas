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
  TestDateTimeHelper = class(TObject)
  private
    fDate: TDateTime;
    fExpected: TDateTime;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure AsYear_2019;
    procedure AsMonth_September;
    procedure AsDay_27;
    procedure DatePart_27May2019;
    procedure AsHour_23h19m15sec;
    procedure AsHour_13June2019_13h00m;
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
    procedure Test_IncMonth_Minus1;
    procedure Test_FirstDayInMonth;
    procedure Test_LastDayInMonth;
    procedure Test_DayOfWeekFirstDayInMonth;
    procedure Test_DayOfWeekLastDayInMonth;
    procedure Test_NumberOfWeeksInMonth;
  end;

  [TestFixture]
  TDate_Cases = class(TObject)
  public
    [TestCase('Month: 02-2010', '4,2010-02-01')]
    [TestCase('Month: 04-2012', '6,2012-04-01')]
    [TestCase('Month: 02-2019', '5,2019-02-28')]
    [TestCase('Month: 10-2019', '5,2019-10-02')]
    [TestCase('Month: 11-2019', '5,2019-11-30')]
    [TestCase('Month: 12-2019', '6,2019-12-31')]
    [TestCase('Month: 01-2020', '5,2020-01-01')]
    [TestCase('Month: 02-2020', '5,2020-02-29')]
    procedure Test_NumberOfWeeks(expectedNumberOfWeeks: integer;
      actualMohthYear: string);
  end;

implementation

type
  TAssertClassHelper = class helper for Assert
    class procedure AreDateEqual(expectedYY, expectedMM, expectedDD: word;
      actualDate: TDateTime);
  end;

class procedure TAssertClassHelper.AreDateEqual(expectedYY, expectedMM,
  expectedDD: word; actualDate: TDateTime);
var
  s1: string;
  s2: string;
begin
  s1 := EncodeDate(expectedYY, expectedMM, expectedDD).ToString;
  s2 := actualDate.ToString();
  AreEqual(s1, s2);
end;


// -----------------------------------------------------------------------
// Setup and TearDown section
// -----------------------------------------------------------------------

procedure TestDateTimeHelper.Setup;
begin
  fDate := EncodeDate(2019, 10, 24) + EncodeTime(21, 15, 59, 0);
  FormatSettings.DateSeparator := '-';
  FormatSettings.ShortDateFormat := 'yyyy/mm/dd';
end;

procedure TestDateTimeHelper.TearDown;
begin
end;

// -----------------------------------------------------------------------
// Tests section 1
// -----------------------------------------------------------------------
{$REGION 'Test section 1'}

procedure TestDateTimeHelper.AsYear_2019;
var
  actualYear: Word;
begin
  fDate := EncodeDate(2019, 10, 24);
  actualYear := fDate.AsYear;
  Assert.AreEqual(2019, actualYear);
end;

procedure TestDateTimeHelper.AsMonth_September;
var
  actualMonth: Word;
begin
  fDate := EncodeDate(2019, 09, 01);
  actualMonth := fDate.AsMonth;
  Assert.AreEqual(9, actualMonth);
end;

procedure TestDateTimeHelper.AsDay_27;
var
  actualDay: Word;
begin
  fDate := EncodeDate(2019, 01, 27);
  actualDay := fDate.AsDay;
  Assert.AreEqual(27, actualDay);
end;

procedure TestDateTimeHelper.DatePart_27May2019;
var
  actualDate: TDateTime;
begin
  fDate := EncodeDate(2019, 05, 27) + EncodeTime(11, 25, 15, 0);
  actualDate := fDate.DatePart;
  Assert.AreEqual(TDateTime(43612), actualDate);
end;

procedure TestDateTimeHelper.AsHour_23h19m15sec;
var
  actualHour: Word;
begin
  fDate := EncodeTime(23, 25, 15, 0);
  actualHour := fDate.AsHour;
  Assert.AreEqual(23, actualHour);
end;

procedure TestDateTimeHelper.AsHour_13June2019_13h00m;
var
  actualHour: Word;
begin
  fDate := EncodeDate(2019, 05, 27) + EncodeTime(13, 00, 00, 00);
  actualHour := fDate.AsHour;
  Assert.AreEqual(13, actualHour);
end;

procedure TestDateTimeHelper.Test_AsMinute;
begin
  Assert.AreEqual(15, fDate.AsMinute);
end;

procedure TestDateTimeHelper.Test_AsSeconds;
begin
  Assert.AreEqual(59, fDate.AsSecond);
end;

procedure TestDateTimeHelper.Test_TimePart;
begin
  fExpected := 21 * (1 / 24) + 15 * (1 / 24 / 60) + 59 * (1 / 24 / 60 / 60);
  Assert.AreEqual(fExpected, fDate.TimePart, 0.00000001);
end;

procedure TestDateTimeHelper.Test_ToString_Empty;
begin
  Assert.AreEqual('2019-10-24', fDate.ToString());
end;

procedure TestDateTimeHelper.Test_ToString_yymmdd;
begin

  Assert.AreEqual('24 ' + FormatSettings.ShortMonthNames[10] + ' 2019',
    fDate.ToString('dd mmm yyyy'));
end;

procedure TestDateTimeHelper.Test_AsFloat;
begin
  Assert.AreEqual(double(43762.886099537), fDate.AsFloat, 0.00000001);
end;

procedure TestDateTimeHelper.Test_DayOfWeek;
begin
  Assert.AreEqual(5, fDate.DayOfWeek);
end;

procedure TestDateTimeHelper.Test_DayOfWeekName;
begin
  Assert.AreEqual(FormatSettings.LongDayNames[5], fDate.DayOfWeekName);
end;

procedure TestDateTimeHelper.Test_DayOfWeekShortName;
begin
  Assert.AreEqual(FormatSettings.ShortDayNames[5], fDate.DayOfWeekShortName);
end;

procedure TestDateTimeHelper.Test_DaysInMonth;
begin
  Assert.AreEqual(31, fDate.DaysInMonth);
end;

procedure TestDateTimeHelper.Test_IncMonth_5;
begin
  Assert.AreDateEqual(2020, 3, 24, fDate.IncMonth(5));
end;

procedure TestDateTimeHelper.Test_IncMonth_Minus1;
begin
  Assert.AreDateEqual(2019, 9, 24, fDate.IncMonth(-1));
end;

procedure TestDateTimeHelper.Test_FirstDayInMonth;
begin
  Assert.AreDateEqual(2019, 10, 1, fDate.FirstDayInMonth);
end;

procedure TestDateTimeHelper.Test_LastDayInMonth;
begin
  Assert.AreDateEqual(2019, 10, 31, fDate.LastDayInMonth);
end;

procedure TestDateTimeHelper.Test_DayOfWeekFirstDayInMonth;
begin
  Assert.AreEqual(2, fDate.DayOfWeekFirstDayInMonth);
end;

procedure TestDateTimeHelper.Test_DayOfWeekLastDayInMonth;
begin
  Assert.AreEqual(4, fDate.DayOfWeekLastDayInMonth);
end;

procedure TestDateTimeHelper.Test_NumberOfWeeksInMonth;
begin
  Assert.AreEqual(5, fDate.NumberOfWeeksInMonth);
end;

{$ENDREGION}
// -----------------------------------------------------------------------
// Tests cases: TDate_Cases
// -----------------------------------------------------------------------

procedure TDate_Cases.Test_NumberOfWeeks(expectedNumberOfWeeks: integer;
  actualMohthYear: string);
var
  yy, mm, dd: word;
  actualDate: TDateTime;
begin
  yy := actualMohthYear.Substring(0, 4).ToInteger();
  mm := actualMohthYear.Substring(5, 2).ToInteger();
  dd := actualMohthYear.Substring(8, 2).ToInteger();
  actualDate := EncodeDate(yy, mm, dd);
  Assert.AreEqual(word(expectedNumberOfWeeks), actualDate.NumberOfWeeksInMonth);
end;

initialization

TDUnitX.RegisterTestFixture(TestDateTimeHelper);

end.
