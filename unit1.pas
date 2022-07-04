unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, LCLType;

type

  TMonster=record
    X,Y,HP: integer;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  path: String;
  i, j, x, win, score: integer;
  PicMonster, Buf: TBitmap;
  Monster: TMonster;
  nums: array[0..9, 0..4] of integer;
  correct_nums: array[1..10] of integer;

implementation

{$R *.lfm}

{ TForm1 }

procedure MainScreen; forward;

procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  path:=ExtractFileDir(Application.ExeName);

  Buf:=TBitmap.Create;
  Buf.Width:=1280;
  Buf.Height:=720;

  PicMonster:=TBitmap.Create;
  PicMonster.LoadFromFile(path+'\imgs\Monster.bmp');
  Monster.X:=0;
  Monster.Y:=0;
  Monster.HP:=3;
  PicMonster.Transparent := True;
  PicMonster.TransparentColor := clWhite;

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if (Key=VK_Up) and (Monster.Y > 0) then Monster.Y-=1;
  if (Key=VK_DOWN) and (Monster.Y < 4) then Monster.Y+=1;
  if (Key=VK_Left) and (Monster.X > 0) then Monster.X-=1;
  if (Key=VK_Right) and (Monster.X < 9) then Monster.X+=1;
  if (Key=VK_Space) then
    if nums[Monster.X, Monster.Y] mod StrToInt(Form1.Edit1.Text) = 0 then
      begin
        score+=1;
        Form1.Label3.Caption:='Score = ' + inttostr(Score);
        nums[Monster.X, Monster.Y]:=-1;
      end
      else if nums[Monster.X, Monster.Y] <> -1 then Monster.HP-=1;
  if Monster.HP < 1 then
    begin
      ShowMessage('Вы проиграли!');
      Score:=0;
      Monster.HP:=3;
      MainScreen;
    end;
  if Score = win then
    begin
      ShowMessage('Вы выиграли!');
      Monster.HP:=3;
      MainScreen;
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Buf.Canvas.Brush.Color:=clWhite;
  Buf.Canvas.Rectangle(0, 0, Form1.Width, Form1.Height);
  with Buf.Canvas do
       begin
         Pen.Color:=clBlack;
         Pen.Width:=10;
         Pen.Style:=psSolid;
         for i:=0 to 10 do
           Line((50+118*i), 50, (50+118*i), 670);
         for i:=0 to 5 do
           Line(50, (50+124*i), 1230, (50+124*i));
         for i:=0 to 9 do
           for j:=0 to 4 do
             begin
               if nums[i,j]<>-1 then
                 if (i=Monster.X) and (j=Monster.Y) then TextOut(130+118*i, 120+124*j, inttostr(nums[i,j]))
                 else TextOut(100+118*i, 100+124*j, inttostr(nums[i,j]));
             end;
         Draw(Monster.X*118+50, Monster.Y*124+50, PicMonster);
         TextOut(1192, 8, Form1.Label3.Caption);
         TextOut(25, 8, 'HP = ' + inttostr(Monster.HP));
       end;
  Form1.Canvas.Draw(0,0, Buf);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  for i:=1 to 10 do
    begin
      correct_nums[i]:=StrToInt(Form1.Edit1.Text) * i;
    end;
  for i:=0 to 9 do
    for j:= 0 to 4 do
      begin
        nums[i,j]:=random((StrToInt(Form1.Edit1.Text)+1)*9)+1;
      end;
  for i:=1 to length(correct_nums) do
    begin
      nums[random(10), random(5)]:=correct_nums[i];
    end;
  for i:=0 to 9 do
    for j:=0 to 4 do
      if nums[i,j] mod StrToInt(Form1.Edit1.Text) = 0 then win+=1;
  Form1.Button1.Visible:=False;
  Form1.Button1.Enabled:=False;
  Form1.Timer1.Enabled:=True;
  Form1.Edit1.Enabled:=False;
  Form1.Edit1.Visible:=False;
end;

procedure Equation;

begin
  with Form1.Canvas do
    begin
    Brush.Color:=clWhite;
    Rectangle(0, 0, Form1.Width, Form1.Height);
    TextOut(600, 9, 'X mod ');
    TextOut(672, 9, ' = 0');
    TextOut(1192, 8, Form1.Label3.Caption);
    end;
end;

procedure MainScreen;
begin
  with Form1 do
    begin
      Monster.X:=0;
      Monster.Y:=0;
      Button1.Visible:=True;
      Button1.Enabled:=True;
      Timer1.Enabled:=False;
      Edit1.Enabled:=True;
      Edit1.Visible:=True;
      Equation;
    end;
end;

end.

