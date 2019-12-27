unit Attribute.MapedToField;

interface

type
  MapedToFieldAttribute = class(TCustomAttribute)
  private
    fFieldName: string;
  public
    constructor Create(const aFiedldName: string);
    property FieldName: string read fFieldName;
  end;

implementation

constructor MapedToFieldAttribute.Create(const aFiedldName: string);
begin
  fFieldName := aFiedldName;
end;

end.
