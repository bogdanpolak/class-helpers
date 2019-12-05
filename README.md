# Repository of VCL and RTL Class Helpers

![ Delphi Support ](https://img.shields.io/badge/Delphi%20Support-%2010%20..%2010.3%20Rio-blue.svg)
![ version ](https://img.shields.io/badge/version-%201.1-yellow.svg)

## Why use Class Helpers?

### 1. Lock-pick (outdated)

From the very beginning till version 10.1 Berlin there was quite popular bug in class helpers, which allows to access private class fields and methods. Many developers identified interesting language extension with this hack. Maybe because of that power class helpers is still underestimated. 

### 2. Safe cleaning technique

Huge amount of VCL code can be cleaned with class helpers. This approach requires a little more discipline, because there can only be one helper per class in a project, but it's really safe refactoring technique. By the way, developers get very good code base for writing unit tests and practicing TDD technique.

Delphi developers should know and use class helpers to:

- **Extract global functions** or utility methods created in forms and store them together in separated container covered with unit tests
- **Reduce size of events** in forms, frames and data modules, what increasing code readability, especially when valuable business code is still written in those places
- **Improve code readability** by changing parameters into subject of calls (see bellow "Subject first" sample), removing flags from calls, using more meaningful names, compressing conditional sequences, making complex things simpler and safer and many other small improvements
- **Introduce TDD approach**. Class helper should be not dependent on project business code thanks of that this code could be really easily covered with unit test and  even developers are able to build new helpers using TDD approach which is really useful in this case.

Sample code - Subject first: first line is classic call and second is written using class helper (which one is more readable):

```pas
// classic call:
GetDictionary (reAvaliable, 1, MyBooks, true);

// improved class:
MyBooks.GetDictionaryActive(reAvaliable, 1);
```
