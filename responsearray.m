%Essa função utiliza a distancia euclidiana exata. Matriz Y mais realista

function steeringvector = responsearray(Mx, Mz, elevation, d_x, d_z, lambda, alpha, ...
    x_user, y_user, z_user)
    
    % Define as posições das antenas no URA (Plano xz) com deslocamento
    x_positions = (0:Mx-1) * d_x;  % Posições das antenas no eixo x
    z_positions = (0:Mz-1) * d_z + elevation;  % Posições das antenas elevadas no eixo z

    % Inicializa o vetor de resposta
    steeringvector = zeros(Mx * Mz, 1); 
    
    % Constante de path loss (Upsilon) com expoente de perda
    Upsilon = (lambda / (4 * pi))^alpha;

    %Calcula a distância euclidiana e aplica Path Loss
    index = 1;
    for i = 1:Mx
        for j = 1:Mz
            % Distância euclidiana entre a antena (i,j) e o usuário (x_user, y_user, z_user)
            d_ij = sqrt((x_user - x_positions(i))^2 + y_user^2 + (z_user - z_positions(j))^2);
            
            % Path loss modelado diretamente no steering vector
            g = Upsilon * (1/d_ij)^alpha;
            steeringvector(index) = g * [exp(-1i * (2 * pi / lambda) * d_ij)];
            
            index = index + 1;
        end
    end
end
