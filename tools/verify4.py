import trimesh, numpy as np, manifold3d as m3d, sys
o=sys.argv[1]
def tom(t): return m3d.Manifold(m3d.Mesh(vert_properties=np.asarray(t.vertices,dtype=np.float32),tri_verts=np.asarray(t.faces,dtype=np.uint32)))
E=tom(trimesh.load(o+'/ambiente.stl')); EM=tom(trimesh.load(o+'/ambiente_montaggio.stl'))
for d in ['rapido','bisaccia']:
    t=trimesh.load(o+f'/{d}.stl'); P=tom(t); ext=t.extents
    print(f'{d}: watertight={t.is_watertight} corpi={len(t.split())} ingombro {ext[0]:.0f}x{ext[1]:.0f}x{ext[2]:.0f}  ~{t.volume/1000*1.24:.0f} g (pieno)')
    print(f'   posizione finale: contatto con tutto (doccino incluso) {(P^E).volume():.0f} mm3 | senza doccino e suo flessibile {(P^EM).volume():.1f} mm3')
    first=None
    for s_ in np.arange(0,200,1.0):
        if (P.translate([0,0,s_])^EM).volume()>1: first=s_; break
    print(f'   calata verticale dall alto: primo contatto a {first} mm sopra la posizione finale')
    for L in (20,25,30,35):
        w=0
        for s_ in np.arange(0,160,2.0): w=max(w,(P.translate([0,-s_,L])^EM).volume())
        for z in np.arange(0,L+0.1,1.0): w=max(w,(P.translate([0,0,z])^EM).volume())
        print(f'   avvicinamento al muro sollevato di {L} mm e poi giu (senza doccino): interferenza max {w:.1f} mm3')
