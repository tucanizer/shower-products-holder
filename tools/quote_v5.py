import matplotlib; matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle, Circle, Polygon
import numpy as np
fig,(a1,a2)=plt.subplots(1,2,figsize=(19,9),gridspec_kw={'width_ratios':[1.35,1]})
def dim(ax,p1,p2,txt,off=0,col='k',fs=9,horiz=True):
    (x1,y1),(x2,y2)=p1,p2
    if horiz:
        ax.annotate('',xy=(x1,y1+off),xytext=(x2,y2+off),arrowprops=dict(arrowstyle='<->',lw=.9,color=col))
        ax.text((x1+x2)/2,y1+off+1.2,txt,ha='center',va='bottom',fontsize=fs,color=col)
    else:
        ax.annotate('',xy=(x1+off,y1),xytext=(x2+off,y2),arrowprops=dict(arrowstyle='<->',lw=.9,color=col))
        ax.text(x1+off+1.5,(y1+y2)/2,txt,ha='left',va='center',fontsize=fs,color=col,rotation=0)
# ---------------- PIANTA (dall'alto): Y = distanza dal muro verso il basso
ax=a1; Y=lambda y:-y
ax.add_patch(Rectangle((-160,0),265,4,fc='#555')); ax.text(-158,5,'MURO (zero delle misure)',fontsize=9)
ax.add_patch(Rectangle((96,-110),4,114,fc='#555')); ax.text(101,-50,'parete\nlaterale',fontsize=8)
for x0,x1 in ((-145,-22),(22,95)): ax.add_patch(Rectangle((x0,Y(98)),x1-x0,98,fc='#fbe3bf',ec='#a05a00',lw=1.2))
ax.text(-83,-90,'BASE 1',ha='center',fontsize=11,weight='bold',color='#a05a00'); ax.text(58,-90,'BASE 2',ha='center',fontsize=11,weight='bold',color='#a05a00')
ax.add_patch(Rectangle((-30,Y(11)),60,11,fc='#bbb',ec='#888')); ax.text(0,-7,'rosetta',ha='center',fontsize=7)
ax.add_patch(Rectangle((-15.3,Y(83)),30.6,72,fc='#e8e8e8',ec='#999',alpha=.9))
ax.add_patch(Circle((0,Y(32)),5,fc='#888')); ax.text(7,Y(32),'1° flessibile\n(27–37)',fontsize=7,va='center')
ax.add_patch(Circle((0,Y(70)),7,fc='#888')); ax.add_patch(Circle((0,Y(70)),12,fc='none',ec='#555',ls='--')); ax.text(13,Y(73),'doccino +\n2° flessibile\n(63–77)',fontsize=7)
# colonne attuali e proposte
for s in (-1,1):
    ax.add_patch(Rectangle((min(s*15.8,s*29),Y(34.5)),13.2,22,fc='none',ec='#8b4a00',lw=1,ls=':'))
    ax.add_patch(Rectangle((min(s*15.8,s*29),Y(38.5)),13.2,22,fc='#8b4a00',ec='#3d2000',alpha=.85))
# distanziatore attuale e proposto
ax.add_patch(Rectangle((-22,Y(81)),44,20,fc='none',ec='#1f5fbf',ls=':',lw=1.2)); ax.text(-21,Y(80),'attuale 61–81',fontsize=7,color='#1f5fbf')
ax.add_patch(Rectangle((-22,Y(63)),44,13,fc='#1f5fbf',alpha=.75)); ax.text(0,Y(56.5),'distanziatore',ha='center',va='center',fontsize=8,color='white',weight='bold')
# quote lungo Y (a destra della base 2 e a sinistra)
X=-120
dim(ax,(X,Y(0)),(X,Y(98)),'98 profondità',off=0,horiz=False)
xq=-60
for (ya,yb,t,c) in [(0,50,'50',  '#1f5fbf'),(50,63,'13','#1f5fbf')]:
    dim(ax,(xq,Y(ya)),(xq,Y(yb)),t+' mm',horiz=False,col=c); xq+=0
dim(ax,(-40,Y(0)),(-40,Y(16.5)),'16,5',horiz=False,col='#8b4a00'); dim(ax,(-40,Y(16.5)),(-40,Y(38.5)),'22 gancio',horiz=False,col='#8b4a00')
ax.text(-150,-104,'Tratteggiato = prototipo v4.  Pieno = v5 definitiva.  Misure in mm dal muro.',fontsize=9)
ax.set_xlim(-162,118); ax.set_ylim(-110,12); ax.set_aspect('equal'); ax.axis('off'); ax.set_title('PIANTA (vista dall\'alto, muro in alto)',fontsize=12,weight='bold')
# ---------------- SEZIONE laterale: y orizzontale dal muro, z verticale (asse raccordo = 0)
ax=a2
ax.add_patch(Rectangle((-5,-120),5,320,fc='#555')); ax.text(-4,185,'MURO',rotation=90,fontsize=9,color='w',va='top')
ax.add_patch(Rectangle((0,-30),11,60,fc='#bbb',ec='#888')); ax.text(1,32,'rosetta',fontsize=7)
ax.add_patch(Rectangle((11,-15.3),72,30.6,fc='#e8e8e8',ec='#999'))
ax.text(40,-4,'raccordo',fontsize=8,ha='center')
ax.add_patch(Rectangle((27,-120),10,105,fc='#999',alpha=.7)); ax.add_patch(Rectangle((63,-120),14,105,fc='#999',alpha=.7))
ax.add_patch(Rectangle((58,15),24,165,fc='#cfcfcf',ec='#888')); ax.text(70,100,'doccino',rotation=90,ha='center',fontsize=8)
# gancio + colonna (proposta) e attuale
ax.add_patch(Rectangle((12.5,-78),22,107.3,fc='none',ec='#8b4a00',ls=':',lw=1.2))
ax.add_patch(Rectangle((16.5,-78),22,107.3,fc='#8b4a00',alpha=.8)); ax.text(27.5,40,'gancio +\ncolonna',ha='center',fontsize=8)
# base (proiezione) definitiva: fondo a -78, pareti fino a -28 dietro
ax.add_patch(Polygon([(0,-78),(98,-78),(98,-8),(0,-18)],closed=True,fc='#fbe3bf',ec='#a05a00',alpha=.6,lw=1.2))
th=np.linspace(np.pi,2*np.pi,30)
ax.text(80,-70,'base\n(dietro al raccordo)',fontsize=7,ha='center',color='#a05a00')
ax.add_patch(Rectangle((61,-78),20,10,fc='none',ec='#1f5fbf',ls=':',lw=1.2))
ax.text(2,-30,'smusso sotto\nla rosetta',fontsize=7,color='darkred')
ax.add_patch(Rectangle((50,-78),13,10,fc='#1f5fbf',alpha=.8))
dim(ax,(0,-92),(50,-92),'50',col='#1f5fbf'); dim(ax,(50,-92),(63,-92),'13',col='#1f5fbf')
dim(ax,(0,-104),(98,-104),'98')
dim(ax,(0,60),(16.5,60),'16,5',col='#8b4a00'); dim(ax,(16.5,60),(38.5,60),'22',col='#8b4a00')
dim(ax,(105,0),(105,-78),'78 asse → fondo',horiz=False); dim(ax,(118,-78),(118,-8),'70 davanti',horiz=False,col='darkred')
dim(ax,(-15,-78),(-15,-18),'60 dietro',horiz=False,col='darkred')
ax.axhline(0,color='k',lw=.4,ls='-.'); ax.text(120,1,'asse raccordo',fontsize=7)
ax.set_xlim(-25,150); ax.set_ylim(-125,190); ax.set_aspect('equal'); ax.axis('off'); ax.set_title('SEZIONE DI LATO (muro a sinistra)',fontsize=12,weight='bold')
plt.tight_layout(); plt.savefig('/mnt/user-data/outputs/v5/quote_v5.png',dpi=120)
