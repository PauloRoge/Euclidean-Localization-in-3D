function steeringvector = steervec_music(Mx, Mz, elevation, d_x, d_z, lambda, ...
    x_user, y_user, z_user)

    % define as posicoes das antenas no URA (Plano xz) com deslocamento
    x_positions = (0:Mx-1) * d_x;  % posicoes das antenas no eixo x
    z_positions = (0:Mz-1) * d_z + elevation;  % Posicoes das antenas elevadas no eixo z

    % inicializa o vetor de resposta
    steeringvector = zeros(Mx * Mz, 1); 

    % calcula a distancia euclidiana e aplica Path Loss
    index = 1;
    for i = 1:Mx
        for j = 1:Mz
            % distancia euclidiana entre a antena (i,j) e o usuário
            d_ij = sqrt((x_user - x_positions(i))^2 + y_user^2 + (z_user - z_positions(j))^2);

            % modelo do steering Vector com Path Loss e Defasagem
            steeringvector(index) = exp(-1i * (2 * pi / lambda) * d_ij);
            
            index = index + 1;
        end
    end
end
