unit Fifteen;

interface

uses
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  ExtCtrls, Dialogs, SysUtils;

type
  TFifteen = class(TGraphicControl)
  private
    FFifteenColor: TColor; // ���� ��������
    FLinesColor: TColor; // ���� �����
    FRowCount, FColCount: integer; // ������ ����
    EmptCol, EmptRow: integer; // ���������� ������ ������
    RowSize, ColSize: integer; //������ ������
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
  FRowCount := 4; // ���-�� �����
  FColCount := 4; // ���-�� ��������
  RowSize := 64;  // ������ �����
  ColSize := 64;  // ������ ��������
  Height := FRowCount*RowSize; // ������ ��������
  Width := FColCount*ColSize;  // ������ ��������
  FFifteenColor := clWindow;   // ���� �������� (�����)
  Filler; // ���������� ������� �������� �� �������
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

// ����� ����
procedure TFifteen.Recover;
begin
  Filler;
  Paint;
end;

// �������������� �������� � ���. ���������
procedure TFifteen.Filler;
var
  I, J: Integer;
begin
  for I := 0 to FRowCount - 1 do
    for J := 0 to FColCount - 1 do
      Field[I, J] := J + 1 + I * FColCount;
  Field[FRowCount - 1, FColCount - 1] := 0;
end;

// �������������� ���������� ���� � ���������� ������
procedure TFifteen.WMLButtonDown(var Message: Tmessage);
var
  CellCol, CellRow: Integer; // ���������� ������
  x1, y1, x2, y2: Integer; // ���������� ���� ���������� (� ��������)
  ColCnt, RowCnt: Integer; // ���������� ��������, ����� ��������
  FifteenWidth, FifteenHeight: Integer; // ������, ������ ��������
  FW, FH: Integer;
begin
  if Assigned(FOnClick) then // ������� �������
    FOnClick(Self);

  if not Finish then // �������� ����� ��������
  begin
    // ����������� ������� ��������
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

    // ������� ����������� � ������� ��������?
    if (Message.LParamLo >= x1) and (Message.LParamLo <= x2)
    and (Message.LParamHi >= y1) and (Message.LParamHi <= y2) then
    begin
      for ColCnt := FColCount downto 1 do // ����� ������ ������� �������� ��������
      begin
        if Message.LParamLo < x1 then Break;
        FW := x2 - x1;
        ColSize := FW div ColCnt;
        x1 := x1 + ColSize;
      end;
      CellCol := FColCount - ColCnt - 1;

      for RowCnt := FRowCount downto 1 do // ����� ������ ������ ��������� ��������
      begin
        if (Message.LParamHi < y1) then Break;
        FH := y2 - y1;
        RowSize := FH div RowCnt;
        y1 := y1 + RowSize;
      end;
      CellRow := FRowCount - RowCnt - 1;
      Move(CellCol, CellRow); // ��������� � ��������� ������ ��������
    end;
  end;
end;

procedure TFifteen.Move(CellCol, CellRow: Integer);
var
  Dir: Integer; // ����������� ������
begin
  // �������� ����������� ������
  if ((CellRow - EmptRow = 0) or (CellCol - EmptCol = 0))
  and not((CellRow - EmptRow = 0) and (CellCol - EmptCol = 0)) then
  begin
    // ����� �� �����������
    if (CellCol - EmptCol > 0) then Dir := 1 // ����������� �����������
    else Dir := -1;                          // ������ ��������
    while (EmptCol <> CellCol) do
    begin
      Field[EmptRow, EmptCol] := Field[EmptRow, EmptCol + Dir];
      EmptCol := EmptCol + Dir;
    end;
    Field[EmptRow, EmptCol] := 0;

    // ����� �� ���������
    if (CellRow - Emptrow > 0) then Dir := 1 // ����������� �����������
    else Dir := -1;                          // ������ ��������
    while (EmptRow <> CellRow) do
    begin
      Field[EmptRow, EmptCol] := Field[EmptRow + Dir, EmptCol];
      EmptRow:=EmptRow + Dir;
    end;
    Field[EmptRow, EmptCol] := 0;

    Paint; // ��������� ����������
    if Assigned(FOnTilesMove) then // ������� ������ ��������
      FOnTilesMove(Self);

    if Finish then // ��������� � ������� �������� ����������� ��������
      if Assigned(FOnVictory) then // ������� ���������� ����� ��������
        FOnVictory(Self);
  end;
end;

// �������� ������������� �������� � ������ �������
function TFifteen.Finish: Boolean;
var
  Row, Col: Integer;
  I: Integer;
begin
  Row := 0; Col := 0;
  Finish := True;
  for I := 1 to FRowCount * FColCount -1 do
  begin
    if Field[Row, Col] <> I then // �������� �� ��������� � ������� �������?
    begin
      Result := False;
      Break; // ����� �� �������
    end;
    // ������� � ��������� ��������
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

// ��������� ����������
procedure TFifteen.Paint;
var
  Image: TBitmap;
  I, J: Integer;                // ����� ������ �������
  x, y: Integer;                // x,y - ���������� ������ ������ � ������
  x1, y1, x2, y2: Integer;      // ���������� ��������
  ColCnt, RowCnt: Integer;      // ���-�� ������ �� ��������� � �����������
  FifteenWidth, FifteenHeight: Integer; //������ �������� ���������
  FW, FH: Integer;              // ������ �������� ���������� ����������
  TxtWidth, TxtHeight: Integer; //������ ������
  Numbers: String;              // ������ ����� �� 1 �� 9
  MaxNumWidth: String;          //����� ������� ������
  Num: Integer;
begin
  Image:= TBitmap.Create;       // �������� �����
  try
    Image.Width := Width;
    Image.Height := Height;
    Image.Canvas.Font.Name := Font.Name;
    Image.Canvas.Font.Style := Font.Style;
    Image.Canvas.Font.Color := Font.Color;

    with Image.Canvas do
    begin
      // ������������ ���������� (����) ��� ���� �����
      Brush.Color := Color;
      FillRect(ClientRect);

      // ����������� ������� ������� �������� ������������ ����������
      if Width / FColCount > Height / FRowCount then
      begin
        FifteenHeight := Height;
        FifteenWidth := Trunc(Height / FRowCount * FColCount);
      end else
      begin
        FifteenWidth := Width;
        FifteenHeight := Trunc(Width / FColCount * FRowCount);
      end;

      // ����������� ��������� �� ������� ����� ����������� ��������
      x1 := (Width - FifteenWidth) div 2;
      y1 := (Height - FifteenHeight) div 2;
      x2 := (Width + FifteenWidth) div 2;
      y2 := (Height + FifteenHeight) div 2;

      // ������������ ���� ��������
      Brush.Color := FFifteenColor;
      FillRect(Rect(x1, y1, x2, y2));

      // ��������� �����
      // �����: ������������ �����
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

      // �����: �������������� �����
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

      Brush.Style := bsClear; // ���������� ��� ��� �������

      i := 0;
      y1 := (Height - FifteenHeight) div 2;

      FH := y2 - y1;
      RowSize := FH div FRowCount;
      Font.Height := RowSize - 2;

      // ����������� ����. �������� �����
      Numbers := '123456789';
      MaxNumWidth := '0';
      for num := 1 to Length(numbers)	do
        if TextWidth(numbers[num]) > TextWidth(MaxNumWidth) then
          MaxNumWidth := numbers[num];

      // ��������� ������ ��� ������ ������ ������� ���������
      TxtHeight := TextHeight(MaxNumWidth);
      TxtWidth := TextWidth(MaxNumWidth) * (Length(IntToStr(FRowCount * FColCount - 1)) + 1);
      if TxtWidth > TxtHeight then
        Font.Height := Round(ColSize / (TxtWidth / TxtHeight));

      // ��������� ���������� ������
      for RowCnt := FRowCount downto 1 do
      begin
        FH := y2 - y1;
        RowSize := FH div RowCnt;
        x1 := (Width - FifteenWidth) div 2; //�������������� ���������� ���. ����.
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

// ������������� ���������
procedure TFifteen.Mixer;
var
  I, J:integer;
  xi, yi, xj, yj: Integer;
begin
  Recover; // �������������� ������� ��������
  Randomize;
  // ��������� ������ � �����
  for I := FRowCount * FColCount - 1 downto 0 do
  begin
    J := Trunc(random(I + 1));
    xi := I mod FRowCount;
    yi := Trunc(I div FRowCount);
    xj := J mod FRowCount;
    yj := Trunc(J div FRowCount);
    SwapTiles(xi, yi, xj, yj);
  end;

  InitEmpty; // ����� � �������������� ��������� ������� �����
  if not IsSolvable then // �����. � ������� �������� ������������ ����.
  begin                                        // �������� ������� �����
    if (EmptRow = 0) and (EmptCol <= 1) then // � ������ ���� �������
      SwapTiles(FRowCount - 1, FColCount - 2, FRowCount - 1, FColCount - 1)
    else
      SwapTiles(0, 0, 0, 1);
  end;
  Refresh;
end;

// ����� ������� �����
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

// ������ �������� �������
procedure TFifteen.SwapTiles(I, J, K, L: Integer);
var
  Temp: Integer; // ����� ��� �������� ������ ��������
begin
  Temp := Field[I, J]; // ������ ������� ������ � �����
  Field[I, J] := Field[K, L]; // ������ ������� ������ �� ����� �������
  Field[K, L] := Temp; // ������ ������� ������ �� ����� �������
end;

// �������� ������������ ��������
function TFifteen.IsSolvable: Boolean;
begin
  if FColCount mod 2 = 1 then // �������� �������� ���-�� �������� ��������
    IsSolvable:=SumInversions mod 2 = 0 // �������� �������� ����� A
  else
    IsSolvable:=(SumInversions + EmptRow + 1) mod 2 = 0; // �������� �������� ����� A + B
end;

// ����� �������� (����� A)
function TFifteen.SumInversions: Integer;
var
  I, J: Integer;
  Inversions: Integer; // ���-�� ������������ (���������������) �����
  InversionsNum: Integer; // ���-�� ������������ (���������������) ��� ���������� ������
  TileNum: Integer; // ����� �������� �� ������
  LastTile: Integer; // ��������� ��������
  TileValue: Integer; // �������� ������� ��������
  K, L, Q: Integer;    // ���������� ������
  CompValue: Integer; // ��������  �������� ���������� �� ���������
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
      // ������� ����� A ��� ������� ������
      for Q := TileNum + 1 to LastTile - 1 do
      begin
        L := Q mod FColCount;
        K := Trunc(Q / FColCount);

        CompValue := Field[K, L];
        if (TileValue > CompValue) and (TileValue <> LastTile)
        and (TileValue <> 0) and (CompValue <> 0) then
        InversionsNum := InversionsNum + 1;
      end;
      Inversions := Inversions + InversionsNum; // ���������� ����� A ����� �����
    end;
  end;
 SumInversions := Inversions; // ����� ���-�� �������� (����� A)
end;

procedure Register;
begin
   RegisterComponents('Ermolaev Components', [TFifteen]);
end;

end.
