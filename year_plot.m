% Latitude de l'observateur
latitude = 45;

% Date de début de l'année
start_date = '01-01';

% Nombre de points par heure
dn = 45;

% Initialisation des vecteurs de temps et de hauteur
t_vect = [];
h_vect = [];

% Boucle pour parcourir chaque jour de l'année
for i = 1:365
    % Calcul de la date pour le jour i
    date_i = datetime(start_date, 'InputFormat', 'dd-MM') + days(i-1);
    t = datestr(date_i, 'dd-mm');

    % Calcul de la hauteur du Soleil pour le jour i
    [h,~] = solar_height(t, latitude, dn);

    % Conversion de la hauteur en degrés et ajout à la liste
    h_deg = rad2deg(h);
    h_vect = [h_vect; h_deg];

    % Ajout des heures de la journée à la liste
    t_vect = [t_vect, linspace(i-1, i, length(h_deg))];
end

% Tracé de la position du Soleil dans le ciel pour l'année entière
figure;
hold on;
grid on;
xlabel('Mois de l''année');
ylabel('Hauteur du Soleil (°)');
title(['Position du Soleil dans le ciel pour la latitude ', num2str(latitude), '°']);

% Définition des couleurs en fonction des mois
colors = colors_by_latitude(latitude);

% Tracé des polygones pour chaque mois
month_end_days = [0, cumsum(eomday(2023,1:11))];
for i = 1:12
    % Indice des jours correspondant au mois i
    idx = find(month(t_vect) == i);

    % Polygone rempli avec la couleur correspondant au mois i
    fill([min(t_vect(idx)), max(t_vect(idx)), max(t_vect(idx)), min(t_vect(idx))], ...
        [-100, -100, 100, 100], ...
        colors(i,:), 'FaceAlpha', 0.1);

    % Marqueur pour la fin du mois i
    xline(month_end_days(i)+15, '--', 'Color', colors(i,:));
end


% Tracé de la courbe de la hauteur du Soleil
plot(t_vect, h_vect);

% Trouver les indices des maxima locaux
[~, max_locs] = findpeaks(h_vect);

% Trouver les indices des minima locaux
[~, min_locs] = findpeaks(-h_vect);

% Relier les maxima locaux en une seule courbe
max_env = interp1(t_vect(max_locs), h_vect(max_locs), t_vect, 'linear', 'extrap');

% Relier les minima locaux en une seule courbe
min_env = interp1(t_vect(min_locs), h_vect(min_locs), t_vect, 'linear', 'extrap');

% Afficher la fonction et son enveloppe
hold('on')
plot(t_vect, max_env, 'r',LineWidth=2);
plot(t_vect, min_env, 'g',LineWidth=2)

% Ajout d'une droite y=0
plot([0 365], [0 0], 'k', LineWidth=3);
% Calcul de l'écart entre le max et le min de max_env
contraste = (max(max_env) - min(max_env))/(max(max_env) + min(max_env));
disp(['Le contraste est de ' num2str(contraste,'%0.2e')]);



% Mise en forme du graphique
xticks(month_end_days+15);
xticklabels({'Janvier','Février','Mars','Avril','Mai','Juin','Juillet','Août','Septembre','Octobre','Novembre','Décembre'});
xlim([0,365])
hold off;


