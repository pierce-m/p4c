#include <core.p4>
#include <v1model.p4>

header data_t {
    bit<32> f1;
    bit<32> f2;
    bit<32> f3;
    bit<32> f4;
    bit<32> b1;
    bit<32> b2;
    bit<32> b3;
    bit<32> b4;
}

struct metadata {
}

struct headers {
    @name("data") 
    data_t data;
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("start") state start {
        packet.extract<data_t>(hdr.data);
        transition accept;
    }
}

control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("NoAction_2") action NoAction() {
    }
    @name("NoAction_3") action NoAction_0() {
    }
    @name("NoAction_4") action NoAction_1() {
    }
    @name("NoAction_5") action NoAction_11() {
    }
    @name("setf1") action setf1_0(bit<32> val) {
        hdr.data.f1 = val;
    }
    @name("noop") action noop_0() {
    }
    @name("noop") action noop_1() {
    }
    @name("noop") action noop_10() {
    }
    @name("noop") action noop_11() {
    }
    @name("setb4") action setb4_0(bit<32> val) {
        hdr.data.b4 = val;
    }
    @name("setb1") action setb1_0(bit<32> val) {
        hdr.data.b1 = val;
    }
    @name("setb1") action setb1_1(bit<32> val) {
        hdr.data.b1 = val;
    }
    @name("E1") table E1() {
        actions = {
            setf1_0();
            noop_0();
            NoAction();
        }
        key = {
            hdr.data.f2: ternary;
        }
        default_action = NoAction();
    }
    @name("E2") table E2() {
        actions = {
            setb4_0();
            noop_1();
            NoAction_0();
        }
        key = {
            hdr.data.b1: ternary;
        }
        default_action = NoAction_0();
    }
    @name("EA") table EA() {
        actions = {
            setb1_0();
            noop_10();
            NoAction_1();
        }
        key = {
            hdr.data.f3: ternary;
        }
        default_action = NoAction_1();
    }
    @name("EB") table EB() {
        actions = {
            setb1_1();
            noop_11();
            NoAction_11();
        }
        key = {
            hdr.data.f4: ternary;
        }
        default_action = NoAction_11();
    }
    apply {
        E1.apply();
        if (hdr.data.f1 == 32w0) 
            EA.apply();
        else 
            EB.apply();
        E2.apply();
    }
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("NoAction_6") action NoAction_12() {
    }
    @name("NoAction_7") action NoAction_13() {
    }
    @name("NoAction_8") action NoAction_14() {
    }
    @name("NoAction_9") action NoAction_15() {
    }
    @name("NoAction_10") action NoAction_16() {
    }
    @name("setb1") action setb1_5(bit<32> val) {
        hdr.data.b1 = val;
    }
    @name("setb1") action setb1_6(bit<32> val) {
        hdr.data.b1 = val;
    }
    @name("noop") action noop_12() {
    }
    @name("noop") action noop_13() {
    }
    @name("noop") action noop_14() {
    }
    @name("noop") action noop_15() {
    }
    @name("noop") action noop_16() {
    }
    @name("setb3") action setb3_0(bit<32> val) {
        hdr.data.b3 = val;
    }
    @name("setb2") action setb2_0(bit<32> val) {
        hdr.data.b2 = val;
    }
    @name("setb4") action setb4_1(bit<32> val) {
        hdr.data.b4 = val;
    }
    @name("A1") table A1() {
        actions = {
            setb1_5();
            noop_12();
            NoAction_12();
        }
        key = {
            hdr.data.f1: ternary;
        }
        default_action = NoAction_12();
    }
    @name("A2") table A2() {
        actions = {
            setb3_0();
            noop_13();
            NoAction_13();
        }
        key = {
            hdr.data.b1: ternary;
        }
        default_action = NoAction_13();
    }
    @name("A3") table A3() {
        actions = {
            setb1_6();
            noop_14();
            NoAction_14();
        }
        key = {
            hdr.data.b3: ternary;
        }
        default_action = NoAction_14();
    }
    @name("B1") table B1() {
        actions = {
            setb2_0();
            noop_15();
            NoAction_15();
        }
        key = {
            hdr.data.f2: ternary;
        }
        default_action = NoAction_15();
    }
    @name("B2") table B2() {
        actions = {
            setb4_1();
            noop_16();
            NoAction_16();
        }
        key = {
            hdr.data.b2: ternary;
        }
        default_action = NoAction_16();
    }
    apply {
        if (hdr.data.b1 == 32w0) {
            A1.apply();
            A2.apply();
            A3.apply();
        }
        B1.apply();
        B2.apply();
    }
}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit<data_t>(hdr.data);
    }
}

control verifyChecksum(in headers hdr, inout metadata meta) {
    apply {
    }
}

control computeChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

V1Switch<headers, metadata>(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;
