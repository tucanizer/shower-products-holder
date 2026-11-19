import sys, numpy as np
base=sys.argv[1]+'/Scaniverse_2026_10_28_221757'
V=[];F=[]
for l in open(base+'.obj'):
    if l.startswith('v '): V.append([float(x) for x in l.split()[1:4]])
    elif l.startswith('f '): F.append([int(q.split('/')[0])-1 for q in l.split()[1:4]])
V=np.array(V);F=np.array(F)
p=np.load(sys.argv[2]); n1,d1,n2,d2=p[:3],p[3],p[4:7],p[7]
# frame: w = wall1 normal, v = up (orthogonalized y), u = v x w
up=np.array([0,1,0.]); v=up-(up@n1)*n1; v/=np.linalg.norm(v)
w1=V@n1+d1
# corner line: intersection; distance from wall2
w2=V@n2+d2
# orient normals: wall1 normal toward side where wall2 sits? use fitting protrusion: count of points with |w1|>1cm near y 0.2-0.3
sel=(V[:,1]>0.2)&(V[:,1]<0.32)&(V[:,0]>0.03)&(V[:,0]<0.13)
print('fitting region w1 stats',np.percentile(w1[sel],[1,5,50,95,99]))
sgn=np.sign(np.median(w1[sel][np.abs(w1[sel])>0.01])) ; print('sgn',sgn)
w1*=sgn; n1s=n1*sgn
u=np.cross(v,n1s)
U=V@u; Vv=V@v
# where is corner (wall2) in u
on2=np.abs(w2)<0.004
print('wall2 u range',np.percentile(U[on2],[5,50,95]), 'w1 range on wall2',np.percentile(w1[on2],[5,50,95]))
on1=np.abs(w1)<0.004
print('wall1 u range',U[on1].min(),U[on1].max(),'v range',Vv[on1].min(),Vv[on1].max())
# protruding points
pr=w1>0.006
P=np.c_[U,Vv,w1][pr]
# grid histogram of protrusion
import collections
print('protruding pts',pr.sum())
H,xe,ye=np.histogram2d(P[:,0],P[:,1],bins=[40,40])
idx=np.argwhere(H>5)
for i,j in idx: pass
# simple clustering by DBSCAN-like grid
from scipy.ndimage import label
lab,nl=label(H>2)
for k in range(1,nl+1):
    m=np.argwhere(lab==k); 
    cnt=H[lab==k].sum()
    if cnt<30: continue
    xs=xe[m[:,0]];ys=ye[m[:,1]]
    inb=(P[:,0]>=xs.min())&(P[:,0]<=xs.max()+(xe[1]-xe[0]))&(P[:,1]>=ys.min())&(P[:,1]<=ys.max()+(ye[1]-ye[0]))
    Q=P[inb]
    print(f'cluster {k}: n={len(Q)} u[{Q[:,0].min():.3f},{Q[:,0].max():.3f}] v[{Q[:,1].min():.3f},{Q[:,1].max():.3f}] wmax={Q[:,2].max():.3f} w95={np.percentile(Q[:,2],95):.3f}')
np.save(sys.argv[3],np.c_[U,Vv,w1,w2*np.sign(np.median(w2))])
