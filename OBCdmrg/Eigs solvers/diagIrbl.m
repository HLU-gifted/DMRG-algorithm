
function [Phi,E] = diagIrbl(varargin)

global Ne

Ble   = varargin{1};
Bre   = varargin{2};
h_int = varargin{3};

% Opciones para IRBLEIGS
opts.k      = Ne;
opts.funpar = {Ble,Bre,h_int};
opts.nbls   = 5;
opts.maxit  = 200;
opts.blsz   = 1;
opts.sigma  = 'se';
opts.tol    = 1e-12;
if nargin == 4
    opts.v0 = varargin{4};
end

% Dimension del superbloque
n = Ble.dim*Bre.dim;

conv = 1; ct = 0;
while conv(1)
    % Diagonalizar 'implicitly restarted block-Lanczos'
    [Phi,E,conv] = irbleigs('Hv',n,opts);
    if conv(1), opts.v0 = Phi(:,1); ct = ct+1; else return, end
    % Si no converge aun, duplicar numero de iteraciones
    if ct > 3
        if opts.maxit > 5000, return, end
        opts.maxit = 2*opts.maxit;
        opts.nbls = 2*opts.nbls;
    end
end
