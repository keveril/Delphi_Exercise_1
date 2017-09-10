unit uWidget;

interface

uses
  SysUtils, Classes, Generics.Collections, Generics.Defaults;

type
  TWidget = class
  private
    fId : Integer;
    fDescription : string;
    function GetAsString : string;
  public
    property Id : Integer read fId;
    property Description : string read fDescription write fDescription;
    property AsString : string read GetAsString;
    Constructor Create(Id: Integer; Description: string);
  end;

  TWidgetList = class
  private
    fItems : TObjectList<TWidget>;
    function GetItems(Index : Integer) : TWidget;
    procedure SetItems(Index : Integer; const Value : TWidget);
//    function CompareIds(Item1, Item2 : Pointer) : Integer;
  public
    property Items[Index : Integer] : TWidget read GetItems write SetItems;
    function Add(Widget : TWidget): Integer;
    function Count() : Integer;
    procedure SortById;
    constructor Create;
    destructor Destroy; override;
  end;


implementation

Constructor TWidget.Create(Id: Integer; Description: string);
begin
  inherited Create;
  self.fId := Id;
  self.Description := Description;
end;

function TWidget.GetAsString: string;
begin
  Result := 'Id: ' + IntToStr(fId) + ' Description: ' +
                   fDescription;
end;

function TWidgetList.Add(Widget: TWidget) : Integer;
begin
  Result := fItems.Add(Widget);
end;

function TWidgetList.Count : Integer;
begin
  Result := fItems.Count;
end;

constructor TWidgetList.Create;
begin
  inherited;
  fItems := TObjectList<TWidget>.Create;
end;

function TWidgetList.GetItems(Index: Integer) : TWidget;
begin
  Result := TWidget(fItems[Index]);
end;

procedure TWidgetList.SetItems(Index: Integer; const Value : TWidget);
begin
  fItems[Index] := Value;
end;


procedure TWidgetList.SortById;
begin
  fItems.Sort(TComparer<TWidget>.Construct(
    function(const L, R: TWidget) : Integer
    begin
       Result :=  L.fid - R.fid;
    end
  ));
end;

destructor TWidgetList.Destroy;
begin
//  for i := fItems.Count - 1 downto 0 do
//  begin
//    fItems[i].Free;
//  end;
  fItems.Free;

  inherited;
end;



end.
