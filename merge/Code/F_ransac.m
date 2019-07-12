function [Korrespondenzen_robust , largest_set_size] = F_ransac(Korrespondenzen, varargin)
    % F_ransac Führe RANSAC-Algorithmus aus.
    %   [Korrespondenzen_robust] = F_ransac(Korrespondenzen, 'epsilon', 0.5, 'p', 0.9, 'tolerance', 0.1);
    %   Diese Funktion führt den RANSAC-Algorithmus zur Bestimmung von
    %   robusten Korrespondenzpunktpaaren aus. Als Eingabeparameter erhält
    %   die Funktion eine Matrix, welche die Korrespondenzpunkte erhält
    %   (die ersten beiden Einträge einer Spalte entsprechen den x- und
    %   y-Koordinaten des Punktes in Kameraframe 1 und die letzten beiden
    %   Einträge einer Spalte entsprechen den x- und y-Koordinaten 
    %   des Punktes in Kameraframe 2). Zusätzlich können über einen Input
    %   Parser Werte für epsilon (Anteil der Ausreißer), p (gewünschte
    %   Wahrscheinlichkeit, dass kein Ausreißer enthalten ist) und 
    %   tolerance (Toleranz) vorgegeben werden. Der Parameter epsilon, aus
    %   dem sich die Zahl der Iterationen berechnet, wird adaptiv angepasst.
    %   Als Rückgabeparameter übergibt die Funktion einen Satz robuster
    %   Korrespondenzpunktpaare.
    %
    % Erstellt: Juli 2019
    
    %% Nachricht anzeigen (1/2).
    disp('   Der RANSAC-Algorithmus wurde gestartet.');
    
    %% Input parser
    parser = inputParser;
    
    % Standartwerte
    % Anteil der Ausreißer.
    default_epsilon = 0.5; 
    % Gewünschte Wahrscheinlichkeit, dass kein Ausreißer im Consensus Set
    % enthalten ist.
    default_p = 0.999;
    % Toleranzbereich.
    default_tolerance = 0.01;
    
    % Prüffunktionen
    check_epsilon = @(x) isnumeric(x) && (0 <= x) && (x <= 1);
    check_p = @(x) isnumeric(x) && (0 <= x) && (x <= 1);
    check_tolerance = @(x) isnumeric(x);
    
    % Parameter hinzufügen
    addOptional(parser, 'epsilon', default_epsilon, check_epsilon);
    addOptional(parser, 'p', default_p, check_p);
    addOptional(parser,'tolerance',default_tolerance,check_tolerance);
    
    % Parse Inputs
    parse(parser,varargin{:});
    
    epsilon = parser.Results.epsilon;
    p = parser.Results.p;
    tolerance = parser.Results.tolerance;
    
    %% Homogene Koordinaten
    x1_pixel = Korrespondenzen(1:2,:);
    x1_pixel(3,:)=1;
    x2_pixel = Korrespondenzen(3:4,:);
    x2_pixel(3,:)=1;
    
    %% RANSAC Algorithmus Vorbereitung
    k = 8;
    num_iterations = log(1-p)/log(1-(1-epsilon)^k);
    largest_set_size = 0;
    largest_set_dist = inf;
    largest_set_F = zeros(3);
    
    %% RANSAC Algorithmus 
    i = 1;
    while (i <= num_iterations)
        random_rows = randperm(size(Korrespondenzen,2),k);
        F = achtpunktalgorithmus(Korrespondenzen(:,random_rows));
        sd = sampson_dist(F, x1_pixel, x2_pixel);
        set_size = sum(sd<tolerance);
        set_dist = sum(sd);
        if (set_size > largest_set_size)||((set_size == largest_set_size) && (set_dist < largest_set_dist))
            largest_set_size = set_size;
            largest_set_dist = set_dist;
            largest_set_F = F;
            Korrespondenzen_robust = Korrespondenzen(:,(sd<tolerance));
            if (1-(largest_set_size/size(Korrespondenzen,2)))<epsilon
                epsilon = (1-(largest_set_size/size(Korrespondenzen,2)));
                num_iterations = log(1-p)/log(1-(1-epsilon)^k);
            end
        end
        i = i+1;
    end 
    
    %% Nachricht anzeigen (1/2).
    fprintf('   Der RANSAC-Algorithmus ist durchglaufen.\n   Anzahl der robusten Korrespondenzpunktpaare: %i \n', largest_set_size);
    
end