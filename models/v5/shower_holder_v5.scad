// =====================================================================
//  PORTASHAMPOO PER RACCORDO DOCCINO  —  v5 DEFINITIVA (16/11/2026)
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
//
//  v5 (dopo la prova del prototipo v4):
//   - distanziatore da 50 a 63 mm dal muro (dietro al flessibile del doccino)
//   - gancio e colonne 4 mm più lontani dal muro
//   - fondo all'altezza del prototipo (78 mm sotto l'asse del raccordo)
//   - pareti più basse dietro e alte 70 mm davanti
//   - angolo sotto la rosetta smussato seguendo la rosetta
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
anello_y0     = rosetta_sp + 5.5;   // v5: gancio 4 mm più lontano dal muro (16,5 mm)
anello_l      = 22;      // lunghezza del gancio sopra al raccordo (resta prima del doccino)
anello_sp     = 5;       // spessore radiale del gancio
avvolgimento  = 180;     // gradi di avvolgimento sopra al raccordo
arco_goccia   = true;    // arco a goccia: stampabile in piedi senza supporti

// ---------- BASI ----------
parete        = 2.4;     // pareti (6 perimetri da 0,4)
fondo         = 2.4;
box_y0        = rosetta_sp + 2;  // davanti alla rosetta la parete posteriore sta qui
box_prof      = 85;      // profondità da box_y0 al bordo anteriore
fondo_z       = -78;     // quota del fondo rispetto all'asse del raccordo (come il prototipo)
h_dietro      = 60;      // altezza delle pareti contro il muro (vicino alla rosetta interviene lo smusso)
h_davanti     = 70;      // altezza delle pareti davanti
rosetta_margine = 3;     // smusso sotto la rosetta: raggio = rosetta + 3 mm
smusso_abbassa = 2;      // smusso abbassato di altri 2 mm (dopo la prova)
box_sx        = -145;    // estremo sinistro (base 1 accorciata di 10 mm: ingombro 240 mm)
varco         = 22;      // base 2: lato interno a 22 mm dall'asse
varco_sx      = varco;   // base 1: lato interno a 22 mm, come la base 2 (la parete passa dentro la colonna)
asola_l       = 4;       // asole di scarico nel fondo
asola_passo   = 10;
traverse      = 2;       // traverse orizzontali nel fondo (versione definitiva)
traversa_l    = 6;       // larghezza di ogni traversa
// distanziatore a pavimento tra le due basi (oggetto blu del disegno)
dist_h        = 10;      // altezza
dist_da       = 49;      // inizio, dal muro (allargato di 1 mm verso il muro)
dist_a        = 63.5;    // fine, dal muro (allargato di 0,5 mm verso l'esterno)

$fn = 64;

// ---------- valori derivati ----------
R      = tubo_d / 2;
ri     = R + gioco;
ro     = ri + anello_sp;
ay1    = anello_y0 + anello_l;
zb     = fondo_z;
box_top = zb + h_dietro;             // (usato per il riempimento sotto le colonne)
by1    = box_y0 + box_prof;          // bordo anteriore
box_dx = angolo_x - 1;               // 1 mm dalla parete laterale
y_att  = rosetta_sp + (att_da + att_a) / 2;
y_doc  = rosetta_sp + (doc_da + doc_a) / 2;
y_mez  = by1 / 2;                    // traversina lunga del prototipo (divide dietro/davanti)

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
    // piano dal bordo dietro (h_dietro, contro il muro) al bordo davanti (h_davanti)
    ang = atan((h_davanti - h_dietro) / by1);
    translate([-400, 0, zb + h_dietro]) rotate([ang, 0, 0])
        translate([0, -60, 0]) cube([800, 400, 200]);
}

// smusso sotto la rosetta: toglie dalle basi il volume vicino alla rosetta
module smusso_rosetta() {
    translate([0, -1, -smusso_abbassa]) rotate([-90, 0, 0])
        cylinder(r = rosetta_d / 2 + rosetta_margine, h = rosetta_sp + 2 + 1, $fn = 96);
}

module asole2d(x0, x1) {
    intersection() {
        offset(delta = -(parete + 5)) pianta(x0, x1, xr_di(x0, x1));
        difference() {
            for (x = [x0 : asola_passo : x1]) translate([x, -10]) square([asola_l, by1 + 20]);
            // traverse orizzontali (da sinistra a destra) che irrigidiscono il piano
            for (i = [1 : traverse]) translate([x0 - 1, i * by1 / (traverse + 1) - traversa_l / 2]) square([x1 - x0 + 2, traversa_l]);
        }
    }
}
function xr_di(x0, x1) = 0;   // (non più usato: niente rientro attorno alla rosetta)

module base(x0, x1) {
    xr = xr_di(x0, x1);
    difference() {
        translate([0, 0, zb]) linear_extrude(h_davanti + 1) pianta(x0, x1, xr);
        translate([0, 0, zb + fondo]) linear_extrude(h_davanti + 1) offset(delta = -parete) pianta(x0, x1, xr);
        taglio_bordo();
        smusso_rosetta();
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
    translate([-varco_sx - 1, dist_da, zb]) cube([varco_sx + varco + 2, dist_a - dist_da, dist_h]);
}

// PROTOTIPO VELOCE v5: solo la parte centrale della versione definitiva
// (arco, colonne, segmenti di base attorno, spacer, muretti con lo smusso sotto la rosetta)
rap_x      = 45;     // larghezza tenuta per lato, dall'asse
rap_muro_y = 20;     // fino a questa distanza dal muro le pareti restano alte (muretti dello smusso)
// parti tenute del bordino/fondo: segmento interno lungo la colonna + striscia lungo il muro
// (tolti i lati esterni e la testata davanti, come indicato da Nico)
module maschera_lato() {
    translate([varco - 1, -1, zb - 1]) cube([1 + 8, by1 - 8 + 1, 50]);                 // segmento interno
    translate([varco - 1, -1, zb - 1]) cube([rap_x - parete - varco + 1, 8 + 1, 50]);  // striscia lungo il muro
}
module prototipo_v5() {
    union() {
        intersection() {
            union() { base_rapido(-rap_x, -varco_sx, 1); base_rapido(varco, rap_x, 1); }
            union() { maschera_lato(); mirror([1, 0, 0]) maschera_lato(); }
        }
        // muretti alti verso il muro, con lo smusso sotto la rosetta, senza il lato esterno
        intersection() {
            union() { base(-rap_x, -varco_sx); base(varco, rap_x); }
            translate([-(rap_x - parete - 0.01), -1, zb - 1]) cube([2 * (rap_x - parete - 0.01), rap_muro_y + 1, h_davanti + 2]);
        }
        gancio(zb, zb, varco, varco);
        distanziatore();
    }
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
if (design == "stampa_rapido")   rotate([0, 0, 90]) orientato() prototipo_v5();
if (design == "stampa_bisaccia") rotate([0, 0, 90]) orientato() bisaccia();
orientato() {
    if (design == "rapido")   prototipo_v5();
    if (design == "bisaccia") bisaccia();
    if (design == "ambiente") ambiente();
    if (design == "ambiente_montaggio") ambiente(false);
    if (design == "scena_rapido")   { ambiente(); color("orange") prototipo_v5(); }
    if (design == "scena_bisaccia") { ambiente(); color("orange") bisaccia();     flaconi_demo([-120, -55, 58], [65, 65, 62]); }
}
