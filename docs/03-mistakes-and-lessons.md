# 3. Mistakes and lessons learned

This page collects everything that went wrong during the project, how each problem was found and what fixed it. Some mistakes were in the model, some in the measurements, some in communication, and some in the printing.

## Measurements

### Estimating from a phone scan
The first versions used sizes estimated from the Scaniverse scan. Chrome and glass reflect, so the scan was good for the layout but wrong on key numbers:

| Quantity | Scan estimate | Real value | Found by |
|---|---|---|---|
| Rosette thickness | 8 mm | 11 mm | v2 prototype: back feet 3 mm short of the tiles |
| Axis to side wall | 80 mm | 96 mm | v2 prototype: right side 16 mm short |
| Hose positions | 37 mm from the wall, Ø 14 (one hose) | 16–26 mm and 52–66 mm (two hoses) | Hand measurement |

**Lesson:** use the scan to understand the layout, not to set sizes. Measure every size that matters by hand, and print a cheap test piece (the v1 hook test, the quick prototypes) before the full part.

### Diameter from a circumference
The fitting diameter came from wrapping a strip of paper around it (96 mm), which gives Ø 30.6 mm. The v1 hook test had three hooks (29.6 / 30.6 / 32.1 mm) to cover the uncertainty. The v2 prototype then confirmed 30.6 mm.

## Modelling errors

### The whole part was mirrored
The first models put the open corner of the caddy on the **left**; the real side wall is on the **right**. The model's Y axis pointed into the wall while the reasoning assumed it pointed out.

- **Fix:** a final `mirror([0,1,0])` on the whole part.
- **Second mistake:** the STLs had already been exported before the fix and had to be exported again.
- **Side effect:** the labels embossed on the hook test came out mirror-written, so they had to be moved outside the `mirror()`.

**Lesson:** fix the coordinate system in writing at the top of the file (see the header of every `.scad`), and check handedness against a photo before exporting.

### Hook test with a closed base
The first hook test had a closed base, which could not drop over the fitting. It was changed to open feet.

### Things that cannot be printed without supports
A first check of the v1/v2 geometry found three problems:

1. **Round arch:** printed standing up, its top is flat and unsupported. → **Teardrop arch**: no surface beyond 45°.
2. **6 mm flat ledge** where the pillars step inwards under the fitting → **45° chamfer**.
3. In the **Side** design, some parts started in mid-air → every part, including struts and legs, now grows from the bed.

After these changes, every version was checked layer by layer for islands (`tools/printab.py`) and overhangs.

### A wrong condition in the v4 code
Base 2 (right) was supposed to extend to the tiles like base 1. A condition written as `if (xr > x0)` never triggered for the right-hand base, so the extension was missing.

- **Fix:** the condition became `if (x1 < 0)`.
- **Lesson:** after a change, render the part and check it from several angles instead of trusting the code.

## Misreading the change requests

Several corrections came from drawings and short descriptions. Some were misread the first time:

- **The "zigzag" notch.** The v4 back wall stepped around the rosette with a zigzag. Nico wanted it to go straight under the rosette, so the zigzag was removed.
- **The left column.** The left side of base 1 was redrawn wrongly. The request was simply to **mirror** the right column.
- **"Empty" prototype.** For the quick prototype the inner squares of the floor were to be removed entirely, leaving it empty.
- **Spacer position.** The spacer had to sit **behind** the hand-shower hose (49–63.5 mm from the wall), not in front of it (v3) or too far forward (v4).
- **"0.4" or "4" mm.** A request to move the hook further from the wall was read as 0.4 mm; Nico meant **4 mm**.

**Lesson:** when a drawing or a number is ambiguous, draw a dimensioned 2D sketch and confirm it before modelling (that is what `models/v5/dimensions_v5.png` is for). Ask before guessing.

## Transferring files to the PC

- **Base64 copy corrupted.** Sending STLs to the Windows PC as base64 text corrupted them. The fix was to render the STLs directly on the PC with OpenSCAD, or to copy them as files.
- **Copies that did not update.** Sometimes a copied file kept its old content even though the copy reported success. Since then every file is copied from a fresh source folder and its **MD5 checksum** is compared on both sides.

## Design lessons

- **A flexible arch needs a tie.** In v2 the two compartments hung only from the arch, so their weight bent it and they swung towards each other by 7–9 mm per kg. A small floor-level spacer between them makes the frame rigid. The beam model shows the arch failing at about 2.4 kg without the spacer, against more than 20 kg with it.
- **Let the walls take the turning forces.** The fitting only carries the weight. The back of the base presses against the tiles and the right side against the side wall. The right compartment should not carry more than about 1.5 times the left one, because the side wall only stops rotation in one direction.

## Printing

These are covered in detail in [printing](05-printing.md):

- **Tangled spool.** The first attempt at the final part failed after a few centimetres: the filament had crossed over itself on the spool, and the knot jammed the feed. The print was stopped by hand and the knot cut out, and the part was printed again from scratch. **Lesson:** on a 17-hour print, check before starting that the spool unwinds freely and has no loose or crossed turns. Never let the free end of the filament go slack when the spool is stored, because that is what lets turns cross.

- **Nozzle temperature.** The final G-code used 215 °C on the first layer and 210 °C after, the bottom of the PLA+ range, instead of the suggested 225/220 °C. Layer bonding is a little weaker, which matters most for the arch.
- **Stringing on the first layer.** Cura's combing skipped retraction on most travel moves (351 of 406 on layer 0). The strings were buried by the skin and have no effect on strength.
- **Warping at the corners.** A large flat base, no brim and fan at 100 % from layer 4 near a window: the corners of both compartments lifted a few mm.
- **Weight 8 % below the estimate** (190 g against 206 g): probably thinner filament and a lower real density, perhaps slight under-extrusion. To check: measure a wall with calipers (it should be 2.4 mm).
- **Thin line on top of the spacer** between the outer walls and the top skin. Cura's default skin overlap is only 5 %; raising it to 15–20 % closes the gap.
