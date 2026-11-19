import sys, numpy as np
import matplotlib; matplotlib.use('Agg')
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection
from PIL import Image
d=sys.argv[1]; out=sys.argv[2]
base=d+'/Scaniverse_2026_10_28_221757'
V=[];T=[];F=[];FT=[]
for l in open(base+'.obj'):
    p=l.split()
    if not p: continue
    if p[0]=='v': V.append([float(x) for x in p[1:4]])
    elif p[0]=='vt': T.append([float(x) for x in p[1:3]])
    elif p[0]=='f':
        a=[q.split('/') for q in p[1:4]]
        F.append([int(q[0])-1 for q in a]); FT.append([int(q[1])-1 for q in a])
V=np.array(V);T=np.array(T);F=np.array(F);FT=np.array(FT)
img=np.asarray(Image.open(base+'.jpg').convert('RGB'))/255.
H,W,_=img.shape
uv=T[FT].mean(1)
px=np.clip((uv[:,0]*W).astype(int),0,W-1); py=np.clip(((1-uv[:,1])*H).astype(int),0,H-1)
col=img[py,px]
# swap to Z-up for matplotlib: (x, -z, y)
P=V[:,[0,2,1]]*np.array([1,-1,1])
tri=P[F]
views=[(15,-90,'fronte'),(15,0,'lato dx'),(15,180,'lato sx'),(15,90,'retro'),(80,-90,'alto'),(30,-45,'3/4')]
fig=plt.figure(figsize=(18,12))
for i,(e,a,n) in enumerate(views):
    ax=fig.add_subplot(2,3,i+1,projection='3d')
    pc=Poly3DCollection(tri,facecolors=col,edgecolors='none'); ax.add_collection3d(pc)
    mn,mx=P.min(0),P.max(0); c=(mn+mx)/2; r=(mx-mn).max()/2
    ax.set_xlim(c[0]-r,c[0]+r);ax.set_ylim(c[1]-r,c[1]+r);ax.set_zlim(c[2]-r,c[2]+r)
    ax.view_init(e,a); ax.set_title(n); ax.set_box_aspect((1,1,1)); ax.set_facecolor('white')
plt.tight_layout(); plt.savefig(out,dpi=80)
