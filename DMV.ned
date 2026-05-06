//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
//

simple Office {
    parameters:
        volatile double serviceTime @unit(s);
    gates:
        input in;
        output out;
}

simple Source {
    parameters:
        volatile double interArrivalTime @unit(s);
    gates:
        output out;
}

simple Sink {
    gates:
        input in;
}

network DMV {
    submodules:
        arrival: Source {
            interArrivalTime = exponential(2s);
        }
        clerk: Office {
            serviceTime = exponential(1.5s);
        }
        exit: Sink;
    connections:
        arrival.out --> clerk.in;
        clerk.out --> exit.in;
}