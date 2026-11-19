PORTASHAMPOO PER RACCORDO DOCCINO — prototipo v1 (28/10/2026)
==============================================================

CONTENUTO
  portashampoo.scad    modello parametrico (OpenSCAD): tutte le misure in cima al file
  provino.stl          3 ganci di prova — STAMPA QUESTO PER PRIMO
  ponte.stl            design 1
  bisaccia.stl         design 2
  laterale.stl         design 3
  panoramica.png       i 3 design montati sulla parete (sopra) e da soli (sotto)

MISURE USATE
  - Corpo del raccordo: Ø 30,6 mm (dai 9,6 cm misurati col foglio, presi come circonferenza)
  - Parete laterale: 80 mm dall'asse del raccordo (il box arriva a 79 mm)
  - Il gancio sta a 10–22 mm dal muro, tra la rosetta e l'uscita del flessibile (stime dallo scan)
  - Flessibile: scende a circa 37 mm dal muro, Ø 14 mm (stima dallo scan)

1) PROVINO (circa 40 g in tutto)
  Tre ganci marcati 29.6 / 30.6 / 32.1 (il diametro del raccordo per cui sono fatti).
  Prova quale si cala sul raccordo, tra rosetta e flessibile, senza forzare e senza ballare.
  - Va bene il 30.6        -> stampa il box così com'è.
  - Va meglio un altro     -> in portashampoo.scad scrivi  tubo_d = 29.6;  (o 32.1) e riesporta.
  - Il gancio non entra tra rosetta e flessibile (12 mm) -> dimmi lo spazio libero.

2) I TRE DESIGN (ingombro 229 x 85 x 129 mm: entrano nel piatto 255 x 255)
  PONTE     2 flaconi grandi a sinistra + 1 fino a ~60 mm a destra + taschino davanti al flessibile.
            Il più capiente e rigido. Si monta INFILANDOLO DALLA PUNTA del raccordo:
            togli il doccino, fai scorrere il gancio lungo il raccordo (il flessibile passa
            nella fessura sotto) fino alla rosetta, poi rimetti il doccino.
            Funziona solo se la punta non è più grossa del corpo (~31 mm).
  BISACCIA  2 flaconi grandi a sinistra + 1 piccolo (fino a ~50 mm) a destra.
            Zona centrale libera per flessibile e doccino. Si cala dall'alto:
            lo avvicini al muro tenendolo 2–3 cm più in alto e lo abbassi sul raccordo.
  LATERALE  2 flaconi grandi, tutto a sinistra; a destra solo un puntone che appoggia
            sulla parete laterale e impedisce al box di ruotare. Il più leggero e veloce
            da stampare. Si monta come la Bisaccia.

  In tutti e tre il peso spinge i piedini posteriori contro le piastrelle e il lato destro
  contro la parete laterale: il raccordo regge solo il peso, non le rotazioni.

3) STAMPA (Cura)
  - Orientamento: così come esce dallo STL (fondo sul piatto, gancio in alto). Nessun supporto.
  - Pareti: 6 linee (2,4 mm), fondo/tetto 4 strati, riempimento 20% (serve solo nei piedini).
  - PLA+ va bene per provare. Per l'uso fisso in doccia meglio il PETG.
  - Peso indicativo: Ponte ~220 g, Bisaccia ~185 g, Laterale ~145 g.

4) MODIFICARE
  Apri portashampoo.scad in OpenSCAD (gratuito), cambia le misure in cima e la riga
  design = "...";  poi F6 (render) e File > Export > STL.
  Con design = "scena_ponte" (o _bisaccia, _laterale) vedi l'anteprima con muri e raccordo.
