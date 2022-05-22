unit FifteenGameForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Fifteen, StdCtrls, Menus, ExtCtrls, ComCtrls, Grids, Buttons;

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
    Timer1: TTimer;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    Fifteen1: TFifteen;
    ControlBar1: TControlBar;
    Panel2: TPanel;
    Label9: TLabel;
    TrackBar1: TTrackBar;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Label10: TLabel;
    TrackBar2: TTrackBar;
    N11: TMenuItem;
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
    procedure N5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MyFifteen1TilesMove(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure SetStart;
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure Fifteen1TilesMove(Sender: TObject);
    procedure Fifteen1Victory(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  Label1.Caption:='¬–≈Ãﬂ -';
  Label2.Caption:='’Œƒ€ -';
  Label3.Caption:='';
  Timer1.Enabled:= false;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  NowTime := Now;
  TimePassed:=StartTime - NowTime;
  DecodeTime(TimePassed, Hour, Min, Sec, Milisec);
  Label1.Caption:='¬–≈Ãﬂ: ' + IntToStr(Min)+':'+IntToStr(Sec)+':'+IntToStr(Milisec);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  Fifteen1.ColCount:=TrackBar1.Position;
  SetStart;
end;

procedure TForm1.TrackBar2Change(Sender: TObject);
begin
  Fifteen1.RowCount:=TrackBar2.Position;
  SetStart;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TrackBar1.Position:=Fifteen1.ColCount;
  TrackBar2.Position:=Fifteen1.RowCount;
end;

procedure TForm1.Fifteen1TilesMove(Sender: TObject);
begin
  if Timer1.Enabled = false then
  begin
    Timer1.Enabled:= true;
    Moves:=0;
    StartTime:= Now;
  end;
  moves:=moves + 1;
  Label2.Caption:='’Œƒ€ ' + IntToStr(moves);
end;

procedure TForm1.Fifteen1Victory(Sender: TObject);
begin
  Timer1.Enabled:= false;
  Label3.Caption:='Victory!';
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
  Label2.Caption:='’Œƒ€ ' + IntToStr(moves);
end;

procedure TForm1.MyFifteen1Victory(Sender: TObject);
begin
  Timer1.Enabled:= false;
  Label3.Caption:='Victory!';
end;

procedure TForm1.N10Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    Form1.Color:= ColorDialog1.Color;
end;

procedure TForm1.N11Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    Fifteen1.LinesColor:= ColorDialog1.Color;
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  SetStart;
  Fifteen1.Mixer;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  SetStart;
  Fifteen1.Recover;
end;

procedure TForm1.N32Click(Sender: TObject);
begin
  SetStart;
  Fifteen1.ColCount:=3;
  Fifteen1.RowCount:=3;
end;

procedure TForm1.N33Click(Sender: TObject);
begin
  SetStart;
  Fifteen1.ColCount:=3;
  Fifteen1.RowCount:=4;
end;

procedure TForm1.N34Click(Sender: TObject);
begin
  SetStart;
  Fifteen1.ColCount:=3;
  Fifteen1.RowCount:=5;
end;

procedure TForm1.N42Click(Sender: TObject);
begin
  SetStart;
  Fifteen1.ColCount:=4;
  Fifteen1.RowCount:=3;
end;

procedure TForm1.N43Click(Sender: TObject);
begin
  SetStart;
  Fifteen1.ColCount:=4;
  Fifteen1.RowCount:=4;
end;

procedure TForm1.N44Click(Sender: TObject);
begin
  SetStart;
  Fifteen1.ColCount:=4;
  Fifteen1.RowCount:=5;
end;

procedure TForm1.N52Click(Sender: TObject);
begin
  SetStart;
  Fifteen1.ColCount:=5;
  Fifteen1.RowCount:=3;
end;

procedure TForm1.N53Click(Sender: TObject);
begin
  SetStart;
  Fifteen1.ColCount:=5;
  Fifteen1.RowCount:=4;
end;

procedure TForm1.N54Click(Sender: TObject);
begin
  SetStart;
  Fifteen1.ColCount:=5;
  Fifteen1.RowCount:=5;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  Fifteen1.Mixer;
end;

procedure TForm1.N7Click(Sender: TObject);
begin
  if ColorDialog1.Execute then
    Fifteen1.FifteenColor:= ColorDialog1.Color;
end;

procedure TForm1.N8Click(Sender: TObject);
begin
  if FontDialog1.Execute then
    Fifteen1.Font:= FontDialog1.Font;
end;

procedure TForm1.N9Click(Sender: TObject);
begin
  Fifteen1.DragKind := dkDrag;
  Fifteen1.DragMode := dmManual;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
 Close;
end;

end.
