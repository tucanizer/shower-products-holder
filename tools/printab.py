import trimesh, numpy as np, sys
from shapely.ops import unary_union
LH=0.28
for f in sys.argv[1:]:
    t=trimesh.load(f); z0=t.bounds[0][2]; t.apply_translation([0,0,-z0])
    n=t.face_normals; a=t.area_faces; c=t.triangles_center
    # overhang angle measured from vertical: down-facing faces
    down=n[:,2]<0
    ang=np.degrees(np.arccos(np.clip(-n[:,2],-1,1)))   # 0 = facing straight down (flat ceiling)
    ov=90-ang   # overhang from vertical: 90 = flat ceiling
    onbed=c[:,2]<0.01
    m=down&~onbed
    print(f'== {f.split("/")[-1]}  altezza {t.extents[2]:.1f} mm')
    for lim in [46,55,65,80]:
        s=m&(ov>lim)
        if s.any(): print(f'   superfici con sbalzo >{lim}°: {a[s].sum():7.1f} mm2  quota {c[s][:,2].min():.1f}-{c[s][:,2].max():.1f} mm  x {c[s][:,0].min():.1f}..{c[s][:,0].max():.1f}')
        else: print(f'   superfici con sbalzo >{lim}°: nessuna')
    # islands: polygon in layer k not overlapping layer k-1
    prev=None; isl=[]
    zs=np.arange(LH/2, t.extents[2], LH)
    for z in zs:
        s=t.section(plane_origin=[0,0,z],plane_normal=[0,0,1])
        if s is None: prev=None; continue
        p2,M=s.to_2D(to_2D=np.eye(4))
        polys=list(p2.polygons_full)
        if prev is not None:
            for p in polys:
                if not p.buffer(0.05).intersects(prev): isl.append((round(z,2),round(p.area,1),[round(v,1) for v in p.bounds]))
        prev=unary_union(polys) if polys else None
    print('   isole (parti che iniziano nel vuoto):', 'nessuna' if not isl else isl[:8], f'({len(isl)})' if isl else '')
