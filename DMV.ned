import org.omnetpp.queueing.Source;
import org.omnetpp.queueing.PassiveQueue;
import org.omnetpp.queueing.Server;
import org.omnetpp.queueing.Classifier;
import org.omnetpp.queueing.Sink;

network DMV_Current
{
    @display("bgb=1268,783");
    submodules:
        source: Source;
        receptionQueue: PassiveQueue;
        receptionist: Server;
        classifier: Classifier {
            @display("p=343,379");
            gates:
                out[5];
        }

        licenseQueue: PassiveQueue {
            @display("p=621,223");
        }
        vehicleQueue: PassiveQueue {
            @display("p=621,379");
        }
        testQueue: PassiveQueue {

            @display("p=621,535");
        }
        licenseClerks[5]: Server {
            @display("p=864,223");
        }
        vehicleClerks[5]: Server {
            @display("p=864,379");
        }
        testClerks[1]: Server {

            @display("p=864,535");
        }
        sink: Sink {

            @display("p=1231,379");
        }
    connections:
        source.out --> receptionQueue.in++;
        receptionQueue.out++ --> receptionist.in++;
        receptionist.out --> classifier.in++;

        classifier.out[0] --> licenseQueue.in++;
        classifier.out[1] --> licenseQueue.in++;

        classifier.out[2] --> vehicleQueue.in++;
        classifier.out[3] --> vehicleQueue.in++;

        classifier.out[4] --> testQueue.in++;

        classifier.rest --> sink.in++;

        for i=0..4 {
            licenseQueue.out++ --> licenseClerks[i].in++;
            licenseClerks[i].out --> sink.in++;
        }

        for i=0..4 {
            vehicleQueue.out++ --> vehicleClerks[i].in++;
            vehicleClerks[i].out --> sink.in++;
        }

        for i=0..0 {
            testQueue.out++ --> testClerks[i].in++;
            testClerks[i].out --> sink.in++;
        }
}


network DMV_Revised
{
   @display("bgb=1268,783");
   submodules:
       source: Source;
       receptionQueue: PassiveQueue;
       receptionist: Server;
       classifier: Classifier {
           @display("p=343,379");
           gates:
               out[5];
       }
       combinedQueue: PassiveQueue {
           @display("p=621,301");
       }
       testQueue: PassiveQueue {
           @display("p=621,535");
       }
       combinedClerks[10]: Server {
           @display("p=864,301");
       }
       testClerks[1]: Server {
           @display("p=864,535");
       }
       sink: Sink {
           @display("p=1231,379");
       }
   connections:
       source.out --> receptionQueue.in++;
       receptionQueue.out++ --> receptionist.in++;
       receptionist.out --> classifier.in++;
       classifier.out[0] --> combinedQueue.in++;
       classifier.out[1] --> combinedQueue.in++;
       classifier.out[2] --> combinedQueue.in++;
       classifier.out[3] --> combinedQueue.in++;
       classifier.out[4] --> testQueue.in++;
       classifier.rest --> sink.in++;
       for i=0..9 {
           combinedQueue.out++ --> combinedClerks[i].in++;
           combinedClerks[i].out --> sink.in++;
       }
       testQueue.out++ --> testClerks[0].in++;
       testClerks[0].out --> sink.in++;
}

