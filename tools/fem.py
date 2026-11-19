"""Telaio 2D (piano XZ) del portashampoo: arco a goccia + montanti + vani rigidi.
Travi di Eulero-Bernoulli (3 gdl/nodo), contatti monolaterali col raccordo e con la parete
laterale (active set). Unità: mm, N, MPa."""
import numpy as np, math, sys, json

E_PLA = 3000.0
SIG_XY = 40.0   # trazione lungo gli strati (stampa in piedi: direzione orizzontale)
SIG_Z  = 18.0   # trazione tra gli strati (direzione verticale) — valore prudente per 0,28 mm / 210 °C
SIG_C  = 55.0   # compressione
RIG = dict(E=1e6, A=1e4, I=1e7)

def build(cfg):
    R = 96/math.pi/2; ri = R+0.5; ro = ri+5; rc = (ri+ro)/2; b = 22.0
    varco = cfg['varco']; x_in = varco; xo = max(ro+2, x_in+7); zs = -R-3
    nodes = []; els = []
    def node(x, z):
        for i, (a, c) in enumerate(nodes):
            if abs(a-x) < 1e-6 and abs(c-z) < 1e-6: return i
        nodes.append((x, z)); return len(nodes)-1
    def el(i, j, E=E_PLA, A=None, I=None, h=None, tag=''):
        if h is not None: A = b*h; I = b*h**3/12
        els.append(dict(i=i, j=j, E=E, A=A, I=I, h=h, tag=tag))
    # arco a goccia (linea media)
    pts = []
    for a in np.linspace(-90, -45, 7): pts.append((rc*math.sin(math.radians(a)), rc*math.cos(math.radians(a))))
    apex = (0, rc*math.sqrt(2))
    p45 = pts[-1]
    for t in np.linspace(0, 1, 7)[1:]: pts.append((p45[0]+(apex[0]-p45[0])*t, p45[1]+(apex[1]-p45[1])*t))
    for t in np.linspace(0, 1, 7)[1:]: pts.append((apex[0]+(-p45[0]-apex[0])*t, apex[1]+(p45[1]-apex[1])*t))
    for a in np.linspace(45, 90, 7)[1:]: pts.append((rc*math.sin(math.radians(a)), rc*math.cos(math.radians(a))))
    ids = [node(*p) for p in pts]
    for k in range(len(ids)-1): el(ids[k], ids[k+1], h=5.0, tag='arco')
    contact_nodes = [node(-p45[0], p45[1]), node(p45[0], p45[1])]
    sup = []   # (node, direzione unitaria della reazione ammessa, k)
    n = 1/math.sqrt(2)
    sup.append((contact_nodes[0], (-n, n), 1e5, 'raccordo sx'))
    sup.append((contact_nodes[1], ( n, n), 1e5, 'raccordo dx'))
    att = {}
    for s in (-1, 1):
        a_end = node(s*rc, 0)
        xc_up = s*(ri+xo)/2; xc_lo = s*(x_in+xo)/2
        p0 = node(xc_up, 0); el(a_end, p0, **RIG, tag='rigido')
        z1 = zs; p1 = node(xc_up, z1)
        nseg = 4
        prev = p0
        for k in range(1, nseg+1):
            q = node(xc_up, z1*k/nseg); el(prev, q, h=xo-ri, tag='montante'); prev = q
        z2 = zs-(x_in-ri); p2 = node(xc_lo, z2); el(prev, p2, h=(xo-ri+xo-x_in)/2, tag='montante'); prev = p2
        z_att = cfg['z_att']
        nseg = max(1, int(abs(z_att-z2)/6))
        for k in range(1, nseg+1):
            q = node(xc_lo, z2+(z_att-z2)*k/nseg); el(prev, q, h=xo-x_in, tag='montante'); prev = q
        att[s] = prev
    # vani rigidi: punti di carico, parete laterale, distanziatore
    loadpts = {}
    for s, key in ((-1, 'xL'), (1, 'xR')):
        lp = node(cfg[key], cfg['z_att']); el(att[s], lp, **RIG, tag='rigido'); loadpts[s] = lp
    zb = -108.0
    for s in (-1, 1):
        bp = node(s*cfg['varco']*1.0001, zb); el(att[s], bp, **RIG, tag='rigido'); loadpts[('fondo', s)] = bp
    if cfg.get('parete') is not None:
        wp = node(cfg['parete'], zb); el(att[1], wp, **RIG, tag='rigido')
        sup.append((wp, (-1, 0), 1e5, 'parete laterale'))
    if cfg.get('distanziatore'):
        a = node(-varco, zb+5); c = node(varco, zb+5)
        el(att[-1], a, **RIG, tag='rigido'); el(att[1], c, **RIG, tag='rigido')
        A = 8*10; I = 8*10**3/12
        el(a, c, E=E_PLA, A=A, I=I, h=None, tag='distanziatore')
    return nodes, els, sup, loadpts

def solve(nodes, els, sup, loads):
    N = len(nodes); K = np.zeros((3*N, 3*N)); F = np.zeros(3*N)
    for e in els:
        (x1, z1), (x2, z2) = nodes[e['i']], nodes[e['j']]
        L = math.hypot(x2-x1, z2-z1); c = (x2-x1)/L; s = (z2-z1)/L
        EA = e['E']*e['A']/L; EI = e['E']*e['I']
        k = np.array([[EA,0,0,-EA,0,0],[0,12*EI/L**3,6*EI/L**2,0,-12*EI/L**3,6*EI/L**2],[0,6*EI/L**2,4*EI/L,0,-6*EI/L**2,2*EI/L],
                      [-EA,0,0,EA,0,0],[0,-12*EI/L**3,-6*EI/L**2,0,12*EI/L**3,-6*EI/L**2],[0,6*EI/L**2,2*EI/L,0,-6*EI/L**2,4*EI/L]])
        T = np.zeros((6, 6)); r = np.array([[c, s, 0], [-s, c, 0], [0, 0, 1]]); T[:3, :3] = r; T[3:, 3:] = r
        e['T'] = T; e['k'] = k; e['L'] = L; e['ang'] = math.degrees(math.atan2(abs(z2-z1), abs(x2-x1)))
        idx = [3*e['i'], 3*e['i']+1, 3*e['i']+2, 3*e['j'], 3*e['j']+1, 3*e['j']+2]
        K[np.ix_(idx, idx)] += T.T@k@T
    for nd, (fx, fz) in loads: F[3*nd] += fx; F[3*nd+1] += fz
    active = [True]*len(sup)
    for it in range(30):
        Kc = K.copy()
        for (nd, d, kk, _), a in zip(sup, active):
            # piccola molla tangenziale (attrito minimo) per eliminare la rotazione libera
            t = (-d[1], d[0])
            for vec, kv in ((d, kk if a else 0.0), (t, 2.0)):
                v = np.array(vec); idx = [3*nd, 3*nd+1]
                Kc[np.ix_(idx, idx)] += kv*np.outer(v, v)
        u = np.linalg.solve(Kc, F)
        changed = False; reac = []
        for j, ((nd, d, kk, nm), a) in enumerate(zip(sup, active)):
            disp = u[3*nd]*d[0]+u[3*nd+1]*d[1]
            R_ = -kk*disp if a else 0.0      # reazione lungo d (positiva = compressione ammessa)
            reac.append((nm, R_))
            if a and R_ < 0: active[j] = False; changed = True
            if not a and disp < 0: active[j] = True; changed = True
        if not changed: break
    res = []
    for e in els:
        idx = [3*e['i'], 3*e['i']+1, 3*e['i']+2, 3*e['j'], 3*e['j']+1, 3*e['j']+2]
        f = e['k']@(e['T']@u[idx])
        Nax = -f[0]; M = max(abs(f[2]), abs(f[5]))
        res.append((e, Nax, M))
    return u, res, reac

def check(res):
    worst = (0, None)
    for e, Nax, M in res:
        if e['tag'] in ('rigido',): continue
        if e['tag'] == 'distanziatore':
            A = e['A']; util = max(0, -Nax)/A/SIG_C; worst = max(worst, (util, (e['tag'], e['ang'], -Nax/A, 0)), key=lambda t: t[0]); continue
        A = e['A']; W = 22*e['h']**2/6
        th = math.radians(e['ang'])
        allow = SIG_XY*SIG_Z/(SIG_XY*math.sin(th)**2+SIG_Z*math.cos(th)**2)
        st = Nax/A + M/W; sc = -Nax/A + M/W
        util = max(st/allow, sc/SIG_C)
        if util > worst[0]: worst = (util, (e['tag'], round(e['ang']), round(st, 2), round(allow, 1)))
    return worst

if __name__ == '__main__':
    cases = json.loads(sys.argv[1])
    for c in cases:
        nodes, els, sup, lp = build(c['cfg'])
        out = {}
        for name, (WL, WR) in c['load'].items():
            loads = [(lp[-1], (0, -WL)), (lp[1], (0, -WR))]
            u, res, reac = solve(nodes, els, sup, loads)
            util, info = check(res)
            Wfail = 1.0/util if util > 0 else float('inf')    # fattore sul carico di prova
            # avvicinamento dei due vani in basso (punti di carico)
            gap = (u[3*lp[('fondo',1)]]-u[3*lp[('fondo',-1)]])
            out[name] = dict(fattore_rottura=round(Wfail, 2), punto=info, avvicinamento_mm=round(-gap, 3),
                             reazioni={k: round(v, 1) for k, v in reac})
        print(json.dumps({c['nome']: out}, ensure_ascii=False))
