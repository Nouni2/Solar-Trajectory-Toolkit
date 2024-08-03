function [h,a] = solar_height(date, latitude, dn)
% Cette fonction calcule la hauteur du Soleil à une latitude donnée à différents points de temps dans une journée.
% La hauteur du Soleil est exprimée en radians par rapport à l'horizon.
% 
% Entrées:
%   date : date sous forme de chaîne de caractères dans le format 'dd-MM'
%   latitude : latitude de l'endroit où la hauteur du Soleil est calculée en degrés
%   dn : nombre de points de temps à calculer
%
% Sorties:
%   h : vecteur de hauteur du Soleil en radians à chaque point de temps dans une journée
%   a : vecteur d'angle azimutal du Soleil en radians à chaque point de temps dans une journée

% Conversion de la date en jours de l'année
date = datetime(date, 'InputFormat', 'dd-MM');
t = day(date, 'dayofyear');

% Theta : l'inclinaison de la Terre sur son axe par rapport à l'écliptique
% Theta Réel = -23.45

theta = -23.45;

% Calcul de la déclinaison du Soleil
delta = theta * cos((2 * pi * (t + 10)) / 365);

% Conversion de la latitude et de la déclinaison en radians
latitude = deg2rad(latitude);
delta = deg2rad(delta);

% Calcul du nombre total de points à calculer
n = 24 * dn;

% Initialisation du vecteur de temps
t_vect = linspace(0, 23, n);

% Initialisation du vecteur de hauteur
h = zeros(n, 1);
a = zeros(n,1);

% Boucle pour calculer la hauteur du Soleil à chaque point de temps
for i = 1:n
    % Calcul de l'heure à partir du temps
    hour = t_vect(i);

    % Calcul de l'angle horaire du Soleil
    H = 15 * (hour - 12);

    % Conversion de l'angle horaire en radians
    H = deg2rad(H);

    % Calcul de la hauteur du Soleil
    h(i) = asin(sin(delta) * sin(latitude) + cos(delta) * cos(latitude) * cos(H));
    a(i) = acos((sin(delta)/(cos(h(i))*cos(latitude))) - tan(h(i))*tan(latitude));
end