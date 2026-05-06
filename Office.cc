#include <omnetpp.h>

using namespace omnetpp;

class Office : public cSimpleModule {
  private:
    cQueue queue;
    cMessage *msgServiced = nullptr;

    // Signals for data collection
    simsignal_t waitTimeSignal;
    simsignal_t qLenSignal;

  protected:
    virtual void initialize() override;
    virtual void handleMessage(cMessage *msg) override;
    void startService(cMessage *msg);
};

Define_Module(Office);

void Office::initialize() {
    // These strings must match the ones in the brackets in the NED file
    waitTimeSignal = registerSignal("waitTime");
    qLenSignal = registerSignal("queueLen");
}

void Office::handleMessage(cMessage *msg) {
    if (msg->isSelfMessage()) { // Service complete
        send(msgServiced, "out");
        msgServiced = nullptr;

        if (!queue.isEmpty()) {
            cMessage *nextCustomer = (cMessage *)queue.pop();
            // Emit the time they spent waiting in the queue
            emit(waitTimeSignal, simTime() - nextCustomer->getTimestamp());
            startService(nextCustomer);
        }
        emit(qLenSignal, queue.getLength());
    } else {
        // Customer arrives - stamp the time so we can calculate wait time later
        msg->setTimestamp();

        if (msgServiced) {
            queue.insert(msg);
            emit(qLenSignal, queue.getLength());
        } else {
            emit(waitTimeSignal, 0.0); // Zero wait time if clerk is free
            startService(msg);
        }
    }
}

void Office::startService(cMessage *msg) {
    msgServiced = msg;
    scheduleAt(simTime() + par("serviceTime"), new cMessage("done"));
}
