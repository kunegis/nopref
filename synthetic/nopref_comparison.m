%
% Comparison plot.
%
% PARAMETERS 
%	$NETWORKS
%
% INPUT FILES 
%	dat-nopref/out.[$NETWORKS]
%
% OUTPUT FILES 
%	plot-nopref/comparison.eps
%

n = load('N')

networks = getenv('NETWORKS'); 
networks = regexp(networks, '[a-zA-Z0-9_-]+', 'match')
assert(length(networks) == 3); 
network_a = networks{1}
network_b = networks{2}
network_c = networks{3}

T_a = load(sprintf('dat-nopref/out.%s', network_a)); 
T_b = load(sprintf('dat-nopref/out.%s', network_b)); 
T_c = load(sprintf('dat-nopref/out.%s', network_c)); 

m_a = size(T_a,1)
m_b = size(T_b,1)
m_c = size(T_c,1)

d_a = full(sparse([T_a(:,1) ; T_a(:,2)], 1, 1, n, 1)); 
d_b = full(sparse([T_b(:,1) ; T_b(:,2)], 1, 1, n, 1)); 
d_c = full(sparse([T_c(:,1) ; T_c(:,2)], 1, 1, n, 1)); 

d_a = d_a(find(d_a)); 
d_b = d_b(find(d_b)); 
d_c = d_c(find(d_c)); 

hold on; 

h = konect_plot_power_law(d_a, [], 0, [1 0   0]); 
h = konect_plot_power_law(d_b, [], 0, [0 0.7 0]); 
h = konect_plot_power_law(d_c, [], 0, [0 0   1]); 

xlabel('Degree (d)');
ylabel('P(x \geq d)'); 
set (gca, 'LineWidth', 5); 

%% legend('Random', 'Tr. clos.', 'Pref. att.', 'Location', 'EastOutside'); 

FN = findall(0,'-property','FontName');
set(FN,'FontName','/usr/share/fonts/truetype/ttf-dejavu/DejaVuSans.ttf'); 
FS = findall(0,'-property','FontSize');
set(FS,'FontSize',19); 

konect_print('plot-nopref/comparison.eps'); 




