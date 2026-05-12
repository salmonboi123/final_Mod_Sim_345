import org.omnetpp.queueing.Source;
import org.omnetpp.queueing.PassiveQueue;
import org.omnetpp.queueing.Server;
import org.omnetpp.queueing.Classifier;
import org.omnetpp.queueing.Sink;
network DMV_Current
{
    @display("bgb=1488,814");
    submodules:
        source: Source {
            @display("p=43,378");
        }
        receptionQueue: PassiveQueue {
            @display("p=197,377");
        }
        receptionist: Server {
            @display("p=385,377");
        }
        classifier: Classifier {
            @display("p=517,377");
            gates:
                out[5];
        }
        combinedQueue: PassiveQueue {
            @display("p=665,277");
        }
        testQueue: PassiveQueue {
            @display("p=665,531");
        }
        combinedClerks[10]: Server {
            @display("p=924,278");
        }
        testClerks[1]: Server {
            @display("p=925,545");
        }
        sink: Sink {
            @display("p=1275,377");
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
