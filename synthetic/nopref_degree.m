%
% Draw a degree distribution.
%
% PARAMETERS
%	$network
%
% INPUT FILES 
%	dat-nopref/out.$network
%	N
%
% OUTPUT FILES 
%	plot-nopref/degree.$network.eps
%	plot-nopref/bidd.$network.eps
%

network = getenv('network')

n = load('N')

T = load(sprintf('dat-nopref/out.%s', network)); 

m = size(T,1)

%
% Degree distribution 
%

d = sparse([T(:,1) ; T(:,2)], 1, 1, n, 1); 
d = full(d); 
d = d(find(d)); % Remove zero-degree nodes

konect_plot_degdist(d);

%
% Preferential attachment exponent text
%

m_split= floor((2/3) * m) 

T1 = T(1:(m_split - 1), :);
T2 = T(m_split:end, :); 

[beta]  = konect_pa(T1, T2)

text(100, 100, sprintf('beta = %f', beta)); 

%
% Create file
%

konect_print(sprintf('plot-nopref/degree.%s.eps', network));

%
% Complementary cumulated degree distribution 
%

konect_plot_power_law(d); 
xlabel('Degree (d)');
ylabel('P(x \geq d)'); 
set (gca, 'LineWidth', 5); 

konect_print(sprintf('plot-nopref/bidd.%s.eps', network));


