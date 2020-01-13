# Repository of VCL and RTL Class Helpers

![ Delphi Support ](https://img.shields.io/badge/Delphi%20Support-%2010%20..%2010.3%20Rio-blue.svg)
![ version ](https://img.shields.io/badge/version-%201.5-yellow.svg)

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

## Good practices

Class helpers looks really promising in the begging and actually there are great solution, but as you create and use more and more of them, you'll start to notice some obstacles. For this reason, good practices should be adapted from the beginning to help avoid potential problems.

1. **One helper for one class (in whole project).** It's possible to declare two class helpers with different methods extending the same class. Although they cannot be used together in one unit (only one of them will be visible), but such code can be compiled. You can potentially use two different helpers in separate units, but you shouldn't do that because it can be dangerous and generate difficult to fix bugs.
1. **Unified collection of helpers.** Try do keep consistent and unified collection of class helpers. The best solution is created separate repository (more details in the following section). At first, helpers may be part of the main business project, but it is better to isolate them, especially when you plan to reuse them in many projects. Helpers should be treated as independent components that have been tested and implemented in the final project.

Points TBD:

1. Do not declare class helpers for business / project classes
1. Prefer to declare a new class over the using more helpers
1. Keep the same delivery cycle for class helpers like for the application code

## Maintenance and helper repository

 One of the recommended practices when using class helpers is to plan good  project maintenance, including version control and release management. Proven steps including two important point: 

1. **Independent project** - class helpers should be maintained as a separate project, versioned and merged into finial projects like other external packages.
1. Release cycle
   - Helpers project should have individual releases with defined version numbers, release dates and its own branching model. New helpers version can be tested and integrated with final projects at the right time. This integration can be straightforward and quick, but sometimes could be more challenging.

This project is live example of such deployment techniques. We are using branching model inspired by Vincent Driessen blog post: [A successful Git branching model](https://nvie.com/posts/a-successful-git-branching-model/) together with planing and delivery model inspired by Kanban method.

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
1. Expanded class
   - Q: **Which VCL / FMX or RTL classes should be chosen as a base for helpers?**
   - The class helper should be defined as high in the component hierarchy as possible. If it's possible define helper for class `TButton` not for `TControl` or `TComponent`.
   - Developer could be not able to compile code (receiving compiler error: *Undeclared identifier*), when it was copied from other unit and that unit is using a class helper. In that scenario it's easy to fix this error by adding class helper if it's defined for the actually used class. Otherwise if this code is using helper for more general class it will be more difficult to find proper class helper to include.
1. Extra cost - time
   - Q: **Are you able to spend extra time on maintaining helpers?**
   - Usually class helper are added as the supporting code together with more general tasks. This is OK, but after closing this task you need to spend some extra time on extracting this helper and adding it into helper repository
1. Version
   - Q: **What version of the helpers class project is being used now?**
   - Application should be using the most recent version of helpers, but migration from previous one to most recent one could cost some time, and have to be plan accordingly.
1. Unit test coverages
   - Q: **Are you able to write unit tests for class helper methods?**
   - Class helpers should be well documented and achieve the highest possible quality. Bugs inside class helpers could be really confusing for the developers