function Cake = cake(min_dist)
    % Die Funktion cake erstellt eine "Kuchenmatrix", die eine kreisfoermige
    % Anordnung von Nullen beinhaltet und den Rest der Matrix mit Einsen
    % auffuellt. Damit koennen, ausgehend vom staerksten Merkmal, andere Punkte
    % unterdrueckt werden, die den Mindestabstand hierzu nicht einhalten. 
    Cake=ones((2*min_dist+1), (2*min_dist+1),'logical');
    a=size(Cake);
    for i = 1:1:a(1) 
        for j = 1:1:a(2)
            if sqrt((i-(min_dist+1))^2+(j-(min_dist+1))^2) <= min_dist % allgemeine Kreisgleichung
                Cake(i,j) = false;
            end
        end
    end
end