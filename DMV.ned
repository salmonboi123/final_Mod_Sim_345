// 1. Declare the simple modules
simple Source {
    parameters:
        volatile double interArrivalTime @unit(s);
    gates:
        output out;
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
        int numLicenseClerks = default(2);
        int numRegClerks = default(2);
    submodules:
        arrival: Source;
        classifier: Classifier;

        // Two separate groups of servers
        licenseClerk[numLicenseClerks]: Office;
        regClerk[numRegClerks]: Office;

        exit: Sink;
    connections:
        arrival.out --> classifier.in;

        // Routing from classifier to specialized groups
        for i=0..numLicenseClerks-1 {
            classifier.outLicense++ --> licenseClerk[i].in;
        }
        for i=0..numRegClerks-1 {
            classifier.outRegistration++ --> regClerk[i].in;
        }

        // All clerks go to the same exit
        for i=0..numLicenseClerks-1 {
            licenseClerk[i].out --> exit.in++;
        }
        for i=0..numRegClerks-1 {
            regClerk[i].out --> exit.in++;
        }
}