import sys, numpy as np
L=np.load(sys.argv[1]); U,Vv,W,W2=L.T
reg=(U>0.02)&(U<0.12)&(Vv>0.20)&(Vv<0.31)&(W>0.003)
P=L[reg]
print('n',len(P))
for w0 in np.arange(0.004,0.08,0.005):
    s=P[(P[:,2]>=w0)&(P[:,2]<w0+0.005)]
    if len(s)<5: print(f'w {w0*1000:.0f}mm: n={len(s)}'); continue
    cu,cv=np.median(s[:,0]),np.median(s[:,1])
    r=np.hypot(s[:,0]-cu,s[:,1]-cv)
    print(f'w {w0*1000:4.0f}-{(w0+.005)*1000:.0f}mm n={len(s):4d} u[{s[:,0].min()*1000:.0f},{s[:,0].max()*1000:.0f}] v[{s[:,1].min()*1000:.0f},{s[:,1].max()*1000:.0f}] center=({cu*1000:.0f},{cv*1000:.0f}) r90={np.percentile(r,90)*1000:.1f}')
# hose region below
reg2=(U>0.02)&(U<0.12)&(Vv>0.05)&(Vv<0.22)&(W>0.003)
H=L[reg2]
for v0 in np.arange(0.06,0.22,0.02):
    s=H[(H[:,1]>=v0)&(H[:,1]<v0+0.02)]
    if len(s): print(f'hose v {v0*1000:.0f}: u[{s[:,0].min()*1000:.0f},{s[:,0].max()*1000:.0f}] w[{s[:,2].min()*1000:.0f},{s[:,2].max()*1000:.0f}] n={len(s)}')
print('corner u (wall2) ~159mm')
