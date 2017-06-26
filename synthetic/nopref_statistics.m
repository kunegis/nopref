%
% Compute all statistics for one network.
%
% PARAMETERS
%	$network
%
% INPUT FILES 
% 	dat-nopref/out.$network
%
% OUTPUT FILES
% 	dat-nopref/statistics.$network
%		.stat.$statistic
%

network = getenv('network') 

consts = konect_consts(); 

T = load(sprintf('dat-nopref/out.%s', network)); 

assert(size(T,2) == 2); 

stat = struct(); 

stat.prefatt = konect_pa(T);

n = max(max(T)); 
A = sparse(T(:,1), T(:,2), 1, n, n); 

stat.gini = konect_statistic_gini(A, consts.SYM, consts.UNWEIGHTED); 

save(sprintf('dat-nopref/statistics.%s', network), 'stat'); 
