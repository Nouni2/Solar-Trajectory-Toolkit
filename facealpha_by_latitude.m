function face_alpha = facealpha_by_latitude(latitude_deg)

% Définit les couleurs standard pour chaque saison
colors = [0 0 1; 0 1 0; 1 1 0; 1 0.5 0; 1 0 0];

% Convertit la latitude en radians
latitude_rad = deg2rad(latitude_deg);

% Détermine la saison en fonction du mois
month = mod(now('month')-1+floor(2*pi/3-latitude_rad/(2*pi/3)), 12)+1;

% Détermine le pourcentage d'avancement dans la saison
day_of_season = now('dayofyear')-floor(2*pi/3-latitude_rad/(2*pi/3))*365-ceil(365/4);
season_length = [89 92 92 91];
pct_of_season = day_of_season/season_length(month);

% Détermine la couleur de base pour la saison
base_color = colors(month,:);

% Détermine le niveau de transparence (facealpha)
if pct_of_season < 0.25
    face_alpha = 0.5 + pct_of_season*2;
elseif pct_of_season < 0.5
    face_alpha = 1;
elseif pct_of_season < 0.75
    face_alpha = 1 - (pct_of_season-0.5)*2;
else
    face_alpha = 0.5 - (pct_of_season-0.75)*2;
end

% Applique la couleur de base et le niveau de transparence
face_alpha = repmat([base_color face_alpha], size(latitude_deg));

end
