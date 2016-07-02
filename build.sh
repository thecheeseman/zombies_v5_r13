cd src/
rm ../build/zombies_v5_svr.pk3
rm ../build/zombies_v5_svr_scripts.pk3
7za a -tzip ../build/zombies_v5_svr.pk3 ../README.md ../LICENSE character info weapons zombies.cfg zombies_debug.cfg 
7za a -xr@exclude.txt -tzip ../build/zombies_v5_svr_scripts.pk3 ../README.md ../LICENSE maps zombies utilities.gsc 