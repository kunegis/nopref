%
% Create one simplex dataset.
%
% A denotes the amount of randomness;
% B denotes the amount of triangle closing; and
% C denotes the amount of preferential attachment.
%
% PARAMETERS 
%	$abc	The case, i.e., six digits
%
% INPUT FILES 
%	N, D
%	SIMPLEX-MAX
% 
% OUTPUT FILES
% 	dat-nopref/out.simplex_$abc
%

abc = getenv('abc')

k = length(abc) / 3  % Number of digits per number          

a = 0;  b = 0;  c = 0; 
for i = 1 : k
    a = a * 10;  
    b = b * 10;
    c = c * 10;
    a = a + abc(0 * k + i) - '0';
    b = b + abc(1 * k + i) - '0';
    c = c + abc(2 * k + i) - '0'; 
end

a
b
c 

q = load('SIMPLEX-MAX')

assert(a >= 1 & a <= q); % Randomness is never zero
assert(b >= 0 & b <= q);
assert(c >= 0 & c <= q); 

assert(a + b + c == q); 

n     = load('N')
d     = load('D')
m_max = n * d / 2

p_random   = a / q
p_triangle = b / q
p_prefatt  = c / q

% The network is undirected and loopless.

A = zeros(n,n); 
% Half-adjancency matrix
% Always in upper triangular form

xx = [];  yy = [];
% The two columns of the corresponding T matrix, 
% sorted by timestamps 

% Keep track of values per node:
dd = zeros(n,1);  % Degree 
ss = zeros(n,1);  % Number of wedges centered on node
tt = zeros(n,1);  % Number of triangles at node

% Keep track of total numbers: 
s = 0;  % Number of wedges
t = 0;  % Number of triangles

m_alt = 0;
% Number of times we used another method to add an edge
% because the method could not be applied.  (E.g., triangle
% closing cannot be done if there are not wegdes.)

while nnz(A) < m_max

  fprintf(1, 'm/m_max = %u/%u\t', ...
	  nnz(A), m_max); 

  r = rand; % In [0,1)

  if r < p_random
    % Add random edge 
    fprintf(1, 'random edge\n'); 
    added = 0;
    while ~added
      u = randi(n);
      v = randi(n);
      if u == v,  continue;  end; 
      if ~(u < v),  tmp= u;  u= v;  v= tmp;  end
      if A(u,v),   continue;  end
      added = 1; 
    end

  elseif r < p_random + p_triangle
    % Close a random triangle
    % Choose a node proportionally to the number of wegdes 
    % minus number of triangles centered on that node 
    fprintf(1, 'random triangle closing\n'); 
    
    % Number of unclosed wegdes per node
    uu = ss - tt;  
    assert(sum(uu < 0) == 0); 
    uu_count = sum(uu); 

    if uu_count == 0,  
      fprintf(1, '\tno unclosed wedges -- adding a random edge\n'); 
      m_alt = m_alt + 1; 
      added = 0;
      while ~added
	u = randi(n);
	v = randi(n);
	if u == v,  continue;  end; 
	if ~(u < v),  tmp= u;  u= v;  v= tmp;  end
	if A(u,v),   continue;  end
	added = 1; 
      end
    else

      % Central node of the unclosed wedge   
      x = 1 + nnz(uu_count * rand > cumsum(uu)); 

      assert(ss(x) >= 1); 
      assert(dd(x) >= 2);
      assert(uu(x) >= 1); 

      x_ii = find(A(x,:)' + A(:,x)); 
      A_xx = A(x_ii, x_ii);  % Symmetric neighbourhood subadjacency matrix
      A_xx = 1 - A_xx;  % Invert
      A_xx = triu(A_xx, 1); % Keep only upper triangular part, without diagonal 
      [uuu vvv zzz] = find(A_xx); 
      kkk = size(uuu,1); 
      assert(kkk == uu(x)); 
      iii = randi(kkk);
      u = x_ii(uuu(iii)); 
      v = x_ii(vvv(iii)); 
      assert(sum((A(u,:)'+A(:,u)) .* (A(v,:)'+A(:,v))) >= 1); 
    end

  else % r_prefatt <= r < 1
    % Add a preferential attachment edge
    fprintf(1, 'preferential attachment\n'); 
    if nnz(A) == 0
      fprintf(1, '\tno edges -- adding a random edge\n'); 
      m_alt = m_alt + 1; 
      added = 0; 
      while ~added 
	u = randi(n);
	v = randi(n);
	if u == v,  continue;  end; 
	if ~(u < v),  tmp = u;  u = v;  v = tmp;  end
	if A(u,v),  continue;  end
	added = 1; 
      end
    else
      added = 0;
      while ~added
	u = 1 + nnz(nnz(A) * rand > cumsum(dd)); 
	assert(dd(u) <= n-1); 
	% The edge is already saturated; skip
	if dd(u) == n-1,  continue;  end
	v_possible = (A(:,u)+A(u,:)') == 0;
	v_possible(u) = 0;
	vi = find(v_possible);
	assert(length(vi) >= 1);
	v = vi(randi(length(vi)));
	assert(u ~= v);
	if u > v,  tmp = u; u = v; v = tmp;  end
	added = 1; 
      end
    end
  end
  
  %
  % Actually add the edge 
  %
  
  assert(u < v); 

  ss(u) = ss(u) + dd(u);
  ss(v) = ss(v) + dd(v);
  s = s + dd(u) + dd(v); 

  ti = find((A(u,:)' + A(:,u)) .* (A(v,:)' + A(:,v))); 
  % Indexes of common neighbours 

  t = t + length(ti);
  tt(ti) = tt(ti) + 1;  
  tt(u) = tt(u) + length(ti);
  tt(v) = tt(v) + length(ti); 

  dd(u) = dd(u) + 1;
  dd(v) = dd(v) + 1; 

  A(u,v) = 1;
  xx = [xx ; u];
  yy = [yy ; v]; 

  assert(2 * nnz(A) == sum(dd));
  assert(sum(dd .* (dd-1)) == 2 * s); 
  assert(sum(ss) == s); 
  assert(sum(tt) == 3 * t); 
end

fprintf(1, 'Alternative method used in %02.3f%% of cases (%u/%u)\n', 100 * m_alt / m_max, m_alt, m_max); 

nopref_synthetic_write...
  (sprintf('dat-nopref/out.simplex_%s', abc), xx, yy); 

