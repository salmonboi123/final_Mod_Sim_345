// 1. Declare the simple modules so NED knows they exist
simple Source {
    parameters:
        volatile double interArrivalTime @unit(s);
    gates:
        output out[]; // Change this to an array
}

simple Office {
    parameters:
        volatile double serviceTime @unit(s);
        @display("i=block/queue;q=queue");

        // --- ADD THE SIGNAL DECLARATION HERE ---
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
        input in[]; // Add brackets here to allow multiple connections
}

// 2. Now define your network
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
        clerk[i].out --> exit.in++; // Add the ++ here
    }
}