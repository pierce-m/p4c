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

extern Virtual {
    abstract bit<16> f(in bit<16> ix);
    void run(in bit<16> ix);
}

extern State {
    State(int<16> size);
    bit<16> get(in bit<16> index);
}

control c(inout bit<16> p) {
    Virtual() @name("cntr") cntr_0 = {
        State(16s1024) @name("state") state_0;
        bit<16> f(in bit<16> ix) {
            return state_0.get(ix);
        }
    };
    action act() {
        cntr_0.run(6);
    }
    table tbl_act() {
        actions = {
            act();
        }
        const default_action = act();
    }
    apply {
        tbl_act.apply();
    }
}

control ctr(inout bit<16> x);
package top(ctr ctrl);
top(c()) main;
