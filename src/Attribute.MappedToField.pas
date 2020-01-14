unit Attribute.MappedToField;

interface

type
  MappedToFieldAttribute = class(TCustomAttribute)
  private
    fFieldName: string;
  public
    constructor Create(const aFiedldName: string);
    property FieldName: string read fFieldName;
  end;

implementation

constructor MappedToFieldAttribute.Create(const aFiedldName: string);
begin
  fFieldName := aFiedldName;
end;

end.
