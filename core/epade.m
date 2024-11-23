function [pdu, pdl] = epade(np, ns, ip, k0, dr)
    sig = k0 * dr;
    n = 2 * np;

    if ip == 1
        nu = 0;
        alp = 0;
    else
        nu = 1;
        alp = -0.25;
    end

    fact = arrayfun(@factorial, 1:n);

    bin = zeros(n + 1);
    for ii = 1:n + 1
        bin(ii, 1) = 1;
        bin(ii, ii) = 1;
    end
    for ii = 3:n + 1
        for jj = 2:ii - 1
            bin(ii, jj) = bin(ii - 1, jj - 1) + bin(ii - 1, jj);
        end
    end

    [dg, dh1] = computeDerivatives(n, sig, alp, nu, bin);

    A = zeros(n, n);
    B = dg(2:n + 1);

    for ii = 1:n
        if (2 * ii - 1 <= n)
            A(ii, 2 * ii - 1) = fact(ii);
        end
        for jj = 1:ii
            if (2 * jj <= n)
                A(ii, 2 * jj) = -bin(ii + 1, jj + 1) * fact(jj) * dg(ii - jj + 1);
            end
        end
    end

    idx = 1:np;
    if ns >= 1
        z1 = -3;
        B(n) = -1;
        A(n, 2 * idx - 1) = z1 .^ idx;
    end
    if ns >= 2
        z1 = -1.5;
        B(n - 1) = -1;
        A(n - 1, 2 * idx - 1) = z1 .^ idx;
    end

    B = A \ B(:);

    dh1(1) = 1;
    dh1(idx + 1) = B(2 * idx - 1);
    roots1 = findRoots(dh1, np);
    pdu = -1 ./ roots1;

    dh1(1) = 1;
    dh1(idx + 1) = B(2 * idx);
    roots2 = findRoots(dh1, np);
    pdl = -1 ./ roots2;
end

function [dg, dh1] = computeDerivatives(n, sig, alp, nu, bin)
    dh1 = zeros(1, n);
    dh2 = zeros(1, n);
    dh3 = zeros(1, n);

    dh1(1) = 0.5 * 1i * sig;
    dh2(1) = alp;
    dh3(1) = -2.0 * nu;

    exp1 = -0.5;
    exp2 = -1.0;
    exp3 = -1.0;

    for ii = 2:n
        dh1(ii) = dh1(ii - 1) * exp1;
        dh2(ii) = dh2(ii - 1) * exp2;
        dh3(ii) = -nu * dh3(ii - 1) * exp3;
        exp1 = exp1 - 1.0;
        exp2 = exp2 - 1.0;
        exp3 = exp3 - 1.0;
    end

    dg = zeros(1, n + 1);
    dg(1) = 1.0;
    dg(2) = dh1(1) + dh2(1) + dh3(1);

    for ii = 2:n
        dg(ii + 1) = dh1(ii) + dh2(ii) + dh3(ii);
        for jj = 1:ii - 1
            dg(ii + 1) = dg(ii + 1) + bin(ii, jj) * (dh1(jj) + dh2(jj) + dh3(jj)) * dg(ii - jj + 1);
        end
    end
end

function roots = findRoots(coeff, np)
    if np == 1
        roots(1) = -coeff(1) / coeff(2);
        return;
    end

    if np == 2
        delta = sqrt(coeff(2)^2 - 4 * coeff(1) * coeff(3));
        roots(1) = (-coeff(2) - delta) / (2 * coeff(3));
        roots(2) = (-coeff(2) + delta) / (2 * coeff(3));
        return;
    end

    roots = zeros(1, np);
    for k = np:-1:3
        guess = 0;
        roots(k) = laguerreRoot(coeff, k, guess, 1e-12, 1000);

        for ii = k:-1:1
            coeff(ii) = coeff(ii) + roots(k) * coeff(ii + 1);
        end
        coeff(1:k) = coeff(2:k + 1);
    end

    delta = sqrt(coeff(2)^2 - 4 * coeff(1) * coeff(3));
    roots(1) = (-coeff(2) - delta) / (2 * coeff(3));
    roots(2) = (-coeff(2) + delta) / (2 * coeff(3));
end

function root = laguerreRoot(coeff, degree, guess, tol, maxIter)
    root = guess;
    epsb = 1e-20;

    while maxIter > 0
        p = coeff(degree);
        pz = 0;
        pzz = 0;

        for ii = degree:-1:1
            pzz = pzz * root + pz;
            pz = pz * root + p;
            p = p * root + coeff(ii);
        end

        if abs(p) < epsb
            return;
        end

        g = pz / p;
        h = g^2 - pzz / p;
        delta = sqrt((degree - 1) * (degree * h - g^2));
        if abs(g + delta) > abs(g - delta)
            dz = degree / (g + delta);
        else
            dz = degree / (g - delta);
        end

        root = root - dz;
        if abs(dz) < tol
            return;
        end
        maxIter = maxIter - 1;
    end
end
