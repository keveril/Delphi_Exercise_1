unit uSubWidget;

interface

uses
  SysUtils, Classes, Generics.Collections, Generics.Defaults, uConstValue, uWidget;


type
  TRedWidget = class(TWidget)
  protected
    function GetColor : string; override;
  public
    constructor Create(AId: Integer; ADescription: string); override;
  end;

  TBlueWidget = class(TWidget)
  protected
    function GetColor : string; override;
  public
    constructor Create(AId: Integer; ADescription: string); override;
  end;

implementation

constructor TRedWidget.Create(AId: Integer; ADescription: string);
  begin
    inherited Create(AId,ADescription);
    Size := 0;
  end;

function TRedWidget.GetColor : string;
begin
  inherited;
  Result := RED;
end;

constructor TBlueWidget.Create(AId: Integer; ADescription: string);
  begin
    inherited Create(AId,ADescription);
    Size := 2;
  end;

function TBlueWidget.GetColor : string;
begin
  inherited;
  Result := BLUE;
end;

end.
