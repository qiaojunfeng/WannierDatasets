import pylab as pl
import numpy as np
from matplotlib.gridspec import GridSpec
tick_labels=[]
tick_locs=[]
tick_labels.append('$\Gamma$')
tick_locs.append(0)
tick_labels.append(' H'.strip())
tick_locs.append(    2.189269)
tick_labels.append(' N'.strip())
tick_locs.append(    3.737316)
tick_labels.append('$\Gamma$')
tick_locs.append(    5.285362)
tick_labels.append(' P'.strip())
tick_locs.append(    7.181325)
tick_labels.append('H'.strip())
tick_locs.append(    9.077287)
tick_labels.append(' N'.strip())
tick_locs.append(   10.171922)
fig = pl.figure()
gs = GridSpec(2, 1,hspace=0.00)
axes1 = pl.subplot(gs[0, 0:])
data = np.loadtxt('Fe-bands.dat')
x=data[:,0]
y=data[:,1]-   17.216700
z=data[:,2]
pl.scatter(x,y,c=z,marker='+',s=1,cmap=pl.cm.jet)
pl.xlim([0,max(x)])
pl.ylim([-0.65,0.65]) # Adjust this range as needed
pl.plot([tick_locs[0],tick_locs[-1]],[0,0],color='black',linestyle='--',linewidth=0.5)
pl.xticks(tick_locs,tick_labels)
for n in range(1,len(tick_locs)):
   pl.plot([tick_locs[n],tick_locs[n]],[pl.ylim()[0],pl.ylim()[1]],color='gray',linestyle='-',linewidth=0.5)
pl.ylabel('Energy$-$E$_F$ [eV]')
pl.tick_params(axis='x',which='both',bottom='off',top='off',labelbottom='off')
axes2 = pl.subplot(gs[1, 0:])
data = np.loadtxt('Fe-curv.dat')
x=data[:,0]
y=data[:,2]
pl.plot(x,y,color='k')
pl.xlim([0,max(x)])
pl.ylim([min(y)-0.025*(max(y)-min(y)),max(y)+0.025*(max(y)-min(y))])
pl.xticks(tick_locs,tick_labels)
for n in range(1,len(tick_locs)):
   pl.plot([tick_locs[n],tick_locs[n]],[pl.ylim()[0],pl.ylim()[1]],color='gray',linestyle='-',linewidth=0.5)
pl.ylabel('$-\Omega_y(\mathbf{k})$  [ $\AA^2$ ]')
outfile = 'Fe-bands+curv_y.pdf'
pl.savefig(outfile,bbox_inches='tight')
pl.show()
