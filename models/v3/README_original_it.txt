PORTASHAMPOO PER RACCORDO DOCCINO — v3 (29/10/2026)
====================================================

COSA C'È
  stampa_rapido_v3.stl     PROTOTIPO VELOCE v3 (telaio), già ruotato per il piatto
  stampa_bisaccia_v3.stl   versione completa v3, già ruotata per il piatto
  portashampoo_v3.scad     modello parametrico OpenSCAD
  panoramica_v3.png        anteprime

MODIFICHE DOPO LA PROVA DEL PROTOTIPO VELOCE v2
  - Vano sinistro: interno 133 x 80 mm (prima 123 x 70): +5 mm per lato.
    Il retro non può arretrare (rosetta), quindi la profondità cresce tutta davanti.
  - Piedini posteriori 3 mm più lunghi verso le piastrelle.
  - Lato destro +16 mm: il box arriva a 95 mm dall'asse e tocca la parete laterale.
    Vano destro interno 68 x 80 mm (prima 52 x 70): ci sta un flacone normale.
  - DISTANZIATORE: barra 10 x 8 mm in basso, davanti, tra i due vani (a ~9 cm dal muro,
    davanti ai flessibili e al doccino). I vani non si avvicinano più e l'arco non si flette.
  - Ingombro 250 x 98 x 137 mm.

STAMPA (Cura)
  - Usa i file "stampa_...": sono già ruotati di 90° (lato lungo lungo Y).
  - Adesione: NESSUNA (niente skirt). Il pezzo è lungo 250 mm e lo skirt a 10 mm non ci sta;
    la linea di spurgo dello start code pulisce già l'ugello e resta lontana dal pezzo.
    In alternativa: skirt 1 linea a 1 mm.
  - Nessun supporto. Verificato: niente sbalzi oltre 45° e nessuna parte che parte nel vuoto.
  - Prototipo veloce: strato 0,28 mm, 3 pareti, riempimento 15%.
  - Versione completa: strato 0,2 mm, 6 pareti, fondo/tetto 4 strati, riempimento 20%;
    per l'uso fisso meglio PETG.

PORTATA (simulazione a travi: arco + montanti + vani, contatto col raccordo e con la parete;
         PLA con 18 MPa di resistenza tra gli strati, valore prudente)
  - v2 senza distanziatore: l'arco si rompeva a ~2,4 kg nel vano sinistro e i vani
    si avvicinavano di ~7–9 mm per ogni kg (quello che hai visto nella prova).
  - v3 completa CON distanziatore: l'arco non è più il punto debole (oltre 20 kg nel modello);
    i vani non si avvicinano (< 0,01 mm).
  - Prototipo veloce v3: ~10 kg per vano prima della rottura dei montanti.
  - Uso consigliato (PLA sotto carico continuo in doccia): fino a 2–3 kg per vano.
  - Il vano destro non deve pesare più di ~1,5 volte il sinistro: la parete laterale tiene
    solo la rotazione verso sinistra.

COME SI MONTA
  Dall'alto, col doccino al suo posto: avvicina il box al muro tenendolo 2–3 cm più in alto,
  con il gancio sopra al raccordo vicino alla rosetta, poi abbassalo. I flessibili restano
  dietro al distanziatore, nel varco centrale. Verificato al computer lungo tutta la discesa.

CHECKLIST DELLA PROVA
   [ ] il gancio si appoggia sul raccordo senza forzare
   [ ] i 4 piedini toccano le piastrelle
   [ ] il lato destro tocca (o quasi) la parete laterale
   [ ] i flessibili passano liberi e il doccino si sfila e si rimette senza toccare il box
   [ ] con i flaconi i vani non si avvicinano più
