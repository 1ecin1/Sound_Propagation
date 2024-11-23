# **Sound Propagation over Undulating Seabed**

## **Project Description**
This project is organized into two primary directories:  
- **core**: Contains the core computational code for sound propagation loss calculations.  
- **data**: Includes scripts for time-frequency analysis of the raw data.  

---

## **Project Overview**
This project validates sound propagation characteristics using the **Spectral Parabolic Equation** and experimental data. A comparison between the calculated distance-dependent intensity and measured data demonstrates the consistency of the propagation model with experimental results. Based on this validation, the project refines the attenuation formula for turbine noise as a function of distance.

---

## **How to Run**
1. Set up the environmental parameters in a `.txt` file located in the root directory.  
2. Once the parameters are configured, execute the `main.m` script in MATLAB.

---

## **Key Configuration Parameters**
The `.txt` file should include the following configuration:  

| Parameter                  | Value                         | Description                    |
|----------------------------|-------------------------------|--------------------------------|
| **1**                      | 1                             | Reserved                      |
| **8**                      | 8                             | Reserved                      |
| **1**                      | 1                             | Reserved                      |
| **1500**                   | Sound speed (m/s)             |                                |
| **100**                    | Source frequency (Hz)         |                                |
| **10**                     | Source depth (m)              |                                |
| **10**                     | Receiver depth (m)            |                                |
| **4002.0**                 | Receiver range (m)            |                                |
| **1**                      | Reserved                      |                                |
| **29.9**                   | Reserved                      |                                |
| **0.1**                    | Reserved                      |                                |
| **50**                     | Reserved                      |                                |
| **40**                     | Reserved                      |                                |
| **70**                     | Reserved                      |                                |
| **1**                      | Reserved                      |                                |
| **0**                      | Reserved                      |                                |
| **3**                      | Reserved                      |                                |

### **Environmental Sound Speed Profile Example**:
```
Depth (m)    Sound Speed (m/s)    Attenuation Coefficient    Extra Parameter
0.00         1500.00             1.0                        0.0  
10.00        1500.00             1.0                        0.0  
29.90        1500.00             1.0                        0.0  
```

---
