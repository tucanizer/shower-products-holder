// =====================================================================
//  PORTASHAMPOO PER RACCORDO DOCCINO  —  v4 (29/10/2026)
//  Parametrico: modifica le misure qui sotto e riesporta lo STL
//  (OpenSCAD: F6 = render, poi File > Export > STL).
//
//  Sistema di riferimento (stando nella doccia, guardando la parete):
//    X = orizzontale lungo il muro (+ verso l'angolo a destra)
//    Y = uscente dal muro verso di te (muro a Y = 0)
//    Z = verticale; l'asse del raccordo è a X = 0, Z = 0
//
//  v4 = v2 + modifiche dopo la prova + disegno di Nico del 29/10:
//   - base 1 (sinistra, quadrati 1-6): +5 mm a sinistra, +10 mm di profondità;
//     lato interno a 22 mm come la base 2 (parete dentro la colonna, a specchio)
//   - base 2 (destra, quadrati 7-8): +16 mm verso la parete laterale
//   - niente piedini: il fondo e la parete posteriore arrivano dritti fino
//     alle piastrelle per tutta la larghezza, anche sotto la rosetta
//   - distanziatore a pavimento tra la base 1 e la base 2, centrato sui
//     quadrati 6 e 8 (fila davanti)
//   - base 1 accorciata di 10 mm a sinistra (ingombro 240 mm)
//   - prototipo veloce: colonne 30 mm più basse
//   - "stampa_..." = pezzo già ruotato di 90° per entrare nel piatto
// =====================================================================

// ---------- QUALE PEZZO GENERARE ----------
// "stampa_rapido"   = prototipo veloce, già ruotato per il piatto (da usare in Cura)
// "stampa_bisaccia" = versione completa, già ruotata per il piatto (da usare in Cura)
// "rapido" / "bisaccia" = stessi pezzi orientati come in doccia
// "scena_rapido" / "scena_bisaccia" = anteprima con muri, raccordo, flessibili e doccino
design = "stampa_rapido";

// ---------- MISURE DEL BAGNO ----------
tubo_d        = 96 / PI; // corpo del raccordo: circonferenza 96 mm -> Ø 30,6 (confermato dal prototipo)
rosetta_d     = 60;      // diametro rosetta (stima)
rosetta_sp    = 11;      // spessore rosetta dal muro (dalla prova: i piedini restavano a 3 mm dal muro)
// misure prese dalla faccia della rosetta, lungo il raccordo:
att_da        = 16;      // 1° tubo (attacco acqua, sotto al raccordo): da 16 ...
att_a         = 26;      // ... a 26 mm
doc_da        = 52;      // 2° tubo (flessibile che entra nel porta-doccino): da 52 ...
doc_a         = 66;      // ... a 66 mm
tubo_fine     = 72;      // fine del raccordo dalla rosetta (stima)
doccino_d     = 24;      // diametro del doccino (stima)
angolo_x      = 96;      // asse raccordo -> parete laterale destra (dalla prova: mancavano 16 mm)
miscelatore_x = -188;    // bordo del miscelatore a sinistra (stima da scan)

// ---------- GANCIO ----------
gioco         = 0.5;     // gioco radiale tra gancio e raccordo
anello_y0     = rosetta_sp + 1.5;   // il gancio parte subito davanti alla rosetta
anello_l      = 22;      // lunghezza del gancio sopra al raccordo (resta prima del doccino)
anello_sp     = 5;       // spessore radiale del gancio
avvolgimento  = 180;     // gradi di avvolgimento sopra al raccordo
arco_goccia   = true;    // arco a goccia: stampabile in piedi senza supporti

// ---------- BASI ----------
parete        = 2.4;     // pareti (6 perimetri da 0,4)
fondo         = 2.4;
box_y0        = rosetta_sp + 2;  // davanti alla rosetta la parete posteriore sta qui
box_prof      = 85;      // profondità da box_y0 al bordo anteriore
box_top       = -28;     // bordo posteriore (sotto al raccordo)
box_h         = 80;      // altezza sul retro
box_calo      = 25;      // il bordo anteriore è più basso di così
box_sx        = -145;    // estremo sinistro (base 1 accorciata di 10 mm: ingombro 240 mm)
varco         = 22;      // base 2: lato interno a 22 mm dall'asse
varco_sx      = varco;   // base 1: lato interno a 22 mm, come la base 2 (la parete passa dentro la colonna)
asola_l       = 4;       // asole di scarico nel fondo
asola_passo   = 10;
abbassa_rapido = 30;     // solo prototipo veloce: colonne più basse di 30 mm (base più vicina al gancio)
// distanziatore a pavimento tra le due basi (oggetto blu del disegno)
dist_h        = 10;      // altezza
dist_p        = 20;      // profondità (lungo Y)

$fn = 64;

// ---------- valori derivati ----------
R      = tubo_d / 2;
ri     = R + gioco;
ro     = ri + anello_sp;
ay1    = anello_y0 + anello_l;
e_rapido = (design == "rapido" || design == "stampa_rapido" || design == "scena_rapido");
zb     = box_top - box_h + (e_rapido ? abbassa_rapido : 0);
by1    = box_y0 + box_prof;          // bordo anteriore
box_dx = angolo_x - 1;               // 1 mm dalla parete laterale
y_att  = rosetta_sp + (att_da + att_a) / 2;
y_doc  = rosetta_sp + (doc_da + doc_a) / 2;
y_mez  = by1 / 2;                    // traversina lunga del prototipo (divide dietro/davanti)
dist_y = (y_mez + 3 + by1 - 8) / 2;  // centro dei quadrati 6 e 8 (fila davanti)

// =====================================================================
//  GANCIO: arco sopra al raccordo + due montanti verso il box
// =====================================================================
// profilo "a goccia": sopra al raccordo le superfici non superano i 45° di sbalzo,
// così l'arco si stampa in piedi SENZA supporti e senza colature dove appoggia.
module goccia(r) {
    if (arco_goccia) hull() { circle(r = r); translate([0, r * sqrt(2) - 0.01]) square(0.02, center = true); }
    else circle(r = r);
}
module profilo_anello() {
    big = ro * 3;
    difference() {
        goccia(ro);
        goccia(ri);
        polygon(concat([[0, 0]],
            [for (a = [avvolgimento / 2 : 5 : 360 - avvolgimento / 2]) [big * sin(a), big * cos(a)]],
            [[big * sin(360 - avvolgimento / 2), big * cos(360 - avvolgimento / 2)]]));
    }
}

// montante: accanto al raccordo sta fuori dal tubo (x >= ri), sotto si sposta fino a x_in
// con uno smusso a 45° (nessun gradino orizzontale sospeso)
module profilo_montante(lato, z_fine, x_in) {
    xo = max(ro + 2, x_in + 7);
    zs = -R - 3;                    // sotto questa quota il montante può rientrare verso il centro
    mirror([lato < 0 ? 1 : 0, 0])
    polygon([[x_in, z_fine], [xo, z_fine], [xo, 0.01], [ri, 0.01], [ri, zs], [x_in, zs - (x_in - ri)]]);
}

module gancio(z_sx, z_dx, x_in_sx, x_in_dx) {
    translate([0, ay1, 0]) rotate([90, 0, 0])
    linear_extrude(anello_l)
    union() {
        profilo_anello();
        profilo_montante(-1, z_sx, x_in_sx);
        profilo_montante( 1, z_dx, x_in_dx);
    }
}

// =====================================================================
//  BASI: pianta dritta fino alle piastrelle
// =====================================================================
// pianta 2D di una base: rettangolo dritto fino alle piastrelle (Y = 0).
// Vicino al centro la base passa SOTTO la rosetta (la rosetta finisce più in alto
// del bordo delle basi), quindi niente rientro.
module pianta(x0, x1, xr) {
    translate([x0, 0]) square([x1 - x0, by1]);
}

module taglio_bordo() {
    ang = atan(box_calo / (by1 - box_y0));
    translate([-400, box_y0, box_top]) rotate([-ang, 0, 0])
        translate([0, -60, 0]) cube([800, 300, 200]);
}

module asole2d(x0, x1) {
    intersection() {
        offset(delta = -(parete + 5)) pianta(x0, x1, xr_di(x0, x1));
        for (x = [x0 : asola_passo : x1]) translate([x, -10]) square([asola_l, by1 + 20]);
    }
}
function xr_di(x0, x1) = 0;   // (non più usato: niente rientro attorno alla rosetta)

module base(x0, x1) {
    xr = xr_di(x0, x1);
    difference() {
        translate([0, 0, zb]) linear_extrude(box_h) pianta(x0, x1, xr);
        translate([0, 0, zb + fondo]) linear_extrude(box_h) offset(delta = -parete) pianta(x0, x1, xr);
        taglio_bordo();
        translate([0, 0, zb - 1]) linear_extrude(fondo + 2) asole2d(x0, x1);
    }
}

// versione "telaio" per la prova veloce: solo cornice del fondo + bordino basso (dentro vuoto)
lab_h = 11;     // altezza del bordino (prototipo veloce: 11 mm)
lab_s = 1.6;    // spessore del bordino
module base_rapido(x0, x1, colonne) {
    xr = xr_di(x0, x1);
    translate([0, 0, zb]) union() {
        linear_extrude(lab_h) difference() { pianta(x0, x1, xr); offset(delta = -lab_s) pianta(x0, x1, xr); }
        linear_extrude(fondo) difference() { pianta(x0, x1, xr); offset(delta = -8) pianta(x0, x1, xr); }
    }
}

module distanziatore() {
    translate([-varco_sx - 1, dist_y - dist_p / 2, zb]) cube([varco_sx + varco + 2, dist_p, dist_h]);
}

module bisaccia(rapido = false) {
    union() {
        if (rapido) { base_rapido(box_sx, -varco_sx, 3); base_rapido(varco, box_dx, 1); }
        else        { base(box_sx, -varco_sx);           base(varco, box_dx); }
        distanziatore();
        gancio(zb, zb, varco, varco);
    }
}

// =====================================================================
//  SCENA DI ANTEPRIMA (non stampare)
// =====================================================================
module ambiente(con_doccino = true) {
    color([0.25, 0.25, 0.27]) translate([-260, -6, -220]) cube([260 + angolo_x, 6, 420]);       // muro
    color([0.30, 0.30, 0.32]) translate([angolo_x, -6, -220]) cube([6, 260, 420]);              // parete laterale
    color("silver") rotate([-90, 0, 0]) cylinder(d = rosetta_d, h = rosetta_sp);               // rosetta
    color("silver") rotate([-90, 0, 0]) cylinder(d = tubo_d, h = rosetta_sp + tubo_fine);      // raccordo
    color([0.75, 0.75, 0.78]) translate([0, y_att, -R + 2]) mirror([0, 0, 1])                   // 1° flessibile
        cylinder(d = att_a - att_da, h = 220);
    if (con_doccino) {
    color([0.75, 0.75, 0.78]) translate([0, y_doc, -R + 2]) mirror([0, 0, 1])                   // 2° flessibile
        cylinder(d = doc_a - doc_da, h = 220);
    color("silver") translate([0, y_doc, R - 4]) cylinder(d = doccino_d, h = 165);             // doccino in piedi
    }
    color([0.8, 0.8, 0.85, 0.5]) translate([miscelatore_x - 50, 0, -100]) cube([50, 45, 140]); // miscelatore
}

module flaconi_demo(xs, ds) {
    for (i = [0 : len(xs) - 1]) color([0.2, 0.55, 0.85])
        translate([xs[i], by1 / 2, zb + fondo]) cylinder(d = ds[i], h = 190);
}

// =====================================================================
// orientato(): come in doccia, vista "Front" di OpenSCAD = dalla doccia
module orientato() { mirror([0, 1, 0]) children(); }
if (design == "stampa_rapido")   rotate([0, 0, 90]) orientato() bisaccia(true);
if (design == "stampa_bisaccia") rotate([0, 0, 90]) orientato() bisaccia();
orientato() {
    if (design == "rapido")   bisaccia(true);
    if (design == "bisaccia") bisaccia();
    if (design == "ambiente") ambiente();
    if (design == "ambiente_montaggio") ambiente(false);
    if (design == "scena_rapido")   { ambiente(); color("orange") bisaccia(true); flaconi_demo([-120, -55, 58], [65, 65, 62]); }
    if (design == "scena_bisaccia") { ambiente(); color("orange") bisaccia();     flaconi_demo([-120, -55, 58], [65, 65, 62]); }
}
