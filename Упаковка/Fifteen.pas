unit Fifteen;

interface

uses
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  ExtCtrls, Dialogs, SysUtils;

type
  TFifteen = class(TGraphicControl)
  private
    FFifteenColor: TColor; // Цвет пятнашек
    FLinesColor: TColor; // Цвет линий
    FRowCount, FColCount: integer; // Размер поля
    EmptCol, EmptRow: integer; // Координаты пустой клетки
    RowSize, ColSize: integer; //Размер клеток
    Field: array[0..10, 0..10] of integer;
    FOnVictory: TNotifyEvent;
    FOnTilesMove: TNotifyEvent;
    FOnClick: TNotifyEvent;
  protected
    procedure WMLButtonDown(var Message: TMessage); message WM_LBUTTONDOWN;
    procedure SetColCount(Value: Integer); virtual;
    procedure SetRowCount(Value: Integer); virtual;
    procedure SetFifteenColor(Value: TColor); virtual;
    procedure SetLinesColor(Value: TColor); virtual;
    procedure Paint; override;
    procedure Move(CellCol, CellRow: Integer); virtual;
    function Finish: boolean; virtual;
    procedure SwapTiles(I, J, K, L: Integer); virtual;
    function IsSolvable: Boolean; virtual;
    function SumInversions: Integer; virtual;
    procedure InitEmpty; virtual;
  public
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    constructor Create(AOwner: TComponent); override;
    procedure Recover; virtual;
    procedure Mixer; virtual;
    procedure Filler; virtual;
  published
    property ColCount:Integer read FColCount write SetColCount;
    property RowCount:Integer read FRowCount write SetRowCount;
    property FifteenColor:TColor read FFifteenColor write SetFifteenColor;
    property LinesColor:TColor read FLinesColor write SetLinesColor;
    property Align;
    property Color;
    property ParentColor;
    property Enabled;
    property Font;
    property ParentFont;
    property Hint;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;
    property Anchors;
    property Action;
    property DragKind;
    property DragMode;
    property DragCursor;

    property OnDblClick;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelUp;
    property OnMouseWheelDown;
    property OnResize;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnStartDock;
    property OnStartDrag;

    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnVictory: TNotifyEvent read FOnVictory write FOnVictory;
    property OnTilesMove: TNotifyEvent read FOnTilesMove write FOnTilesMove;
end;

procedure Register;

implementation

constructor TFifteen.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRowCount := 4; // Кол-во строк
  FColCount := 4; // Кол-во столбцов
  RowSize := 64;  // Размер строк
  ColSize := 64;  // Размер столбцов
  Height := FRowCount*RowSize; // Высота пятнашек
  Width := FColCount*ColSize;  // Ширина пятнашек
  FFifteenColor := clWindow;   // Цвет пятнашек (белый)
  Filler; // Заполнение массива костяшек по порядку
end;

procedure TFifteen.SetColCount(Value: integer);
begin
  if Value < 3 then
    Value := 3
  else
    if Value > 10 then
      Value := 10;

  FColCount := Value;
  Filler;
  Refresh;
end;

procedure TFifteen.SetFifteenColor(Value: TColor);
begin
  if FFifteenColor <> Value then
  begin
    FFifteenColor := Value;
    Refresh;
  end;
end;

procedure TFifteen.SetLinesColor(Value: TColor);
begin
  if FLinesColor <> Value then
  begin
    FLinesColor := Value;
    Refresh;
  end;
end;

procedure TFifteen.SetRowCount(Value: integer);
begin
  if Value < 3 then
    Value := 3
  else
    if Value > 10 then
      Value := 10;

  FRowCount := Value;
  Filler;
  Refresh;
end;

// Новая игра
procedure TFifteen.Recover;
begin
  Filler;
  Paint;
end;

// Восстановление пятнашек в исх. положение
procedure TFifteen.Filler;
var
  I, J: Integer;
begin
  for I := 0 to FRowCount - 1 do
    for J := 0 to FColCount - 1 do
      Field[I, J] := J + 1 + I * FColCount;
  Field[FRowCount - 1, FColCount - 1] := 0;
end;

// Преобразование координаты мыши в координаты клетки
procedure TFifteen.WMLButtonDown(var Message: Tmessage);
var
  CellCol, CellRow: Integer; // Координаты клетки
  x1, y1, x2, y2: Integer; // Координаты краёв компонента (в пикселях)
  ColCnt, RowCnt: Integer; // Количество столбцов, строк пятнашек
  FifteenWidth, FifteenHeight: Integer; // Ширина, высота пятнашек
  FW, FH: Integer;
begin
  if Assigned(FOnClick) then // Событие нажатия
    FOnClick(Self);

  if not Finish then // Проверка сбора пятнашек
  begin
    // Определение размера пятнашек
    if Width / FColCount > Height / FRowCount then
    begin
      FifteenHeight := Height;
      FifteenWidth := Trunc(Height / FRowCount * FColCount);
    end else
    begin
      FifteenWidth := Width;
      FifteenHeight := Trunc(Width / FColCount * FRowCount);
    end;

    x1 := (Width - FifteenWidth) div 2;
    y1 := (Height - FifteenHeight) div 2;
    x2 := (Width + FifteenWidth) div 2;
    y2 := (Height + FifteenHeight) div 2;

    // Нажатие произведено в области пятнашек?
    if (Message.LParamLo >= x1) and (Message.LParamLo <= x2)
    and (Message.LParamHi >= y1) and (Message.LParamHi <= y2) then
    begin
      for ColCnt := FColCount downto 1 do // Поиск номера колонки выбраной костяшки
      begin
        if Message.LParamLo < x1 then Break;
        FW := x2 - x1;
        ColSize := FW div ColCnt;
        x1 := x1 + ColSize;
      end;
      CellCol := FColCount - ColCnt - 1;

      for RowCnt := FRowCount downto 1 do // Поиск номера строки выбранной костяшки
      begin
        if (Message.LParamHi < y1) then Break;
        FH := y2 - y1;
        RowSize := FH div RowCnt;
        y1 := y1 + RowSize;
      end;
      CellRow := FRowCount - RowCnt - 1;
      Move(CellCol, CellRow); // Обращение к процедуре сдвига пятнашек
    end;
  end;
end;

procedure TFifteen.Move(CellCol, CellRow: Integer);
var
  Dir: Integer; // Направление сдвига
begin
  // Проверка возможности обмена
  if ((CellRow - EmptRow = 0) or (CellCol - EmptCol = 0))
  and not((CellRow - EmptRow = 0) and (CellCol - EmptCol = 0)) then
  begin
    // Сдвиг по горизонтали
    if (CellCol - EmptCol > 0) then Dir := 1 // Определение направления
    else Dir := -1;                          // сдвига костяшек
    while (EmptCol <> CellCol) do
    begin
      Field[EmptRow, EmptCol] := Field[EmptRow, EmptCol + Dir];
      EmptCol := EmptCol + Dir;
    end;
    Field[EmptRow, EmptCol] := 0;

    // Сдвиг по вертикали
    if (CellRow - Emptrow > 0) then Dir := 1 // Определение направления
    else Dir := -1;                          // сдвига костяшек
    while (EmptRow <> CellRow) do
    begin
      Field[EmptRow, EmptCol] := Field[EmptRow + Dir, EmptCol];
      EmptRow:=EmptRow + Dir;
    end;
    Field[EmptRow, EmptCol] := 0;

    Paint; // Отрисовка компонента
    if Assigned(FOnTilesMove) then // Событие сдвига костяшек
      FOnTilesMove(Self);

    if Finish then // Обращение к функции проверки собранности пятнашек
      if Assigned(FOnVictory) then // Событие завершения сбора пятнашек
        FOnVictory(Self);
  end;
end;

// Проверка рассположения костяшек в нужном порядке
function TFifteen.Finish: Boolean;
var
  Row, Col: Integer;
  I: Integer;
begin
  Row := 0; Col := 0;
  Finish := True;
  for I := 1 to FRowCount * FColCount -1 do
  begin
    if Field[Row, Col] <> I then // Костяшка не совпадает с номером порядка?
    begin
      Result := False;
      Break; // Выход из функции
    end;
    // Переход к следующей костяшке
    if Col < FColCount - 1 then
      Inc(Col)
    else
    begin
      Col := 0;
      Inc(Row);
    end;
  end;
end;

procedure TFifteen.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if (AWidth < 0) then AWidth := 0;
  if (AHeight < 0) then AHeight := 0;
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;

// Отрисовка компонента
procedure TFifteen.Paint;
var
  Image: TBitmap;
  I, J: Integer;                // Номер ячейки массива
  x, y: Integer;                // x,y - координаты вывода текста в клетке
  x1, y1, x2, y2: Integer;      // Координаты пятнашек
  ColCnt, RowCnt: Integer;      // Кол-во клеток по вертикали и горизонтали
  FifteenWidth, FifteenHeight: Integer; //Размер пятнашек Константы
  FW, FH: Integer;              // Размер пятнашек Изменяемые переменные
  TxtWidth, TxtHeight: Integer; //Ширина текста
  Numbers: String;              // Строка чисел от 1 до 9
  MaxNumWidth: String;          //Самый широкий символ
  Num: Integer;
begin
  Image:= TBitmap.Create;       // Создание канвы
  try
    Image.Width := Width;
    Image.Height := Height;
    Image.Canvas.Font.Name := Font.Name;
    Image.Canvas.Font.Style := Font.Style;
    Image.Canvas.Font.Color := Font.Color;

    with Image.Canvas do
    begin
      // Закрашивание компонента (фона) под цвет формы
      Brush.Color := Color;
      FillRect(ClientRect);

      // Определение меньшей стороны пятнашек относительно компонента
      if Width / FColCount > Height / FRowCount then
      begin
        FifteenHeight := Height;
        FifteenWidth := Trunc(Height / FRowCount * FColCount);
      end else
      begin
        FifteenWidth := Width;
        FifteenHeight := Trunc(Width / FColCount * FRowCount);
      end;

      // Определение координат по которым будут описываться пятнашки
      x1 := (Width - FifteenWidth) div 2;
      y1 := (Height - FifteenHeight) div 2;
      x2 := (Width + FifteenWidth) div 2;
      y2 := (Height + FifteenHeight) div 2;

      // Закрашивание фона пятнашек
      Brush.Color := FFifteenColor;
      FillRect(Rect(x1, y1, x2, y2));

      // Отрисовка ячеек
      // Сетка: вертикальные линии
      Pen.Color := FLinesColor;
      for ColCnt := FColCount downto 1 do
      begin
        FW := x2 - x1;
        ColSize := FW div ColCnt;
        MoveTo(x1, y1);
        LineTo(x1, y2);
        x1 := x1 + ColSize;
        MoveTo(x1 - 1, y1);
        LineTo(x1 - 1, y2);
      end;

      // Сетка: горизонтальные линии
      x1 := (Width - FifteenWidth) div 2;
      for RowCnt := FRowCount downto 1 do
      begin
        FH := y2 - y1;
        RowSize := FH div RowCnt;
        MoveTo(x1, y1);
        LineTo(x2, y1);
        y1 := y1 + RowSize;
        MoveTo(x1, y1 - 1);
        LineTo(x2, y1 - 1);
      end;

      Brush.Style := bsClear; // Прозрачный фон для номеров

      i := 0;
      y1 := (Height - FifteenHeight) div 2;

      FH := y2 - y1;
      RowSize := FH div FRowCount;
      Font.Height := RowSize - 2;

      // Определение макс. широкого числа
      Numbers := '123456789';
      MaxNumWidth := '0';
      for num := 1 to Length(numbers)	do
        if TextWidth(numbers[num]) > TextWidth(MaxNumWidth) then
          MaxNumWidth := numbers[num];

      // Изменение шрифта под ширину клетки методом пропорций
      TxtHeight := TextHeight(MaxNumWidth);
      TxtWidth := TextWidth(MaxNumWidth) * (Length(IntToStr(FRowCount * FColCount - 1)) + 1);
      if TxtWidth > TxtHeight then
        Font.Height := Round(ColSize / (TxtWidth / TxtHeight));

      // Отрисовка содержимго клеток
      for RowCnt := FRowCount downto 1 do
      begin
        FH := y2 - y1;
        RowSize := FH div RowCnt;
        x1 := (Width - FifteenWidth) div 2; //Восстановление координаты нач. пятн.
        J := 0;

        y := y1 + (RowSize - TextHeight(IntToStr(Field[I, J]))) div 2;
        for ColCnt := FColCount downto 1 do
        begin
          FW := x2 - x1;
          ColSize := FW div ColCnt;
          x := x1 + (ColSize - TextWidth(IntToStr(Field[I, J]))) div 2;
          if (Field[I, J] <> 0) and (Font.Height >= 1) then
            TextOut(x, y, IntToStr(Field[I, J]));
          x1 := x1 + ColSize;
          Inc(J);
        end;
        y1 := y1 + RowSize;
        Inc(I);
      end;
    end;
    Canvas.CopyRect(ClientRect, Image.Canvas, ClientRect);
  finally
    Image.Free;
  end;
end;

// Перемешивание элементов
procedure TFifteen.Mixer;
var
  I, J:integer;
  xi, yi, xj, yj: Integer;
begin
  Recover; // Восстановление порядка костяшек
  Randomize;
  // Тасование Фишера — Йетса
  for I := FRowCount * FColCount - 1 downto 0 do
  begin
    J := Trunc(random(I + 1));
    xi := I mod FRowCount;
    yi := Trunc(I div FRowCount);
    xj := J mod FRowCount;
    yj := Trunc(J div FRowCount);
    SwapTiles(xi, yi, xj, yj);
  end;

  InitEmpty; // Поиск и восстановление координат пустого места
  if not IsSolvable then // Обращ. к функции проверки собираемости пятн.
  begin                                        // проверка пустого места
    if (EmptRow = 0) and (EmptCol <= 1) then // в первых двух клетках
      SwapTiles(FRowCount - 1, FColCount - 2, FRowCount - 1, FColCount - 1)
    else
      SwapTiles(0, 0, 0, 1);
  end;
  Refresh;
end;

// Поиск пустого места
procedure TFifteen.InitEmpty;
var
  I, J:integer;
begin
  for I:= 0 to FRowCount - 1 do
    for J := 0 to FColCount - 1 do
      if Field[I, J] = 0 then
      begin
        EmptRow:=I;
        EmptCol:=J;
        Exit;
      end;
end;

// Замена костяшек местами
procedure TFifteen.SwapTiles(I, J, K, L: Integer);
var
  Temp: Integer; // Буфер для хранения номера костяшки
begin
  Temp := Field[I, J]; // Запись первого номера в буфер
  Field[I, J] := Field[K, L]; // Запись второго номера на место первого
  Field[K, L] := Temp; // Запись первого номера на место второго
end;

// Проверка собираемости пятнашек
function TFifteen.IsSolvable: Boolean;
begin
  if FColCount mod 2 = 1 then // Проверка чётности кол-ва столбцов пятнашек
    IsSolvable:=SumInversions mod 2 = 0 // Проверка четности числа A
  else
    IsSolvable:=(SumInversions + EmptRow + 1) mod 2 = 0; // Проверка чётности чисел A + B
end;

// Сумма инсерсий (число A)
function TFifteen.SumInversions: Integer;
var
  I, J: Integer;
  Inversions: Integer; // Кол-во неправильных (инвертированных) общее
  InversionsNum: Integer; // Кол-во неправильных (инвертированных) для выбранного номера
  TileNum: Integer; // Номер элемента по списку
  LastTile: Integer; // Последняя костяшка
  TileValue: Integer; // Значение данного элемента
  K, L, Q: Integer;    // Координаты клеток
  CompValue: Integer; // Значение  элемента следующего за выбранным
begin
  Inversions := 0;
  for I := 0 to FRowCount - 1 do
  begin
    for J := 0 to FColCount - 1 do
    begin
      TileNum := I * FColCount + J;
      LastTile := FColCount * FRowCount;
      TileValue := Field[I, J];
      InversionsNum := 0;
      // Подсчёт числа A для данного номера
      for Q := TileNum + 1 to LastTile - 1 do
      begin
        L := Q mod FColCount;
        K := Trunc(Q / FColCount);

        CompValue := Field[K, L];
        if (TileValue > CompValue) and (TileValue <> LastTile)
        and (TileValue <> 0) and (CompValue <> 0) then
        InversionsNum := InversionsNum + 1;
      end;
      Inversions := Inversions + InversionsNum; // Добавление числа A общую сумму
    end;
  end;
 SumInversions := Inversions; // Общее кол-во инверсий (числа A)
end;

procedure Register;
begin
   RegisterComponents('Ermolaev Components', [TFifteen]);
end;

end.
