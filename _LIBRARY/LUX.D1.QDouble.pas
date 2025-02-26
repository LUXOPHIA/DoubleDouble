unit LUX.D1.QDouble;

interface //#################################################################### ■

uses System.SysUtils, System.Math;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TQDouble

     TQDouble = record
     private
       hi  :Double;
       me1 :Double;
       me2 :Double;
       lo  :Double;
       ///// M E T H O D
       class function AddQD( const X_,Y_:TQDouble ) :TQDouble; static;
       class function SubQD( const X_,Y_:TQDouble ) :TQDouble; static;
       class function MulQD( const X_,Y_:TQDouble ) :TQDouble; static;
       class function DivQD( const X_,Y_:TQDouble ) :TQDouble; static;
       class function Normalize4( const Arr_:array of Double ) :TQDouble; static;
     public
       ///// O P E R A T O R
       class operator Negative( const X_:TQDouble ) :TQDouble;
       class operator Positive( const X_:TQDouble ) :TQDouble;
       class operator Add( const X_,Y_:TQDouble ) :TQDouble;
       class operator Subtract( const X_,Y_:TQDouble ) :TQDouble;
       class operator Multiply( const X_,Y_:TQDouble ) :TQDouble;
       class operator Divide( const X_,Y_:TQDouble ) :TQDouble;
       ///// C A S T
       class operator Implicit( A_:Double ) :TQDouble;
       class operator Explicit( X_:TQDouble ) :Double;
       ///// M E T H O D
       function ToString :String;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Abso( const X_:TQDouble ) :TQDouble; overload;
function Pow2( const X_:TQDouble ) :TQDouble; overload;
function Roo2( const X_:TQDouble ) :TQDouble; overload;
function Power( const Base_:TQDouble; const Expon_:Integer ) :TQDouble; overload;
function Exp( const X_:TQDouble ) :TQDouble; overload;
function Ln( const X_:TQDouble ) :TQDouble; overload;
function Sin( const X_:TQDouble ) :TQDouble; overload;
function Cos( const X_:TQDouble ) :TQDouble; overload;

implementation //############################################################### ■

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDDouble

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////////// M E T H O D

class function TQDouble.AddQD( const X_,Y_:TQDouble ) :TQDouble;
var
   Tmp :array[ 0..7 ] of Double;
begin
     Tmp[0] := X_.hi;   Tmp[1] := X_.me1;  Tmp[2] := X_.me2;  Tmp[3] := X_.lo;
     Tmp[4] := Y_.hi;   Tmp[5] := Y_.me1;  Tmp[6] := Y_.me2;  Tmp[7] := Y_.lo;

     Result := Normalize4( Tmp );
end;

class function TQDouble.SubQD( const X_,Y_:TQDouble ) :TQDouble;
begin
     Result := AddQD( X_, -Y_ );
end;

class function TQDouble.MulQD( const X_,Y_:TQDouble ) :TQDouble;
var
   Tmp :array[ 0..15 ] of Double;
   I :Integer;
begin
     for I := 0 to 15 do Tmp[I] := 0.0;

     Tmp[0] := X_.hi * Y_.hi;

     Result := Normalize4( Tmp );
end;

class function TQDouble.DivQD( const X_,Y_:TQDouble ) :TQDouble;
var
   XD, YD :Double;
begin
     XD := Double( X_ );
     YD := Double( Y_ );

     if ( YD = 0 ) then raise Exception.Create( 'TQDouble.DivQD: divide by zero' );

     Result := TQDouble( XD / YD );
end;

class function TQDouble.Normalize4( const Arr_:array of Double ) :TQDouble;
var
   S :Double;
   I :Integer;
begin
     S := 0;
     for I := 0 to High( Arr_ ) do S := S + Arr_[I];

     Result.hi  := S;
     Result.me1 := 0;
     Result.me2 := 0;
     Result.lo  := 0;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TQDouble.Negative( const X_:TQDouble ) :TQDouble;
begin
     Result.hi  := -X_.hi ;
     Result.me1 := -X_.me1;
     Result.me2 := -X_.me2;
     Result.lo  := -X_.lo ;
end;

class operator TQDouble.Positive( const X_:TQDouble ) :TQDouble;
begin
     Result := X_;
end;

class operator TQDouble.Add( const X_,Y_:TQDouble ) :TQDouble;
begin
     Result := AddQD( X_, Y_ );
end;

class operator TQDouble.Subtract( const X_,Y_:TQDouble ) :TQDouble;
begin
     Result := SubQD( X_, Y_ );
end;

class operator TQDouble.Multiply( const X_,Y_:TQDouble ) :TQDouble;
begin
     Result := MulQD( X_, Y_ );
end;

class operator TQDouble.Divide( const X_,Y_:TQDouble ) :TQDouble;
begin
     Result := DivQD( X_, Y_ );
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TQDouble.Implicit( A_:Double ) :TQDouble;
begin
     Result.hi  := A_;
     Result.me1 := 0 ;
     Result.me2 := 0 ;
     Result.lo  := 0 ;
end;

class operator TQDouble.Explicit( X_:TQDouble ) :Double;
begin
     Result := X_.hi + X_.me1 + X_.me2 + X_.lo;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TQDouble.ToString :String;
begin
     Result := Format( '%0.60g', [ Double(Self) ] );
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Abso( const X_:TQDouble ) :TQDouble;
begin
     if X_.hi < 0 then Result := -X_
                  else Result := X_;
end;

function Pow2( const X_:TQDouble ) :TQDouble;
begin
     Result := X_ * X_;
end;

function Roo2( const X_:TQDouble ) :TQDouble;
var
   D :Double;
   G :TQDouble;
   I :Integer;
begin
     D := Double( X_ );
     if D <= 0 then
     begin
          Result := 0;  Exit;
     end;

     G := TQDouble( Sqrt( D ) );
     for I := 1 to 2 do G := G - ( Pow2( G ) - X_ ) / ( TQDouble( 2.0 ) * G );
     Result := G;
end;

function Power( const Base_:TQDouble; const Expon_:Integer ) :TQDouble;
var
   E :Integer;
   B, R :TQDouble;
   NegP :Boolean;
begin
     if Expon_ = 0 then
     begin
          Result := TQDouble( 1.0 );
          Exit;
     end;

     E    := Abs( Expon_ );
     NegP := ( Expon_ < 0 );
     B    := Base_;
     R    := 1;

     while E > 0 do
     begin
          if ( E and 1 ) = 1 then R := R * B;
          B := B * B;
          E := E shr 1;
     end;

     if NegP then R := TQDouble( 1.0 ) / R;

     Result := R;
end;

function Exp( const X_:TQDouble ) :TQDouble;
var
   D :Double;
   DA :TQDouble;
   Sum, Term, XQD :TQDouble;
   K :Integer;
begin
     D  := Double( X_ );
     DA := TQDouble( Exp( D ) );

     Sum  := 1;
     Term := 1;
     XQD  := X_;
     for K := 1 to 6 do
     begin
          Term := Term * XQD / TQDouble( K );
          Sum := Sum + Term;
     end;

     Result := ( DA + Sum ) * TQDouble( 0.5 );
end;

function Ln( const X_:TQDouble ) :TQDouble;
var
   Y, Diff :TQDouble;
   I :Integer;
begin
     if X_.hi <= 0 then raise Exception.Create( 'TQD_Ln: argument <= 0' );

     Y := TQDouble( Ln( Double(X_) ) );
     for I := 1 to 2 do
     begin
          Diff := X_ - Exp( Y );
          Y := Y + Diff / Exp( Y );
     end;
     Result := Y;
end;

function Sin( const X_:TQDouble ) :TQDouble;
var
   Sum, Term, XSq :TQDouble;
   Sign :Integer;
   K :Integer;
begin
     Term := X_;
     Sum  := Term;
     Sign := -1;
     XSq  := X_ * X_;
     for K := 1 to 6 do
     begin
          Term := Term * XSq / TQDouble( (2*K)*(2*K+1) );
          if Sign > 0 then Sum := Sum + Term
                      else Sum := Sum - Term;
          Sign := -Sign;
     end;
     Result := Sum;
end;

function Cos( const X_:TQDouble ) :TQDouble;
var
   Sum, Term, XSq :TQDouble;
   Sign :Integer;
   K :Integer;
begin
     Term := 1;
     Sum  := Term;
     Sign := -1;
     XSq  := X_ * X_;
     for K := 1 to 6 do
     begin
          Term := Term * XSq / TQDouble( (2*K-1)*(2*K) );
          if Sign > 0 then Sum := Sum + Term
                      else Sum := Sum - Term;
          Sign := -Sign;
     end;
     Result := Sum;
end;

end. //######################################################################### ■
