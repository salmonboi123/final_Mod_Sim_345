// Here we declare everything we need to use
simple Source {
    parameters:
        volatile double interArrivalTime @unit(s);
    gates:
        output out[]; // Array for later use
}

simple Office {
    parameters:
        volatile double serviceTime @unit(s);
        @display("i=block/queue;q=queue");

        // Signal Delcaration is located here
        @signal[waitTime](type="simtime_t");
        @signal[queueLen](type="long");

        @statistic[waitTime](title="Wait Time"; source="waitTime"; record=vector,mean);
        @statistic[queueLen](title="Queue Length"; source="queueLen"; record=vector,max);
    gates:
        input in;
        output out;
}

simple Sink {
    gates:
        input in[]; // We need mulptiple connections
}

// Network Definition
network DMV_Advanced {
    parameters:
        int numClerks = default(3);
    submodules:
        arrival: Source {
            @display("p=50,100");
        }
        clerk[numClerks]: Office {
            @display("p=150,100,column,80");
        }
        exit: Sink {
            @display("p=250,100");
        }
    connections:
    for i=0..numClerks-1 {
        arrival.out++ --> clerk[i].in;
        clerk[i].out --> exit.in++; // How we add the needed information to the vector
    }
}