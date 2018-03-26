function K = local_gausskernel( sigmaX, N ) 
% 1D Gaussian kernel K with N samples and SD sigmaX
%
% Reference:
% Stark and Abeles, JNM 2009

x = -( N - 1 ) / 2 : ( N - 1 ) / 2;
K = 1 / ( 2 * pi * sigmaX ) * exp( -( x.^2 / 2 / sigmaX^2 ) );
return