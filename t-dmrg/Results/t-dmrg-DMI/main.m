
function main()

% Parametros del sistema
global b0 b1 
S1      = 0.5;
S0      = 0.5;
celdaU  = [1 0];
Nrp     = 100;
% Parametros del modelo
global J Dx Dy Dz 
h_int = 'hDM';
J  = 1;
Dx = 0;
Dy = 0;
Dz = 1;
% Hamiltoniano inicial
global h
Bn = 2;
%==============================
% Domain wall state
% hL = repmat(-Bn,[1,Nrp]);
% hR = repmat(Bn,[1,Nrp]);
% h  = [hL,hR];
%estini = 'DW';
%==============================
% Neel state
%h = repmat([-Bn,Bn],[1,Nrp]);
%estini = 'NE';
%==============================
% Ferromagnetic state
h = repmat(-Bn,[1,2*Nrp]);
estini = 'FE';
%==============================
% Spin glass state (random)
%h = genSpinGlass(Bn,2*Nrp);
%estini = 'SG';
%==============================
% Parametros del DMRG
global Ne 
m_ini = 1; % product state
m     = 60;
Ne    = 1;
% Parametros del t-DMRG
tf = 50;  % tiempo final 
tm = 1;    % cada t=tc se miden observables
dt = 0.05; % paso de tiempo
global dirop
dirop = 'tmp';

clc
fprintf('\n\n')
fprintf('\t\t\t t-DMRG cadena de espines 1/2 con interaccion D-M\n')
fprintf('\t\t\t       E. Solano-Carrillo, Fecha: %s\n\n',date)
fprintf('Parametros usados:\n\n')
fprintf('Hamiltoniano:\n J = %d, Dx = %d, Dy = %d, Dz = %d\n',J,Dx,Dy,Dz)
fprintf('Estado inicial:\n %s\n',estini)
fprintf('Tamanho de la cadena:\n L = %d sitios\n',numel(celdaU)*Nrp)
fprintf('Numero de autoestados de rho a retener:\n m = %d\n',m)
fprintf('Tiempo final:\n tf = %d\n',tf)
fprintf('Paso de tiempo:\n dt = %.3f\n',dt)
fprintf('Se miden observables cada:\n tm = %d\n',tm)
fprintf('\n')
% Sitios b0 y b1 iniciales
[Sz1 Sp1] = matrices_spin(S1); d1 = 2*S1+1;
[Sz0 Sp0] = matrices_spin(S0); d0 = 2*S0+1;
b1 = bloque(1,d1,zeros(d1),Sp1,Sz1,eye(d1));
b0 = bloque(1,d0,zeros(d0),Sp0,Sz0,eye(d0));

[Bl,Br,d,Phi] = gsdmrg(S0,S1,celdaU,Nrp,m_ini,'h_ini');
%E = vesperadoE(Phi,Bl,Br,h_int,repmat(d1,[1,2*Nrp]));

% No se necesitan mas operadores de bloques -> construir bloques simples
for l = 1:length(Bl)
    Bl{l} = bloque_simple(Bl{l}.l, Bl{l}.dim, Bl{l}.O);
    Br{l} = bloque_simple(Br{l}.l, Br{l}.dim, Br{l}.O);
end

% Empezar evolucion temporal
fsave = strcat('D',int2str(Dx),int2str(Dy),int2str(Dz),estini);
tdmrg(Phi,h_int,Bl,Br,d,m,tf,tm,dt,fsave)
