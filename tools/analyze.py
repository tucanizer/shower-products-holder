import sys, numpy as np
base=sys.argv[1]+'/Scaniverse_2026_10_28_221757'
V=[]
for l in open(base+'.obj'):
    if l.startswith('v '): V.append([float(x) for x in l.split()[1:4]])
V=np.array(V)
rng=np.random.default_rng(0)
def ransac(P,it=3000,th=0.004):
    best=None;bc=0
    for _ in range(it):
        s=P[rng.choice(len(P),3,replace=False)]
        n=np.cross(s[1]-s[0],s[2]-s[0]); nn=np.linalg.norm(n)
        if nn<1e-9: continue
        n/=nn; d=-n@s[0]
        c=(np.abs(P@n+d)<th).sum()
        if c>bc: bc=c;best=(n,d)
    return best,bc
(n1,d1),c1=ransac(V); print('plane1',n1,d1,c1,len(V))
rest=V[np.abs(V@n1+d1)>0.01]
(n2,d2),c2=ransac(rest); print('plane2',n2,d2,c2, 'angle',np.degrees(np.arccos(abs(n1@n2))))
np.save(sys.argv[2],np.array([*n1,d1,*n2,d2]))
