﻿unit Helper.TWinControl;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Controls;

type
  TWinControlHelper = class helper for TWinControl
  private const
    Version = '1.8';
  private
  public
    function FindChildControlByType(aClass: TClass): TControl;
    function FindChildControlRecursiveByType(aClass: TClass): TControl;
    function FindChildControlRecursive(const aName: string): TControl;
    // function GetChildControlsByType(aClass: TClass): TArray<TControl>;
  end;

implementation

function TWinControlHelper.FindChildControlByType(aClass: TClass): TControl;
var
  i: Integer;
begin
  for i := 0 to Self.ControlCount - 1 do
    if Self.Controls[i].ClassType = aClass then
      Exit(Self.Controls[i]);
  Result := nil;
end;

function TWinControlHelper.FindChildControlRecursiveByType(aClass: TClass)
  : TControl;
var
  i: Integer;
begin
  Result := Self.FindChildControlByType(aClass);
  if Result = nil then
    for i := 0 to Self.ControlCount - 1 do
      if Self.Controls[i] is TWinControl then
      begin
        Result := (Self.Controls[i] as TWinControl)
          .FindChildControlRecursiveByType(aClass);
        if Result <> nil then
          Exit;
      end;
end;

function TWinControlHelper.FindChildControlRecursive(const aName: string)
  : TControl;
var
  i: Integer;
  winControl: TWinControl;
begin
  Result := Self.FindChildControl(aName);
  if Result = nil then
    for i := 0 to Self.ControlCount - 1 do
      if Self.Controls[i] is TWinControl then
      begin
        winControl := (Self.Controls[i] as TWinControl);
        Result := winControl.FindChildControlRecursive(aName);
        if Result <> nil then
          Exit;
      end;
end;

end.
