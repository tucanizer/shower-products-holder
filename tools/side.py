import numpy as np, matplotlib; matplotlib.use('Agg'); import matplotlib.pyplot as plt
from matplotlib.patches import Polygon, Rectangle, Circle
R=15.3; ytab=55
box=np.array([[0,0],[100,0],[100,129.7],[2.5,129.7],[2.5,174.7],[0,174.7]])
piv=np.array([1.25,174.2])
def place(th):
    t=np.radians(th); d=box-piv
    y=d[:,0]*np.cos(t)+d[:,1]*np.sin(t); z=-d[:,0]*np.sin(t)+d[:,1]*np.cos(t)
    return np.c_[y+ytab, z+R]
fig,axs=plt.subplots(1,2,figsize=(13,6.5))
for ax,th,tit in [(axs[0],0,'Come lo hai disegnato'),(axs[1],14,'Come si mette davvero: il peso sta davanti all anello,\nil box ruota e il fondo schiaccia il flessibile sul muro')]:
    ax.add_patch(Rectangle((-15,-260),15,320,color='0.35'))
    ax.add_patch(Rectangle((0,-30),8,60,color='0.6'))
    ax.add_patch(Rectangle((0,-R),78,2*R,color='0.75'))
    ax.add_patch(Rectangle((30,-250),14,250-R+2,color='0.15'))
    ax.add_patch(Polygon(place(th),closed=True,fc=(1,0.6,0,0.55),ec='darkorange',lw=2))
    ax.plot(*place(0)[[0,1,2,3,4,5,0]].T,'--',color='0.5',lw=1) if th else None
    ax.set_xlim(-20,190); ax.set_ylim(-250,50); ax.set_aspect('equal'); ax.set_title(tit,fontsize=11)
    ax.set_xlabel('distanza dal muro (mm)'); ax.grid(alpha=.3)
    ax.text(2,-245,'muro',color='w',fontsize=9,rotation=90)
    ax.text(31,-240,'flessibile',color='w',fontsize=8,rotation=90)
axs[1].annotate('~13-14°',xy=(70,-150),fontsize=11,color='darkred')
plt.tight_layout(); plt.savefig('bagno/nico_lato_schema.png',dpi=100)
