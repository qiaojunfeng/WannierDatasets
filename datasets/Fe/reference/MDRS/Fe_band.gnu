set style data dots
set nokey
set xrange [0:10.17192]
set yrange [  7.87373 : 42.87171]
set arrow from  2.18927,   7.87373 to  2.18927,  42.87171 nohead
set arrow from  3.73732,   7.87373 to  3.73732,  42.87171 nohead
set arrow from  5.28536,   7.87373 to  5.28536,  42.87171 nohead
set arrow from  7.18132,   7.87373 to  7.18132,  42.87171 nohead
set arrow from  9.07729,   7.87373 to  9.07729,  42.87171 nohead
set xtics ("G"  0.00000,"H"  2.18927,"N"  3.73732,"G"  5.28536,"P"  7.18132,"H|P"  9.07729,"N" 10.17192)
 plot "Fe_band.dat"
