program DoubleDouble;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  LUX.D1.QDouble in '_LIBRARY\LUX.D1.QDouble.pas',
  LUX.D1.DDouble in '_LIBRARY\LUX.D1.DDouble.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
