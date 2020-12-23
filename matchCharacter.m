function char = matchCharacter(charImg)
%Find the best match for the segmented character
templates = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
numTemplates = size(templates, 2);

char = '';
maxMatches = -1;
bestMatch = -1;

%Match the character
for i = 1 : numTemplates
    %Read in the current template
    curTemplate = imread(strcat('Templates/', templates(i), '.bmp'));
    
    %rsize the potential character to the size of the template
    character = imresize(charImg, size(curTemplate));
    
    %Find SURF features for the potential character and template
    charPoints = detectSURFFeatures(character);
    [fChar,vptsChar] = extractFeatures(character,charPoints);
    tempPoints = detectSURFFeatures(curTemplate);
    [fTemp,vptsTemp] = extractFeatures(curTemplate,tempPoints);
    
    %Match the SURF features from the potential character and the template
    indexPairs = matchFeatures(fChar,fTemp) ;
    numMatches = size(indexPairs, 1);
    
    %Perform normalized cross-correlation with the potential character and
    %the template
    c = normxcorr2(curTemplate, character);
    match = max(c(:));
    
    %If the correlation score is too low there the template is a bad match
    if match < 0.6
        continue;
    end

    %Determine if the current template is the best match
    if numMatches > maxMatches && bestMatch*0.95 < match
        bestMatch = match;
        maxMatches = numMatches;
        char = templates(i);
    elseif numMatches == maxMatches && bestMatch*0.94 < match
        bestMatch = match;
        maxMatches = numMatches;
        char = templates(i);
    elseif bestMatch*1.2 < match
        bestMatch = match;
        maxMatches = numMatches;
        char = templates(i);
    end
    
    fprintf("Best match score %f\n", bestMatch);
end

