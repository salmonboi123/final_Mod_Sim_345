#include <omnetpp.h>

using namespace omnetpp;

class Sink : public cSimpleModule {
  protected:
    virtual void handleMessage(cMessage *msg) override;
};

Define_Module(Sink);

void Sink::handleMessage(cMessage *msg) {
    delete msg; // This is where we have the customer finally leaves the DMV
}
