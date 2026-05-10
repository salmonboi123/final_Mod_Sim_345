#include <omnetpp.h>
using namespace omnetpp;

class Classifier : public cSimpleModule {
  protected:
    virtual void handleMessage(cMessage *msg) override;
};

Define_Module(Classifier);

void Classifier::handleMessage(cMessage *msg) {
    // 40% are here for Licenses, 60% for Registration
    if (uniform(0, 1) < 0.4) {
        int gateIndex = intrand(gateSize("outLicense"));
        send(msg, "outLicense", gateIndex);
    } else {
        int gateIndex = intrand(gateSize("outRegistration"));
        send(msg, "outRegistration", gateIndex);
    }
}
