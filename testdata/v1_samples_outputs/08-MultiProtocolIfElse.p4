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

struct ingress_metadata_t {
    bit<1> drop;
    bit<8> egress_port;
    bit<4> packet_type;
}

header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}

header icmp_t {
    bit<16> typeCode;
    bit<16> hdrChecksum;
}

header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<8>  diffserv;
    bit<16> totalLen;
    bit<16> identification;
    bit<3>  flags;
    bit<13> fragOffset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> hdrChecksum;
    bit<32> srcAddr;
    bit<32> dstAddr;
}

header ipv6_t {
    bit<4>   version;
    bit<8>   trafficClass;
    bit<20>  flowLabel;
    bit<16>  payloadLen;
    bit<8>   nextHdr;
    bit<8>   hopLimit;
    bit<128> srcAddr;
    bit<128> dstAddr;
}

header tcp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<4>  res;
    bit<8>  flags;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}

header udp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<16> length_;
    bit<16> checksum;
}

header vlan_tag_t {
    bit<3>  pcp;
    bit<1>  cfi;
    bit<12> vid;
    bit<16> etherType;
}

struct metadata {
    @name("ing_metadata") 
    ingress_metadata_t ing_metadata;
}

struct headers {
    @name("ethernet") 
    ethernet_t ethernet;
    @name("icmp") 
    icmp_t     icmp;
    @name("ipv4") 
    ipv4_t     ipv4;
    @name("ipv6") 
    ipv6_t     ipv6;
    @name("tcp") 
    tcp_t      tcp;
    @name("udp") 
    udp_t      udp;
    @name("vlan_tag") 
    vlan_tag_t vlan_tag;
}

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("parse_icmp") state parse_icmp {
        packet.extract(hdr.icmp);
        transition accept;
    }
    @name("parse_ipv4") state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition select(hdr.ipv4.fragOffset, hdr.ipv4.ihl, hdr.ipv4.protocol) {
            (13w0x0 &&& 13w0x0, 4w0x5 &&& 4w0xf, 8w0x1 &&& 8w0xff): parse_icmp;
            (13w0x0 &&& 13w0x0, 4w0x5 &&& 4w0xf, 8w0x6 &&& 8w0xff): parse_tcp;
            (13w0x0 &&& 13w0x0, 4w0x5 &&& 4w0xf, 8w0x11 &&& 8w0xff): parse_udp;
            default: accept;
        }
    }
    @name("parse_ipv6") state parse_ipv6 {
        packet.extract(hdr.ipv6);
        transition select(hdr.ipv6.nextHdr) {
            8w0x1: parse_icmp;
            8w0x6: parse_tcp;
            8w0x11: parse_udp;
            default: accept;
        }
    }
    @name("parse_tcp") state parse_tcp {
        packet.extract(hdr.tcp);
        transition accept;
    }
    @name("parse_udp") state parse_udp {
        packet.extract(hdr.udp);
        transition accept;
    }
    @name("parse_vlan_tag") state parse_vlan_tag {
        packet.extract(hdr.vlan_tag);
        transition select(hdr.vlan_tag.etherType) {
            16w0x800: parse_ipv4;
            16w0x86dd: parse_ipv6;
            default: accept;
        }
    }
    @name("start") state start {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            16w0x8100: parse_vlan_tag;
            16w0x9100: parse_vlan_tag;
            16w0x800: parse_ipv4;
            16w0x86dd: parse_ipv6;
            default: accept;
        }
    }
}

control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    @name("nop") action nop() {
    }
    @name("set_egress_port") action set_egress_port(bit<8> egress_port) {
        meta.ing_metadata.egress_port = egress_port;
    }
    @name("ipv4_match") table ipv4_match() {
        actions = {
            nop;
            set_egress_port;
            NoAction;
        }
        key = {
            hdr.ipv4.srcAddr: exact;
        }
        default_action = NoAction();
    }
    @name("ipv6_match") table ipv6_match() {
        actions = {
            nop;
            set_egress_port;
            NoAction;
        }
        key = {
            hdr.ipv6.srcAddr: exact;
        }
        default_action = NoAction();
    }
    @name("l2_match") table l2_match() {
        actions = {
            nop;
            set_egress_port;
            NoAction;
        }
        key = {
            hdr.ethernet.srcAddr: exact;
        }
        default_action = NoAction();
    }
    apply {
        if (hdr.ethernet.etherType == 16w0x800) {
            ipv4_match.apply();
        }
        else {
            if (hdr.ethernet.etherType == 16w0x86dd) {
                ipv6_match.apply();
            }
            else {
                l2_match.apply();
            }
        }
    }
}

control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.vlan_tag);
        packet.emit(hdr.ipv6);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.udp);
        packet.emit(hdr.tcp);
        packet.emit(hdr.icmp);
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
