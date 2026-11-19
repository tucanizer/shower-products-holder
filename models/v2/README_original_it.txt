PORTASHAMPOO PER RACCORDO DOCCINO — v2 (28/10/2026)
====================================================

COSA C'È
  rapido_v2.stl         PROTOTIPO VELOCE: telaio della Bisaccia, stessa geometria di aggancio
  bisaccia_v2.stl       versione completa consigliata (2 flaconi grandi + 1 piccolo, max ~50 mm)
  laterale_v2.stl       versione completa alternativa (2 flaconi grandi, tutto a sinistra)
  portashampoo_v2.scad  modello parametrico OpenSCAD (misure in cima al file)

MISURE USATE (dalla faccia della rosetta, lungo il raccordo)
  - 1° tubo (attacco acqua, sotto):            16–26 mm
  - 2° tubo (flessibile del doccino, sotto):   52–66 mm  -> il doccino sta in piedi lì sopra
  - Gancio:  da 1,5 a 23,5 mm (sopra al raccordo, lontano dal doccino)
  - Raccordo Ø 30,6 mm (circonferenza 96 mm) — da confermare col provino della v1
  - Rosetta spessa ~8 mm dal muro (stima)
  - Parete laterale a 80 mm dall'asse; il box arriva a 79 mm

STAMPABILITÀ SENZA SUPPORTI (verificata sui modelli)
  - Arco del gancio a GOCCIA: sopra al raccordo nessuna superficie supera i 45° di
    sbalzo, quindi si stampa in piedi senza supporti e senza colature proprio dove
    appoggia sul raccordo (appoggio su due linee a 45°, si centra da solo).
  - Montanti: sotto al raccordo rientrano con uno smusso a 45°, niente gradini sospesi.
  - Analisi strato per strato (0,28 mm): nessuna parte che inizia nel vuoto.
  - Tutti i pezzi partono dal piatto (fondo, piedini, montanti, puntone del Laterale).
  - Montanti alti ~9 cm ma larghi 22 mm: sotto la spinta dell'ugello flettono circa 0,1 mm,
    non c'è rischio di crollo. Se vuoi stare tranquillo: velocità pareti esterne ≤ 40 mm/s.

COME SI MONTA (tutte le versioni v2)
  Dall'alto, col doccino al suo posto: tieni il box sopra al raccordo,
  con il gancio contro la rosetta, e abbassalo. I due flessibili passano
  nel varco centrale (44 mm), il doccino resta libero.
  Verificato al computer: nessun contatto con raccordo, flessibili, doccino,
  rosetta e pareti lungo tutta la discesa.

1) PROTOTIPO VELOCE  (rapido_v2.stl)
  Cura: strato 0,28 mm, 3 pareti, riempimento 15%, nessun supporto,
  orientato così com'è (cornici sul piatto, gancio in alto). PLA+ va benissimo.
  Altezza di stampa 137 mm.
  Cosa controllare una volta montato:
   [ ] il gancio si appoggia sul raccordo senza forzare e senza ballare
   [ ] il gancio sta tra rosetta e doccino senza toccarli
   [ ] i due flessibili passano liberi nel varco centrale
   [ ] i 4 piedini posteriori toccano le piastrelle (il box sta dritto)
   [ ] il lato destro arriva vicino alla parete laterale (1 mm di gioco)
   [ ] a sinistra resta spazio dal miscelatore
   [ ] con un flacone pieno per lato resta stabile
  Se qualcosa non torna, misura quanto manca/avanza e dimmelo: cambio il parametro.

2) VERSIONE COMPLETA  (bisaccia_v2.stl o laterale_v2.stl)
  Cura: strato 0,2 mm, 6 pareti (2,4 mm), fondo/tetto 4 strati, riempimento 20%.
  Nessun supporto. Per l'uso fisso in doccia meglio PETG; PLA+ va bene per provarla.
  Peso indicativo: Bisaccia ~210 g, Laterale ~185 g. Altezza di stampa 137 mm.
