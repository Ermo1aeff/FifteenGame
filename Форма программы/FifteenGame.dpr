program FifteenGame;

uses
  Forms,
  FifteenGameForm in 'FifteenGameForm.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.HelpFile := 'egorka.ermolaev.02@gmail.com';
  Application.Title := 'Пятнашки';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
