// =====================================================================
//  PORTASHAMPOO PER RACCORDO DOCCINO  —  v2 (28/10/2026)
//  Parametrico: modifica le misure qui sotto e riesporta lo STL
//  (OpenSCAD: F6 = render, poi File > Export > STL).
//
//  Sistema di riferimento (stando nella doccia, guardando la parete):
//    X = orizzontale lungo il muro (+ verso l'angolo a destra)
//    Y = uscente dal muro verso di te (muro a Y = 0)
//    Z = verticale; l'asse del raccordo è a X = 0, Z = 0
//
//  Novità v2: sotto al raccordo pendono DUE flessibili (attacco vicino alla
//  rosetta + tubo che risale nel porta-doccino), il doccino sta in piedi sulla
//  punta. Il box lascia libero il centro e si cala dall'alto SENZA togliere
//  il doccino.
// =====================================================================

// ---------- QUALE PEZZO GENERARE ----------
// "rapido"   = telaio leggero della Bisaccia per provare l'aggancio (stampa veloce)
// "bisaccia" = due vani, centro libero per i flessibili (consigliato)
// "laterale" = un vano a sinistra + puntone sulla parete laterale
// "scena_rapido" / "scena_bisaccia" / "scena_laterale" = anteprima con muri e raccordo
design = "rapido";

// ---------- MISURE DEL BAGNO ----------
tubo_d        = 96 / PI; // corpo del raccordo: circonferenza 96 mm -> Ø 30,6 (correggi dopo il provino)
rosetta_d     = 60;      // diametro rosetta (stima)
rosetta_sp    = 8;       // spessore rosetta dal muro (stima: misurala se puoi)
// misure prese dalla faccia della rosetta, lungo il raccordo:
att_da        = 16;      // 1° tubo (attacco acqua, sotto al raccordo): da 16 ...
att_a         = 26;      // ... a 26 mm
doc_da        = 52;      // 2° tubo (flessibile che entra nel porta-doccino): da 52 ...
doc_a         = 66;      // ... a 66 mm
tubo_fine     = 72;      // fine del raccordo dalla rosetta (stima)
doccino_d     = 24;      // diametro del doccino (stima)
angolo_x      = 80;      // asse raccordo -> parete laterale destra (misurata)
miscelatore_x = -188;    // bordo del miscelatore a sinistra (stima da scan)

// ---------- GANCIO ----------
gioco         = 0.5;     // gioco radiale tra gancio e raccordo
anello_y0     = rosetta_sp + 1.5;   // il gancio parte subito davanti alla rosetta
anello_l      = 22;      // lunghezza del gancio sopra al raccordo (resta prima del doccino)
anello_sp     = 5;       // spessore radiale del gancio
avvolgimento  = 180;     // gradi di avvolgimento sopra al raccordo (180 = arco fino a metà raccordo)
arco_goccia   = true;    // arco a goccia: stampabile in piedi senza supporti

// ---------- BOX ----------
parete        = 2.4;     // pareti (6 perimetri da 0,4)
fondo         = 2.4;
box_y0        = 10;      // faccia posteriore del box (davanti alla rosetta)
box_prof      = 75;      // profondità esterna
box_top       = -28;     // bordo posteriore (sotto al raccordo)
box_h         = 80;      // altezza sul retro
box_calo      = 25;      // il bordo anteriore è più basso di così
box_sx        = -150;    // estremo sinistro
varco         = 22;      // semi-larghezza del varco centrale per i due flessibili
asola_l       = 4;       // asole di scarico nel fondo
asola_passo   = 10;
piede_l       = 18;      // piedini che appoggiano sulle piastrelle
piede_h       = 14;

$fn = 64;

// ---------- valori derivati ----------
R      = tubo_d / 2;
ri     = R + gioco;
ro     = ri + anello_sp;
ay1    = anello_y0 + anello_l;
zb     = box_top - box_h;
by1    = box_y0 + box_prof;
box_dx = angolo_x - 1;               // 1 mm dalla parete laterale
piede_in = rosetta_d / 2 + 3;        // piedini interni fuori dalla rosetta (montaggio dall'alto)
y_att  = rosetta_sp + (att_da + att_a) / 2;
y_doc  = rosetta_sp + (doc_da + doc_a) / 2;

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
//  VANO: scatola aperta, bordo anteriore ribassato, fondo con asole
// =====================================================================
module taglio_bordo(x0, x1) {
    ang = atan(box_calo / (by1 - box_y0));
    translate([x0 - 1, box_y0, box_top]) rotate([-ang, 0, 0])
        translate([0, -50, 0]) cube([x1 - x0 + 2, 300, 200]);
}

module asole(x0, x1, y0, y1) {
    for (x = [x0 + parete + 5 : asola_passo : x1 - parete - 5])
        translate([x, y0 + parete + 6, zb - 1]) cube([asola_l, y1 - y0 - 2 * parete - 12, fondo + 2]);
}

module vano(x0, x1) {
    difference() {
        translate([x0, box_y0, zb]) cube([x1 - x0, by1 - box_y0, box_h]);
        translate([x0 + parete, box_y0 + parete, zb + fondo])
            cube([x1 - x0 - 2 * parete, by1 - box_y0 - 2 * parete, box_h]);
        taglio_bordo(x0, x1);
        asole(x0, x1, box_y0, by1);
    }
}

// versione "telaio" per la prova veloce: cornice + traversine + bordino basso
lab_h = 15;     // altezza del bordino
lab_s = 1.6;    // spessore del bordino
module vano_rapido(x0, x1) {
    union() {
        difference() {   // bordino perimetrale
            translate([x0, box_y0, zb]) cube([x1 - x0, by1 - box_y0, lab_h]);
            translate([x0 + lab_s, box_y0 + lab_s, zb - 1]) cube([x1 - x0 - 2 * lab_s, by1 - box_y0 - 2 * lab_s, lab_h + 2]);
        }
        difference() {   // cornice del fondo
            translate([x0, box_y0, zb]) cube([x1 - x0, by1 - box_y0, fondo]);
            translate([x0 + 8, box_y0 + 8, zb - 1]) cube([x1 - x0 - 16, by1 - box_y0 - 16, fondo + 2]);
        }
        // traversine (i flaconi ci appoggiano sopra)
        n = max(1, floor((x1 - x0) / 35));
        if (n > 1) for (i = [1 : n - 1]) translate([x0 + i * (x1 - x0) / n - 3, box_y0, zb]) cube([6, by1 - box_y0, fondo]);
        translate([x0, (box_y0 + by1) / 2 - 3, zb]) cube([x1 - x0, 6, fondo]);
    }
}

module piede(x0) {
    translate([x0, 0, zb]) cube([piede_l, box_y0 + 1, piede_h]);
}

// =====================================================================
//  BISACCIA v2 (consigliata)
// =====================================================================
module bisaccia(rapido = false) {
    union() {
        if (rapido) { vano_rapido(box_sx, -varco); vano_rapido(varco, box_dx); }
        else        { vano(box_sx, -varco);        vano(varco, box_dx); }
        gancio(zb, zb, varco, varco);
        piede(box_sx);
        piede(box_dx - piede_l);
        piede(-piede_in - piede_l);
        piede(piede_in);
    }
}

// =====================================================================
//  LATERALE v2
// =====================================================================
// a destra: gamba fino al piatto + puntone appoggiato sul piatto + tampone sulla parete
// laterale (tutto parte dal piatto: niente parti sospese, niente supporti)
module laterale() {
    xo = ro + 2;
    union() {
        vano(box_sx, -varco);
        gancio(zb, zb, varco, ri);
        translate([ri, anello_y0, zb]) cube([box_dx - ri, anello_l, 10]);               // puntone
        translate([0, anello_y0 + anello_l, 0]) rotate([90, 0, 0])                         // squadretta a 45°
            linear_extrude(anello_l) polygon([[xo - 0.01, zb + 9], [xo + 30, zb + 9], [xo - 0.01, zb + 39]]);
        translate([box_dx - 4, anello_y0, zb]) cube([4, anello_l, 45]);                  // tampone
        piede(box_sx);
        piede(-piede_in - piede_l);
        piede(box_dx - piede_l);
    }
}

// =====================================================================
//  SCENA DI ANTEPRIMA (non stampare)
// =====================================================================
module ambiente() {
    color([0.25, 0.25, 0.27]) translate([-260, -6, -220]) cube([260 + angolo_x, 6, 420]);       // muro
    color([0.30, 0.30, 0.32]) translate([angolo_x, -6, -220]) cube([6, 260, 420]);              // parete laterale
    color("silver") rotate([-90, 0, 0]) cylinder(d = rosetta_d, h = rosetta_sp);               // rosetta
    color("silver") rotate([-90, 0, 0]) cylinder(d = tubo_d, h = rosetta_sp + tubo_fine);      // raccordo
    color([0.75, 0.75, 0.78]) translate([0, y_att, -R + 2]) mirror([0, 0, 1])                   // 1° flessibile
        cylinder(d = att_a - att_da, h = 220);
    color([0.75, 0.75, 0.78]) translate([0, y_doc, -R + 2]) mirror([0, 0, 1])                   // 2° flessibile
        cylinder(d = doc_a - doc_da, h = 220);
    color("silver") translate([0, y_doc, R - 4]) cylinder(d = doccino_d, h = 165);             // doccino in piedi
    color([0.8, 0.8, 0.85, 0.5]) translate([miscelatore_x - 50, 0, -100]) cube([50, 45, 140]); // miscelatore
}

module flaconi_demo(xs, ds) {
    for (i = [0 : len(xs) - 1]) color([0.2, 0.55, 0.85])
        translate([xs[i], (box_y0 + by1) / 2 + 3, zb + fondo]) cylinder(d = ds[i], h = 190);
}

// =====================================================================
// Il mirror porta il pezzo nel sistema di OpenSCAD: con la vista "Front"
// lo vedi come dalla doccia (angolo a destra, miscelatore a sinistra).
mirror([0, 1, 0]) {
    if (design == "rapido")   bisaccia(true);
    if (design == "bisaccia") bisaccia();
    if (design == "laterale") laterale();
    if (design == "ambiente") ambiente();
    if (design == "scena_rapido")   { ambiente(); color("orange") bisaccia(true); flaconi_demo([-115, -55, 50], [60, 60, 48]); }
    if (design == "scena_bisaccia") { ambiente(); color("orange") bisaccia();     flaconi_demo([-115, -55, 50], [60, 60, 48]); }
    if (design == "scena_laterale") { ambiente(); color("orange") laterale();     flaconi_demo([-115, -55], [60, 60]); }
}
