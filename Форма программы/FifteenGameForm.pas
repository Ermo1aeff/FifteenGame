unit FifteenGameForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TFifteen, StdCtrls, Menus, ExtCtrls, ComCtrls, Grids;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Ds1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N2x31: TMenuItem;
    N32: TMenuItem;
    N42: TMenuItem;
    N52: TMenuItem;
    N2x41: TMenuItem;
    N33: TMenuItem;
    N43: TMenuItem;
    N53: TMenuItem;
    N2x51: TMenuItem;
    N34: TMenuItem;
    N44: TMenuItem;
    N54: TMenuItem;
    N4: TMenuItem;
    PopupMenu1: TPopupMenu;
    N5: TMenuItem;
    MyFifteen1: TMyFifteen;
    Timer1: TTimer;
    ControlBar1: TControlBar;
    Panel1: TPanel;
    Label1: TLabel;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    Label2: TLabel;
    Label3: TLabel;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure N52Click(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure N43Click(Sender: TObject);
    procedure N53Click(Sender: TObject);
    procedure N34Click(Sender: TObject);
    procedure N44Click(Sender: TObject);
    procedure N54Click(Sender: TObject);
    procedure MyFifteen1Victory(Sender: TObject);
    procedure MyFifteen2Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MyFifteen1TilesMove(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure SetStart;
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure MyFifteen1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure MyFifteen1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure MyFifteen1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Num: integer;
  Hour, Min, Sec, Milisec: word;
  NowTime, StartTime, TimePassed: TDateTime;
  Moves:integer;

implementation

{$R *.dfm}

procedure TForm1.SetStart;
begin
  Label1.Caption:='ÂÐÅÌß -';
  Label2.Caption:='ÕÎÄÛ -';
  Label3.Caption:='';
  Timer1.Enabled:= false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  NowTime := Now;
  TimePassed:=StartTime - NowTime;
  DecodeTime(TimePassed, Hour, Min, Sec, Milisec);
  Label1.Caption:='ÂÐÅÌß: ' + IntToStr(Min)+':'+IntToStr(Sec)+':'+IntToStr(Milisec);
end;

procedure TForm1.FormClick(Sender: TObject);
begin
  ShowMessage('Click on form');
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  MyFifteen1.ColCount:=MyFifteen1.ColCount+1;
  MyFifteen1.RowCount:=MyFifteen1.RowCount+1;
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  MyFifteen1.ColCount:=MyFifteen1.ColCount-1;
  MyFifteen1.RowCount:=MyFifteen1.RowCount-1;
end;

procedure TForm1.MyFifteen1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  MyFifteen1.ColCount:=MyFifteen1.ColCount+1;
  MyFifteen1.RowCount:=MyFifteen1.RowCount+1;
end;

procedure TForm1.MyFifteen1MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  MyFifteen1.ColCount:=MyFifteen1.ColCount+1;
  MyFifteen1.RowCount:=MyFifteen1.RowCount+1;
end;

procedure TForm1.MyFifteen1MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  MyFifteen1.ColCount:=MyFifteen1.ColCount-1;
  MyFifteen1.RowCount:=MyFifteen1.RowCount-1;
end;

procedure TForm1.MyFifteen1TilesMove(Sender: TObject);
begin
  if Timer1.Enabled = false then
  begin
    Timer1.Enabled:= true;
    Moves:=0;
    StartTime:= Now;
  end;
  moves:=moves + 1;
  Label2.Caption:='ÕÎÄÛ ' + IntToStr(moves);
end;

procedure TForm1.MyFifteen1Victory(Sender: TObject);
begin
  Timer1.Enabled:= false;
  Label3.Caption:='Victory!';
end;

procedure TForm1.MyFifteen2Click(Sender: TObject);
begin
  MyFifteen1.FifteenColor:=RGB(11,11,150);
  ShowMessage('Âû ñîáðàëè ïÿòíàøêè '+IntToStr(MyFifteen1.ColCount)+
  'x'+IntToStr(MyFifteen1.RowCount)+'!');
end;

procedure TForm1.N10Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    Form1.Color:= ColorDialog1.Color;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  SetStart;
  MyFifteen1.Mixer;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  SetStart;
  MyFifteen1.Recover;
end;

procedure TForm1.N32Click(Sender: TObject);
begin
  SetStart;
  MyFifteen1.ColCount:=3;
  MyFifteen1.RowCount:=3;
end;

procedure TForm1.N33Click(Sender: TObject);
begin
  SetStart;
  MyFifteen1.ColCount:=3;
  MyFifteen1.RowCount:=4;
end;

procedure TForm1.N34Click(Sender: TObject);
begin
  SetStart;
  MyFifteen1.ColCount:=3;
  MyFifteen1.RowCount:=5;
end;

procedure TForm1.N42Click(Sender: TObject);
begin
  SetStart;
  MyFifteen1.ColCount:=4;
  MyFifteen1.RowCount:=3;
end;

procedure TForm1.N43Click(Sender: TObject);
begin
  SetStart;
  MyFifteen1.ColCount:=4;
  MyFifteen1.RowCount:=4;
end;

procedure TForm1.N44Click(Sender: TObject);
begin
  SetStart;
  MyFifteen1.ColCount:=4;
  MyFifteen1.RowCount:=5;
end;

procedure TForm1.N52Click(Sender: TObject);
begin
  SetStart;
  MyFifteen1.ColCount:=5;
  MyFifteen1.RowCount:=3;
end;

procedure TForm1.N53Click(Sender: TObject);
begin
  SetStart;
  MyFifteen1.ColCount:=5;
  MyFifteen1.RowCount:=4;
end;

procedure TForm1.N54Click(Sender: TObject);
begin
  SetStart;
  MyFifteen1.ColCount:=5;
  MyFifteen1.RowCount:=5;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  MyFifteen1.Mixer;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    MyFifteen1.FifteenColor:= ColorDialog1.Color;
end;

procedure TForm1.N8Click(Sender: TObject);
begin
  if FontDialog1.Execute then
    MyFifteen1.Font:= FontDialog1.Font;
end;

procedure TForm1.N9Click(Sender: TObject);
begin
  MyFifteen1.DragKind := dkDrag;
  MyFifteen1.DragMode := dmManual;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
 Close;
end;

end.
