import trimesh, numpy as np, manifold3d as m3d, sys
out=sys.argv[1]
def tom(t): return m3d.Manifold(m3d.Mesh(vert_properties=np.asarray(t.vertices,dtype=np.float32),tri_verts=np.asarray(t.faces,dtype=np.uint32)))
env=trimesh.load(out+'/ambiente.stl')
E=tom(env)
for d in ['provino','ponte','bisaccia','laterale']:
    t=trimesh.load(out+f'/{d}.stl')
    ext=t.bounds[1]-t.bounds[0]
    line=f'{d:9s} watertight={t.is_watertight} corpi={len(t.split())} ingombro X{ext[0]:.0f} x Y{ext[1]:.0f} x Z{ext[2]:.0f} mm  vol={t.volume/1000:.1f} cm3 ~{t.volume/1000*1.24:.0f} g'
    if d!='provino':
        inter=(tom(t)^E).volume()
        line+=f'  collisione con ambiente={inter:.1f} mm3'
        # base on bed: lowest faces area
        z0=t.bounds[0][2]; 
        line+=f'  zmin={z0:.1f}'
    print(line)
