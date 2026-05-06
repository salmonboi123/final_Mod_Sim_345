#include <omnetpp.h>

using namespace omnetpp;

class Source : public cSimpleModule {
  private:
    cMessage *timerEvent = nullptr;

  protected:
    virtual void initialize() override;
    virtual void handleMessage(cMessage *msg) override;
};

Define_Module(Source);

void Source::initialize() {
    // Here we create a timer to trigger the first customer arrival
    timerEvent = new cMessage("nextArrival");
    scheduleAt(simTime() + par("interArrivalTime"), timerEvent);
}

void Source::handleMessage(cMessage *msg) {
    if (msg == timerEvent) {
        cMessage *customer = new cMessage("Customer");

        // Here we are picking a random clerk index (0 to numClerks-1)
        int numGates = gateSize("out");
        int randomClerk = intrand(numGates);

        // Here we send to that specific gate index
        send(customer, "out", randomClerk);

        scheduleAt(simTime() + par("interArrivalTime"), timerEvent);
    } else {
        delete msg;
    }
}
