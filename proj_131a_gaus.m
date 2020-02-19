tic
SNRdB = 1:0.5:15;
SNR = 10.^(SNRdB / 20);
% zz = SNRdB + SNR;
% yy = SNRdB - SNR;
% plot(SNRdB, pdf('Normal', SNRdB, 0, 1)); hold on
% plot(SNRdB, pdf('Normal', zz, 0, 1)); hold on
% plot(SNRdB, pdf('Normal', yy, 0, 1));
semilogy(SNRdB, qfunc((SNR)), 'k-', 'LineWidth', 3.0);
xlim([1 15]);
legend('Theoretical Gaussian BER', 'Location', 'SouthWest')
title('Gaussian BER vs SNR');
ylabel('BER');
xlabel('SNR (dB)');
grid on
hold on
f = [50000 100000 500000 1000000 5000000 10000000 50000000];
for z = 1:length(f)
    Error = zeros(1, length(SNR));
    M = f(z);
    parfor k = 1:length(SNR)
        rng(2000);
        N = randn(1, M); % Gaussian distribution
        rng(2001);
        S1 = rand(1,M); % Uniform distribution

        S2 = (S1 >= 0.5); % H1 data, or logical HIGH data
        SS = SNR(k) * (2 * S2 - 1);

        X = SS + N;
        XX = X .* S2;
        X1 = (XX < 0);

        M1 = sum(S2);
        X11 = sum(X1);
        Pe = X11 / M1;
        Error(k) = Pe;
    end
    txt = ['M = ', num2str(f(z))];
    semilogy(SNRdB, Error, 'x-', 'DisplayName', txt, 'LineWidth', 1.5)
    hold on
end
toc