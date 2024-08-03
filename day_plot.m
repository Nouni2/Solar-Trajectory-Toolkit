% Latitude de l'observateur
latitude = 60;

% Date
date = '21-6';

% Nombre de points par heure
n_points = 100;

% Calcul de la hauteur du Soleil
[h,~] = solar_height(date, latitude, n_points);

% Conversion des hauteurs en degrés
h_deg = rad2deg(h);

% Tracé de la position du Soleil dans le ciel
hours = linspace(0, 23, length(h_deg));
plot(hours, h_deg);
grid on;
xlabel('Heure (h)');
xticks(0:23);
ylabel('Hauteur du Soleil (°)');
title(['Position du Soleil dans le ciel le ', datestr(datetime(date, 'InputFormat', 'dd-MM'), 'dd, mmm')]);

% Ajout de la latitude en légende
latitude_str = num2str(latitude);
legend(['Latitude = ', latitude_str, '°']);

% Trouver les maximums locaux de la courbe
[pks, locs] = findpeaks(h_deg);

% Trouver l'heure du zénith
[max_h, max_idx] = max(pks);
zenith_hour = hours(locs(max_idx));

% Trouver l'heure du lever du Soleil
sunrise_hour = fzero(@(x) interp1(hours, h_deg, x), [0, zenith_hour]);

% Trouver l'heure du coucher du Soleil
sunset_hour = fzero(@(x) interp1(hours, h_deg, x), [zenith_hour, 23]);

% Trouver la durée du jour
length_day = sunset_hour - sunrise_hour;

% Afficher les résultats
disp(['Heure du lever du Soleil: ', datestr(sunrise_hour/24, 'HH:MM'), 'h']);
disp(['Heure du coucher du Soleil: ', datestr(sunset_hour/24, 'HH:MM'), 'h']);
disp(['Durée du jour: ', datestr(length_day/24, 'HH:MM'), 'h']);
disp(['Heure du zénith: ', datestr(zenith_hour/24, 'HH:MM'), 'h']);
