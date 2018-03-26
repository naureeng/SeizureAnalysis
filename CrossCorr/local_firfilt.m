function Y = local_firfilt( x, W ) 
% zero-phase lag low-pass filtering of x's columns with the FIR W
%
% Reference:
% Stark and Abeles, JNM 2009

C = length( W );
D = ceil( C / 2 ) - 1;
data = [ flipud( x( 1 : C, : ) ); x; flipud( x( end - C + 1 : end, : ) ) ];
Y = filter( W, 1, data);
Y = Y( 1 + C + D : end - C + D, : );

end
