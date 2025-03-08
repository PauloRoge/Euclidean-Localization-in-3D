function musicpseudospectrum = music(Y, Mx, Mz, elevation, d_x, d_z, lambda, snapshots, ...
    x_grid, y_grid, z_grid)
    
    R = (Y * Y') / snapshots; % matriz de covariância
    [eigenvectors, eigenvalues] = eig(R); % decomposição espectral (autovetores e autovalores)
    estimated_sources = 1;
    [~, i] = sort(diag(eigenvalues), 'descend'); % seleciona subespaço de ruido
    eigenvectors = eigenvectors(:, i);
    Vn = eigenvectors(:, estimated_sources+1:end);
    
    % computa Pmusic(x,y,z)
    Pmusic = zeros(length(x_grid), length(y_grid), length(z_grid));
    
    % Loop sobre a grade de busca (x, y, z)
    for i = 1:length(x_grid)
        for j = 1:length(y_grid)
            for k = 1:length(z_grid)
                x_user = x_grid(i);
                y_user = y_grid(j);
                z_user = z_grid(k);
                
                % usa o steering vector com path loss para projecao
                a = steervec_music(Mx, Mz, elevation, d_x, d_z, lambda, ...
                    x_user, y_user, z_user);
                
                % calcula a funcao MUSIC
                Pmusic(i, j, k) = 1 / (a' * (Vn * Vn') * a);
            end
        end
    end
    
    % Normaliza o espectro MUSIC
    Pmusic = abs(Pmusic) / max(abs(Pmusic(:))); 
    musicpseudospectrum = Pmusic;
end
