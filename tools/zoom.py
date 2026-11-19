import sys, numpy as np
import matplotlib; matplotlib.use('Agg'); import matplotlib.pyplot as plt
L=np.load(sys.argv[1]); U,Vv,W,W2=L.T
m=(U>-0.01)&(U<0.17)&(Vv>0.0)&(Vv<0.33)&(W>-0.005)&(W<0.1)
fig,ax=plt.subplots(1,2,figsize=(14,7))
ax[0].scatter(U[m]*1000,Vv[m]*1000,c=W[m]*1000,s=1,cmap='viridis',vmin=0,vmax=75); ax[0].set_aspect('equal'); ax[0].set_title('Fronte (colore = sporgenza dal muro, mm)'); ax[0].set_xlabel('u mm (angolo a 159)'); ax[0].set_ylabel('altezza mm')
m2=m&(U>0.03)&(U<0.11)
ax[1].scatter(W[m2]*1000,Vv[m2]*1000,s=1,c='k'); ax[1].set_aspect('equal'); ax[1].set_title('Lato (muro a sinistra, x=0)'); ax[1].set_xlabel('sporgenza mm'); ax[1].axvline(0,color='r')
for a in ax: a.grid(True)
plt.tight_layout(); plt.savefig(sys.argv[2],dpi=90)
