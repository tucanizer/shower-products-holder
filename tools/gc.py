import re, sys, collections, json
f=sys.argv[1]
x=y=z=e=0.0; F=0; layer=None; typ=None; absE=True
ext_b=[1e9,1e9,-1e9,-1e9]; trav_b=[1e9,1e9,-1e9,-1e9]
per_type_b=collections.defaultdict(lambda:[1e9,1e9,-1e9,-1e9]); speeds=collections.defaultdict(collections.Counter)
layer_z={}; layer_time={}; layer_b=collections.defaultdict(lambda:[1e9,1e9,-1e9,-1e9]); temps=[]; fans=[]
retracted=False; long_travel_noretract=0; long_travel=0; maxtrav=0
types=collections.Counter(); first_layer_seen=False; lastE=0
cur_time=0
settings=''
for ln,line in enumerate(open(f,encoding='utf-8',errors='replace')):
    s=line.strip()
    if s.startswith(';SETTING_3'): settings+=s[11:]; continue
    if s.startswith(';LAYER:'): layer=int(s[7:]); continue
    if s.startswith(';TYPE:'): typ=s[6:]; types[typ]+=1; continue
    if s.startswith(';TIME_ELAPSED:'): layer_time[layer]=float(s[14:]); continue
    c=s.split(';')[0].strip()
    if not c: continue
    p=c.split()
    cmd=p[0]
    if cmd in ('M104','M109','M140','M190'): temps.append((layer,cmd,c)); continue
    if cmd in ('M106','M107'): fans.append((layer,c)); continue
    if cmd=='M82': absE=True
    if cmd=='M83': absE=False
    if cmd=='G92':
        for t in p[1:]:
            if t[0]=='E': e=float(t[1:])
        continue
    if cmd in ('G0','G1'):
        nx,ny,nz,ne=x,y,z,None
        for t in p[1:]:
            k=t[0]; v=float(t[1:])
            if k=='X': nx=v
            elif k=='Y': ny=v
            elif k=='Z': nz=v
            elif k=='E': ne=v if absE else e+v
            elif k=='F': F=v
        moved=(nx!=x or ny!=y)
        if ne is not None:
            de=ne-e
            if de<0: retracted=True
            elif de>0 and not moved: retracted=False
            if de>0 and moved and layer is not None:
                retracted=False
                for b,(px,py) in [(ext_b,(nx,ny))]:
                    pass
                for b in (ext_b,per_type_b[typ],layer_b[layer]):
                    b[0]=min(b[0],nx,x); b[1]=min(b[1],ny,y); b[2]=max(b[2],nx,x); b[3]=max(b[3],ny,y)
                speeds[typ][round(F/60)]+=1
                layer_z[layer]=nz
            e=ne
        elif moved and layer is not None:
            d=((nx-x)**2+(ny-y)**2)**.5
            trav_b[0]=min(trav_b[0],nx);trav_b[1]=min(trav_b[1],ny);trav_b[2]=max(trav_b[2],nx);trav_b[3]=max(trav_b[3],ny)
            if d>3:
                long_travel+=1
                if not retracted: long_travel_noretract+=1; maxtrav=max(maxtrav,d)
        x,y,z=nx,ny,nz
print('estrusione bbox (stampa, esclusi start code):',[round(v,2) for v in ext_b])
print('spostamenti bbox:',[round(v,2) for v in trav_b])
for t,b in per_type_b.items(): print(f'  {t:12s} bbox x {b[0]:.1f}-{b[2]:.1f} y {b[1]:.1f}-{b[3]:.1f}  velocita mm/s piu usate {speeds[t].most_common(4)}')
print('tipi:',dict(types))
print('layer:',len(layer_z),'z primo',layer_z.get(0),'z ultimo',layer_z[max(layer_z)])
print('temperature:',temps[:12])
print('ventola (primi):',fans[:8])
print(f'spostamenti >3mm: {long_travel}, senza ritrazione: {long_travel_noretract}, max {maxtrav:.1f} mm')
# time by z band
lt=sorted(layer_time.items()); prev=0; bands=collections.defaultdict(float)
for L,t in lt:
    zz=layer_z.get(L,0); dt=t-prev; prev=t
    band='0-3 mm (cornici)' if zz<=3 else ('3-15 mm (bordino)' if zz<=15.3 else ('15-105 (montanti)' if zz<=105 else '105-138 (arco)'))
    bands[band]+=dt
print('tempo per fascia (min):',{k:round(v/60,1) for k,v in bands.items()})
# layer bboxes at certain z
for zz in [0.3,10,50,100,110,120,125,130,135,137.4]:
    L=min(layer_z,key=lambda k:abs(layer_z[k]-zz)); b=layer_b[L]
    print(f'  z={layer_z[L]:.2f} (L{L}) bbox x {b[0]:.1f}-{b[2]:.1f} ({b[2]-b[0]:.1f}) y {b[1]:.1f}-{b[3]:.1f} ({b[3]-b[1]:.1f}) tempo layer {layer_time.get(L,0)-layer_time.get(L-1,0):.1f}s')
open('/tmp/claude-0/-home-claude/1135e8f9-a881-588b-b920-0e9d1b425d43/scratchpad/gc_settings.txt','w').write(settings)
