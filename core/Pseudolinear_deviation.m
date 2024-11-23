function deviation = calculateDeviation(collocationPoints, dr, dz, lowerBoundary)
    % calculateDeviation: Computes deviation for pseudolinear underwater 
    % acoustic propagation using the Split-step Padé PE algorithm.
    %
    % Parameters:
    %   collocationPoints - Collocation points for Chebyshev interpolation.
    %   dr - Range step size.
    %   dz - Depth step size.
    %   lowerBoundary - Type of lower boundary ('A', 'V', or 'R').

    % Initialize the environment
    initializeEnvironment(collocationPoints, dr, dz, lowerBoundary);

    % Read environmental parameters
    [caseName, layers, np, ns, c0, freq, sourceDepth, receiverDepth, maxRange, ...
     dr, depth, dz, tlMin, tlMax, N, rangeSteps, collocationPoints, ...
     depths, soundSpeed, density, attenuation, lowerBoundary] = readEnvironmentParameters('input_SMPE.txt');

    % Add PML layer if needed
    if lowerBoundary == 'A'
        [depth, layers, collocationPoints, depths, soundSpeed, density, attenuation] = ...
            addPMLLayer(depth, layers, collocationPoints, depths, soundSpeed, density, attenuation, c0, freq);
    end

    % Initialize parameters
    [wavenumber, refWaveNumber, depthGrid, depths, soundSpeed, density, attenuation] = ...
        initializeParameters(freq, c0, dz, depth, layers, N, collocationPoints, depths, soundSpeed, density, attenuation);

    % Compute Depth Operator adjustment for PML if required
    boundaryAdjustment = computeBoundaryAdjustment(lowerBoundary, depths, depth, refWaveNumber, freq, c0);

    % Obtain initial field
    [sourceField, phi, range] = computeInitialField(sourceDepth, dz, refWaveNumber, wavenumber, soundSpeed, np, ns, c0, dr, layers, depths, collocationPoints);

    % Perform Split-step Padé PE propagation
    [fieldValues, rangeValues] = performPropagation(layers, collocationPoints, depths, soundSpeed, density, attenuation, ...
                                                     rangeSteps, dr, lowerBoundary, boundaryAdjustment, phi);

    % Transform spectral coefficients to physical space
    soundField = computeSoundField(fieldValues, dz, depthGrid, depths, layers, rangeValues);

    % Cut off PML region
    if lowerBoundary == 'A'
        [depthGrid, soundField] = truncatePMLRegion(depthGrid, soundField, depth);
    end

    % Calculate transmission loss
    transmissionLoss = computeTransmissionLoss(soundField, rangeValues, dz);

    % Load reference transmission loss for comparison
    analyticTL = loadAnalyticTL(lowerBoundary, length(rangeValues), length(depthGrid));

    % Calculate deviation
    deviation = calculateDeviationMetric(transmissionLoss, analyticTL, depthGrid, rangeValues);
end

function initializeEnvironment(collocationPoints, dr, dz, lowerBoundary)
    % Placeholder for environment initialization
end

function [depth, layers, collocationPoints, depths, soundSpeed, density, attenuation] = ...
    addPMLLayer(depth, layers, collocationPoints, depths, soundSpeed, density, attenuation, c0, freq)
    % Add a Perfectly Matched Layer (PML) to the environment
    wavelength = 2 * c0 / freq;
    depth = [depth; depth(end) + wavelength];
    layers = layers + 1;
    collocationPoints = [collocationPoints; max(ceil(collocationPoints(end) * 0.25), 20)];
    for i = 1:length(depths)
        depths{i} = [depths{i}, depth(end)];
        soundSpeed{i} = [soundSpeed{i}, soundSpeed{i}(end)];
        density{i} = [density{i}, density{i}(end)];
        attenuation{i} = [attenuation{i}, attenuation{i}(end)];
    end
end

function boundaryAdjustment = computeBoundaryAdjustment(lowerBoundary, depths, depth, refWaveNumber, freq, c0)
    if lowerBoundary == 'A'
        lambda = 2 * c0 / freq;
        tau = (depths{end} - depth(end - 1)) / lambda;
        tau = 100 * tau .^ 3 ./ (1 + tau .^ 2);
        boundaryAdjustment = 1 ./ (1 + tau + 2i * tau);
    else
        boundaryAdjustment = 1;
    end
end

function [sourceField, phi, range] = computeInitialField(sourceDepth, dz, refWaveNumber, wavenumber, soundSpeed, np, ns, c0, dr, layers, depths, collocationPoints)
    % Compute initial field using self-starter
    % Interpolate source wavefield and perform spectral transformation
end

function [fieldValues, rangeValues] = performPropagation(layers, collocationPoints, depths, soundSpeed, density, attenuation, rangeSteps, dr, lowerBoundary, boundaryAdjustment, phi)
    % Perform propagation using Split-step Padé PE algorithm
end

function soundField = computeSoundField(fieldValues, dz, depthGrid, depths, layers, rangeValues)
    % Transform spectral coefficients to physical space
end

function [depthGrid, soundField] = truncatePMLRegion(depthGrid, soundField, depth)
    validIndices = depthGrid <= depth(end - 1);
    depthGrid = depthGrid(validIndices);
    soundField = soundField(validIndices, :);
end

function transmissionLoss = computeTransmissionLoss(soundField, rangeValues, dz)
    % Calculate transmission loss
    transmissionLoss = -20 * log10(abs(soundField));
    transmissionLoss = transmissionLoss(2:100/dz, 2:end);
end

function analyticTL = loadAnalyticTL(lowerBoundary, numRanges, numDepths)
    % Load analytic transmission loss data for comparison
end

function deviation = calculateDeviationMetric(transmissionLoss, analyticTL, depthGrid, rangeValues)
    % Calculate deviation metric
    deviation = abs(analyticTL - transmissionLoss);
    deviation = sum(deviation(:)) / (length(depthGrid) - 2) / (length(rangeValues) - 1);
end
