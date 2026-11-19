import trimesh, numpy as np, matplotlib; matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon, Circle, Rectangle, FancyBboxPatch
t=trimesh.load('/home/claude/portashampoo/v4/out/rapido.stl')
fig,ax=plt.subplots(figsize=(15,7.5))
def draw(z,fc,ec,lw=0.8,alpha=1):
    s=t.section(plane_origin=[0,0,z],plane_normal=[0,0,1])
    p2,_=s.to_2D(to_2D=np.eye(4))
    for p in p2.polygons_full:
        ax.add_patch(Polygon(np.array(p.exterior.coords),closed=True,fc=fc,ec=ec,lw=lw,alpha=alpha))
        for h in p.interiors: ax.add_patch(Polygon(np.array(h.coords),closed=True,fc='white',ec=ec,lw=lw))
draw(-68,'#c97800','#7a4200')           # bordino
draw(-77,'#f4a836','#a05a00')          # fondo (cornici + traversine)
draw(-40,'#8b4a00','#3d2000')           # montanti
# muro, parete, rosetta, raccordo, flessibili, doccino (vista dall'alto)
ax.add_patch(Rectangle((-175,0),275,5,fc='#555',ec='none')); ax.text(-170,7,'MURO (piastrelle)',fontsize=10,color='#333')
ax.add_patch(Rectangle((96,-100),5,105,fc='#555',ec='none')); ax.text(102,-60,'PARETE\nLATERALE',fontsize=9,color='#333')
ax.add_patch(Rectangle((-30,-11),60,11,fc='#bbb',ec='#888')); ax.text(-28,-6.5,'rosetta',fontsize=7)
ax.add_patch(Rectangle((-15.3,-83),30.6,72,fc='#ddd',ec='#888',alpha=.8)); ax.text(-13,-78,'raccordo',fontsize=7,rotation=90)
ax.add_patch(Circle((0,-32),5,fc='#999',ec='k',lw=.5)); ax.add_patch(Circle((0,-70),7,fc='#999',ec='k',lw=.5)); ax.add_patch(Circle((0,-70),12,fc='none',ec='#666',ls='--'))
ax.annotate('flessibili + doccino',xy=(0,-70),xytext=(-5,-118),fontsize=8,ha='center',arrowprops=dict(arrowstyle='->',lw=.7))
# celle numerate (v4)
L0,L1=-145,-22; xs=[L0,L0+123/3,L0+2*123/3,L1]; ym=-49
cells=[]
for i in range(3):
    for (ya,yb) in [(-6,ym),(ym,-90)]:
        cells.append(((xs[i]+xs[i+1])/2,(ya+yb)/2))
for (ya,yb) in [(-6,ym),(ym,-90)]: cells.append(((22+95)/2,(ya+yb)/2))
labels=['1','2','3','4','5','6','7','8']
for k,(cx,cy) in enumerate(cells):
    ax.add_patch(Circle((cx,cy),6.5,fc='white',ec='#1f5fbf',lw=1.5)); ax.text(cx,cy,labels[k],ha='center',va='center',fontsize=12,color='#1f5fbf',weight='bold')
ax.text(2.5,-71,'distanziatore',fontsize=8,color='white',ha='center',va='center',weight='bold')
ax.text(-25.5,-45,'A',fontsize=13,weight='bold',color='darkred',ha='center'); ax.text(25.5,-45,'A',fontsize=13,weight='bold',color='darkred',ha='center')
ax.text(0,-92,'B = varco',fontsize=10,weight='bold',color='darkred',ha='center')

ax.set_xlim(-180,125); ax.set_ylim(-125,15); ax.set_aspect('equal'); ax.axis('off')
ax.set_title('Prototipo veloce v4 visto DALL\'ALTO (muro in alto, tu in basso)  —  A = montanti dell\'arco, B = varco dei flessibili, 1–8 = quadratini, distanziatore tra 6 e 8',fontsize=11)
plt.tight_layout(); plt.savefig('/mnt/user-data/outputs/pianta_v4.png',dpi=130)
