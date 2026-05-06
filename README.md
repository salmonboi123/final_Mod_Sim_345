# 🏛️ DMV Multi-Server Simulation
[![Build Status](https://img.shields.io/badge/OMNeT%2B%2B-6.3.0-blue)](https://omnetpp.org/)
[![Academic Project](https://img.shields.io/badge/Stevens-Engineering-red)](https://www.stevens.edu/)

A discrete event simulation (DES) project modeling a Department of Motor Vehicles (DMV) office. Developed to analyze queuing theory and optimize service efficiency.

## 📊 System Overview
This project simulates a **Multi-Server/Single-Queue** (or multi-queue) system.
* **Source:** Models customer arrival using an `exponential()` distribution.
* **Clerks:** A vector of servers representing DMV windows.
* **Sink:** Disposes of messages and records total throughput.



## 🛠️ Technical Implementation

### The Network Structure (`.ned`)
We used **Gate Vectors** to connect one source to multiple clerks dynamically.
```omnetpp
connections:
    for i=0..numClerks-1 {
        arrival.out++ --> clerk[i].in;
        clerk[i].out --> exit.in++;
    }
