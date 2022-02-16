unit TFifteen;

interface

uses
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  ExtCtrls, Dialogs, SysUtils;

type
  TMyFifteen = class(TGraphicControl)
  private
    FFifteenColor:TColor;     //Цвет пятнашек
    FRowCount, FColCount:integer; // размер поля
    EmptCol, EmptRow:integer; // координаты пустой клетки
    RowSize, ColSize:integer; //Размер клеток
    Field: array[0..10, 0..10] of integer;
    fOnVictory: TNotifyEvent;
  protected
    procedure WMLButtonDown(var M: Tmessage); message wm_LButtonDown;
    //function GetColCount: integer;
    procedure SetColCount(Value: integer); virtual;
    //function GetRowCount: integer;
    procedure SetRowCount(Value: integer); virtual;
    //function GetFifteenColor: TColor;
    //procedure SetFifteenColor(Value: TColor); virtual;
    procedure Paint; override;
    procedure Move(CellCol, CellRow: integer); virtual;
    function Finish: boolean; virtual;
  public
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    constructor Create(AOwner: TComponent); override;
    procedure Recover; virtual;
    procedure Mixer; virtual;
  published
    property ColCount:integer read FColCount write SetColCount;
    property RowCount:integer read FRowCount write SetRowCount;
    property FifteenColor:TColor read FFifteenColor write FFifteenColor;
    property OnMouseMove;
    property Align;
    property Color;
    property ParentColor;
    property Enabled;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Anchors;
    property Action;
    property OnDblClick;
    property OnVictory: TNotifyEvent read fOnVictory write fOnVictory;
end;

procedure Register;

implementation

constructor TMyFifteen.Create(AOwner: TComponent);
var i, j: integer;
begin
  inherited Create(AOwner);
  FRowCount:= 4;
  FColCount:= 4;
  ColSize:= 64;
  RowSize:= 64;
  Height:=FRowCount*RowSize;
  Width:= FColCount*ColSize;
  FFifteenColor:=clWindow;
  for i:=0 to FRowCount-1 do
    for j:=0 to FColCount-1 do
      Field[i,j] := j+1+i*FColCount;
  Field[FRowCount-1, FColCount-1]:=0;
end;

//function TMyFifteen.GetColCount: integer;     //read
//begin
//  Result:=FColCount;
//end;

procedure TMyFifteen.SetColCount(Value: integer);
begin
  if (Value < 3) then
    Value:=3
  else
    if (Value > 5) then
      Value:=5;
      
  if (value <> FColCount) then
  begin
    FColCount:=Value;
    Recover;
    Refresh;
  end;
end;

//function TMyFifteen.GetRowCount: integer;    //read
//begin
//  Result:=FRowCount;
//end;

procedure TMyFifteen.SetRowCount(Value: integer);
begin
  if (Value < 3) then
    Value:=3
  else
    if (Value > 5) then
      Value:=5;

  if (value <> FRowCount) then
  begin
    FRowCount:=Value;
    Recover;
    Refresh;
  end;
end;

//function TMyFifteen.GetFifteenColor: TColor;    //read
//begin
//  Result:=FFifteenColor;
//end;

//procedure TMyFifteen.SetFifteenColor(Value: TColor);    //write
//begin
//  if (FFifteenColor <> Value) then
//  begin
//    FFifteenColor:=Value;
//    Refresh;
//  end;
//end;

// новая игра
procedure TMyFifteen.Recover; 
var
  i,j: integer;
begin
  // исходное (правильное) положение
  for i:=0 to FRowCount-1 do
    for j:=0 to FColCount-1 do
      Field[i,j] := j+1+i*FColCount;
  Field[FRowCount-1, FColCount-1]:=0;
  Paint; // отобразить поле
end;

// Клик по компоненту
procedure TMyFifteen.WMLButtonDown(var M: Tmessage);
var
  CellCol, CellRow: integer; // координаты клетки
  x1, y1, x2, y2:integer;
  ColCnt, RowCnt: integer;
  FifteenWidth, FifteenHeight: integer;
  FW, FH: integer;
begin
  //Проверка сбора пятнашек
  if not(Finish) then
  begin
    // преобразование координаты мыши в координаты клетки
    if Width / FColCount > Height / FRowCount then
    begin
      FifteenHeight:=Height;
      FifteenWidth:=Trunc(Height / FRowCount * FColCount);
    end else
    begin
      FifteenWidth:=Width;
      FifteenHeight:=Trunc(Width / FColCount * FRowCount);
    end;

    x1:=(Width - FifteenWidth) div 2;
    y1:=(Height - FifteenHeight) div 2;
    x2:=(Width + FifteenWidth) div 2;
    y2:=(Height + FifteenHeight) div 2;

    //Клик произведён в области пятнашек?
    if (M.LParamLo >= x1) and (M.LParamLo <= x2)
    and (M.LParamHi >= y1) and (M.LParamHi <= y2) then
    begin
      ColCnt:=FColCount;
      while (ColCnt > 0) and (M.LParamLo >= x1) do
      begin
        FW:=x2-x1;
        ColSize:=FW div ColCnt;
        Dec(ColCnt);
        x1:=x1+ColSize;
      end;
      CellCol:=FColCount-ColCnt-1;

      RowCnt:=FRowCount;
      while (RowCnt > 0) and (M.LParamHi >= y1) do
      begin
        FH:=y2-y1;
        RowSize:=FH div RowCnt;
        Dec(RowCnt);
        y1:=y1+RowSize;
      end;
      CellRow:=FRowCount-RowCnt-1;
      Move(CellCol,CellRow);
    end;
  end;
end;

// перемещение костяшки в соседнюю пустую клетку
procedure TMyFifteen.Move(CellCol,CellRow: integer);
begin
  // Проверка возможности обмена
  // Если обмен невозможен, то осуществляется выход из процедуры
  if not ((abs(CellCol-EmptCol) = 1) and (CellRow-EmptRow = 0)
  or (abs(CellRow-EmptRow) = 1) and (CellCol-EmptCol = 0)) then exit;
  // Если обмен возможен меняем костяшку и пустую клетку местами
  // Обмен. Переместим костяшку из CellRow, CellCol в EmptRow, EmptCol
  Field[EmptRow,EmptCol] := Field[CellRow,CellCol];
  Field[CellRow,CellCol] := 0;
  EmptCol:=CellCol;
  EmptRow:=CellRow;
  Paint;  // отрисовать поле
  if Finish then
    if Assigned(fOnVictory) then
      fOnVictory(self);
end;

// проверяет, расположены ли
// фишки в нужном порядке
function TMyFifteen.Finish: Boolean;
var
  Row, Col: integer;
  i: integer;
begin
  Row :=0; Col :=0;
  Finish := True; // пусть фишки в нужном порядке
  for i:=1 to FRowCount*FColCount-1 do
  begin
    if Field[Row,Col] <> i then
    begin
      Result:= False;
      Break;
    end;
    // к следующей клетке
    if Col < FColCount-1 then
      Inc(Col)
    else
    begin
      Col :=0;
      Inc(Row);
    end;
  end;
end;

procedure TMyFifteen.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (AWidth<0) then AWidth:=0;
  if (AHeight<0) then AHeight:=0;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

// выводит игровое поле
procedure TMyFifteen.Paint;
var
  Image:TBitmap;
  i, j: integer; // Номер ячейки массива
  x, y: integer; // x,y - координаты вывода текста в клетке
  x1, y1, x2, y2: integer; // Координаты пятнашек
  ColCnt, RowCnt :integer;  // Кол-во клеток по верикали и горизонтали
  FifteenWidth, FifteenHeight: integer; //Размер пятнашек Константы
  FW, FH: integer; // Размер пятнашек Изменяемые переменные
begin
  Image:= TBitmap.Create;
  try
    Image.Width:= Width;
    Image.Height:= Height;
    Image.Canvas.Font.Name:=Font.Name;
    Image.Canvas.Font.Style:=Font.Style;
    with Image.Canvas do
    begin
      if ParentColor then
        Brush.Color:=Parent.Brush.Color;

      // Закрашивание компонента (фона) под цвет формы
      Brush.Color:=Color;
      FillRect(ClientRect);

      // Определение меньшей стооны пятнашек относительно помпонента
      if Width / FColCount > Height / FRowCount then
      begin
        FifteenHeight:=Height;
        FifteenWidth:=Trunc(Height / FRowCount * FColCount);
      end else
      begin
        FifteenWidth:=Width;
        FifteenHeight:=Trunc(Width / FColCount * FRowCount);
      end;

      // Нахождение координат по которым будут описываться пятнашки
      x1:=(Width - FifteenWidth) div 2;
      y1:=(Height - FifteenHeight) div 2;
      x2:=(Width + FifteenWidth) div 2;
      y2:=(Height + FifteenHeight) div 2;

      Brush.Color:=FFifteenColor;
      FillRect(Rect(x1, y1, x2, y2));

      // Отрисовка ячеек
      // сетка: вертикальные линии
//      ColCnt:=FColCount;         //Замена на for в качестве оптимизации
//      while (ColCnt > 0) do
      for ColCnt := FColCount downto 1 do
      begin
        FW:=x2-x1;
        ColSize:=FW div ColCnt;
        MoveTo(x1, y1);
        LineTo(x1, y2);
        MoveTo(x1+ColSize-1, y1);
        LineTo(x1+ColSize-1, y2);
//        Dec(ColCnt);
        x1:=x1+ColSize;
      end;

      // сетка: горизонтальные линии
      x1:=(Width - FifteenWidth) div 2;
//      RowCnt:=FRowCount;           //Замена на for в качестве оптимизации
//      while (RowCnt > 0) do
      for RowCnt := FRowCount downto 1 do
      begin
        FH:=y2-y1;
        RowSize:=FH div RowCnt;
        MoveTo(x1, y1);
        LineTo(x2, y1);
        MoveTo(x1, y1+RowSize-1);
        LineTo(x2, y1+RowSize-1);
//        Dec(RowCnt);
        y1:=y1+RowSize;
      end;

      //Отрисовка содержимго клеток
      Brush.Style:=bsClear;    //Прозрачный фон
      i:=0;
//      RowCnt:=FRowCount;
      y1:=(Height - FifteenHeight) div 2;
//      while (RowCnt > 0) do              //Замена на for в качестве оптимизации
      for RowCnt := FRowCount downto 1 do
      begin
        FH:=y2-y1;
        RowSize:=FH div RowCnt;

//        ColCnt:=FColCount;
        x1:=(Width - FifteenWidth) div 2;
        j:=0;

        Font.Height:=RowSize-2;

        y:=y1 + (RowSize - TextHeight(IntToStr(Field[i,j]))) div 2;
//        while (ColCnt > 0) do
        for ColCnt := FColCount downto 1 do
        begin
          FW:=x2-x1;
          ColSize:=FW div ColCnt;
          
          x:=x1 + (ColSize - TextWidth(IntToStr(Field[i,j]))) div 2;
          if (Field[i, j] <> 0) and (Font.Height >= 1) then
            TextOut(x,y,IntToStr(Field[i,j]));

//          Dec(ColCnt);
          x1:=x1+ColSize;
          Inc(j);
        end;

//        Dec(RowCnt);
        y1:=y1+RowSize;
        Inc(i);
      end;

    end;
    Canvas.CopyRect(ClientRect, Image.Canvas, ClientRect);
  finally
    Image.Free;
  end;
end;

// Перемешивание элементов
procedure TMyFifteen.Mixer;
var
  x1,y1: integer; // пустая клетка
  x2,y2: integer;
  oldx, oldy: integer; // предыдущее место пустой клетки
  rand: integer;     // направление, относительно пустой
  i: integer;
begin
  Recover;
  x1:=FColCount-1;
  y1:=FRowCount-1;
  randomize;
  for i:= 0 to 120 do
  begin
    repeat
      x2:=x1;
      y2:=y1;
      rand:=random(4)+1;
      case rand of
        1: dec(x2);
        2: inc(x2);
        3: dec(y2);
        4: inc(y2);
      end;
    until (x2>=0) and (x2<=FColCount-1) and (y2>= 0) and (y2<=FRowCount-1) and not((x2 = oldx) and (y2 = oldy));
    // здесь определили фишку, которую
    // надо переместить в пустую клетку
    Field[y1,x1] := Field[y2,x2];
    Field[y2,x2] := 0;
    oldx:=x1;
    oldy:=y1;
    x1:=x2;
    y1:=y2;
  end;
  // запомним координаты пустой клетки
  EmptCol:= x1;
  EmptRow:= y1;
  Paint;
end;

procedure Register;
begin
   RegisterComponents('Test', [TMyFifteen]);
end;

end.
