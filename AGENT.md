# AGENT.md - Delphi Class Helpers Project

## Project Overview

**Name:** Delphi Class Helpers  
**Repository:** class-helpers  
**Owner:** bogdanpolak  
**Current Version:** 1.9 (working on version 1.10)  
**License:** MIT  
**Language:** Object Pascal (Delphi)  
**Supported Delphi Versions:** XE4 through Delphi 12

## Purpose

This library provides class helpers (extension methods) for standard Delphi classes across VCL, RTL, and FireDAC frameworks. The goal is to make Delphi code more readable and expressive by adding fluent, chainable methods to existing classes.

**Philosophy:** Transform verbose procedural code into readable, method-chained expressions.

## Project Structure

```
class-helpers/
├── src/                          # Source code
│   ├── rtl/                      # Runtime Library helpers
│   │   ├── Helper.TBytes.pas
│   │   ├── Helper.TDataSet.pas
│   │   ├── Helper.TDateTime.pas
│   │   ├── Helper.TField.pas
│   │   ├── Helper.TJSONObject.pas
│   │   ├── Helper.TStream.pas
│   │   └── Attribute.MappedToDBField.pas
│   ├── vcl/                      # Visual Component Library helpers
│   │   ├── Helper.TApplication.pas
│   │   ├── Helper.TDBGrid.pas
│   │   ├── Helper.TForm.pas
│   │   ├── Helper.TPicture.pas
│   │   ├── Helper.TStringGrid.pas
│   │   └── Helper.TWinControl.pas
│   └── firedac/                  # FireDAC helpers
│       ├── Helper.TFDConnection.pas
│       └── Helper.TFDCustomManager.pas
├── tests/                        # Unit tests (DUnit)
│   ├── rtl/                      # Tests for RTL helpers
│   ├── vcl/                      # Tests for VCL helpers
│   └── firedac/                  # Tests for FireDAC helpers
├── examples/                     # Example applications
│   ├── 01-playground/           # Interactive demo
│   └── 02-formhelper/           # Form helper demo
├── doc/                         # Documentation
│   └── Helper.TBytes.md
└── utility/                     # Build utilities
    └── app-config.json
```

## Key Components

### RTL Helpers

1. **Helper.TBytes** - Binary data manipulation
   - Compression (ZLib), Base64 encoding
   - CRC32 calculation
   - Stream and file I/O
   - Hex/string conversions
   - PNG signature verification

2. **Helper.TDataSet** - Dataset operations
   - `ForEachRow` - Iterate with lambda
   - `LoadData<T>` - Map to object lists
   - `SaveData<T>` - Persist objects to dataset

3. **Helper.TDateTime** - Date/time utilities
   - `AsYear`, `AsMonth`, `AsDay`
   - `DayOfWeek`
   - `IncMonth`, `IncDay`
   - `AsStringDateISO` - ISO 8601 formatting

4. **Helper.TStream** - Stream operations

5. **Helper.TJSONObject** - JSON handling

6. **Helper.TField** - Field operations

### VCL Helpers

1. **Helper.TForm** - Form enhancements
2. **Helper.TStringGrid** - String grid operations
3. **Helper.TDBGrid** - Database grid utilities
4. **Helper.TWinControl** - Control helpers
5. **Helper.TPicture** - Picture/image handling
6. **Helper.TApplication** - Application helpers

### FireDAC Helpers

1. **Helper.TFDConnection** - Database connection utilities
2. **Helper.TFDCustomManager** - Manager operations

## Coding Conventions

### File Naming
- Pattern: `Helper.<ClassName>.pas`
- Test pattern: `Test.Helper.<ClassName>.pas`

### Unit Structure
```pascal
unit Helper.TClassName;

interface

uses
  System.Classes,
  System.SysUtils;

type
  TClassNameHelper = record helper for TClassName
  private const
    Version = '1.9';  // Version tracking in each helper
  private
    // Private methods
  public
    // Public methods with XML doc comments
  end;

implementation

// Implementation

end.
```

### Documentation
- **Every public helper method MUST have XML doc comments** (`///`)
- **Minimum requirement:** `<summary>` tag with at least one bullet point
- Do not document parameters, do not use `<param>` tags where needed
- Document return values with `<returns>` tags where applicable, it should used rarely
- Include usage examples in comments or separate .md files
- XML doc comments appear before the method declaration

**Example:**
```pascal
/// <summary>
/// Returns size of byte array
/// </summary>
function GetSize: Integer;

/// <summary>
/// Changes size of byte array to "aSize" bytes
/// - If the new size is larger, additional bytes are initialized to zero
/// - If the new size is smaller, excess bytes are discarded
/// </summary>
procedure SetSize(aSize: Integer);
```

### Version Management
- Each helper includes a private constant `Version`
- Current version: '1.9'
- Working branch: version1.10

## Testing

- Framework: DUnit
- Test files mirror source structure
- Three test projects:
  - `TestsRtlHeplers.dpr` - RTL tests
  - `TestsVclHeplers.dpr` - VCL tests
  - `TestsFiredacHeplers.dpr` - FireDAC tests
- Each test project includes `clear_project.bat` for cleanup

## Build Process

### Delphi Project Files
- `.dpr` - Delphi Project file (main program)
- `.pas` - Pascal source unit
- `.dfm` - Form design file (binary)
- Batch files: `clear_project.bat` - Clean intermediate files

### Configuration
- `utility/app-config.json` - Application configuration
- Version bumper utility available (see `utility/bumper_README.md`)

## Development Guidelines

### Adding New Helpers

1. **Create source file** in appropriate directory (`src/rtl/`, `src/vcl/`, or `src/firedac/`)
2. **Follow naming convention:** `Helper.TClassName.pas`
3. **Include version constant** in the helper type
4. **Add XML documentation** - **REQUIRED** for all public methods (minimum: `<summary>` with bullet points)
5. **Create test file** in corresponding `tests/` subdirectory
6. **Update README.md** with new helper examples
7. **Create documentation** in `doc/` if complex

### Code Style

- Use meaningful method names that read like English
- Prefer fluent interfaces (return Self for chaining)
- Keep methods focused (single responsibility)
- Use default parameters for optional behavior
- Include const parameters where appropriate

### Testing

- Write unit tests for all new functionality
- Test edge cases (empty arrays, nil values, etc.)
- Test error conditions
- Include integration tests for complex helpers

## Common Tasks

### Running Tests
Open the appropriate `.dpr` file in Delphi IDE:
- RTL: `tests/rtl/TestsRtlHeplers.dpr`
- VCL: `tests/vcl/TestsVclHeplers.dpr`
- FireDAC: `tests/firedac/TestsFiredacHeplers.dpr`

Build and run through IDE or command line.

### Adding Examples
1. Create or modify frames in `examples/01-playground/`
2. Pattern: `Frame.<FeatureName>.pas` and `Frame.<FeatureName>.dfm`
3. Register in main form (`Form.Main.pas`)

### Updating Documentation
- Primary docs: `README.md`
- Detailed API docs: `doc/Helper.<ClassName>.md`
- Use code examples from tests or examples folder

## Important Notes for AI Assistants

### When Working with This Project

1. **Language is Object Pascal (Delphi)** - Not C-style syntax
   - Uses `begin/end` not `{}`
   - Case-insensitive
   - Strong typing with inference
   - Semicolons end statements

2. **Helper Pattern** - Delphi-specific feature
   - Extends existing classes without inheritance
   - Syntax: `record helper for TClassName`
   - Cannot access private members of helped class
   - Methods appear as if they're part of the original class

3. **File Extensions**
   - `.pas` - Pascal source (text)
   - `.dfm` - Form definitions (can be text or binary)
   - `.dpr` - Project file (text)
   - `.dcu` - Compiled unit (binary, don't commit)

4. **Version Tracking**
   - Each helper has `Version` constant
   - Keep synchronized with README badge
   - Branch name indicates working version

5. **No External Dependencies**
   - Uses only standard Delphi RTL/VCL/FireDAC
   - No third-party packages required
   - Keeps deployment simple

6. **Testing is Important**
   - All features should have unit tests
   - Use DUnit framework
   - Tests demonstrate usage patterns

### Common Pitfalls

- Don't confuse with C# extension methods (similar but different)
- Helpers can't be overridden (no polymorphism)
- Can't access private/protected members
- One helper per type (last one wins if multiple)
- Record helpers are value types, class helpers are reference types

## Example Code Patterns

### Basic Helper Method
```pascal
function TBytesHelper.GetSize: Integer;
begin
  Result := Length(Self);
end;
```

### Chainable Method
```pascal
function TDateTimeHelper.IncMonth(Months: Integer): TDateTime;
begin
  Result := System.DateUtils.IncMonth(Self, Months);
end;
```

### Method with Lambda
```pascal
procedure TDataSetHelper.ForEachRow(aProc: TProc);
begin
  First;
  while not Eof do
  begin
    aProc();
    Next;
  end;
end;
```

## Contact & Contributing

**Author:** Bogdan Polak  
**License:** MIT (see LICENSE file)  
**Contributing:** Follow existing code patterns, include tests, update documentation

---

*This document is intended for AI assistants to understand the project structure, conventions, and development patterns when helping with this Delphi class helpers library.*
