# Solar Trajectory Toolkit

## Project Overview

This MATLAB project aims to calculate the position of the sun in the sky based on the observer's geographic location and time, with user-defined accuracy. It calculates key solar parameters such as solar declination, azimuth, and elevation, and determines important solar events like sunrise and sunset times. The project provides a comprehensive tool for analyzing the sun's trajectory and its apparent motion throughout the year.

![sunrise-sunset](https://github.com/user-attachments/assets/69a0a6e1-9bda-4aa5-9e74-0eccc7d87921)


## General Definitions

- **Latitude**: The latitude of an observer is the angle between the equatorial plane and the direction of the vertical at a given point on the Earth's surface. It is measured in degrees or radians, ranging from $-90^\circ$ (south) to $90^\circ$ (north).

- **Longitude**: The longitude of an observer is the angle between the Greenwich meridian plane and the meridian passing through the observation point. It is measured in degrees or radians, ranging from $-180^\circ$ to $180^\circ$, indicating east and west positions relative to the Greenwich meridian.

- **Solar Elevation**: The solar elevation is the vertical angle between the line joining the sun to the observer and the local horizontal plane. It is measured in degrees or radians. A positive elevation indicates the sun is above the horizon, while a negative elevation indicates it is below the horizon.

- **Azimuth**: Azimuth is the horizontal angle between the north direction and the point where the sun is located in the sky, measured clockwise from north. It is measured in degrees, ranging from $0^\circ$ (north) to $360^\circ$ (north).

- **Obliquity of the Ecliptic**: The obliquity of the ecliptic is the angle between the ecliptic plane (the Earth's orbital plane around the Sun) and the celestial equator plane. It is approximately $23.436^\circ$ and represents the tilt of the Earth's rotational axis relative to its orbit.

## I. Calculation of Solar Declination

**Solar Declination**: The solar declination is the angle between the celestial equator plane and the direction of the sun as seen from Earth. It is measured in degrees or radians and varies throughout the year due to the tilt of the Earth's rotational axis and its orbit around the Sun.

### Formula for Solar Declination

The expression for solar declination $\delta$ is given by:

$$
\delta = \arcsin(\sin(\epsilon) \cdot \cos(\omega_{\text{mean}} \cdot (t + 10) + 2\pi \cdot \epsilon_{\text{eccentricity}} \cdot \sin(\omega_{\text{mean}} \cdot (t - 2))))
$$

**Where**:
- $t$ is the time in days since midnight at the start of January 1st, including decimals for local hours later or earlier in the day.
- $\omega_{\text{mean}}$ is the mean angular speed in radians per day.
- $\epsilon_{\text{eccentricity}}$ is the correction for the eccentricity of Earth's orbit.

### MATLAB Code Snippet

```matlab
clear; close all;

p = 30; % Precision in minutes

% Number of points per day
points_per_day = 24 * 60 / p;

% Total number of points for the year
nb_points = 365 * points_per_day;

% Create a vector for the hours of each day according to precision p
% The linspace function creates a vector from 0 to 24 with points_per_day + 1 points, and the last point is removed to avoid redundancy at midnight.
hours_in_day = linspace(0, 24, points_per_day + 1);
hours_in_day(end) = [];

% Repeat this vector for each day of the year
% The repmat function repeats the hours vector for each day of the year.
daily_hours = repmat(hours_in_day, 1, 365);

% Create a vector for the days of the year
% The kron function creates a vector with each day repeated points_per_day times to match the daily hours vector.
days_in_year = kron(0:364, ones(1, points_per_day));

% Combine the day and hour vectors to get the total time vector t
t = days_in_year + daily_hours / 24;  % Converts hours into fractions of days

% Convert obliquity from degrees to radians
epsilon = deg2rad(-23.436);
omega_mean = 2 * pi / 365.24;
epsilon_eccentricity = 0.0167;

% Calculate the solar declination
delta = asin(sin(epsilon) * cos(omega_mean * (t + 10) + 2 * pi * epsilon_eccentricity * sin(omega_mean * (t - 2))));

% Prepare time markers (months)
months = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'};
month_idx = linspace(0, 365, 12);

% Plot declination as a function of time
figure('Position',[1000 100 1500 1000])
plot(t, rad2deg(delta), 'LineWidth', 2);
xticks(month_idx);
xticklabels(months);
xlabel('Months');
xlim([0 365]);
ylabel('Declination (\delta) in degrees');
title('Solar Declination Over Time');
grid on;
```

### Explanation

The graph illustrates the variation of solar declination $\delta$ as a function of time $t$ over the course of the year. The points where the curve reaches its extreme values correspond to the solstices, marking the times of the year when the Earth's axis tilt relative to its orbit plane around the sun is maximal, leading to the most pronounced variations in solar declination. These maxima indicate periods such as the summer solstice in the northern hemisphere, where the sun is highest in the sky, and the winter solstice, where it is lowest. The passages where the curve crosses the horizontal axis correspond to the equinoxes, when the solar declination is zero.

## II. Solar Elevation and Azimuth

### Definitions

- **Hour Angle ($\omega$)**: The hour angle is the measure of the angle between the observer's local meridian and the plane passing through the sun and the celestial pole. It represents the sun's angular position in the sky relative to a fixed reference point on the ground.

### Formula for Solar Elevation

The solar elevation $h$ is given by:

$$
h = \arcsin(\sin(\delta) \cdot \sin(\phi) + \cos(\delta) \cdot \cos(\phi) \cdot \cos(\omega))
$$

### Formula for Azimuth

The azimuth $\alpha$ is given by:

$$
\alpha = \atan2\left(\sin(h), \cos(h) \cdot \sin(\phi) - \tan(\delta) \cdot \cos(\phi)\right)
$$

**Where**:
- $\phi$ is the latitude of the observer.
- $\omega$ is the hour angle.
- $\delta$ is the solar declination.

### MATLAB Code Snippet

```matlab
% Define latitude and longitude in radians
latitude = deg2rad(45);  % Replace with desired latitude
longitude = deg2rad(-75); % Replace with desired longitude, west is negative

% Adjust time for longitude in hours
t_adjusted = t + (longitude * (24 / (2 * pi))); % Adjust t for longitude

% Convert adjusted time to local true solar time
t_hours = mod(t_adjusted * 24, 24); % Modulo 24 to have hours between 0 and 24

% Calculate hour angle in radians for each time point
omega = 2 * pi * (t_hours - 12) / 24; % New formula with adjusted t_hours

% Calculate solar elevation in radians
h = asin(sin(delta) .* sin(latitude) + cos(delta) .* cos(latitude) .* cos(omega));

% Calculate azimuth in radians for each time point
alpha = atan2(sin(h), (cos(h).*sin(latitude) - tan(delta).*cos(latitude)));

% Adjust azimuth based on solar elevation
alpha = alpha + pi * (h < 0);

% Plot solar elevation as a function of time
figure('Position',[1000 100 1500 1000])
plot(t, rad2deg(h), 'LineWidth', 2);
yline(0, 'LineWidth', 2);
xticks(month_idx);
xticklabels(months);
xlabel('Months');
xlim([0 365]);
ylabel('Solar Elevation (h) in degrees');
title('Solar Elevation Over Time');
grid on;
```
![sun_position](https://github.com/user-attachments/assets/5a94e95e-8e70-4791-b287-dc4e47fb5694)


### Finding Solar Events

The solar events like dawn, dusk, and sunrise/sunset are determined based on specific thresholds for solar elevation.

### MATLAB Code Snippet for Solar Events

```matlab
% Thresholds for solar events in radians
thresholds = deg2rad([-18, -12, -6, 0]);  % Astronomical, nautical, civil twilight, and sunrise/sunset

event_names = ["Astronomical Dawn", "Astronomical Dusk", ...
               "Nautical Dawn", "Nautical Dusk", ...
               "Civil Dawn", "Civil Dusk", ...
               "Sunrise", "Sunset"];

% Initialize matrix to store solar event times
solar_event_times =

 NaN(365, length(event_names)); 

% Loop over each day of the year
for day = 1:365
    % Select solar elevation for the current day
    h_day = h((day-1)*points_per_day+1:day*points_per_day);
    
    % Find and record solar event times
    for i = 1:length(thresholds)
        threshold = thresholds(i);
        
        % Dawn - moment when the sun crosses the threshold from below
        dawn_idx = find(diff(sign(h_day - threshold)) > 0, 1, 'first');
        if ~isempty(dawn_idx)
            solar_event_times(day, i*2-1) = t((day-1)*points_per_day + dawn_idx);
        end
        
        % Dusk - moment when the sun crosses the threshold from above
        dusk_idx = find(diff(sign(h_day - threshold)) < 0, 1, 'last');
        if ~isempty(dusk_idx)
            solar_event_times(day, i*2) = t((day-1)*points_per_day + dusk_idx);
        end
    end
end

% Convert times to formatted hours and minutes
format_hours_minutes = @(x) sprintf('%02d:%02d', mod(floor(x*24), 24), round((x*24-floor(x*24))*60));
formatted_times = arrayfun(format_hours_minutes, solar_event_times, 'UniformOutput', false);

% Display results for the first 10 days
for day = 1:10
    fprintf('Day %d:\n', day);
    for event = 1:length(event_names)
        time = formatted_times{day, event};
        if isnan(solar_event_times(day, event))
            time = 'N/A';
        end
        fprintf('%s: %s\n', event_names(event), time);
    end
    fprintf('\n'); % New line to separate days
end
```
![day_length](https://github.com/user-attachments/assets/a441875f-0ea7-4a65-beae-80fd348e8b2c)



**Acknowledgment:** This project utilized ChatGPT to help organize the code and improve documentation.


