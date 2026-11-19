import trimesh, numpy as np, manifold3d as m3d, math, sys
out=sys.argv[1]
def tom(t): return m3d.Manifold(m3d.Mesh(vert_properties=np.asarray(t.vertices,dtype=np.float32),tri_verts=np.asarray(t.faces,dtype=np.uint32)))
R=96/math.pi/2
def cyl_y(r,y0,y1): # along -y from y0 to y1 (negative)
    c=m3d.Manifold.cylinder(abs(y1-y0),r,r,96)  # along +z
    return c.rotate([90,0,0]).translate([0,y0,0])  # +z -> -y
tube=cyl_y(R,0,-78)
ros=cyl_y(30,0,-8)
hose=m3d.Manifold.cylinder(222,7,7,48).translate([0,-37,-235])
fit=tube+ros+hose
print('check fitting z of hose top', hose.bounding_box())
for d,mode in [('ponte','y'),('ponte','z'),('bisaccia','z'),('laterale','z')]:
    P=tom(trimesh.load(out+f'/{d}.stl'))
    worst=0;first=None
    for s in np.arange(0,90,1.0):
        Q=P.translate([0,-s,0]) if mode=='y' else P.translate([0,0,s])
        # mode y: box placed further from wall (toward room = -y in mirrored frame)
        v=(Q^fit).volume()
        if v>1 and first is None: first=s
        worst=max(worst,v)
    print(f'{d:9s} percorso {"lungo il raccordo (dalla punta)" if mode=="y" else "dall alto"}: max interferenza {worst:.1f} mm3, primo contatto a {first}')
print('--- percorso misto: avvicino al muro sollevato di L, poi abbasso')
for d in ['ponte','bisaccia','laterale']:
    P=tom(trimesh.load(out+f'/{d}.stl'))
    for L in [22,25,30]:
        worst=0
        for s in np.arange(0,100,2.0): worst=max(worst,(P.translate([0,-s,L])^fit).volume())
        for z in np.arange(0,L+0.1,1.0): worst=max(worst,(P.translate([0,0,z])^fit).volume())
        print(f'{d:9s} L={L}: max interferenza {worst:.1f} mm3')
