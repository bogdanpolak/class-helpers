unit Attribute.MappedToDBField;

interface

type
  MappedToDBFieldAttribute = class(TCustomAttribute)
  private
    fFieldName: string;
  public
    constructor Create(const aFiedldName: string);
    property FieldName: string read fFieldName;
  end;

implementation

constructor MappedToDBFieldAttribute.Create(const aFiedldName: string);
begin
  fFieldName := aFiedldName;
end;

end.
