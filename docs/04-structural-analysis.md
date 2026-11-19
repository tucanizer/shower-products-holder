# 4. Structural analysis

Script: [`tools/fem.py`](../tools/fem.py)

## Why

The v2 prototype showed that, with bottles inside, the two compartments swung towards each other. Before choosing a fix, the frame was modelled to find out where it was weak and how much a spacer would help.

## Model

A **2D frame in the vertical plane across the wall** (XZ), solved with Euler–Bernoulli beam elements (3 degrees of freedom per node):

- **Arch:** the teardrop hook, modelled along its mid-line. It is 5 mm thick and 22 mm wide.
- **Pillars:** they run from the arch down to the compartments, with the 45° step under the fitting.
- **Compartments:** treated as rigid bodies, loaded at their centre.
- **Contacts:** one-way contacts, so they can push but not pull, solved with an active-set iteration:
  - the arch on the fitting, along the two 45° lines;
  - the right compartment against the side wall.
- **Spacer:** an 8 × 10 mm bar between the two compartments near the floor.

## Material

| Property | Value | Note |
|---|---|---|
| Young's modulus (PLA) | 3000 MPa | |
| Tensile strength along the layers | 40 MPa | |
| Tensile strength **between** layers | **18 MPa** | Deliberately conservative (0.28 mm layers, 210 °C) |
| Compressive strength | 55 MPa | |

The part prints standing up, so the arch is loaded partly **across** its layers. For each element the allowable stress is interpolated between the two strengths according to its angle to the layers.

## Results

| Case | Failure load (left compartment) | Compartments moving together |
|---|---|---|
| v2 without spacer | **about 2.4 kg**: the arch breaks | **7–9 mm per kg** (matches what the prototype showed) |
| v3/v5 with spacer | **more than 20 kg** in the model: the arch is no longer the weak point | less than 0.01 mm |
| v3 quick prototype | about 10 kg per compartment before the pillars fail | |

## Recommended use

- PLA under a constant load in a warm, wet shower slowly creeps, so the recommended load is **2–3 kg per compartment**. That is well above the 1.5 kg design target.
- The **right compartment should not weigh more than about 1.5 times the left one**: the side wall only stops the caddy rotating one way.
- PETG would be a better material for permanent use in the shower.

## Limits of the model

- It is 2D: it ignores twisting along the fitting and the stiffness of the walls and floors.
- The compartments are treated as rigid.
- It does not model creep or fatigue.
- The hand-shower hose position is estimated.

Its purpose was to compare designs (with and without the spacer), not to certify a load.
