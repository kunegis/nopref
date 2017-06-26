%
% Draw the simplex of \beta values for all combinations of networks.
%
% PARAMETERS 
%	$statistic
%
% INPUT FILES
%	SIMPLEX-MAX
%	dat-nopref/statistics.simplex_$abc for all variants 
%
% OUTPUT FILES 
% 	plot-nopref/simplex.$statistic.[a].eps
%

statistic = getenv('statistic') 

s = load('SIMPLEX-MAX')

%
% Get all numbers 
%

% entry (1+b, 1+c) is the statistic
stat = zeros(1+s, 1+s); 

l = length(sprintf('%u', s))
forma = sprintf('%%0%uu', l) 

for a = 1:s
    for b = 0:(s-a)
	c = s - a - b;
	a
	b
	c

	ap = sprintf(forma, a)
	bp = sprintf(forma, b)
	cp = sprintf(forma, c)

	filename = sprintf('dat-nopref/statistics.simplex_%s%s%s', ...
			   ap, bp, cp)
	data = load(filename)
	stat(1+b, 1+c) = data.stat.(statistic);
    end
end

stat

%
% Plot
% 

color_no = [0 0 1]; 

hold on;

axis equal;
axis([(-1/s), (1+1/s), (-1/s), (sqrt(3)/2+1/s)]);

for a = 1:s
    for b = 0:(s-a)
	c = s - a - b;
	
	a
	b
	c

	% Draw a hexagon for all cases

	value = stat(1+b, 1+c)

	color = [1 1 1] * value / max(max(stat))

	% Center point
	x = (a / 2 + b) / s
	y = (a * sqrt(3) / 2) / s
	xx = [0, 1/2, 1/2, 0, -1/2, -1/2] / s + x
	yy = [1/sqrt(3), 1/sqrt(12), -1/sqrt(12), -1/sqrt(3), -1/sqrt(12), 1/sqrt(12)] / s + y
	fill(xx, yy, [1 1 1], 'FaceColor', color);
    end
end

% Draw crossed-out hexagons
for c = 0:s
    x = (s-c) / s;
    y = 0;
    xx = [0, 1/2, 1/2, 0, -1/2, -1/2] / s + x
    yy = [1/sqrt(3), 1/sqrt(12), -1/sqrt(12), -1/sqrt(3), -1/sqrt(12), 1/sqrt(12)] / s + y
    fill(xx, yy, [1 1 1], 'FaceColor', color_no); 
end

% Texts
f = 0.2;
text(0.5, sqrt(3)/2+1/sqrt(3)/s + f/s, 'Random = 100%',       'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
text(-1/2/s  - f/s, 0,                 'Pref. att. = 100%',   'HorizontalAlignment', 'right',  'VerticalAlignment', 'middle');
text(1+1/2/s + f/s, 0,                 'Tr. cl. = 100%',      'HorizontalAlignment', 'left',   'VerticalAlignment', 'middle');

% Legend
L = 5; % Number of legend items
q = 1/(L-1)*(sqrt(3)/2-1/2)/1; % Inner radius of legend hexagon
x = 0.95; % X-coordinate of the whole legend 
r = 1.0; % Determines space between legend text and legend hexagon

y = 1/2 - 1/(L-1)*(sqrt(3)/2-1/2);
xx = [0, 1/2, 1/2, 0, -1/2, -1/2] * q + x
yy = [1/sqrt(3), 1/sqrt(12), -1/sqrt(12), -1/sqrt(3), -1/sqrt(12), 1/sqrt(12)] * q + y
fill(xx, yy, [1 1 1], 'FaceColor', color_no); 
text(x+q*r, y, 'Not computed', ...
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle'); 
for i = L:-1:1
    y = 1/2 + (L-i)/(L-1)*(sqrt(3)/2-1/2);
    xx = [0, 1/2, 1/2, 0, -1/2, -1/2] * q + x
    yy = [1/sqrt(3), 1/sqrt(12), -1/sqrt(12), -1/sqrt(3), -1/sqrt(12), 1/sqrt(12)] * q + y
    color = [1 1 1] * (i-1)/(L-1) 
    fill(xx, yy, [1 1 1], 'FaceColor', color); 
    text(x+q*r, y, sprintf('%.2f', (i-1)/(L-1)*max(max(stat))), ...
	 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle'); 
end

text(x+q*r, 1/2 + L/(L-1)*(sqrt(3)/2-1/2), ...
     sprintf('%s =', statistic), ...
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');


axis off;

FN = findall(0,'-property','FontName');
set(FN,'FontName','/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf'); 
FS = findall(0,'-property','FontSize');
set(FS,'FontSize',14);

konect_print(sprintf('plot-nopref/simplex.%s.a.eps', statistic)); 
