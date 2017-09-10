unit uWidgetReader;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uWidget;

type
  TWidgetReader = class(TForm)
    DisplayMemo: TMemo;
    OpenFileButton: TButton;

    procedure OpenFileButtonClick(Sender: TObject);
    procedure DisplayResult(WidgetList : TWidgetList; DisplayMemo : TMemo);
//    function LoadFileToStr(const FileName: TFileName): AnsiString;
//    procedure ListCreate(FileContent : string; WidgetList : TWidgetList);
    procedure LoadFileToList(const FileName: TFileName;
                              WidgetList : TWidgetList);
    procedure AddWidgetToList(SourceStr : string; WidgetList : TWidgetList);
  end;

var
  WidgetReader: TWidgetReader;
//  WidgetList : TWidgetList;

implementation

{$R *.dfm}

{
function TWidgetReader.LoadFileToStr(const FileName: TFileName) : AnsiString;
var
  FileStream : TFileStream;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    if FileStream.Size > 0 then
    begin
      SetLength(Result, FileStream.Size);
      FileStream.Read(Pointer(Result)^, FileStream.Size);
    end;
  finally
    FileStream.Free;
  end;
end;
}

procedure TWidgetReader.LoadFileToList(const FileName: TFileName;
                                      WidgetList : TwidgetList);
var
  Reader : TStreamReader;
  LineContent : string;
begin
  Reader := TStreamReader.Create(
            FileName,
            TEncoding.UTF8);

  while not(Reader.EndOfStream) do
  begin
    LineContent := Reader.ReadLine;
    AddWidgetToList(LineContent,WidgetList);
  end;
  Reader.Free;
end;

procedure TWidgetReader.AddWidgetToList(SourceStr: string; WidgetList: TWidgetList);
var
  description : string;
  id : Integer;
  tabPosition : Integer;
  StrLength : Integer;
  Widget : TWidget;
begin
  StrLength := Length(SourceStr);
  tabPosition := Pos(#9,SourceStr);
  id := StrToInt(Copy(SourceStr,0,tabPosition-1));
  description := Copy(SourceStr,tabPosition+1,StrLength - tabPosition);
  Widget := TWidget.Create(id,description);
  WidgetList.Add(Widget);
end;

{
procedure TwidgetReader.ListCreate(FileContent: string; WidgetList : TWidgetList);
var
  Widget : TWidget;
  StrLength : Integer;
  i : Integer;
  ch : char;
  buffer : string;
  flag : boolean; //true for Id; false for Description;
  id : integer;
begin
  StrLength := Length(FileContent);
  id := 0;
  buffer := '';
  ch := ' ';
  i := 0;
  flag := true;
  while i <= StrLength do
  begin
    if ch = #9 then
      begin
        if flag then
        begin
          id := StrToInt(buffer);
          buffer := '';
          ch := ' ';
          flag := false;
        end
        else
        begin
          Widget := TWidget.Create(id,buffer);
          WidgetList.Add(Widget);
          buffer :='';
          ch := ' ';
          flag := true;
        end;

      end
      else
      begin
        ch := FileContent[i];
        if (ch <> #0) and (ch <> #9)  then
          buffer := buffer + ch;
        inc(i);
      end;
    end;
  Widget := TWidget.Create(id,buffer);
  WidgetList.Add(Widget);
end;
}

procedure TWidgetReader.OpenFileButtonClick(Sender: TObject);
var
  OpenFile : TOpenDialog;
//  FileContent : string;
  WidgetList : TWidgetList;
begin
  OpenFile := TOpenDialog.Create(self);
  OpenFile.InitialDir := GetCurrentDir;
  OpenFile.Options := [ofFileMustExist];
  if not OpenFile.Execute then
    ShowMessage('Open file was cancelled')
  else
  begin
    WidgetList := TWidgetList.Create;
    LoadFileToList(OpenFile.Files[0],WidgetList);
 //   FileContent := string(LoadFileToStr(OpenFile.Files[0]));
    DisplayMemo.Text :='';
 //   ListCreate(FileContent,WidgetList);
    DisplayResult(WidgetList, DisplayMemo);
  end;
  OpenFile.Free;
end;

procedure TWidgetReader.DisplayResult(WidgetList : TWidgetList; DisplayMemo : TMemo);
var
  count : Integer;
  i : Integer;
  widget : TWidget;
begin
  WidgetList.SortById;
  count := WidgetList.Count;
  for i := 0 to count - 1 do
  begin
    widget := WidgetList.Items[i];
    DisplayMemo.Text := DisplayMemo.Text + widget.AsString + #13#10;
  end;
  WidgetList.Destroy;
end;

end.
