# 6. Tools

Python scripts written during the project to check the models and G-code before printing. They are kept as they were used: quick working scripts with Italian comments, not a polished library.

**Requirements:** Python 3 with `numpy`, `trimesh`, `shapely`, `manifold3d` and `matplotlib`. Most scripts take a folder or a file path as their first argument.

## Phone scan

| Script | What it does |
|---|---|
| `analyze.py` | Loads the Scaniverse OBJ (extract `scan/` first) and fits the two tile walls with RANSAC; saves the plane parameters |
| `fitting.py` | Uses the two planes to build a wall-aligned frame and extracts the points that stick out of the wall: the fitting and the hoses |
| `head.py` | Prints slices of those points: the width and position of the fitting, the hand-shower holder and the hoses |
| `zoom.py` | Plots the extracted points |
| `render.py`, `render2.py` | Textured matplotlib renders of the scan |

## Model checks

| Script | What it does |
|---|---|
| `printab.py` | Slices one or more STLs layer by layer (0.28 mm) and reports **islands** (regions starting in mid-air) and the area of **overhangs** beyond 45° |
| `verify.py` | v1: contact between each design and the shower environment model |
| `sweep.py` | v1/v2: moves each design along its **mounting path** (slid on from the tip, dropped from above, or moved to the wall raised and then lowered) and reports the worst collision |
| `verify2.py` | v2/v3: watertightness, number of bodies, size, and collisions while lowering from above |
| `verify4.py` | v4/v5: contact in the final position (with and without the hand shower), first contact when dropped vertically, and the "raised, against the wall, then down" path |
| `side.py` | 2D side schematic of the fitting area |
| `pianta.py`, `pianta4.py` | Dimensioned **plan views** of the v2 and v4 prototypes with numbered floor cells (`pianta` = plan in Italian). These were used for the change-request drawing |
| `quote_v5.py` | The dimensioned drawing of v5 (`models/v5/dimensions_v5.png`) |

The checks expect the original Italian file names of the working folders (`ambiente.stl` for the environment, `rapido.stl`, `bisaccia.stl`, …), and the plotting scripts have hard-coded paths. In this repository the v5 environment is `models/v5/environment_preview.stl` (with the hand shower) and `environment_mounting.stl` (without it, for the mounting path).

## Analysis

| Script | What it does |
|---|---|
| `fem.py` | 2D beam model of the frame with one-way contacts (see [structural analysis](04-structural-analysis.md)). Input: a JSON list of cases |
| `gc.py` | G-code analyser. It reports print and travel bounding boxes, speeds by feature type, temperatures and fan per layer, travel moves without retraction, time per height band and the slicer settings Cura embeds at the end of the file |

Example:

```bash
python3 tools/gc.py gcode/v5_final.gcode
python3 tools/printab.py models/v5/print_final_v5.stl models/v5/print_quick_prototype_v5.stl
```
