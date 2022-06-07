set X=-v 1.0 -m 16 -l 0 -a F27E3B22 -b 00003657
for %%f in (%*) do "%~dp0\hca.exe" %X% %%f
echo:
