function merkmale = harris_detektor(input_image, varargin)
    % In dieser Funktion soll der Harris-Detektor implementiert werden, der
    % Merkmalspunkte aus dem Bild extrahiert
    %% Input parser aus Aufgabe 1.7
    p=inputParser;
    addParameter(p,'segment_length',15,@(x) isnumeric(x) && mod(x,2)==1 && x>1);
    addParameter(p,'k',0.05,@(x) isnumeric(x) && x>=0 && x<=1);
    addParameter(p,'tau',10^6,@(x) isnumeric(x) && x>0);
    addParameter(p,'do_plot',false,@(x) islogical(x));
    addOptional(p,'min_dist',20,@(x) isnumeric(x) && x>=0);
    addOptional(p,'tile_size',[200 200],@(x) isnumeric(x) && (isscalar(x) || isvector(x)));
    addOptional(p,'N',5,@(x) isnumeric(x) && x>=0);
    parse(p,varargin{:});
    segment_length = p.Results.segment_length;
    k = p.Results.k;
    tau = p.Results.tau;
    do_plot = p.Results.do_plot;
    min_dist = p.Results.min_dist;
    tile_size = p.Results.tile_size;
    N = p.Results.N;
    %% Vorbereitung zur Feature Detektion aus Aufgabe 1.4
    if ndims(input_image)==2
        % Approximation des Bildgradienten
        input_image=double(input_image);
        [Fx, Fy]=sobel_xy(input_image);
        % Gewichtungsberechnung mit dem Gau�filter aus Kapitel 1.2
        w=[segment_length;1];
        b = -(segment_length-1)/2:1:(segment_length-1)/2;
        sigma=sqrt(segment_length/(2*log(2)));
        C=1/(sum(exp(-double(b).^2/(2*sigma^2))));
        w=C*exp(-transpose(b).^2/(2*sigma^2));
        % Harris Matrix G
        a=size(input_image);
        G11=[a(1),a(2)];
        G22=[a(1),a(2)];
        G12=[a(1),a(2)];
        Fx2=Fx.^2;
        Fy2=Fy.^2;
        FxFy=Fx.*Fy;
        G11=conv2(Fx2,w*transpose(w),'same');
        G22=conv2(Fy2,w*transpose(w),'same');
        G12=conv2(FxFy,w*transpose(w),'same');
    else
       error('Image format has to be NxMx1');
    end
    
    %% Merkmalsextraktion ueber die Harrismessung aus Aufgabe 1.5
    [y,x]=size(input_image);
    H=zeros(y,x,'double');
    corners=zeros(y,x,'double');
    counter=0;
    merkmal=[];
    for i=1:1:x
        for j=1:1:y
            G=[G11(j,i),G12(j,i);G12(j,i),G22(j,i)];
            H(j,i)=det(G)-k*(trace(G)^2);
            if H(j,i)<tau
                corners(j,i)=0;
            else
                counter=counter+1;
                corners(j,i)=H(j,i);
                merkmal(:,counter)=[i,j];
            end
        end
    end
    
    %% Merkmalsvorbereitung aus Aufgabe 1.9
    a=size(corners);
    corner=zeros(a(1)+2*min_dist,a(2)+2*min_dist);
    corner(min_dist+1:a(1)+min_dist,min_dist+1:a(2)+min_dist)=corners(:,:);
    corners=corner;
    [cstrich,I]=sort(corners(:),'descend');
    nullen_indizes = find(~cstrich);
    sorted_index=I(1:min(nullen_indizes)-1);
    %% Akkumulatorfeld aus Aufgabe 1.10
    a=size(input_image);
    x_tile=ceil(a(1)/tile_size(1));
    y_tile=ceil(a(2)/tile_size(2));
    AKKA=zeros(x_tile,y_tile);
    if size(sorted_index,1)<N*x_tile*y_tile
        merkmale=zeros(2,size(sorted_index,1));
    else
        merkmale=zeros(2,N*x_tile*y_tile);
    end
    
    %% Merkmalsbestimmung mit Mindestabstand und Maximalzahl pro Kachel
    a=size(input_image);
    b=size(sorted_index);
    Cake = cake(min_dist);
    Cake(min_dist+1,min_dist+1)=1;
    for i=1:1:b(1)
        if corners(sorted_index(i))~=0
            [ycorn,xcorn] = ind2sub(size(corners),sorted_index(i));%aus dem index werden x und y koordinaten gemacht.  corn wegen corner
            corners(ycorn-min_dist:ycorn+min_dist,xcorn-min_dist:xcorn+min_dist)=corners(ycorn-min_dist:ycorn+min_dist,xcorn-min_dist:xcorn+min_dist).*Cake;%im umkreis der ecke werden alle anderen m�glichen ecken gleich null gesetzt
            xAKKA=ceil((xcorn-min_dist)/tile_size(2));%x koordinate der kachel berechnen
            yAKKA=ceil((ycorn-min_dist)/tile_size(1));%y koordinate der kachel berechnen
            if AKKA(yAKKA,xAKKA)<N    %pr�fen ob bereits N ecken in der Kachel gefunden wurden
                AKKA(yAKKA,xAKKA)=AKKA(yAKKA,xAKKA)+1; % die anzahl der ecken in der berechneten Kachel um eine erh�hen
                merkmale(:,sum(sum(AKKA)))=[xcorn-min_dist;ycorn-min_dist]; % die Ecke erf�llt alle kriterien. Daher wird sie in merkmale �bernommen. min dist muss, wegen des min dist gro�en nullrandes von corners, von xcorn und ycorn abgezogen werden 
            else
                sorted_index(i)=0;%es wurden bereits N ecken in dieser kacheln gefunden, weshalb diese (die nicht zu den N st�rksten ecken geh�rt) gel�scht wird
                corners(ycorn,xcorn)=0;%die ecke auch aus der corners matrix l�schen
            end
        else
            sorted_index(i)=0;%diese ecke wurde bereits durch den kuchen einer benachbarten ecke auf null gesetzt
        end
    end
    sorted_index = sorted_index(sorted_index~=0); %alle zu nah aneinander liegende Ecken werden aus der sorted_index liste gel�scht
    b=size(sorted_index);
    merkmale=merkmale(:,1:sum(sum(AKKA)));%alle zu viel allokierten merkmalspunkte werden aus der merkmalmatrix gel�scht
    % Plot Routine
    if do_plot==true
        figure
        imshow(uint8(input_image));
        hold on;
        plot(merkmale(1,:),merkmale(2,:),'r+','MarkerSize', 10);
    end
end
    