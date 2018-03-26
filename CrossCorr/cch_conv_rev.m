function [pred] = cch_conv_rev(CCH, W)
% Reference:
% Stark and Abeles, JNM 2009
%
% modified code written by Stark and Abeles for LFP data

% Step 1: Input Parameters
[m,~] = size( CCH );
if m == 1
    CCH = CCH'; 
else
end

HF = 0.6;

% Step 2: Prepare the Gaussian Convolution Window
SDG = W / 2;
if round( SDG ) == SDG % even W
  win = local_gausskernel( SDG, 6 * SDG + 1 );
  cidx = SDG * 3 + 1;
else
  win = local_gausskernel( SDG, 6 * SDG + 2 ); 
  cidx = SDG * 3 + 1.5; 
end
    
win( cidx ) = win( cidx ) * ( 1 - HF );
win = win / sum( win );      

% Step 3: Compute a predictor by convolving the CCH with the window 
C = length(win);
D = ceil( C / 2 ) - 1;
if length(CCH) < C
    data = [ flipud( CCH( 1 : end, : ) ); CCH; flipud( CCH( abs(end - C + 1) : end, : ) ) ];
else
    data = [ flipud( CCH( 1 : C, : ) ); CCH; flipud( CCH( end - C + 1 : end, : ) ) ];
end
   
Y = filter(win, 1, data);
pred = Y( 1 + C + D : end - C + D, : );

end




