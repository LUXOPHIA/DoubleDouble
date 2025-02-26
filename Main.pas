unit Main;

interface  //################################################################### ■

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.TabControl;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
      TabItemD1: TTabItem;
        ImageD1: TImage;
      TabItemD2: TTabItem;
        ImageD2: TImage;
      TabItemD4: TTabItem;
        ImageD4: TImage;
    Panel1: TPanel;
      Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { private 宣言 }
  public
    { public 宣言 }
  end;

var
  Form1: TForm1;

implementation //############################################################### ■

{$R *.fmx}

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

procedure TForm1.FormCreate(Sender: TObject);
begin
     /////
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
     /////
end;

//------------------------------------------------------------------------------

procedure TForm1.Button1Click(Sender: TObject);
begin
     /////
end;

end. //######################################################################### ■
