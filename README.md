# Thermodynamic Modeling and Temperature Control of a Neonatal Incubator

This repository contains the modeling, simulation, and control design of a neonatal incubator system, including continuous-time and discrete-time temperature control strategies. The work focuses on replicating and improving the thermal regulation behavior of the YP-90A neonatal incubator, where the newborn’s microenvironment temperature is the primary controlled variable. The proposed control strategies include a continuous-time PID controller and an incremental digital RST controller designed from a reduced-order model obtained through system identification.

This repository corresponds to the research work **"Low-order Dynamic Modeling and Control of a Neonatal Incubator"**, accepted and presented at the **2025 IEEE 7th Colombian Conference on Automatic Control (CCAC)**. The article is currently undergoing editorial processing for publication in the IEEE Xplore Digital Library. Once available, it can be consulted through:

https://ieeexplore.ieee.org/Xplore/home.jsp

The publication link and DOI will be added here once the final version is released.

---

## Project Structure

# INCUBATOR_TEMP: Temperature Control for Thermal Incubator

This project contains the code and models for the design, identification, and implementation of temperature control systems for a thermal incubator.

---

## Project Structure

The repository is organized into the following main directories:

| Directory | Description |
| :--- | :--- |
| `analog_control/` | Design and evaluation of a **continuous-time PID controller**. |
| `digital_control/` | Implementation of an **incremental RST discrete-time controller**. |
| `identification/` | Scripts for **thermal model identification**: full-order model and its first-order approximation. |
| `incubator_sim/` | **Simulink models** for system-level and closed-loop simulation. |
| `Narma_L2_control/` | Exploration (optional) of **NARMA-L2 neural-based control**. |
| `slprj/` | **Auto-generated artifacts** from Simulink (this directory is excluded via `.gitignore`). |


---

## Summary

The neonatal incubator is modeled using thermodynamic and heat transfer principles to represent interactions between:
- Neonate core and skin layers
- Incubator air volume and humidity
- Plexiglass chamber walls
- Mattress thermal storage

A fifth-order dynamic model is derived and later approximated to a first-order transfer function to enable control-oriented design. Based on this reduced model:

- A **continuous-time PID controller** is designed to improve settling time with constrained overshoot.
- A **discrete incremental RST controller** is synthesized to achieve smooth actuation and strong disturbance rejection.

---

## Requirements

- MATLAB R2021a or newer
- Simulink
- Control System Toolbox

---

## Usage

1. Model development and identification: `identification/`
2. Continuous PID control design: `analog_control/`
3. Discrete incremental RST controller: `digital_control/`
4. System-level Simulink evaluation: `incubator_sim/`
5. Optional neural control experiments: `Narma_L2_control/`

---

## Publication Status

This work was **accepted and presented** at:

**2025 IEEE 7th Colombian Conference on Automatic Control (CCAC)**  
Bogotá, Colombia.

The article is **pending publication** in IEEE Xplore.  
Once indexed, DOI and full reference will be included here.

---

## Authors

**Santiago Florido Gómez**  
Mechatronics Engineering, Universidad EIA, Envigado, Colombia  
santiago.florido@eia.edu.co

**José David Gómez Bedoya**  
Mechatronics Engineering, Universidad EIA, Envigado, Colombia  
jose.gomez65@eia.edu.co

**Tatiana Manrique**  
Department of Mechatronics and Electromechanics, Institución Universitaria ITM, Medellín, Colombia  
dollymanrique@itm.edu.co

**Robinson A. Torres**  
Biomedical Engineering, Universidad EIA, Envigado, Colombia  
robinson.torres@eia.edu.co
