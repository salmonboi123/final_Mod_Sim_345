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
    // Create a timer to trigger the first arrival
    timerEvent = new cMessage("nextArrival");
    scheduleAt(simTime() + par("interArrivalTime"), timerEvent);
}

void Source::handleMessage(cMessage *msg) {
    // Create a new customer and send them to the Office
    cMessage *customer = new cMessage("Customer");
    send(customer, "out");

    // Schedule the next customer arrival
    scheduleAt(simTime() + par("interArrivalTime"), msg);
}
