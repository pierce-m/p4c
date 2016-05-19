# Copyright 2013-present Barefoot Networks, Inc. 
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#include "/home/mbudiu/git/p4c/build/../p4include/core.p4"
#include "/home/mbudiu/git/p4c/build/../p4include/v1model.p4"

header hdr1_t {
    bit<8> f1;
    bit<8> f2;
}

struct metadata {
}

struct headers {
    @name("hdr1") 
    hdr1_t hdr1;
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("start") state start {
        packet.extract(hdr.hdr1);
        transition accept;
    }
}

control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("a11") action a11() {
        standard_metadata.egress_spec = 9w1;
    }
    @name("a12") action a12() {
        standard_metadata.egress_spec = 9w2;
    }
    @name("t_ingress_1") table t_ingress_1() {
        actions = {
            a11;
            a12;
            NoAction;
        }
        key = {
            hdr.hdr1.f1: exact;
        }
        size = 128;
        default_action = NoAction();
    }
    apply {
        t_ingress_1.apply();
    }
}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.hdr1);
    }
}

control verifyChecksum(in headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}

control computeChecksum(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}

V1Switch(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;
