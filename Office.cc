#include <omnetpp.h>

using namespace omnetpp;

class Office : public cSimpleModule {
  private:
    cQueue queue;
    cMessage *msgServiced = nullptr;
    simsignal_t waitTimeSignal;

  protected:
    virtual void initialize() override;
    virtual void handleMessage(cMessage *msg) override;
    void startService(cMessage *msg);
};

Define_Module(Office);

void Office::initialize() {
    waitTimeSignal = registerSignal("waitTime");
}

void Office::handleMessage(cMessage *msg) {
    if (msg->isSelfMessage()) {
        // Service finished
        send(msgServiced, "out");
        msgServiced = nullptr;

        // Serve next person in line
        if (!queue.isEmpty()) {
            startService((cMessage *)queue.pop());
        }
    } else {
        // New customer arrives
        if (msgServiced) {
            queue.insert(msg);
        } else {
            startService(msg);
        }
    }
}

void Office::startService(cMessage *msg) {
    msgServiced = msg;
    simtime_t duration = par("serviceTime");
    scheduleAt(simTime() + duration, new cMessage("done"));
}
