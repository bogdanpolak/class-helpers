# Repository of VCL and RTL Class Helpers

![ Delphi Support ](https://img.shields.io/badge/Delphi%20Support-%2010%20..%2010.3%20Rio-blue.svg)
![ version ](https://img.shields.io/badge/version-%201.3-yellow.svg)

## Why use Class Helpers?

### 1. Historically used as private fields lock-picks

**This in not longer available in recent Delphi versions.** From the very beginning (2006) till Berlin / 10.1 version there was quite popular bug in class helpers, which allows to access private class fields and methods. Many developers identified this interesting language extension with such hack. The misuse of class helpers has led to this powerful cleaning solution being still underestimated. 

### 2. Safe cleaning technique

Huge amount of VCL code can be cleaned with class helpers, which are really safe refactoring technique. This refactoring is co much safe that can be done even without proper unit test coverage. In this context it is surprising that it allows to teach writing unit tests in a fun and non-invasive way. Class helpers have to be autonomous and thanks of that they are very easy code for teaching unit tests and TDD.

This refactoring approach requires a little more discipline and project organization and it will be covered bellow. Class helpers could be dangerous if they are used improperly. For example one point from helpers "dark side" list is that in the project can be only one helper expanding class. This list is a little longer, but well managed helpers repository and defined release cycle allow to solve most of them.

Cleaning techniques include the following benefits:

- **Extract global functions** - global functions and utility methods wrote straight in forms (modules) can be extracted and reuse, also they can grouped together in separated containers based on subject class, finally they can be covered with unit tests
- **Reduce size of events** - size of code in events (forms, frames and data modules) can be significantly decreased, which helps to improve code readability, especially when valuable business code is  mixed together with visualization or with component processing
- **Improve utility code readability** - it is available by removing one of the function parameter which is a call subject (see bellow "Subject first" sample), together with that small improvements we are able to remove flags from calls, use more meaningful names, compress conditional sequences, make complex things simpler and safer
- **Introduce TDD approach**. - class helpers should be autonomous and not dependent on project's business code, thanks of that are  easy to cover with unit tests, then can be expanded using TDD development (red-green-refactor) which is really helpful here

Sample code - Subject first: first line is classic call and second is written using class helper *(which one is more readable?)*:

```pas
// classic call:
StoreLibrary (reAvaliable, 1, mysqlDataSet, true);

// improved class:
mysqlDataSet.StoreAndUpdateLibrary(reAvaliable, 1);
```

## Helpers

| Helper name | Expanded class | Information |
| --- | --- | --- |
| TApplicationHelper | TApplication | concept solution for storing general reusable functions  |
| TDataSetHelper | TDataSet | extension function for data manipulation and storage |
| TDateTimeHelper | TDateTime | sample record helper  |
| TDBGridHelper | TDBGrid | expanding classic DBGrid |
| TJSONObjectHelper | TJSONObject | function manipulating on JSON memory DOM |
| TStringGridHelper | TStringGrid | more advanced features added to StringGrid control |
| TWinControlHelper | TWinControl | utility methods available for all TWinControl descendants (TForm, TPanel, etc.)  |

[Full helper catalog](https://github.com/bogdanpolak/class-helpers/tree/master/src)


## Unit testing

One of the important purposes of using class helpers is to learn how to write unit tests. This repository contains a sample DUnitX test project for the included helpers. I encourage to start analyzing this collection from opening and executing this project. Unit test sets can be easily expanded to provide better (tighter) test coverage. To have better unit testing experience I suggest to install the best TDD Delphi IDE extension: [TestInsight](https://bitbucket.org/sglienke/testinsight/wiki/Home) - very productive platform of working with unit test project (glory to the author! Stefan Glienke).

Sample unit test can be found in `tests` repository folder. [Jump to this folder ...](https://github.com/bogdanpolak/class-helpers/tree/master/tests)

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
