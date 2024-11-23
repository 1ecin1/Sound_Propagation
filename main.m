clc;
close all;
clear;
%%
seabedFiles = dir('./*.txt');
totalField = [];
previousStepField = [];
cumulativeRange = 0;
previousDepth = 0;

for fileIndex = length(seabedFiles)
    [caseName, numLayers, numPade, numSample, refSpeed, frequency, sourceDepth, ...
        receiverDepth, maxRange, rangeStep, maxDepth, depthStep, tlMin, tlMax, ...
        numCollocation, rangeVector, collocationPoints, layerDepths, soundSpeed, ...
        density, attenuation, lowerBoundary] = ReadEnvParameter(['input_SMPE_' num2str(fileIndex) '.txt']);
    
    if lowerBoundary == 'A'
        wavelength = 2 * refSpeed / frequency;
        maxDepth = [maxDepth; maxDepth(end) + wavelength];
        numLayers = numLayers + 1;
        collocationPoints = [collocationPoints; max(ceil(collocationPoints(end) * 0.1), 20)];
        PMLDepth = {maxDepth(end-1:end)'};
        PMLSpeed = {[soundSpeed{end,1}(end), soundSpeed{end,1}(end)]};
        PMLDensity = {[density{end,1}(end), density{end,1}(end)]};
        PMLAttenuation = {[attenuation{end,1}(end), attenuation{end,1}(end)]};
        PMLDepth = repmat(PMLDepth, 1, numCollocation);
        PMLSpeed = repmat(PMLSpeed, 1, numCollocation);
        PMLDensity = repmat(PMLDensity, 1, numCollocation);
        PMLAttenuation = repmat(PMLAttenuation, 1, numCollocation);
        layerDepths = [layerDepths; PMLDepth];
        soundSpeed = [soundSpeed; PMLSpeed];
        density = [density; PMLDensity];
        attenuation = [attenuation; PMLAttenuation];
    end

    [w, k0, z, layerDepths, soundSpeed, density, attenuation] = Initialization(frequency, refSpeed, depthStep, maxDepth, ...
        numLayers, numCollocation, collocationPoints, layerDepths, soundSpeed, density, attenuation);

    if lowerBoundary == 'A'
        tau = (layerDepths{end} - maxDepth(end-1)) / wavelength;
        tau = 100 * tau .^ 3 ./ (1 + tau .^ 2);
        gFactor = 1.0 ./ (1 + tau + 2i * tau);
    else
        gFactor = 1;
    end

    depthArray = (0 : 0.1 * depthStep : maxDepth(end))';
    [zLayer, cLayer] = Column(numLayers, layerDepths(:,1), soundSpeed(:,1));
    cw = interp1(zLayer, cLayer, depthArray, 'linear');
    phi = {};

    if previousDepth >= maxDepth
        phi(:,1) = {previousStepField(1:size(zLayer,1))};
    else
        starter = selfstarter(sourceDepth, 0.1 * depthStep, w, cw, numPade, numSample, refSpeed, rangeStep);
        for m = 1 : numLayers
            phi(m,1) = {interp1(depthArray, starter, layerDepths{m,1}, 'linear')};
            phi(m,1) = {ChebTransFFT(collocationPoints(m,1), phi{m,1})};
        end
    end
    
    range = rangeStep;
    [pade1, pade2] = epade(numPade, numSample, 1, k0, rangeStep);

    rangeVector = [rangeStep, rangeVector(2:end), maxRange];
    for j = 1 : length(rangeVector)-1
        X = DepthOperator(numLayers, k0, refSpeed, collocationPoints, layerDepths(:,j), ...
                          soundSpeed(:,j), density(:,j), attenuation(:,j), gFactor);

        if rangeVector(j+1) - rangeVector(j) > rangeStep
            [phiTemp, rangeTemp] = FlatStep(X, numLayers, collocationPoints, pade1, pade2, numPade, ...
                                            rangeVector(j)+cumulativeRange, rangeVector(j+1)+cumulativeRange, rangeStep, ...
                                            layerDepths(:,j), density(:,j), phi(:,end), lowerBoundary);

            phi = [phi, phiTemp(:,2:end)];
            range = [range, rangeTemp(2:end)];
        else
            phiTemp = OneStep(X, numLayers, collocationPoints, pade1, pade2, numPade, ...
                              layerDepths(:,j), density(:,j), phi(:,end), lowerBoundary);               

            phi = [phi, phiTemp];
            range = [range, rangeVector(j)];
        end
    end
    previousStepField = phi{end};
    phiPhysical = cell(numLayers,1);
    for i = 1 : numLayers
        phiPhysical(i) = {cell2mat(phi(i,:))};
    end
    psi = KernelFunc(phiPhysical, depthStep, layerDepths(:,1), numLayers);
    psi = psi .* exp(1i * k0 * rangeStep);
    field = psi ./ sqrt(range);

    if lowerBoundary == 'A'
        ind = find(z <= maxDepth(end-1));
        z = z(ind);
        field = field(ind,:);
    end

    if fileIndex == 1
        totalField = [totalField field];
    else 
        maxRows = max(size(totalField, 1), size(field, 1));
        A_padded = [totalField; zeros(maxRows - size(totalField, 1), size(totalField, 2))];
        B_padded = [field; zeros(maxRows - size(field, 1), size(field, 2))];
        totalField = [A_padded B_padded(:,2:end)];
    end

    cumulativeRange = cumulativeRange + maxRange;
    previousDepth = maxDepth;
end
%%
resultTL = -20 * log10(abs(totalField));
figure;
plot(resultTL(44,:),'r-','LineWidth',1.5);
set(gca,'YDir','reverse');
xlabel('Range (m)');
ylabel('TL (dB)');
title(['Depth=', num2str(receiverDepth), 'm']);
set(gca,'FontSize',16,'FontName','Times New Roman');
set(gca, 'XScale', 'log');
