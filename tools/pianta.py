import trimesh, numpy as np, matplotlib; matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Polygon, Circle, Rectangle, FancyBboxPatch
t=trimesh.load('/home/claude/portashampoo/v2/out/rapido.stl')
fig,ax=plt.subplots(figsize=(15,7.5))
def draw(z,fc,ec,lw=0.8,alpha=1):
    s=t.section(plane_origin=[0,0,z],plane_normal=[0,0,1])
    p2,_=s.to_2D(to_2D=np.eye(4))
    for p in p2.polygons_full:
        ax.add_patch(Polygon(np.array(p.exterior.coords),closed=True,fc=fc,ec=ec,lw=lw,alpha=alpha))
        for h in p.interiors: ax.add_patch(Polygon(np.array(h.coords),closed=True,fc='white',ec=ec,lw=lw))
draw(-98,'#c97800','#7a4200')           # bordino
draw(-107,'#f4a836','#a05a00')          # fondo (cornici + traversine)
draw(-40,'#8b4a00','#3d2000')           # montanti
# muro, parete, rosetta, raccordo, flessibili, doccino (vista dall'alto)
ax.add_patch(Rectangle((-175,0),275,5,fc='#555',ec='none')); ax.text(-170,7,'MURO (piastrelle)',fontsize=10,color='#333')
ax.add_patch(Rectangle((80,-100),5,105,fc='#555',ec='none')); ax.text(86,-60,'PARETE\nLATERALE',fontsize=9,color='#333')
ax.add_patch(Rectangle((-30,-8),60,8,fc='#bbb',ec='#888')); ax.text(-28,-6.5,'rosetta',fontsize=7)
ax.add_patch(Rectangle((-15.3,-80),30.6,72,fc='#ddd',ec='#888',alpha=.8)); ax.text(-13,-78,'raccordo',fontsize=7,rotation=90)
ax.add_patch(Circle((0,-29),5,fc='#999',ec='k',lw=.5)); ax.add_patch(Circle((0,-67),7,fc='#999',ec='k',lw=.5)); ax.add_patch(Circle((0,-67),12,fc='none',ec='#666',ls='--'))
ax.annotate('flessibili + doccino',xy=(0,-67),xytext=(-5,-118),fontsize=8,ha='center',arrowprops=dict(arrowstyle='->',lw=.7))
# celle numerate
L0,L1=-150,-22; xs=[L0,L0+128/3,L0+2*128/3,L1]; ym=-47.5
cells=[]
for i in range(3):
    for (ya,yb) in [(-10,ym),(ym,-85)]:
        cells.append(((xs[i]+xs[i+1])/2,(ya+yb)/2))
for (ya,yb) in [(-10,ym),(ym,-85)]: cells.append(((22+79)/2,(ya+yb)/2))
order=[0,1,2,3,4,5,6,7]
labels=['1','2','3','4','5','6','7','8']
for k,(cx,cy) in enumerate(cells):
    ax.add_patch(Circle((cx,cy),6.5,fc='white',ec='#1f5fbf',lw=1.5)); ax.text(cx,cy,labels[k],ha='center',va='center',fontsize=12,color='#1f5fbf',weight='bold')
ax.text(-25.5,-45,'A',fontsize=13,weight='bold',color='darkred',ha='center'); ax.text(25.5,-45,'A',fontsize=13,weight='bold',color='darkred',ha='center')
ax.text(0,-92,'B = varco',fontsize=10,weight='bold',color='darkred',ha='center')
for px in (-150,-51,33,61): ax.text(px+9,-5.5,'P',fontsize=10,weight='bold',color='darkgreen',ha='center',va='center')
ax.set_xlim(-180,105); ax.set_ylim(-125,15); ax.set_aspect('equal'); ax.axis('off')
ax.set_title('Prototipo veloce v2 visto DALL\'ALTO (muro in alto, tu in basso)  —  A = montanti dell\'arco, B = varco dei flessibili, P = piedini, 1–8 = quadratini del fondo',fontsize=11)
plt.tight_layout(); plt.savefig('/mnt/user-data/outputs/pianta_prototipo_v2.png',dpi=130)
