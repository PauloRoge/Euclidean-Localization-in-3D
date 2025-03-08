function Y = signals(Mx, Mz, elevation, snapshots, d_x, d_z, lambda, ...
    source_positions, expoentpathloss, transmittedpower, noisepowerdBm)

    % Garante que source_positions tem pelo menos 3 colunas (x, y, z)
    if size(source_positions, 2) < 3
        source_positions = [source_positions, zeros(size(source_positions, 1), ...
            3 - size(source_positions, 2))];
    end

    % Converte a potência do ruído de dBm para Watts
    noisepower = 10^((noisepowerdBm - 30) / 10); 

    % número total de antenas no URA
    M = Mx * Mz;

    % inicializa matriz de canal H
    H = zeros(M, size(source_positions, 1)); % M linhas (antenas) x Nº de usuários (colunas)

    % matriz de canal para cada usuario
    for s = 1:size(source_positions, 1)
        x_user = source_positions(s, 1);
        y_user = source_positions(s, 2);
        z_user = source_positions(s, 3);

        H(:, s) = responsearray(Mx, Mz, elevation, d_x, d_z, lambda, ...
            expoentpathloss, x_user, y_user, z_user);
    end

    % geração de sinais transmitidos e ruído
    X = sqrt(transmittedpower) * (randn(size(source_positions, 1), snapshots) + ...
        1j * randn(size(source_positions, 1), snapshots)) / sqrt(2); 

    Z = sqrt(noisepower) * (randn(M, snapshots) + 1j * randn(M, snapshots)) / sqrt(2); 

    % matriz de sinais recebidos
    Y = H * X + Z; 

    % Cálculo da SNR para verificação
    received_power = sum(abs(H * X).^2, 'all') / numel(H * X);
    noise_power = sum(abs(Z).^2, 'all') / numel(Z);
    SNR = 10 * log10(received_power / noise_power);
    
    disp(['SNR = ', num2str(SNR), ' dB']);
end
