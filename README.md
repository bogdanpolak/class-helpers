﻿# Delphi Class Helpers - VCL RTL and FireDAC

![ Delphi Support ](https://img.shields.io/badge/Delphi%20Support-%20XE4%20..%2011.2-blue.svg)
![ version ](https://img.shields.io/badge/version-%201.8-yellow.svg)

# Delphi Class Helpers

Make Delphi code more readable using class helpers:

Classic call:
```pas
StoreDataset (1, mysqlDataSet, true);
```
More readable call:
```pas
mysqlDataSet.StoreSelected_StopAfterFirstError(
   function():boolean
   begin
     Result := mysqlDataSet.FieldByName('Status').Value = '1'
   end), fDataStorer);
```

# Sample helpers

**TBytes Helper** - Generate numbers, ZLib compress, Base64 encode, Calc CRC32

```pas
uses
  Helpers.TBytes;

type
  TUploadImageCommand = record
    Image: string;
    ControlSum: integer;
  end;

procedure SendCommandToRestServer(const aCommand: TUploadImageCommand); 
begin
  writeln('Use RestClient or IdHttpClient to send POST request');
  writeln('POST /rest/upload-image/ TUploadImageCommand');
  writeln('TUploadImageCommand:');
  writeln('    ControlSum = ', aCommand.ControlSum);
  writeln('    Image Length = ', Length(aCommand.Image));
  writeln('    Image = ', aCommand.Image);
end;

var
  bytes: TBytes;
  idx: integer;
  memoryStream: TMemoryStream;
  command := TUploadImageCommand;
begin
  bytes.Size := 1000;
  for idx := 0 to bytes.Size-1 do
    bytes[idx] := idx div 10;
  memoryStream := TMemoryStream.Create();
  bytes := CompressToStream(memoryStream);
  command.Image := bytes.GenerateBase64Code();
  command.ControlSum := bytes.GetSectorCRC32(0, bytes.Size);
  SendCommandToRestServer(command);
end.
```

**TBytes Helper**:  Store and Load TBytes from Stream or File. Load and verify PNG image

```pas
uses
  Helpers.TBytes;

var
  bytes: TBytes;
  idx: integer;
  memoryStream: TMemoryStream;
  command := TUploadImageCommand;
begin
  bytes.InitialiseFromBase64String('U2FtcGxlIHRleHQ=');
  bytes.SaveToFile('notes.txt'); // save: Sample text
  memoryStream:= bytes.CreateStream();
  // memoryStream.Size = 11
  memoryStream.Free;
  // -----------------
  s :=  bytes.GetSectorAsString(0, 6);  // ASCII only text
  bytes := [0, 0, 15, 16, $A0, 255, 0, 0, 0, 0, 1];
  if bytes.GetSectorAsHex(2, 4) = '0F 10 A0 FF' then
  begin
    memoryStream := TMemoryStream.Create();
    memoryStream.LoadFromFile('small.png');
    memoryStream.Position := 0;
    signature.LoadFromStream(memoryStream,8);
    if (signature.GetSectorAsHex = '89 50 4E 47 0D 0A 1A 0A') and
       (signature.GetSectorAsString(1, 3) = 'PNG') then
    begin
      memoryStream.Position := 0;
      pngImage := TPngImage.Create;
      pngImage.LoadFromStream(memoryStream);
      // Image1.Picture := pngImage;
      pngImage.Free;
    end;
    memoryStream.Free;
  end;
end;
```

**TDateTime Helper**: Informations about TDateTime

```pas
uses
  Helpers.TDateTime;

var
  date: TDateTime;
begin
  date := EncodeDate(1989, 06, 04);
  writeln(date.AsYear);  // 1989
  writeln(date.AsMonth);  // 06
  writeln(date);  //  06/04/1989
  writeln(EncodeDate(2017, 10, 24).DayOfWeek);  // 3
  writeln(date.IncMonth(5).ToString('yyyy-mm-dd');  //  1989-11-04
  writeln(date.AsStringDateISO);  //  1989-06-04
  date := EncodeDate(2019, 10, 24) + EncodeTime(18,45,12,0);
  writeln(date.AsStringDateISO);  //  2019-10-24T18:45:12.000Z
end.
```

**TDataSet Helper**: ForEachRow, LoadData<>, SaveData<>

```pas
uses
  Helpers.TDataSet;

type
  TCity = class
  public
    id: Integer;
    City: string;
    Rank: Variant;
    visited: Variant;
  end;
  
var
  dataset: TDataSet;
  cityNames: TArray<string>;
  idx: integer;
  cities: TObjectList<TCityForDataset>;
begin
  dataset := GivenDataSet(fOwner, [
    { } [1, 'Edinburgh', 5.5, EncodeDate(2018, 05, 28)],
    { } [2, 'Glassgow', 4.5, EncodeDate(2015, 09, 13)],
    { } [3, 'Cracow', 6.0, EncodeDate(2019, 01, 01)],
    { } [4, 'Prague', 4.9, EncodeDate(2013, 06, 21)]]);
  SetLength(cityNames, dataset.RecordCount);
  idx := 0;
  dataset.ForEachRow(
    procedure
    begin
      cityNames[idx] := dataset.FieldByName('city').AsString;
      inc(idx);
    end);
  writeln(string.Join(', ', citiecityNamess));

  cities := dataset.LoadData<TCityForDataset>();
  witeln(cities.Count);  // 4
  witeln(cities[0].City);  // Edinburgh
  witeln(cities[3].Rank); //  4.9

  cities[2].Rank := 5.8;
  cities[2].visited := EncodeDate(2020, 7, 22);
  cities.Add(TCity.Create());
  cities[4].id := 5;
  cities[4].City := 'Warsaw';
  dataset.SaveData<TCity>(cities);
  // SaveData updated Cracow record and added Warsaw
end
```


**TStringGrid Helper**: Fill and Resize TStringGrid


```pas
// StringGrid1: TStringGrid;
// StringGrid2: TStringGrid;

procedure TForm1.Button1Click(Sender: TObject);
var
  structure, rows: string;
begin
  StringGrid1.ColCount := 4;
  StringGrid1.RowCount := 3;
  StringGrid1.ColsWidth([40, 100, 90, 110, 80]);
  StringGrid1.FillCells([
    ['1', 'Jonh Black', 'U21', '34'], 
    ['2', 'Bogdan Polak', 'N47', '28']]);

  structure := 
    '{"column": "no", "caption": "No.", "width": 30}, ' +
    '{"column": "mesure", "caption": "Mesure description", "width": 200}, ' +
    '{"column": "value", "caption": "Value", "width": 60}';
  rows := 
    '{"no": 1, "mesure": "Number of DI Containers", "value": 120},' +
    '{"no": 2, "mesure": "Maximum ctor injection",  "value": 56}'; 
  data
  jsData := TJSONObject.ParseJSONValue(Format(
    '{"structure": [%s],  "data": [%s]}', [structure, rows])
    ) as TJSONObject; 
  StringGrid2.FillWithJson(jsData);
end;
```

# Available Helpers

**RTL Helpers:**

| Unit | Helper description |
| --- | --- |
| [Helper.TBytes](./doc/Helper.TBytes.md) | Allows to manipulates arrays of bytes: size, load & save, getter & setters |
| Helper.TDataSet | Additional TDataSet functionality like: iterating through dataset or LoadData / SaveData - allows to map a list of objects to the dataset |
| Helper.TDateTime | Methods that allow easily manipulate date and time |
| Helper.TField | Allows to load Base64 data into Blob Field or verifying signature of the stored data |
| Helper.TJSONObject | Methods reading data or storing in the JSON DOM structure, like IsValidIsoDate(fieldName) |
| Helper.TStream | Methods which facilitate reading and writing data to streams |

**VCL Helpers:**

| Expanded class | Helper description |
| --- | --- |
| TApplication | Sample helper containing experimental method like: `InDeveloperMode`. |
| TDBGrid | Methods manipulating DBGrid columns, like: AutoSizeColumns - automatically arranging with of each column |
| TForm | Methods managing timers: SetInterval and SetTimeout |
| TPicture | Allow to assign TBytes and TBlobField to TPicture with automatic image format recognition |
| TStringGrid | Filling and configuring String Grid control: loading data, setting columns width, clearing content of cell or row |
| TWinControl | Utility methods for searching child controls by type or by name. Visible for all TWinControl descendants: TForm, TPanel, etc.  |

**Other Helpers:**

| Expanded class | Helper description |
| --- | --- |
| Helper.TFDConnection |  |
| Helper.TFDCustomManager |  |

Helper naming convention is to add suffix `Helper` to the name of the expanded class, what means that class helper for `TDataSet` will has a name `TDataSetHelper`. 

Each helper is stored in a separate file and unit its name is `Helper.<ExpanedClassName>.pas`.

All helper units are stored in the `src` subfolder -  [go to that location](src/).


# Helpers Demo Projects

1) Class Helper Playground - sample project
   - Location: `examples/01-playground/` - [go to that location](examples/01-playground/)
   - Project name: `HelperPlayground.dpr`
   - Contains several frames and each of them is demonstrating one or two helpers
   - Demo frames:
      - **Frame.StringGridHelper** - `Helper.TStringGrid.pas`
      - **Frame.DataSetHelper** - `Helper.TDataSet.pas` and `Helper.TDBGrid.pas`
      - **Frame.ByteAndStreamHelpers** - `Helper.TBytes.pas` and `Helper.TStream.pas`
1) Form Helper Demo
   - Location: `examples/02-formhelper/` - [go to that location](examples/02-formhelper/)
   - Project name: `HelpersMiniDemo.dpr`
   - Simple project presenting `Helper.TForm.pas` and usage of timer a helper methods


# Why Class Helpers?

### 1. Safe cleaning technique

The huge amount of VCL (FMX) code can be cleared using class helpers, which are actually an easy refactoring technique with low risk for complex projects. Using this method, teams can start upgrading their legacy projects even without unit tests safety net. Moreover the verification of newly created helpers can be easily done with unit tests. This approach allow to teach developers how to write unit tests in a correct way (learn in practice F.I.R.S.T principles or other). Teams can also easily apply TDD development process (write tests first and then implement functionality) in a fun and non-invasive way.

Sometimes class helpers could be also dangerous if they are used improperly. For this reason it is required to apply a little more disciplined development and delivery process, suggestions connected with that area are covered in the following sections. 

Class helpers benefits:

- **Extract global functions** - global functions and utility methods wrote straight in forms (modules) can be extracted and reuse, also they can grouped together in separated containers based on subject class, finally they can be covered with unit tests
- **Reduce size of events** - size of code in events (forms, frames and data modules) can be significantly decreased, which helps to improve code readability, especially when valuable business code is  mixed together with visualization or with component processing
- **Improve utility code readability** - it is available by removing one of the function parameter which is a call subject (see bellow "Subject first" sample), together with that small improvements we are able to remove flags from calls, use more meaningful names, compress conditional sequences, make complex things simpler and safer
- **Introduce TDD approach**. - class helpers should be autonomous and not dependent on project's business code, thanks of that are  easy to cover with unit tests, then can be expanded using TDD development (red-green-refactor) which is really helpful here

### 2. Private fields/methods lock-pick (now not available)

From the very beginning (Delphi 2006) till Delphi Berlin / 10.1 version there was quite popular class helper bug, which allows to access private fields and private methods using helpers. Because of this bug many developers identified this interesting language extension with such hack. The misuse of class helpers has caused that value of this super powerful solution is underestimated. 


# TDD and Unit testing

One of the important purposes of using class helpers is ability of extract useful and reusable code, and then cover them with unit tests. Developers can even easily employ TDD, test driven approach in which first we need to write unit tests and then implement logic


That repository is demonstrating how to practice TDD approach. Each class and record helper has DUnitX test. Unit test sets can be easily expanded to provide better test coverage. To have better unit testing experience it's recommended to install the best TDD Delphi IDE extension **TestInsight** - free and a very productive platform created by Stefan Glienke. Glory to the author! Link to the TestInsight repo: [go to the Bitbucket site](https://bitbucket.org/sglienke/testinsight/wiki/Home)

Sample unit test can be found in `tests` repository folder - [go to that location](tests/)

Sample test of `TStringGrid` class helper `ColsWidth` method:

```pas
procedure TestTStringGridHelper.FiveColumns_ColsWidth;
begin
  fGrid.ColCount := 5;
  fGrid.ColsWidth([50, 100, 90, 110, 80]);
  Assert.AreEqual(110, fGrid.ColWidths[3]);
  Assert.AreEqual(80, fGrid.ColWidths[4]);
end;
```

## Class Helpers in Delphi


## Good practices

Class helpers looks really promising in the begging and actually there are great solution, but as you create and use more and more of them, you'll start to notice some obstacles. For this reason, good practices should be adapted from the beginning to help avoid potential problems.

1. **One helper for one class (in whole project).** It's possible to declare two class helpers with different methods extending the same class. Although they cannot be used together in one unit (only one of them will be visible), but such code can be compiled. You can potentially use two different helpers in separate units, but you shouldn't do that because it can be dangerous and generate difficult to fix bugs.
1. **Unified collection of helpers.** Try do keep consistent and unified collection of class helpers. The best solution is created separate repository (more details in the following section). At first, helpers may be part of the main business project, but it is better to isolate them, especially when you plan to reuse them in many projects. Helpers should be treated as independent components that have been tested and implemented in the final project.
1. **Use only when necessary.** Do not declare class helpers for your classes, which can be easily extend using classic OOP methods, such as inheritance, polymorphism and composition. Helpers are really useful for extending the functionality of RTL, VCL or FMX classes. They can also be successfully used to extend third-party components. The added functionality should be domain independent and easy to reuse in various projects.
1. **Define as close as possible.** The class helper should be defined as close to the used class as possible. The VCL framework has very expanded inheritance tree and in some cases developer can define expanding method for more general class (like TWinControl) or for more specialized one (like TGroupBox). From usage perspective, it is much better to expand specialized classes then general: it could be more difficult to figure out which helper unit has to be included (added to uses section) after coping existing code into a new unit. When helper is defined for the same class which is actually used this is not a problem.
1. **Define release cycle.** A project with helpers should be treated as an independent product. As a consumer the developer should be aware of helpers version which he is using now and about possible available updates. More information you can find in Maintenance section.


## Helpers maintenance

 One of the recommended practices when using class helpers is to plan good  project maintenance, including version control and release management. Proven steps including two important point: 

1. **Independent project** - class helpers should be maintained as a separate project, versioned and merged into finial projects like other external packages.
1. **Helpers release cycle** - class helpers project should have releases with defined version numbers and dates. Which makes it necessary to build an independent branching model in the repository. New helpers release can be tested before deploy and then integrated with final projects at the right time. Such integration can be simple or a little more difficult depending on the number of breakthrough changes.

This GitHub project is live example of such deployment techniques. We are using branching model inspired by Vincent Driessen blog post: [A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/) together with planing and delivery model inspired by Kanban method.

**Class helpers project branching model**

![](./doc/resources/branching-model.png)

* Green and brown branches are feature branches, which are temporary one
   - first one (brown) `is021-grid-column-restore` is for new feature: method `LoadColumnsFromJsonString` in TDBGrid class helper, which allows to restore column configuration (order, title caption, width and visibility) stored in JSON string. Feature definition is written in [GitHub Issue #21](https://github.com/bogdanpolak/class-helpers/issues/21)
   - second one (green) `is014-doc-dark-side` is new documentation section in main `README.md` file. 
* Violet branch is version (release) branch, which is long-life one 
   - Feature branches are merged into version when feature is ready to deliver. Developers shouldn't commit changes direct into version branch. In this example only final changes - before release are approved in violet branch
* Blue branch is master branch, which is infinite one
   - No direct changes are allowed on this branch and this is production branch

**Class helpers project Kanban board**

![](./doc/resources/kanban-board.png)

Kanban board and planning sessions are suggested techniques to achieve - incremental delivery. Class helpers project can't be delivered too often, because of integration cost (integration class helper repository with final Delphi projects). And from the other side delivery of the new version shouldn't take too long, because all projects should use advantages of new helpers (high reusability).


## The Dark Side of class helpers

Class helpers are look really nice on the first contact, but they have some dangerous side effects. In this section you able to better understand the weaknesses of this solution. If you try to define two class helpers expanding the same base class you will see that only one of them will be visible. More to that you are not able to expand class helper functionality with inheritance. Also you are not able to define additional memory (fields) in the class helper.

You can protect your project against the effects of these weaknesses. Before defining a new class helper you should ask yourself a few questions:

1. Better alternatives.
   - Q: **Is not possible to introduce expected functionality within a new class?** 
   - Definition of a new class is better approach, easier to understand and more popular, all dependencies should be inject to this class and whole composition should be easy to decouple into independent units.
   - A class helper could be a temporary solution during code refactoring (when developer is not sure about the responsibilities of the new class).
1. Where to define class helper
   - Q: **Which VCL / FMX or RTL classes should be chosen as a base for helper?**
   - The class helper should be defined as high in the component hierarchy as possible. After copy existing code into a new unit developer could be not able to compile it (receiving compiler error: *Undeclared identifier* for some method of a class). In that case the developer should be aware that he needs to add unit with class helper definition expanding this class to the uses section. It's is easy to fix this compiler error if helper is defined for actually used class. Otherwise developer has to check one by one more general (in inheritance chain) classes.
   - If this is possible define helper for specialized classes (`TButton`) not for more general (`TControl`, `TComponent`, etc.).
1. Extra cost - time
   - Q: **Are you able to spend extra time on maintaining helpers?**
   - Usually class helper are added as the supporting code together with more general tasks. This is OK, but after closing this task you need to spend some extra time on extracting this helper and adding it into helper repository
1. Version
   - Q: **What version of the helpers class project is being used now?**
   - Application should be using the most recent version of helpers, but migration from previous one to most recent one could cost some time, and have to be plan accordingly.
1. Unit test coverages
   - Q: **Are you able to write unit tests for class helper methods?**
   - Class helpers should be well documented and achieve the highest possible quality. Bugs inside class helpers could be really confusing for the developers
