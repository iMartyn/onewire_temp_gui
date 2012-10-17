unit tempform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Serial;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Memo1: TMemo;
    Splitter1: TSplitter;
    Timer1: TTimer;
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
    MySerialHandle: TSerialHandle;
    CurrentLine: String;
    Counter: Integer;
    CurrentTempC: Real;
  public
    { public declarations }
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Timer1Timer(Sender: TObject);
var
  bffr: char;
  FileHandle: Text;
  sLeft: String;
begin
  bffr := #0;
  SerRead(MySerialHandle,bffr,1);   // The 1 here is to read 1 character
  if (bffr <> #0) then
  begin
    Inc(Counter);
    CurrentLine := CurrentLine + bffr;
    Memo1.Text:=Memo1.Text+bffr;
    bffr := #0;
      if (Pos('dresses',CurrentLine) > 0) or (counter > 1024) then
      begin
        if ((Pos('Temperature',CurrentLine) > 0) and (Pos('Fahrenheit',CurrentLine) > 0)) then
        begin
          Label1.Caption := Copy(CurrentLine,Pos('Temperature',CurrentLine),Pos('Fahrenheit',CurrentLine)-Pos('Temperature',CurrentLine)+10);
          sLeft := Copy(CurrentLine,Pos('Temperature',CurrentLine)+14,99);
          Try
            CurrentTempC := StrToFloat(Copy(sLeft,0,Pos(' ',sLeft)));
          finally
          end;
          Label1.Caption := 'Current Temperature is '+FloatToStr(CurrentTempC)+' degrees Celcius';
        end;
        Application.ProcessMessages;
        AssignFile(FileHandle, '/tmp/serial.log');
        if (not FileExists('/tmp/serial.log')) then
          Rewrite(FileHandle)
        else
          Append(FileHandle);
        Write(FileHandle, CurrentLine);
        CloseFile(FileHandle);
        counter := 0;
      CurrentLine := '';
      end;
  end
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MySerialHandle := SerOpen('/dev/ttyACM0');
  SerSetParams(MySerialHandle, 9600,8,EvenParity,1,[]);
  CurrentLine := '';
  Counter := 0;
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
  Memo1.Visible := Checkbox1.Checked;
end;

end.

