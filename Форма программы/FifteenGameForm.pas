unit FifteenGameForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TFifteen, StdCtrls, Menus, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    MyFifteen1: TMyFifteen;
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
    Edit1: TEdit;
    Button1: TButton;
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
    procedure Button1Click(Sender: TObject);
    procedure MyFifteen2Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  num: integer;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
//  MyFifteen1.FifteenColor:=StringToColor('clWindow');
  Edit1.Text:=ColorToString(MyFifteen1.FifteenColor);
  Self.Caption := 'Пятнашки';
  Self.Color := RGB(random(127),random(127),random(127));
  MyFifteen1.FifteenColor:= RGB(random(127),random(127),random(127));
end;

procedure TForm1.MyFifteen1Victory(Sender: TObject);
begin
  MyFifteen1.FifteenColor:=RGB(11,11,150);
  ShowMessage('Вы собрали пятнашки '+IntToStr(MyFifteen1.ColCount)+
  'x'+IntToStr(MyFifteen1.RowCount)+'!');
end;

procedure TForm1.MyFifteen2Click(Sender: TObject);
begin
  MyFifteen1.FifteenColor:=RGB(11,11,150);
  ShowMessage('Вы собрали пятнашки '+IntToStr(MyFifteen1.ColCount)+
  'x'+IntToStr(MyFifteen1.RowCount)+'!');
end;

procedure TForm1.N1Click(Sender: TObject);
begin
  MyFifteen1.Mixer;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
  MyFifteen1.Recover;
end;

procedure TForm1.N32Click(Sender: TObject);
begin
  MyFifteen1.ColCount:=3;
  MyFifteen1.RowCount:=3;
end;

procedure TForm1.N33Click(Sender: TObject);
begin
  MyFifteen1.ColCount:=3;
  MyFifteen1.RowCount:=4;
end;

procedure TForm1.N34Click(Sender: TObject);
begin
  MyFifteen1.ColCount:=3;
  MyFifteen1.RowCount:=5;
end;

procedure TForm1.N42Click(Sender: TObject);
begin
  MyFifteen1.ColCount:=4;
  MyFifteen1.RowCount:=3;
end;

procedure TForm1.N43Click(Sender: TObject);
begin
  MyFifteen1.ColCount:=4;
  MyFifteen1.RowCount:=4;
end;

procedure TForm1.N44Click(Sender: TObject);
begin
  MyFifteen1.ColCount:=4;
  MyFifteen1.RowCount:=5;
end;

procedure TForm1.N52Click(Sender: TObject);
begin
  MyFifteen1.ColCount:=5;
  MyFifteen1.RowCount:=3;
end;

procedure TForm1.N53Click(Sender: TObject);
begin
  MyFifteen1.ColCount:=5;
  MyFifteen1.RowCount:=4;
end;

procedure TForm1.N54Click(Sender: TObject);
begin
  MyFifteen1.ColCount:=5;
  MyFifteen1.RowCount:=5;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
  MyFifteen1.Mixer;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
 Close;
end;

end.
