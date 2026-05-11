# 🏛️ DMV Operational Efficiency Simulation
[![Tools](https://img.shields.io/badge/Simulator-OMNeT%2B%2B%206.3.0-blue)](https://omnetpp.org/)
[![Stevens Institute of Technology](https://img.shields.io/badge/Stevens-CPE345-red)](https://www.stevens.edu/)
[![Language](https://img.shields.io/badge/Language-C%2B%2B-green)](https://isocpp.org/)

## 📋 Project Overview
This repository contains a discrete event simulation (DES) of a Department of Motor Vehicles (DMV) office. The project was developed to analyze the impact of **Queue Pooling** on customer wait times and system throughput.

### The Problem
Traditional DMV setups often use separate queues for different departments (e.g., Licenses vs. Registrations), leading to "idling servers" where one clerk is free while another's line is backed up.

### The Solution: Pooled Resource Model
Our final iteration implements a **Single-Queue/Multi-Server** architecture. By merging 10 clerks into a single pooled resource, we demonstrate a significant reduction in average wait time by eliminating line-specific bottlenecks.


---

## 🛠️ System Architecture

### 1. Network Topology (`DMV.ned`)
The network is built using dynamic gate vectors, allowing the number of clerks to be scaled instantly via the configuration file without modifying the source code.

```omnetpp
network DMV_Advanced {
    parameters:
        int totalClerks = default(10);
    submodules:
        arrival: Source;
        clerk[totalClerks]: Office {
            @display("i=block/queue;q=queue");
        }
        exit: Sink;
    connections:
        for i=0..totalClerks-1 {
            arrival.out++ --> clerk[i].in;
            clerk[i].out --> exit.in++;
        }
}
