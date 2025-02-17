﻿unit LUX.D3.Diff;

interface //#################################################################### ■

uses LUX,
     LUX.D3,
     LUX.D1.Diff;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble3D

     TdDouble3D = record
     private
       ///// A C C E S S O R
       function Geto :TDouble3D;
       procedure Seto( const o_:TDouble3D );
       function Getd :TDouble3D;
       procedure Setd( const d_:TDouble3D );
     public
       X :TdDouble;
       Y :TdDouble;
       Z :TdDouble;
       /////
       constructor Create( const X_,Y_,Z_:TdDouble ); overload;
       constructor Create( const o_,d_:TDouble3D ); overload;
       ///// P R O P E R T Y
       property o :TDouble3D read Geto write Seto;
       property d :TDouble3D read Getd write Setd;
       ///// O P E R A T O R
       class operator Positive( const V_:TdDouble3D ) :TdDouble3D;
       class operator Negative( const V_:TdDouble3D ) :TdDouble3D;
       class operator Add( const A_,B_:TdDouble3D ) :TdDouble3D;
       class operator Subtract( const A_,B_:TdDouble3D ) :TdDouble3D;
       class operator Multiply( const A_:TdDouble; const B_:TdDouble3D ) :TdDouble3D;
       class operator Multiply( const A_:TdDouble3D; const B_:TdDouble ) :TdDouble3D;
       class operator Divide( const A_:TdDouble3D; const B_:TdDouble ) :TdDouble3D;
       ///// C A S T
       class operator Implicit( const V_:Integer ) :TdDouble3D;
       class operator Implicit( const V_:Int64 ) :TdDouble3D;
       class operator Implicit( const V_:Double ) :TdDouble3D;
       class operator Implicit( const V_:TdDouble ) :TdDouble3D;
     end;

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

implementation //############################################################### ■

uses System.Math;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TdDouble3D

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////// A C C E S S O R

function TdDouble3D.Geto :TDouble3D;
begin
     Result.X := X.o;
     Result.Y := Y.o;
     Result.Z := Z.o;
end;

procedure TdDouble3D.Seto( const o_:TDouble3D );
begin
     X.o := o_.X;
     Y.o := o_.Y;
     Z.o := o_.Z;
end;

function TdDouble3D.Getd :TDouble3D;
begin
     Result.X := X.d;
     Result.Y := Y.d;
     Result.Z := Z.d;
end;

procedure TdDouble3D.Setd( const d_:TDouble3D );
begin
     X.d := d_.X;
     Y.d := d_.Y;
     Z.d := d_.Z;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

constructor TdDouble3D.Create( const X_,Y_,Z_:TdDouble );
begin
     X := X_;
     Y := Y_;
     Z := Z_;
end;

constructor TdDouble3D.Create( const o_,d_:TDouble3D );
begin
     o := o_;
     d := d_;
end;

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TdDouble3D.Positive( const V_:TdDouble3D ) :TdDouble3D;
begin
     Result.o := +V_.o;
     Result.d := +V_.d;
end;

class operator TdDouble3D.Negative( const V_:TdDouble3D ) :TdDouble3D;
begin
     Result.o := -V_.o;
     Result.d := -V_.d;
end;

class operator TdDouble3D.Add( const A_,B_:TdDouble3D ) :TdDouble3D;
begin
     Result.o := A_.o + B_.o;
     Result.d := A_.d + B_.d;
end;

class operator TdDouble3D.Subtract( const A_,B_:TdDouble3D ) :TdDouble3D;
begin
     Result.o := A_.o - B_.o;
     Result.d := A_.d - B_.d;
end;

class operator TdDouble3D.Multiply( const A_:TdDouble; const B_:TdDouble3D ) :TdDouble3D;
begin
     Result.X := A_ * B_.X;
     Result.Y := A_ * B_.Y;
     Result.Z := A_ * B_.Z;
end;

class operator TdDouble3D.Multiply( const A_:TdDouble3D; const B_:TdDouble ) :TdDouble3D;
begin
     Result.X := A_.X * B_;
     Result.Y := A_.Y * B_;
     Result.Z := A_.Z * B_;
end;

class operator TdDouble3D.Divide( const A_:TdDouble3D; const B_:TdDouble ) :TdDouble3D;
begin
     Result.X := A_.X / B_;
     Result.Y := A_.Y / B_;
     Result.Z := A_.Z / B_;
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TdDouble3D.Implicit( const V_:Integer ) :TdDouble3D;
begin
     Result.o := V_;
     Result.d := 0;
end;

class operator TdDouble3D.Implicit( const V_:Int64 ) :TdDouble3D;
begin
     Result.o := V_;
     Result.d := 0;
end;

class operator TdDouble3D.Implicit( const V_:Double ) :TdDouble3D;
begin
     Result.o := V_;
     Result.d := 0;
end;

class operator TdDouble3D.Implicit( const V_:TdDouble ) :TdDouble3D;
begin
     Result.o := V_.o;
     Result.d := V_.d;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 C L A S S 】

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

end. //######################################################################### ■
