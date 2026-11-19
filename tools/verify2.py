import trimesh, numpy as np, manifold3d as m3d, sys
out=sys.argv[1]
def tom(t): return m3d.Manifold(m3d.Mesh(vert_properties=np.asarray(t.vertices,dtype=np.float32),tri_verts=np.asarray(t.faces,dtype=np.uint32)))
E=tom(trimesh.load(out+'/ambiente.stl'))
for d in sys.argv[2].split(','):
    t=trimesh.load(out+f'/{d}.stl'); P=tom(t); ext=t.extents
    print(f'{d:9s} watertight={t.is_watertight} corpi={len(t.split())} facce={len(t.faces)} ingombro {ext[0]:.0f}x{ext[1]:.0f}x{ext[2]:.0f} mm ~{t.volume/1000*1.24:.0f} g  collisione={ (P^E).volume():.2f} mm3')
    worst=0;first=None
    for s in np.arange(0,200,1.0):
        v=(P.translate([0,0,s])^E).volume()
        if v>1 and first is None: first=s
        worst=max(worst,v)
    print(f'          calata dall alto (0-200 mm): max interferenza {worst:.1f} mm3, primo contatto {first}')
