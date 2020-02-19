tic

SNRdB = 1:0.5:15;
SNR = 10 .^ (SNRdB / 20);

% figure(1)
% zz = SNRdB + SNR;
% yy = SNRdB - SNR;
% plot(SNRdB, (sqrt(2)\2 * exp(-abs(SNRdB) .* sqrt(2)))); hold on
% plot(SNRdB, (sqrt(2)\2 * exp(-abs(zz) .* sqrt(2)))); hold on
% plot(SNRdB, (sqrt(2)\2 * exp(-abs(yy) .* sqrt(2))));
% xlim ([-5 5]);
% legend('Noise', '0 Bit', '1 Bit');
% figure(2)

semilogy(SNRdB, 1 - laplacian(SNR), 'g-', 'LineWidth', 3.0);
hold on
grid on
xlim([1 15])
title('Laplacian BER vs SNR');
ylabel('BER');
xlabel('SNR (dB)');
legend('Theoretical Laplacian BER', 'Location', 'SouthWest')

z = [50000 100000 500000 1000000 5000000 10000000];

for i = 1:length(z)
    Error = [];
    M = z(i);
    parfor k = 1:length(SNR)
        rng(2002);
        N = rand(1, M);
        NL = ilaplacian(N);
        rng(2003);
        S1 = rand(1, M);
        S2 = (S1 >= 1/2);
        SS = SNR(k) * (2 * S2 - 1);

        X = SS + NL;
        XX = X .* S2;
        X1 = (XX < 0);
        
        M1 = sum(S2);
        X11 = sum(X1);
        Pe = X11 / M1;

        Error = [Error Pe];

    end
    
    txt = ['M = ', num2str(z(i))];
    semilogy(SNRdB, Error, '^-.', 'DisplayName', txt, 'LineWidth', 1.0);
    hold on

end
toc


function y = laplacian(x)
    for i = 1:length(x)
        if x(i) < 0
            y(i) = 1/2 * exp(x(i) * sqrt(2));
        else
            y(i) = 1 - 1/2 * exp(-x(i) * sqrt(2));
        end
    end
end

function y = ilaplacian(x)
    y = (x < 1/2) .* (1 / sqrt(2)) .* log(2 * x) + (x >= 1/2) .* (-1 / sqrt(2)) .* log(2 - 2 * x);
end






