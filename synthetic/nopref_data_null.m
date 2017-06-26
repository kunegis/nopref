DEPRECATED -- use nopref_data_simplex.m 

%
% Generate the Erdős--Rényi network
%
% INPUT FILES 
%	N	Number of nodes
%	M	Number of edges
%
% OUTPUT FILES
%	dat-nopref/out.null	The network
%

n = load('N')
m = load('M') 

m_corrected = 4 * m 

T = randi(n, m_corrected, 2); 

A = sparse(T(:,1), T(:,2), 1);
A = triu(A, 1);
[x y z] = find(A);

x = x(1:m)
y = y(1:m)

nopref_synthetic_write('dat-nopref/out.null', x, y); 

