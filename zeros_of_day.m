% Latitude de l'observateur
latitude = 56;

% Date de début de l'année
start_date = '01-01';

% Nombre de points par heure
dn = 100;

% Initialisation du vecteur de durées de jour
duree_jour = zeros(365,1);

% Boucle sur chaque jour de l'année
for i = 1:365
    % Calcul de la date correspondante
    date_i = datetime(start_date, 'InputFormat', 'dd-MM') + days(i-1);
    date_str = datestr(date_i, 'dd-mm');

    % Calcul de la hauteur du Soleil pour ce jour
    [h_vect,~] = solar_height(date_str, latitude, dn);

    % Recherche des heures de lever et de coucher du Soleil
    sunrise = [];
    sunset = [];
    for j=1:length(h_vect)-1
        if h_vect(j) < 0 && h_vect(j+1) > 0
            sunrise = [sunrise, j];
        elseif h_vect(j) > 0 && h_vect(j+1) < 0
            sunset = [sunset, j];
        end
    end
    
    % Calcul de la durée du jour si il y a un lever et un coucher du Soleil
    if ~isempty(sunrise) && ~isempty(sunset)
        duree_jour(i) = (sunset(1)-sunrise(1))/dn;
    else
        duree_jour(i) = 0;
    end
end

% Tracer l'histogramme de la durée du jour
figure;
hold on;
grid on;

% Tracé des polygones pour chaque mois
month_end_days = [0, cumsum(eomday(2023,1:11))];
for i = 1:12
    % Indice des jours correspondant au mois i
    idx = sum(eomday(2023,1:i-1))  + 1 : sum(eomday(2023,1:i)) ;

    % Polygone rempli avec la couleur correspondant au mois i
    fill([idx(1), idx(end), idx(end), idx(1)], ...
        [0,0 , 24, 24], ...
        colors(i,:), 'FaceAlpha', 0.1);

    % Marqueur pour la fin du mois i
    xline(month_end_days(i), '--', 'Color', colors(i,:));
end

bar(duree_jour);
grid('on')

duree_moy = mean(duree_jour);

% Tracé de la courbe reliant les centres des barres
bar_centers = (1:365) - 0.5;
plot(bar_centers, duree_jour, 'r', 'LineWidth', 2);

% Tracé de la durée moyenne du jour en noir
plot([0 365], [duree_moy duree_moy], 'k--', 'LineWidth', 2);

% Mise en forme du graphique
xticks(month_end_days);
xticklabels({'Janvier','Février','Mars','Avril','Mai','Juin','Juillet','Août','Septembre','Octobre','Novembre','Décembre'});
ylim([0 24])
title('Durée du jour en fonction de la date');
xlabel('Date');
ylabel('Durée du jour (en heures)');

% Ajout de la latitude en légende
legend(['\lambda = ' num2str(latitude)], 'Durée moyenne');
