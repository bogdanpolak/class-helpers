﻿unit Helper.TForm;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.ExtCtrls,
  Vcl.Forms;

type
  TTimerKind = (tkTimeout, tkInterval);

  TTimerRecord = record
  public
    fTimerKind: TTimerKind;
    fTimer: TTImer;
    fOnInterval: TProc;
    class function Create: TTimerRecord; static;
  end;

  TFormHelper = class helper for TForm
  private const
    Version = '1.8';
  private
    class var fTimers: TArray<TTimerRecord>;
    class var fTimerCount: integer;
    class var fOwner: TComponent;
    class var fNextTimerID: integer;
    class procedure LocalGarbageCollector;
    class function FindTimer(aTimerID: integer): TTimerRecord;
    procedure EventMethod_OnTimer(Sender: TObject);
    function CreateNewTimer(aTimerKind: TTimerKind; aInterval: Cardinal;
      const afOnInterval: TProc): TTImer;
  public
    class constructor Create;
    class destructor Destory;
    /// <summary>
    ///   Starts a new interval counter and returns its ID, which you can
    ///   use to delete / stop the interval at a later time. Interval is a
    ///   cyclic timer call executed every "aInterval" milliseconds.
    ///   The "aOnInterval" parameter is the method invoked (object, class or
    ///   anonymous methods can be provided)
    /// </summary>
    ///  <see cref="TFormHelper.StopInterval"/>
    function SetInterval(aInterval: Cardinal; aOnInterval: TProc): integer;
    /// <summary>
    ///   Stops an active interval using its ID.
    /// </summary>
    ///  <see cref="TFormHelper.SetInterval"/>
    procedure StopInterval(aIntervalID: integer);
    /// <summary>
    ///   Starts one-time timer and invokes "aOnTimeout" method after
    ///   "aTimeout" milliseconds.
    /// </summary>
    ///  <see cref="TFormHelper.SetInterval"/>
    procedure SetTimeout(aTimeout: Cardinal; aOnTimeout: TProc);
    /// <summary>
    ///   Allows to define method invoked just after a first display on the
    ///   form, when all its resources are initialized and activated. The
    ///   "aOnReady" method is invoked only once.
    /// </summary>
    procedure SetOnFormReady(aOnReady: TProc);
    /// <summary>
    ///   Allows to check number of currently constructed internal timers. This
    ///   timers should be removed automatically when they are no longer needed.
    ///   Available for diagnostic purposes.
    /// </summary>
    function GetTimersCount: integer;
  end;

implementation

// -----------------------------------------------------------------------
// class constructor / class destructor
// -----------------------------------------------------------------------

class constructor TFormHelper.Create;
begin
  fOwner := TComponent.Create(nil);
  fNextTimerID := 1;
  fTimers := nil;
  fTimerCount := 0;
end;

class destructor TFormHelper.Destory;
begin
  LocalGarbageCollector;
  if fOwner <> nil then
    fOwner.Free;
end;

// -----------------------------------------------------------------------
// Utils
// -----------------------------------------------------------------------

class function TTimerRecord.Create: TTimerRecord;
begin
  Result.fTimerKind := tkInterval;
  Result.fTimer := nil;
  Result.fOnInterval := nil;
end;

class procedure TFormHelper.LocalGarbageCollector;
var
  idx: integer;
  j: integer;
begin
  if fTimerCount = 0 then
    exit;
  for idx := fTimerCount - 1 downto 0 do
    if not fTimers[idx].fTimer.Enabled then
    begin
      fTimers[idx].fTimer.Free;
      fTimers[idx].fTimer := nil;
      for j := idx + 1 to fTimerCount - 1 do
        fTimers[j - 1] := fTimers[j];
      fTimers[fTimerCount - 1] := TTimerRecord.Create;
      dec(fTimerCount);
    end;
end;

class function TFormHelper.FindTimer(aTimerID: integer): TTimerRecord;
var
  idx: integer;
begin
  for idx := 0 to fTimerCount - 1 do
    if aTimerID = fTimers[idx].fTimer.Tag then
      exit(fTimers[idx]);
  Result := TTimerRecord.Create;
end;

procedure TFormHelper.EventMethod_OnTimer(Sender: TObject);
var
  aTimer: TTImer;
  aTimerID: integer;
  aTimerRec: TTimerRecord;
begin
  LocalGarbageCollector;
  if not(Sender is TTImer) then
    exit;
  aTimer := (Sender as TTImer);
  aTimerID := aTimer.Tag;
  aTimerRec := FindTimer(aTimerID);
  if (aTimerRec.fTimer <> nil) and (aTimerRec.fTimerKind = tkTimeout) then
    aTimerRec.fTimer.Enabled := False;
  if Assigned(aTimerRec.fOnInterval) then
    aTimerRec.fOnInterval();
end;

function TFormHelper.CreateNewTimer(aTimerKind: TTimerKind; aInterval: Cardinal;
  const afOnInterval: TProc): TTImer;
var
  aTimer: TTImer;
begin
  LocalGarbageCollector;
  aTimer := TTImer.Create(fOwner);
  aTimer.Tag := fNextTimerID;
  fNextTimerID := fNextTimerID + 1;
  if fTimerCount = Length(fTimers) then
  begin
    SetLength(fTimers, fTimerCount + 10);
  end;
  fTimers[fTimerCount].fTimerKind := aTimerKind;
  fTimers[fTimerCount].fTimer := aTimer;
  fTimers[fTimerCount].fOnInterval := afOnInterval;
  fTimerCount := fTimerCount + 1;
  aTimer.OnTimer := EventMethod_OnTimer;
  aTimer.Interval := aInterval;
  aTimer.Enabled := True;
  Result := aTimer;
end;

// -----------------------------------------------------------------------
// Helper methods
// -----------------------------------------------------------------------

function TFormHelper.GetTimersCount: integer;
begin
  Result := fOwner.ComponentCount;
end;

function TFormHelper.SetInterval(aInterval: Cardinal;
  aOnInterval: TProc): integer;
var
  aTimer: TTImer;
begin
  aTimer := CreateNewTimer(tkInterval, aInterval, aOnInterval);
  Result := aTimer.Tag;
end;

procedure TFormHelper.StopInterval(aIntervalID: integer);
var
  aTimerRec: TTimerRecord;
begin
  aTimerRec := FindTimer(aIntervalID);
  if aTimerRec.fTimer <> nil then
    aTimerRec.fTimer.Enabled := False;
  LocalGarbageCollector;
end;

procedure TFormHelper.SetTimeout(aTimeout: Cardinal; aOnTimeout: TProc);
begin
  CreateNewTimer(tkTimeout, aTimeout, aOnTimeout);
end;

procedure TFormHelper.SetOnFormReady(aOnReady: TProc);
begin
  CreateNewTimer(tkTimeout, 1, aOnReady);
end;

end.
