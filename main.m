close all; clear; clc;

% arquitetura URA
Mx = 8; % numeros de antenas eixo x
Mz = 8; % numeros de antenas eixo y
M = Mx * Mz; % numero total de antenas
    
% parametros
freq = 15 * 10^9;             % gigahertz (mmWave)
lambda = (3 * 10^8) / freq;   % comprimento de onda
d_x = lambda / 2;             % espaçamento entre antenas no eixo x
d_z = lambda / 2;             % espaçamento entre antenas no eixo z
snapshots = 200;              % número de amostras temporais
power = 0.1;                  % potencia transmitida (W)
noisepowerdBm = -90;          % potencia de ruido (dBm)
alpha = 1;                    % expoente do path loss (free-space)

elevation = 30; % altura fixa da URA
user = [10, 30, 5];  % usuário 1 (x, y, z)

% definir grade de busca para MUSIC
x_grid = -100:1:100;  % varredura da posição x
y_grid = 1.5:1:60;    % varredura da posição y
z_grid = 0:1:50;      % varredura da posição z



% gerar sinais recebidos no URA
Y = signals(Mx, Mz, elevation, snapshots, d_x, d_z, lambda, ...
    user, alpha, power, noisepowerdBm);

% computação do Pmusic em 3D
Pmusic = music(Y, Mx, Mz, elevation, d_x, d_z, lambda, snapshots, ...
    x_grid, y_grid, z_grid);

% indices para os cortes na altura (z) e profundidade (y) do usuário
[~, idx_z] = min(abs(z_grid - user(3))); % corte no plano z = usuário
[~, idx_y] = min(abs(y_grid - user(2))); % corte no plano y = usuário

% criando figura com dois subplots
figure;

% subplot 1: plano xy (corte em z = user)
subplot(1, 2, 1);
imagesc(x_grid, y_grid, 10 * log10(Pmusic(:,:,idx_z).')); % exibe corte no plano xy
axis square;
colorbar;
xlabel('Posição X (m)');
ylabel('Posição Y (m)');
title(['Pseudo-Espectro MUSIC - XY (z = ', num2str(z_grid(idx_z)), ' m)']);
grid on;

% subplot 2: plano xz (corte em y = user)
subplot(1, 2, 2);
imagesc(x_grid, z_grid, 10 * log10(squeeze(Pmusic(:,idx_y,:)).')); % exibe corte no plano xz
axis square;
colorbar;
xlabel('Posição X (m)');
ylabel('Posição Z (m)');
title(['Pseudo-Espectro MUSIC - XZ (y = ', num2str(y_grid(idx_y)), ' m)']);
grid on;
