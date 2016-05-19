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

match_kind {
    exact
}

typedef bit<48> EthernetAddress;
extern tbl {
}

control c(bit<1> x) {
    action Set_dmac(EthernetAddress dmac) {
    }
    action drop() {
    }
    table unit() {
        key = {
            x: exact;
        }
        actions = {
            Set_dmac;
            drop;
        }
        default_action = Set_dmac(48w0xaabbccddeeff);
        implementation = tbl();
    }
    apply {
    }
}

