unit LUX.D1.DDouble;

interface //#################################################################### ■

uses System.SysUtils, System.Math;

type //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 T Y P E 】

     //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R E C O R D 】

     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDDouble

     TDDouble = record
     private
       hi :Double;
       lo :Double;
       ///// M E T H O D
       class procedure TwoSum( const A_,B_:Double; out S_,E_:Double ); static;
       class procedure TwoProd( const A_,B_:Double; out P_,E_:Double ); static;
       class function Split( const A_:Double ) :TArray<Double>; static;
       class function AddDD( const X_,Y_:TDDouble ) :TDDouble; static;
       class function SubDD( const X_,Y_:TDDouble ) :TDDouble; static;
       class function MulDD( const X_,Y_:TDDouble ) :TDDouble; static;
       class function DivDD( const X_,Y_:TDDouble ) :TDDouble; static;
       class function Normalize2( const A_,B_:Double ) :TDDouble; static;
     public
       ///// O P E R A T O R
       class operator Negative( const X_:TDDouble ) :TDDouble;
       class operator Positive( const X_:TDDouble ) :TDDouble;
       class operator Add( const X_,Y_:TDDouble ) :TDDouble;
       class operator Subtract( const X_,Y_:TDDouble ) :TDDouble;
       class operator Multiply( const X_,Y_:TDDouble ) :TDDouble;
       class operator Divide( const X_,Y_:TDDouble ) :TDDouble;
       class operator Equal( const X_,Y_:TDDouble ) :Boolean;
       class operator NotEqual( const X_,Y_:TDDouble ) :Boolean;
       class operator GreaterThan( const X_,Y_:TDDouble ) :Boolean;
       class operator LessThan( const X_,Y_:TDDouble ) :Boolean;
       class operator GreaterThanOrEqual( const X_,Y_:TDDouble ) :Boolean;
       class operator LessThanOrEqual( const X_,Y_:TDDouble ) :Boolean;
       ///// C A S T
       class operator Implicit( A_:Double ) :TDDouble;
       class operator Explicit( X_:TDDouble ) :Double;
       ///// M E T H O D
       function ToString :String;
       class function Parse( const S_:String ) :TDDouble; static;
     end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Abso( const X_:TDDouble ) :TDDouble; overload;
function Pow2( const X_:TDDouble ) :TDDouble; overload;
function Roo2( const X_:TDDouble ) :TDDouble; overload;
function Power( const Base_:TDDouble; const Expon_:Integer ) :TDDouble; overload;
function Exp( const X_:TDDouble ) :TDDouble; overload;
function Ln( const X_:TDDouble ) :TDDouble; overload;
function Sin( const X_:TDDouble ) :TDDouble; overload;
function Cos( const X_:TDDouble ) :TDDouble; overload;

implementation //############################################################### ■

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TDDouble

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& private

//////////////////////////////////////////////////////////////////// M E T H O D

class procedure TDDouble.TwoSum( const A_,B_:Double; out S_,E_:Double );
var
   V :Double;
begin
     S_ := A_ + B_;
     V  := S_ - A_;
     E_ := ( A_ - ( S_ - V ) ) + ( B_ - V );
end;

class procedure TDDouble.TwoProd( const A_,B_:Double; out P_,E_:Double );
var
   SplA, SplB :TArray<Double>;
   Ah, Al,
   Bh, Bl :Double;
begin
     P_ := A_ * B_;

     SplA := Split( A_ );
     SplB := Split( B_ );
     Ah   := SplA[0];
     Al   := SplA[1];
     Bh   := SplB[0];
     Bl   := SplB[1];

     E_ := ( Ah*Bh - P_ )
         + ( Ah*Bl + Al*Bh )
         + ( Al*Bl );
end;

class function TDDouble.Split( const A_:Double ) :TArray<Double>;
const
     SPLITCONST :Double = 134217729.0; // 2^27 + 1
var
   T, Hi_, Lo_ :Double;
begin
     SetLength( Result, 2 );
     T   := SPLITCONST * A_;
     Hi_ := T - ( T - A_ );
     Lo_ := A_ - Hi_;

     Result[0] := Hi_;
     Result[1] := Lo_;
end;

class function TDDouble.AddDD( const X_,Y_:TDDouble ) :TDDouble;
var
   S, E,
   s2, e2,
   sum2, err2,
   hi1, lo1,
   hi2, lo2,
   hi3, lo3,
   finalHi, finalLo :Double;
begin
     TwoSum( X_.hi, Y_.hi, S, E );
     TwoSum( X_.lo, Y_.lo, s2, e2 );
     TwoSum( s2, E, sum2, err2 );

     TwoSum( S, sum2, hi1, lo1 );
     TwoSum( lo1, err2, hi2, lo2 );
     TwoSum( hi2, e2, hi3, lo3 );

     TwoSum( (hi1 + hi3), (lo2 + lo3), finalHi, finalLo );

     Result.hi := finalHi;
     Result.lo := finalLo;
end;
//==============================================================================

class function TDDouble.SubDD( const X_,Y_:TDDouble ) :TDDouble;
begin
     Result := AddDD( X_, -Y_ );
end;

class function TDDouble.MulDD( const X_,Y_:TDDouble ) :TDDouble;
var
   p1, p2, cross1, cross2, cross3 :Double;
   temp :array[0..3] of Double;
begin
     // 1) X_.hi * Y_.hi
     TwoProd( X_.hi, Y_.hi, p1, p2 );

     // 2) クロス項
     cross1 := X_.hi * Y_.lo;
     cross2 := X_.lo * Y_.hi;
     cross3 := X_.lo * Y_.lo;

     // 3) 全部を一気に配列化 (p1, p2, cross1+cross2, cross3)
     temp[0] := p1;                       // 最も大きい可能性大
     temp[1] := p2;
     temp[2] := ( cross1 + cross2 );
     temp[3] := cross3;

     // 4) 4項をAddDDと同様の手順でまとめる (ローカルな4項→2項正規化)
     //    => Shewchuk式にするとより厳密
     Result := TDDouble(0);
     // 順次AddDDするか、2Sum展開でまとめる
     // ここでは段階的AddDDで実装例

     Result := AddDD( Result, TDDouble( temp[0] ) );
     Result := AddDD( Result, TDDouble( temp[1] ) );
     Result := AddDD( Result, TDDouble( temp[2] ) );
     Result := AddDD( Result, TDDouble( temp[3] ) );
end;

class function TDDouble.DivDD( const X_,Y_:TDDouble ) :TDDouble;
var
   Z, Diff :TDDouble;
   I :Integer;
begin
     if ( ( Y_.hi = 0 ) and ( Y_.lo = 0 ) ) then raise Exception.Create( 'TDDouble.DivDD: divide by zero' );

     Z := TDDouble( 1 / Double(Y_) );

     for I := 1 to 2 do
     begin
          Diff := 1 - ( Y_ * Z );
          Z := Z + ( Z * Diff );
     end;
     Result := X_ * Z;
end;

class function TDDouble.Normalize2( const A_,B_:Double ) :TDDouble;
var
   S, E :Double;
begin
     TwoSum( A_, B_, S, E );
     Result.hi := S;
     Result.lo := E;
end;

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& public

//////////////////////////////////////////////////////////////// O P E R A T O R

class operator TDDouble.Negative( const X_:TDDouble ) :TDDouble;
begin
     Result.hi := -X_.hi;
     Result.lo := -X_.lo;
end;

class operator TDDouble.Positive( const X_:TDDouble ) :TDDouble;
begin
     Result := X_;
end;

class operator TDDouble.Add( const X_,Y_:TDDouble ) :TDDouble;
begin
     Result := AddDD( X_, Y_ );
end;

class operator TDDouble.Subtract( const X_,Y_:TDDouble ) :TDDouble;
begin
     Result := SubDD( X_, Y_ );
end;

class operator TDDouble.Multiply( const X_,Y_:TDDouble ) :TDDouble;
begin
     Result := MulDD( X_, Y_ );
end;

class operator TDDouble.Divide( const X_,Y_:TDDouble ) :TDDouble;
begin
     Result := DivDD( X_, Y_ );
end;

class operator TDDouble.Equal( const X_,Y_:TDDouble ) :Boolean;
begin
     Result := ( Double(X_) = Double(Y_) );
end;

class operator TDDouble.NotEqual( const X_,Y_:TDDouble ) :Boolean;
begin
     Result := not ( X_ = Y_ );
end;

class operator TDDouble.GreaterThan( const X_,Y_:TDDouble ) :Boolean;
begin
     Result := ( Double(X_) > Double(Y_) );
end;

class operator TDDouble.LessThan( const X_,Y_:TDDouble ) :Boolean;
begin
     Result := ( Double(X_) < Double(Y_) );
end;

class operator TDDouble.GreaterThanOrEqual( const X_,Y_:TDDouble ) :Boolean;
begin
     Result := not ( X_ < Y_ );
end;

class operator TDDouble.LessThanOrEqual( const X_,Y_:TDDouble ) :Boolean;
begin
     Result := not ( X_ > Y_ );
end;

//////////////////////////////////////////////////////////////////////// C A S T

class operator TDDouble.Implicit( A_:Double ) :TDDouble;
begin
     Result.hi := A_;
     Result.lo := 0 ;
end;

class operator TDDouble.Explicit( X_:TDDouble ) :Double;
begin
     Result := X_.hi + X_.lo;
end;

//////////////////////////////////////////////////////////////////// M E T H O D

function TDDouble.ToString :String;
begin
     Result := Format( '%0.30g', [ Double(Self) ] );
end;

class function TDDouble.Parse( const S_:String ) :TDDouble;
var
     D :Double;
begin
     D := StrToFloat( S_ );
     Result := D;
end;

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$【 R O U T I N E 】

function Abso( const X_:TDDouble ) :TDDouble;
begin
     if X_.hi < 0 then Result := -X_
                  else Result := +X_;
end;

function Pow2( const X_:TDDouble ) :TDDouble;
begin
     Result := X_ * X_;
end;

function Roo2( const X_:TDDouble ) :TDDouble;
var
   R :TDDouble;
   I :Integer;
   Two :TDDouble;
begin
     if ( X_.hi <= 0 ) then
     begin
          Result := 0;  Exit;
     end;

     R := TDDouble( Sqrt( Double(X_) ) );
     Two := 2;

     for I := 1 to 2 do R := R - ( Pow2( R ) - X_ ) / ( Two * R );
     Result := R;
end;

function Power( const Base_:TDDouble; const Expon_:Integer ) :TDDouble;
var
   E :Integer;
   B, Res :TDDouble;
   NegP :Boolean;
begin
     if Expon_ = 0 then
     begin
          Result := 1;  Exit;
     end;

     E    := Abs( Expon_ );
     NegP := ( Expon_ < 0 );
     B    := Base_;
     Res  := 1;

     while E > 0 do
     begin
          if ( E and 1 ) = 1 then Res := Res * B;
          B := B * B;
          E := E shr 1;
     end;

     if NegP then Res := 1 / Res;

     Result := Res;
end;

function Exp( const X_:TDDouble ) :TDDouble;
var
   Xd :Double;
   S :Double;
   Sum, Term, XDD :TDDouble;
   K :Integer;
begin
     Xd := Double( X_ );
     S  := Exp( Xd );
     Result := TDDouble( S );

     Sum  := 1;
     Term := 1;
     XDD  := X_;
     for K := 1 to 6 do
     begin
          Term := Term * XDD / TDDouble( K );
          Sum := Sum + Term;
     end;
     Result := ( Result + Sum ) * 0.5;
end;

function Ln( const X_:TDDouble ) :TDDouble;
var
   Y, Diff :TDDouble;
   I :Integer;
begin
     if X_.hi <= 0 then raise Exception.Create( 'TDD_Ln: argument <= 0' );

     Y := TDDouble( Ln( Double(X_) ) );
     for I := 1 to 2 do
     begin
          Diff := X_ - Exp( Y );
          Y := Y + Diff / Exp( Y );
     end;
     Result := Y;
end;

function Sin( const X_:TDDouble ) :TDDouble;
var
   Sum, Term, XSq :TDDouble;
   Sign :Integer;
   K :Integer;
begin
     Term := X_;
     Sum  := Term;
     Sign := -1;
     XSq  := X_ * X_;
     for K := 1 to 6 do
     begin
          Term := Term * XSq / TDDouble( (2*K)*(2*K+1) );
          if Sign > 0 then Sum := Sum + Term
                      else Sum := Sum - Term;
          Sign := -Sign;
     end;
     Result := Sum;
end;

function Cos( const X_:TDDouble ) :TDDouble;
var
   Sum, Term, XSq :TDDouble;
   Sign :Integer;
   K :Integer;
begin
     Term := 1;
     Sum  := Term;
     Sign := -1;
     XSq  := X_ * X_;
     for K := 1 to 6 do
     begin
          Term := Term * XSq / TDDouble( (2*K-1)*(2*K) );
          if Sign > 0 then Sum := Sum + Term
                      else Sum := Sum - Term;
          Sign := -Sign;
     end;
     Result := Sum;
end;

end. //######################################################################### ■
