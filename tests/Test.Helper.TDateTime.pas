unit Test.Helper.TDateTime;
// ♥ 2019 (c) https://github.com/bogdanpolak

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
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure AsYear_04June1989;
    procedure AsMonth_20Apr1971;
    procedure AsDay_12Sep1683;
    procedure DatePart_27May2019;
    procedure AsHour_23h19m15sec;
    procedure AsHour_13June2019_13h00m;
    procedure AsMinute_7h25m59s;
    procedure AsSeconds_8h59m13s;
    procedure TimePart_31Dec2019_23h59m59s;
    procedure ToString_31Dec2019_UK;
    procedure ToString_14October2019_USA;
    procedure ToString_Format_yymmdd;
    procedure AsFloat_01Jan1999_01h01m01s;
    procedure DayOfWeek_24Oct2017;
    procedure DayOfWeekName_24Oct2017_Ru;
    procedure DayOfWeekShortName_24Oct2017_Ru;
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
end;

procedure TestDateTimeHelper.TearDown;
begin
end;

// -----------------------------------------------------------------------
// Tests section 1
// -----------------------------------------------------------------------

procedure TestDateTimeHelper.AsYear_04June1989;
var
  actualYear: word;
begin
  fDate := EncodeDate(1989, 06, 04);
  actualYear := fDate.AsYear;
  Assert.AreEqual(1989, actualYear);
end;

procedure TestDateTimeHelper.AsMonth_20Apr1971;
var
  actualMonth: word;
begin
  fDate := EncodeDate(1971, 04, 21);
  actualMonth := fDate.AsMonth;
  Assert.AreEqual(4, actualMonth);
end;

procedure TestDateTimeHelper.AsDay_12Sep1683;
var
  actualDay: word;
begin
  fDate := EncodeDate(1683, 09, 12);
  actualDay := fDate.AsDay;
  Assert.AreEqual(12, actualDay);
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
  actualHour: word;
begin
  fDate := EncodeTime(23, 25, 15, 0);
  actualHour := fDate.AsHour;
  Assert.AreEqual(23, actualHour);
end;

procedure TestDateTimeHelper.AsHour_13June2019_13h00m;
var
  actualHour: word;
begin
  fDate := EncodeDate(2019, 05, 27) + EncodeTime(13, 00, 00, 00);
  actualHour := fDate.AsHour;
  Assert.AreEqual(13, actualHour);
end;

procedure TestDateTimeHelper.AsMinute_7h25m59s;
var
  actualMinute: word;
begin
  fDate := EncodeTime(07, 25, 59, 00);
  actualMinute := fDate.AsMinute;
  Assert.AreEqual(25, actualMinute);
end;

procedure TestDateTimeHelper.AsSeconds_8h59m13s;
var
  actualSecond: word;
begin
  fDate := EncodeTime(08, 59, 13, 00);
  actualSecond := fDate.AsSecond;
  Assert.AreEqual(13, actualSecond);
end;

procedure TestDateTimeHelper.TimePart_31Dec2019_23h59m59s;
var
  actualTime: TDateTime;
  expectedTime: TDateTime;
begin
  fDate := EncodeDate(2019, 12, 31) + EncodeTime(23, 59, 59, 00);
  actualTime := fDate.TimePart;
  expectedTime := 23 * (1 / 24) + 59 * (1 / 24 / 60) + 59 * (1 / 24 / 60 / 60);
  Assert.AreEqual(expectedTime, actualTime, 0.00000001);
end;

procedure TestDateTimeHelper.ToString_31Dec2019_UK;
var
  originalSettings: TFormatSettings;
  actualDateString: string;
begin
  originalSettings := FormatSettings;
  try
    FormatSettings := TFormatSettings.Create('uk-en');
    fDate := EncodeDate(2019, 12, 31);
    actualDateString := fDate.ToString();
    Assert.AreEqual('31.12.2019', actualDateString);
  finally
    FormatSettings := originalSettings;
  end;
end;

procedure TestDateTimeHelper.ToString_14October2019_USA;
var
  originalSettings: TFormatSettings;
  actualDateString: string;
begin
  originalSettings := FormatSettings;
  try
    FormatSettings := TFormatSettings.Create('en-us');
    fDate := EncodeDate(2019, 10, 14);
    actualDateString := fDate.ToString();
    Assert.AreEqual('10/14/2019', actualDateString);
  finally
    FormatSettings := originalSettings;
  end;
end;

procedure TestDateTimeHelper.ToString_Format_yymmdd;
var
  actualDateString: string;
  expectedDateString: string;
begin
  fDate := EncodeDate(2019, 10, 24);
  actualDateString := fDate.ToString('dd mmm yyyy');
  expectedDateString := '24 ' + FormatSettings.ShortMonthNames[10] + ' 2019';
  Assert.AreEqual(expectedDateString, actualDateString);
end;

procedure TestDateTimeHelper.AsFloat_01Jan1999_01h01m01s;
var
  expectedValue: double;
  actualValue: double;
begin
  fDate := EncodeDate(1999, 01, 01) + EncodeTime(01, 01, 01, 00);
  actualValue := fDate.AsFloat;
  expectedValue := 36161 // date part
    + 01 * (1 / 24) // hours
    + 01 * (1 / 24 / 60) // minutes
    + 01 * (1 / 24 / 60 / 60); // seconds
  Assert.AreEqual(expectedValue, actualValue, 0.00000001);
end;

procedure TestDateTimeHelper.DayOfWeek_24Oct2017;
var
  actualDayOfWeek: word;
begin
  fDate := EncodeDate(2017, 10, 24);
  actualDayOfWeek := fDate.DayOfWeek;
  Assert.AreEqual(3, actualDayOfWeek);
end;

procedure TestDateTimeHelper.DayOfWeekName_24Oct2017_Ru;
var
  originalSettings: TFormatSettings;
  actualDayOfWeekString: string;
begin
  originalSettings := FormatSettings;
  try
    FormatSettings := TFormatSettings.Create('ru-ru');
    fDate := EncodeDate(2017, 10, 24);
    actualDayOfWeekString := fDate.DayOfWeekName;
    // вторник (ru) = Tuesday (eng)
    Assert.AreEqual('вторник', actualDayOfWeekString);
  finally
    FormatSettings := originalSettings;
  end;
end;

procedure TestDateTimeHelper.DayOfWeekShortName_24Oct2017_Ru;
var
  originalSettings: TFormatSettings;
  actualDayOfWeekString: string;
begin
  originalSettings := FormatSettings;
  try
    FormatSettings := TFormatSettings.Create('ru-ru');
    fDate := EncodeDate(2017, 10, 24);
    actualDayOfWeekString := fDate.DayOfWeekShortName;
    Assert.AreEqual('Вт', actualDayOfWeekString);
  finally
    FormatSettings := originalSettings;
  end;
end;

procedure TestDateTimeHelper.Test_DaysInMonth;
begin
  fDate := EncodeDate(2019, 10, 24) + EncodeTime(21, 15, 59, 0);
  Assert.AreEqual(31, fDate.DaysInMonth);
end;

procedure TestDateTimeHelper.Test_IncMonth_5;
begin
  fDate := EncodeDate(2019, 10, 24) + EncodeTime(21, 15, 59, 0);
  Assert.AreDateEqual(2020, 3, 24, fDate.IncMonth(5));
end;

procedure TestDateTimeHelper.Test_IncMonth_Minus1;
begin
  fDate := EncodeDate(2019, 10, 24) + EncodeTime(21, 15, 59, 0);
  Assert.AreDateEqual(2019, 9, 24, fDate.IncMonth(-1));
end;

procedure TestDateTimeHelper.Test_FirstDayInMonth;
begin
  fDate := EncodeDate(2019, 10, 24) + EncodeTime(21, 15, 59, 0);
  Assert.AreDateEqual(2019, 10, 1, fDate.FirstDayInMonth);
end;

procedure TestDateTimeHelper.Test_LastDayInMonth;
begin
  fDate := EncodeDate(2019, 10, 24) + EncodeTime(21, 15, 59, 0);
  Assert.AreDateEqual(2019, 10, 31, fDate.LastDayInMonth);
end;

procedure TestDateTimeHelper.Test_DayOfWeekFirstDayInMonth;
begin
  fDate := EncodeDate(2019, 10, 24) + EncodeTime(21, 15, 59, 0);
  Assert.AreEqual(2, fDate.DayOfWeekFirstDayInMonth);
end;

procedure TestDateTimeHelper.Test_DayOfWeekLastDayInMonth;
begin
  fDate := EncodeDate(2019, 10, 24) + EncodeTime(21, 15, 59, 0);
  Assert.AreEqual(4, fDate.DayOfWeekLastDayInMonth);
end;

procedure TestDateTimeHelper.Test_NumberOfWeeksInMonth;
begin
  fDate := EncodeDate(2019, 10, 24) + EncodeTime(21, 15, 59, 0);
  Assert.AreEqual(5, fDate.NumberOfWeeksInMonth);
end;

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
