
function nopref_synthetic_write(filename, x, y)

OUT = fopen(filename, 'w');
if OUT < 0, error(filename); end;
fprintf(OUT, '%u\t%u\n', [x y]'); 
if fclose(OUT) < 0,  error(filename);  end;
