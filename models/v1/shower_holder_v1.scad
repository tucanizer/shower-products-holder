// =====================================================================
//  PORTASHAMPOO PER RACCORDO DOCCINO  —  prototipo v1 (28/10/2026)
//  Parametrico: modifica le misure qui sotto e riesporta lo STL
//  (OpenSCAD: F6 = render, poi File > Export > STL).
//
//  Sistema di riferimento (guardando la parete):
//    X = orizzontale lungo il muro (+ verso l'angolo a destra)
//    Y = uscente dal muro verso di te (muro a Y = 0)
//    Z = verticale; l'asse del raccordo è a X = 0, Z = 0
// =====================================================================

// ---------- QUALE PEZZO GENERARE ----------
// "provino"  = 3 ganci di prova (diametri diversi) — stampa questo per primo!
// "ponte"    = box a due vani a cavallo del flessibile, chiuso davanti
// "bisaccia" = due vani separati, zona centrale libera per flessibile e doccino
// "laterale" = un solo vano a sinistra + puntone sulla parete laterale
// "scena_ponte" / "scena_bisaccia" / "scena_laterale" = anteprima con muri e raccordo
design = "ponte";

// ---------- MISURE DEL BAGNO ----------
tubo_circonf  = 96;     // circonferenza del corpo del raccordo misurata col foglio (mm)
tubo_d        = tubo_circonf / PI;   // = 30.6 mm (oppure scrivi direttamente il diametro)
rosetta_d     = 60;     // diametro rosetta a muro (stima da scan)
rosetta_sp    = 8;      // spessore rosetta (stima da scan)
tubo_lung     = 78;     // sporgenza totale del raccordo (stima)
flex_y        = 37;     // distanza muro -> centro del flessibile che scende (stima da scan)
flex_d        = 14;     // diametro esterno del flessibile
angolo_x      = 80;     // distanza asse raccordo -> parete laterale destra (misurata)
miscelatore_x = -185;   // dove inizia il miscelatore a sinistra (stima da scan)

// ---------- GANCIO ----------
gioco         = 0.5;    // gioco radiale tra gancio e raccordo
anello_y0     = 10;     // il gancio inizia a 10 mm dal muro (davanti alla rosetta)
anello_l      = 12;     // larghezza del gancio lungo il raccordo (zona libera ~18 mm)
anello_sp     = 5;      // spessore radiale del gancio
avvolgimento  = 200;    // gradi di avvolgimento sopra al raccordo

// ---------- BOX ----------
parete        = 2.4;    // spessore pareti (6 perimetri da 0.4)
fondo         = 2.4;    // spessore fondo
box_y0        = 10;     // faccia posteriore del box (stacca dalla rosetta)
box_prof      = 75;     // profondità esterna del box
box_top       = -28;    // quota del bordo posteriore (sotto il raccordo)
box_h         = 80;     // altezza del box sul retro
box_calo      = 25;     // quanto è più basso il bordo anteriore
box_sx        = -150;   // estremo sinistro del box
foro_d        = 6;      // fori di scarico nel fondo
foro_passo    = 12;
piede_l       = 18;     // piedini che appoggiano sulle piastrelle
piede_h       = 14;

$fn = 96;

// ---------- valori derivati ----------
R     = tubo_d / 2;
ri    = R + gioco;
ro    = ri + anello_sp;
ay1   = anello_y0 + anello_l;
zb    = box_top - box_h;            // quota fondo
by1   = box_y0 + box_prof;          // faccia anteriore
box_dx = angolo_x - 1;              // estremo destro: 1 mm dalla parete laterale
slot_s = flex_d / 2 + 4;            // semi-larghezza canale del flessibile (Ponte)
slot_y1 = flex_y + flex_d / 2 + 5;  // fondo del canale (Ponte)

// =====================================================================
//  GANCIO: arco sopra al raccordo + due montanti verso il box
// =====================================================================
module profilo_anello() {
    big = ro * 3;
    difference() {
        circle(r = ro);
        circle(r = ri);
        polygon(concat([[0, 0]],
            [for (a = [avvolgimento / 2 : 5 : 360 - avvolgimento / 2]) [big * sin(a), big * cos(a)]],
            [[big * sin(360 - avvolgimento / 2), big * cos(360 - avvolgimento / 2)]]));
    }
}

// montante: sopra il raccordo sta fuori dal tubo (x >= ri),
// sotto il raccordo si allarga verso il centro fino a x_in
module profilo_montante(lato, z_fine, x_in) {
    mirror([lato < 0 ? 1 : 0, 0])
    union() {
        translate([ri, -R - 3]) square([ro - ri + 2, R + 3]);
        translate([x_in, z_fine]) square([ro + 2 - x_in, -R - 3 - z_fine + 0.01]);
    }
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
//  VANO: scatola aperta con bordo anteriore ribassato e fondo forato
// =====================================================================
module taglio_bordo(x0, x1, y0, y1) {
    // piano inclinato dal bordo posteriore (box_top) a quello anteriore (box_top - box_calo)
    ang = atan(box_calo / (by1 - box_y0));
    translate([x0 - 1, box_y0, box_top]) rotate([-ang, 0, 0])
        translate([0, -50, 0]) cube([x1 - x0 + 2, 300, 200]);
}

module vano(x0, x1, y0 = box_y0, y1 = by1) {
    difference() {
        translate([x0, y0, zb]) cube([x1 - x0, y1 - y0, box_h]);
        // interno
        translate([x0 + parete, y0 + parete, zb + fondo]) cube([x1 - x0 - 2 * parete, y1 - y0 - 2 * parete, box_h]);
        taglio_bordo(x0, x1, y0, y1);
        // fori di scarico
        for (x = [x0 + parete + 6 : foro_passo : x1 - parete - 6])
            for (y = [y0 + parete + 6 : foro_passo : y1 - parete - 6])
                translate([x, y, zb - 1]) cylinder(d = foro_d, h = fondo + 2, $fn = 24);
    }
}

module piede(x0) {
    translate([x0, 0, zb]) cube([piede_l, box_y0 + 1, piede_h]);
}

// =====================================================================
//  DESIGN 1 — PONTE
// =====================================================================
module ponte() {
    union() {
        vano(box_sx, -slot_s);
        vano(slot_s, box_dx);
        vano(-slot_s - parete, slot_s + parete, slot_y1, by1);   // taschina davanti al flessibile
        gancio(zb, zb, slot_s, slot_s);
        piede(box_sx);
        piede(box_dx - piede_l);
    }
}

// =====================================================================
//  DESIGN 2 — BISACCIA
// =====================================================================
bis_s = 20;    // semi-larghezza della zona centrale libera
module bisaccia() {
    union() {
        vano(box_sx, -bis_s);
        vano(bis_s, box_dx);
        gancio(zb, zb, bis_s, bis_s);
        piede(box_sx);
        piede(box_dx - piede_l);
        piede(-bis_s - piede_l);
        piede(bis_s);
    }
}

// =====================================================================
//  DESIGN 3 — LATERALE con puntone
// =====================================================================
lat_s = 17;          // bordo destro del vano: più largo del raccordo, così il box si cala dall'alto
strut_z = -55;       // quota del puntone
module laterale() {
    union() {
        vano(box_sx, -lat_s);
        gancio(zb, strut_z - 10, lat_s, ri);
        // puntone verso la parete laterale
        translate([ri, anello_y0, strut_z - 10]) cube([box_dx - ri, anello_l, 10]);
        // nervatura a 45° sotto il puntone
        hull() {
            translate([ri, anello_y0, strut_z - 10]) cube([ro - ri + 2, anello_l, 1]);
            translate([ri, anello_y0, strut_z - 30]) cube([ro - ri + 2, anello_l, 1]);
            translate([ri + 22, anello_y0, strut_z - 10]) cube([1, anello_l, 1]);
        }
        // tampone sulla parete laterale
        translate([box_dx - 4, anello_y0, strut_z - 30]) cube([4, anello_l, 40]);
        piede(box_sx);
        piede(-lat_s - piede_l);
    }
}

// =====================================================================
//  PROVINO: tre ganci da stampare per verificare il diametro
// =====================================================================
module provino_singolo(d, etichetta) {
    r_i = d / 2 + gioco;
    r_o = r_i + anello_sp;
    big = r_o * 3;
    h = 22;
    union() {
        rotate([90, 0, 0]) linear_extrude(anello_l, center = true)
        union() {
            difference() {
                circle(r = r_o); circle(r = r_i);
                polygon(concat([[0, 0]],
                    [for (a = [avvolgimento / 2 : 5 : 360 - avvolgimento / 2]) [big * sin(a), big * cos(a)]]));
            }
            // due montanti con piedino: sotto al gancio resta APERTO, così si cala sul raccordo
            for (m = [0, 1]) mirror([m, 0]) {
                translate([r_i, -h]) square([r_o - r_i + 2, h]);
                translate([r_i, -h]) square([18, 8]);
            }
        }
        // etichetta in rilievo sul piedino destro
        translate([r_i + 9, -anello_l / 2 + 0.01, -h + 4]) rotate([90, 0, 0])
            linear_extrude(0.8) text(etichetta, size = 3.6, halign = "center", valign = "center",
                                    font = "DejaVu Sans:style=Bold");
    }
}
module provino() {
    // l'ultimo numero è il diametro del raccordo su cui il gancio si adatta
    ds = [tubo_d - 1, tubo_d, tubo_d + 1.5];
    for (i = [0 : 2])
        translate([i * 75, 0, 22]) provino_singolo(ds[i], str(round(ds[i] * 10) / 10));
}

// =====================================================================
//  SCENA DI ANTEPRIMA (non stampare)
// =====================================================================
module ambiente() {
    color([0.25, 0.25, 0.27]) translate([-260, -6, -220]) cube([260 + angolo_x, 6, 400]);           // muro
    color([0.30, 0.30, 0.32]) translate([angolo_x, -6, -220]) cube([6, 260, 400]);                  // parete laterale
    color("silver") rotate([-90, 0, 0]) cylinder(d = rosetta_d, h = rosetta_sp);                   // rosetta
    color("silver") rotate([-90, 0, 0]) cylinder(d = tubo_d, h = tubo_lung);                        // corpo
    color([0.15, 0.15, 0.15]) translate([0, flex_y, -R + 2]) mirror([0, 0, 1]) cylinder(d = flex_d, h = 220); // flessibile
    color([0.8, 0.8, 0.85, 0.5]) translate([miscelatore_x - 50, 0, -83]) cube([50, 42, 130]);     // miscelatore (ingombro)
}

module flaconi_demo(xs, ds) {
    for (i = [0 : len(xs) - 1]) color([0.2, 0.55, 0.85, 0.85])
        translate([xs[i], (box_y0 + by1) / 2 + 3, zb + fondo]) cylinder(d = ds[i], h = 190);
}

// =====================================================================
// Le misure sopra sono pensate stando DENTRO la doccia e guardando la parete.
// Il mirror finale porta il pezzo nel sistema di OpenSCAD: con la vista
// "Front" lo vedi esattamente come dalla doccia (angolo a destra, miscelatore a sinistra).
if (design == "provino")  provino();   // simmetrico: fuori dal mirror così le scritte si leggono dritte
mirror([0, 1, 0]) {
    if (design == "ponte")    ponte();
    if (design == "bisaccia") bisaccia();
    if (design == "laterale") laterale();
    if (design == "ambiente") ambiente();   // solo per verifiche
    if (design == "scena_ponte")    { ambiente(); color("orange") ponte();    flaconi_demo([-115, -50, 47], [60, 60, 52]); }
    if (design == "scena_bisaccia") { ambiente(); color("orange") bisaccia(); flaconi_demo([-115, -55, 50], [60, 60, 45]); }
    if (design == "scena_laterale") { ambiente(); color("orange") laterale(); flaconi_demo([-115, -50], [60, 60]); }
}
