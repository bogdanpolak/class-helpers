# Dataset Mapper Demo - LoadData & SaveData

This example demonstrates the powerful `LoadData<T>` and `SaveData<T>` methods from `TDataSetHelper` which provide automatic mapping between datasets and object lists.

## What This Demo Shows

This application demonstrates:

1. **Loading data from a dataset into objects** using `LoadData<T>`
2. **Modifying objects in memory** with proper change tracking
3. **Saving modified objects back to the dataset** using `SaveData<T>`
4. **Automatic INSERT and UPDATE detection** based on primary keys
5. **Change tracking** using the `IsChanged` boolean field

## How to Use

1. **Click "Load Data"** - Loads all records from the dataset into a `TObjectList<TProduct>`
2. **Click "Modify Data"** - Modifies 2 existing products and adds 1 new product in memory
3. **Click "Save Data"** - Saves all changes back to the dataset (2 updates + 1 insert)
4. **Click "Reset"** - Restores the dataset to its original state

## Key Concepts

### LoadData<T> Method

```pascal
var products := ClientDataSet1.LoadData<TProduct>;
```

- Creates a new `TObjectList<T>` and populates it with data from the dataset
- Automatically maps dataset fields to object properties by name
- Handles all data type conversions
- Preserves NULL values for optional fields

### SaveData<T> Method

```pascal
var savedCount := ClientDataSet1.SaveData<TProduct>(products);
```

- Iterates through the object list
- Only processes objects where `IsChanged = True`
- **UPDATE**: If a record with matching primary key exists in dataset
- **INSERT**: If no matching record found
- Returns the number of records saved
- Automatically detects NULL values for optional fields

### Object Requirements

For the mapper to work correctly, your object class must:

1. **Have a boolean change tracking field** (default name: `IsChanged`)
2. **Have properties matching dataset field names** (case-insensitive)
3. **Have primary key properties** that correspond to dataset primary key fields

Example object class:

```pascal
TProduct = class
private
  FId: Integer;
  FProductName: string;
  FPrice: Double;
  FStockQuantity: Integer;
  FIsChanged: Boolean;  // Required for SaveData!
public
  property Id: Integer read FId write FId;
  property ProductName: string read FProductName write FProductName;
  property Price: Double read FPrice write FPrice;
  property StockQuantity: Integer read FStockQuantity write FStockQuantity;
  property IsChanged: Boolean read FIsChanged write FIsChanged;
end;
```

### Dataset Requirements

For the mapper to work correctly, your dataset must:

1. **Have a primary key defined** using `ProviderFlags`:

```pascal
FieldByName('Id').ProviderFlags := [pfInUpdate, pfInWhere, pfInKey];
```

Without this, `SaveData` will raise an `EDataMapperError` exception.

## Custom Field Mapping

If your object property names don't match dataset field names, use the `MappedToDBField` attribute:

```pascal
type
  TProduct = class
  private
    [MappedToDBField('product_name')]
    FName: string;
  public
    property Name: string read FName write FName;
  end;
```

Don't forget to add `Attribute.MappedToDBField` to your uses clause.

## Change Tracking Options

You can use a different field name for change tracking:

```pascal
// Using a custom change flag name
var savedCount := dataset.SaveData<TProduct>(products, 'HasBeenModified');
```

Your object class would then need:

```pascal
property HasBeenModified: Boolean read FModified write FModified;
```

## Exceptions Handled

The demo includes exception handling for:

- **Missing change flag field** - EDataMapperError
- **Missing primary key definition** - EDataMapperError
- **Invalid field mapping** - EDataMapperError

## Auto-Detect NULL Feature

`SaveData` automatically converts certain values to NULL for optional fields:

- **Date/Time fields**: Values ≤ 0 become NULL
- **Numeric fields**: Values < 0 become NULL

This feature is enabled by default and works for non-required fields only.

## Real-World Usage Scenarios

This pattern is useful for:

- **Multi-tier applications** - Load data, send to client, receive modifications, save back
- **Batch updates** - Modify multiple records in memory, then save all at once
- **Undo/Redo functionality** - Keep object list separate from dataset
- **Data validation** - Validate all changes before committing to dataset
- **REST API integration** - Map JSON data to objects, then to dataset

## Related Methods

- `LoadData<T>` - Maps dataset rows to objects
- `SaveData<T>` - Maps objects back to dataset rows
- `AppendRows` - Bulk insert from variant arrays

## Learn More

See the unit tests in `tests/rtl/Test.Helper.TDataSet.pas` for more advanced usage examples including:

- Working with blob fields
- Custom field mapping with attributes
- Complex scenarios with multiple updates and inserts
- Error handling

---

For full documentation of the `TDataSetHelper` class, see:
- Source: `src/rtl/Helper.TDataSet.pas`
- Tests: `tests/rtl/Test.Helper.TDataSet.pas`
