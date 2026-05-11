// 1. Declare the simple modules
simple Source {
    parameters:
        volatile double interArrivalTime @unit(s);
    gates:
        output out[];
}

simple Classifier {
    gates:
        input in;
        output outLicense[]; // Array for multiple clerks
        output outRegistration[]; // Array for multiple clerks
}

simple Office {
    parameters:
        volatile double serviceTime @unit(s);
        @signal[waitTime](type="simtime_t");
        @statistic[waitTime](title="Wait Time"; source="waitTime"; record=vector,mean);
    gates:
        input in;
        output out;
}

// --- THIS WAS LIKELY MISSING ---
simple Sink {
    gates:
        input in[];
}

// 2. Define the network
network DMV_Advanced {
    parameters:
        int totalClerks = default(10); // 5 license + 5 registration merged
    submodules:
        arrival: Source;
        // Everyone goes here now
        clerk[totalClerks]: Office {
            @display("p=150,100,column,40");
        }
        exit: Sink;
    connections:
        for i=0..totalClerks-1 {
            // arrival needs to be a gate vector again to talk to all 10
            arrival.out++ --> clerk[i].in;
            clerk[i].out --> exit.in++;
        }
}