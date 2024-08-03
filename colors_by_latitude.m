function colors = colors_by_latitude(latitude_deg)

    % Transforme la latitude en radians
    latitude_rad = deg2rad(latitude_deg);

    % Calcule le sinus de la latitude
    sin_lat = sin(latitude_rad);

    % Définit les couleurs de base en fonction de la latitude
    if abs(sin_lat) >= 0.9 % Latitude polaire
        colors = [0.8 0.8 1.0;   % Janvier : bleu clair
                  0.9 0.9 1.0;   % Février : transition vers le vert
                  1.0 1.0 1.0;   % Mars : blanc
                  0.9 1.0 0.9;   % Avril : transition vers le vert
                  0.0 1.0 0.0;   % Mai : vert
                  1.0 1.0 0.9;   % Juin : transition vers le jaune
                  1.0 1.0 0.5;   % Juillet : jaune
                  1.0 0.9 0.0;   % Août : jaune
                  1.0 0.5 0.0;   % Septembre : transition vers le rouge
                  1.0 0.0 0.0;   % Octobre : rouge
                  0.8 0.0 0.0;   % Novembre : transition vers le bleu foncé
                  0.4 0.4 1.0];  % Décembre : bleu foncé
    elseif abs(sin_lat) >= 0.7 % Latitude subpolaire
        colors = [0.7 0.7 0.9;   % Janvier : bleu pâle
                  0.7 0.8 0.9;   % Février : bleu pâle
                  0.7 0.9 1.0;   % Mars : bleu pâle
                  0.8 0.9 1.0;   % Avril : bleu pâle
                  0.9 0.9 1.0;   % Mai : bleu pâle
                  1.0 1.0 1.0;   % Juin : blanc
                  1.0 0.9 0.9;   % Juillet : rose clair
                  1.0 0.8 0.8;   % Août : rose clair
                  1.0 0.7 0.7;   % Septembre : rose clair
                  1.0 0.6 0.6;   % Octobre : rose clair
                  1.0 0.5 0.5;   % Novembre : rose clair
                  1.0 0.4 0.4];  % Décembre : rose clair
    elseif abs(sin_lat) >= 0.5 % Latitude tempérée
        colors = [0.0 0.0 0.6;   % Janvier : bleu foncé
                  0.6 0.8 1.0;   % Février : bleu clair
                  0.4 0.8 0.4;   % Mars : vert clair
                  0.0 0.6 0.0;   % Avril : vert foncé
                  0.8 1.0 0.6;   % Mai : vert clair
                  1.0 1.0 0.2;   % Juin : jaune clair
                  1.0 0.6 0.0;   % Juillet : jaune foncé
                  1.0 0.4 0.0;   % Août : jaune clair
                  1.0 0.8 0.6;   % Septembre : orange
                  0.8 0.0 0.0;   % Octobre : rouge foncé
                  0.6 0.0 0.2;   % Novembre : rouge clair
                  0.6 0.8 1.0];  % Décembre : bleu clair
    elseif abs(sin_lat) >= 0.3 % Latitude désertique
        colors = [0.9 0.9 0.4;   % Janvier : jaune pâle
                  1.0 1.0 0.5;   % Février : jaune pâle
                  1.0 1.0 0.6;   % Mars : jaune pâle
                  1.0 1.0 0.7;   % Avril : jaune pâle
                  1.0 1.0 0.8;   % Mai : jaune pâle
                  1.0 1.0 0.9;   % Juin : jaune pâle
                  1.0 1.0 1.0;   % Juillet : blanc
                  1.0 0.9 0.9;   % Août : rose clair
                  1.0 0.7 0.7;   % Septembre : rouge clair
                  1.0 0.6 0.6;   % Octobre : rouge clair
                  1.0 0.5 0.5;   % Novembre : rouge foncé
                  1.0 0.4 0.4];  % Décembre : rouge foncé
    else % Latitude équatoriale
        colors = [0.2 0.5 0.2;   % Janvier : vert foncé
                  0.3 0.6 0.3;   % Février : vert foncé
                  0.4 0.7 0.4;   % Mars : vert clair
                  0.5 0.8 0.5;   % Avril : vert clair
                  0.6 0.9 0.6;   % Mai : vert clair
                  0.7 1.0 0.7;   % Juin : vert clair
                  0.8 0.9 0.8;   % Juillet : vert clair
                  0.9 0.8 0.9;   % Août : vert clair
                  0.8 0.7 0.8;   % Septembre : vert clair
                  0.7 0.6 0.7;   % Octobre : vert clair
                  0.6 0.5 0.6;   % Novembre : vert foncé
                  0.5 0.4 0.5];  % Décembre : vert foncé
    end
end
