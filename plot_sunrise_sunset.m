latitude = 36; % Latitude de l'observateur

% Date de début de l'année
start_date = '01-01';

% Nombre de points par heure
dn = 45;

% Initialisation des vecteurs d'heures de coucher et de lever du soleil
sunrise_times = NaN(1, 365);
sunset_times = NaN(1, 365);

% Boucle pour parcourir chaque jour de l'année
for i = 1:365
    % Calcul de la date pour le jour i
    date_i = datetime(start_date, 'InputFormat', 'dd-MM') + days(i-1);
    t = datestr(date_i, 'dd-mm');

    % Calcul de la hauteur du Soleil pour le jour i
    [h, ~] = solar_height(t, latitude, dn);

    % Conversion des heures de coucher et de lever du Soleil
    sunrise_hour_idx = find(h > 0, 1, 'first');
    sunset_hour_idx = find(h > 0, 1, 'last');
    
    % Vérification pour les latitudes polaires
    if ~isempty(sunset_hour_idx)
        sunset_hour = sunset_hour_idx / dn;
        sunset_times(i) = sunset_hour;
    end
    
    if ~isempty(sunrise_hour_idx)
        sunrise_hour = sunrise_hour_idx / dn;
        sunrise_times(i) = sunrise_hour;
    end
end

% Tracé de l'heure du coucher de soleil à gauche
yyaxis left;
plot(find(~isnan(sunset_times)), sunset_times(~isnan(sunset_times)), 'b-', 'MarkerSize', 8, 'LineWidth', 2);
hold on;

% Tracé des croix rouges pour les jours où le soleil ne se couche pas
plot(find(isnan(sunset_times)), sunset_times(isnan(sunset_times)), 'bx', 'MarkerSize', 10, 'LineWidth', 2);

% Tracé de l'heure du lever de soleil à droite
yyaxis right;
plot(find(~isnan(sunrise_times)), sunrise_times(~isnan(sunrise_times)), 'r-', 'MarkerSize', 8, 'LineWidth', 2);

% Tracé des croix bleues pour les jours où le soleil ne se lève pas
plot(find(isnan(sunrise_times)), sunrise_times(isnan(sunrise_times)), 'rx', 'MarkerSize', 10, 'LineWidth', 2);

% Mise en forme du graphique
xlabel('Jour de l''année (jours)');
yyaxis left;
ylabel('Heure du coucher (heure du jour)');
yyaxis right;
ylabel('Heure du lever (heure du jour)');
title(['Heure du coucher et du lever du Soleil à la latitude ', num2str(latitude), '°']);
grid on;

% Définition des couleurs en fonction des mois
colors = colors_by_latitude(latitude);

% Tracé des polygones pour chaque mois
ylim([0 24])
month_end_days = [0, cumsum(eomday(2023,1:11))];
t_vect = linspace(1, 365, 365); % Vecteur des jours de l'année
for i = 1:12
    % Indice des jours correspondant au mois i
    idx = find(month(t_vect) == i);

    % Polygone rempli avec la couleur correspondant au mois i
    fill([min(t_vect(idx)), max(t_vect(idx)), max(t_vect(idx)), min(t_vect(idx))], ...
        [0, 0, 24, 24], ...
        colors(i,:), 'FaceAlpha', 0.1);

    % Marqueur pour la fin du mois i
    xline(month_end_days(i)+15, '--', 'Color', colors(i,:));
end

% Mise en forme de l'axe des x
xticks(month_end_days+15);
xticklabels({'Janvier','Février','Mars','Avril','Mai','Juin','Juillet','Août','Septembre','Octobre','Novembre','Décembre'});
xlim([0,365]);

% Mise en forme de l'axe des y
yyaxis left;
yticks(0:2:24);
yticklabels(compose('%02d:00', 0:2:24));
ylim([0, 24]);

yyaxis right;
yticks(0:2:24);
yticklabels(compose('%02d:00', 0:2:24));
ylim([0, 24]);

hold off;

if abs(latitude)<66.56188

    % Recherche du coucher le plus tardif et du lever le plus tôt
    latest_sunset = max(sunset_times);
    earliest_sunrise = min(sunrise_times);

    % Calcul de l'amplitude
    amplitude = latest_sunset - earliest_sunrise;

    % Jour le plus court
    shortest_day = min(sunset_times - sunrise_times);

    % Jour le plus long
    longest_day = max(sunset_times - sunrise_times);

    % Durée moyenne du jour
    average_day_duration = mean(sunset_times - sunrise_times);

    % Variations de la durée du jour
    day_variations = sunset_times - sunrise_times;

    % Affichage des résultats
    disp('Informations sur les heures de lever et de coucher du Soleil sur une année :');
    disp(['Coucher le plus tardif : ', datestr(datenum(0,0,0,latest_sunset,0,0),'HH:MM'), ' (Heure locale)']);
    disp(['Lever le plus tôt : ', datestr(datenum(0,0,0,earliest_sunrise,0,0),'HH:MM'), ' (Heure locale)']);
    disp(['Jour le plus court : ', datestr(datenum(0,0,0,shortest_day,0,0),'HH:MM'), ' (Durée entre lever et coucher)']);
    disp(['Jour le plus long : ', datestr(datenum(0,0,0,longest_day,0,0),'HH:MM'), ' (Durée entre lever et coucher)']);
    disp(['Durée moyenne du jour : ', datestr(datenum(0,0,0,average_day_duration,0,0),'HH:MM'), ' (Heure locale)']);
    disp(['Variations de la durée du jour : ']);
    disp(['  - Minimum : ', datestr(datenum(0,0,0,min(day_variations),0,0),'HH:MM'), ' (Durée entre lever et coucher)']);
    disp(['  - Maximum : ', datestr(datenum(0,0,0,max(day_variations),0,0),'HH:MM'), ' (Durée entre lever et coucher)']);
end