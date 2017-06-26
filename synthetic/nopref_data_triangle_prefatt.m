DEPRECATED -- use nopref_data_simplex.m 

%
% Generate a network with both triangle closing and preferential
% attachment.  
%
% INPUT FILES 
%	N, M
%
% OUTPUT FILES 
%	dat-nopref/out.triangle_prefatt
%

p = 0.2; % Probability of triangle closing
q = 0.7; % Probability of preferential attachment 

n = load('N')
m = load('M')

A = zeros(n,n); 
% Adjancency matrix
% Always in upper triangular form

xx = [];  yy = [];
% The two columns of the corresponding T matrix, sorted by timestamps 

d = zeros(n,1);
% Degree vector 

w = zeros(n,1);
% By node, the number of wedges centered on that node

ws = 0;
% Number of wedges

while nnz(A) < m

  fprintf(1, '|A| = %u, ws = %u\n', nnz(A), ws); 

  r = rand;

  if rand < p
    % Close a random triangle
    % Choose a node proportionally to the number of wegdes centered on that node
    fprintf(1, 'random triangle closing\n'); 
    if ws == 0,  
      fprintf(1, '\tno wedges\n'); 
      continue;  
    end
    x = 1 + nnz(ws * rand > cumsum(w));   % Central node of the wedge
    fprintf(1, '\tx = %u\n', x); 
    fprintf(1, '\td(x) = %u\n', d(x)); 
    fprintf(1, '\tw(x) = %u\n', w(x)); 
    assert(w(x) >= 1); 
    assert(d(x) >= 2);
    ui = randi(d(x));
    s = find(A(x,:)' + A(:,x));
    u = s(ui);
    vi = randi(d(x) - 1);
    if vi >= ui,  vi = vi + 1;  end
    v = s(vi);
    if u > v,  
       tmp = u;
       u = v;
       v = tmp;
    end
    if A(u,v) == 1,  continue;  end
  elseif r < p + q
    % Add a preferential attachment edge
    fprintf(1, 'preferential attachment\n'); 
    if nnz(A) == 0
       fprintf(1, '\no edges\n'); 
       continue;
    end
    u = 1 + nnz(nnz(A) * rand > cumsum(d)); 
    added = 0;
    while ~added
      v = randi(n);
      if u == v,  continue;  end
      if u > v, 
	 tmp = u;
	 u = v;
	 v = tmp;
      end
      if A(u,v),  continue;  end
      added = 1;
    end
  else
    % Add random edge 
    fprintf(1, 'random edge\n'); 
    added = 0;
    while ~added
      u = randi(n);
      v = randi(n);
      if ~ (u < v),  continue;  end
      if A(u,v),     continue;  end
      added = 1; 
    end
  end

  fprintf(1, '\tadd(%u, %u)\n', u, v); 
  assert(u < v); 

  A(u,v) = 1;
  xx = [xx ; u];
  yy= [yy ; v]; 

  w(u) = w(u) + d(u);
  w(v) = w(v) + d(v);
  ws = ws + d(u) + d(v); 
  d(u) = d(u) + 1;
  d(v) = d(v) + 1; 

  assert(2 * nnz(A) == sum(d));
  assert(sum(d .* (d-1)) == 2 * ws); 
end

nopref_synthetic_write('dat-nopref/out.triangle_prefatt', xx, yy); 
