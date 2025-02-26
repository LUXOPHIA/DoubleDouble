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

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TQDouble

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

     Tmp[0]  := X_.hi  * Y_.hi;
     Tmp[1]  := X_.hi  * Y_.me1;
     Tmp[2]  := X_.hi  * Y_.me2;
     Tmp[3]  := X_.hi  * Y_.lo;
     Tmp[4]  := X_.me1 * Y_.hi;
     Tmp[5]  := X_.me1 * Y_.me1;
     Tmp[6]  := X_.me1 * Y_.me2;
     Tmp[7]  := X_.me1 * Y_.lo;
     Tmp[8]  := X_.me2 * Y_.hi;
     Tmp[9]  := X_.me2 * Y_.me1;
     Tmp[10] := X_.me2 * Y_.me2;
     Tmp[11] := X_.me2 * Y_.lo;
     Tmp[12] := X_.lo  * Y_.hi;
     Tmp[13] := X_.lo  * Y_.me1;
     Tmp[14] := X_.lo  * Y_.me2;
     Tmp[15] := X_.lo  * Y_.lo;

     Result := Normalize4( Tmp );
end;

//------------------------------------------------------------------------------
//  除算 4項 ÷ 4項 : Newton法で 1/Y_ を計算 → 乗算
//------------------------------------------------------------------------------
class function TQDouble.DivQD( const X_,Y_:TQDouble ) :TQDouble;
var
   Z, Diff :TQDouble;
   I :Integer;
begin
     // Y_==0 のチェック
     if ( Double(Y_) = 0 ) then raise Exception.Create( 'TQDouble.DivQD: divide by zero' );

     // 1 / Y_ の初期近似 : double値で
     Z := TQDouble( 1.0 / Double(Y_) );

     // 2～3回の反復でQuadDouble精度に
     for I := 1 to 2 do
     begin
          Diff := TQDouble(1.0) - ( Y_ * Z ); // (1 - Y_*Z)
          Z := Z + ( Z * Diff );             // Z += Z*(1 - Y_*Z)
     end;

     // X_ * (1/Y_)
     Result := X_ * Z;  // => MulQD => Normalize4
end;

//------------------------------------------------------------------------------
//  Normalize4 : 与えられた配列 (最大8項や16項など) を 4項に圧縮
//    1) 絶対値の大きい順にソート
//    2) Left-to-right で 2Sum を繰り返し "expansion sum"
//    3) 得られた拡張を最終的に4つの要素にまとめる
//------------------------------------------------------------------------------
class function TQDouble.Normalize4( const Arr_:array of Double ) :TQDouble;
var
   Buf :array of Double;
   N :Integer;
   i, j :Integer;
   S, E :Double;
   Comps :array[0..3] of Double;
   LenC :Integer;
begin
     N := Length( Arr_ );
     SetLength( Buf, N );

     //--- 1) 配列をコピー ---
     for i := 0 to N-1 do Buf[i] := Arr_[i];

     //--- 2) 絶対値の大きい順にソート ---
     for i := 0 to N-2 do
     begin
          for j := i+1 to N-1 do
          begin
               if Abs( Buf[j] ) > Abs( Buf[i] ) then
               begin
                    var tmp := Buf[i];
                    Buf[i] := Buf[j];
                    Buf[j] := tmp;
               end;
          end;
     end;

     //--- 3) Left-to-right で展開加算 (Shewchukの GrowExpansionに類似) ---
     //     Comps[] に最大4項まで蓄積
     Comps[0] := Buf[0];
     Comps[1] := 0.0;
     Comps[2] := 0.0;
     Comps[3] := 0.0;
     LenC := 1; // 現在何項あるか

     for i := 1 to N-1 do
     begin
          var x := Buf[i];
          // x を Comps[] に加算
          // ここでは(Compsと x)を 2Sum しながら順に繰り込む
          var newComps :array of Double;
          SetLength( newComps, LenC+1 );

          // Q に x を代入して、comps[i] と 2Sum
          var Q := x;
          for j := 0 to LenC-1 do
          begin
               // TQDouble互換: 2Sum( comps[j], Q, S, E )
               S := Comps[j] + Q;
               E := Q - ( S - Comps[j] );
               Q := E;
               newComps[j] := S;
          end;
          // 最後に Q を追加
          newComps[LenC] := Q;

          // newComps が (LenC+1)項になった
          // ただし 4項を超えるなら切り詰める
          if LenC < 4 then Inc( LenC ); // 項数増加(最大4)
          // 再格納
          for j := 0 to LenC-1 do Comps[j] := newComps[j];
     end;

     //--- 4) Comps に最大4項の展開が入ったはず
     //        => hi, me1, me2, lo に順に格納
     //        （絶対的に大きい順に並んでいるわけではないが、
     //          nonoverlappingをできるだけ保持）
     Result.hi  := Comps[0];
     if LenC>1 then Result.me1 := Comps[1] else Result.me1 := 0;
     if LenC>2 then Result.me2 := Comps[2] else Result.me2 := 0;
     if LenC>3 then Result.lo  := Comps[3] else Result.lo  := 0;
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
                  else Result := +X_;
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
     for I := 1 to 2 do G := G - ( Pow2( G ) - X_ ) / ( 2 * G );
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
          Result := 1;
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

     if NegP then R := 1 / R;

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

     Result := ( DA + Sum ) * 0.5;
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
