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

header_type data_t {
    fields {
        f1 : 32;
        f2 : 32;
        f3 : 32;
        f4 : 32;
        b1 : 8;
        b2 : 8;
        b3 : 8;
        b4 : 8;
    }
}
header data_t data;

parser start {
    extract(data);
    return ingress;
}

field_list sel_fields {
    data.f1;
    data.f2;
    data.f3;
    data.f4;
}

field_list_calculation sel_hash {
    input {
        sel_fields;
    }
    algorithm : crc16;
    output_width : 14;
}

action_selector sel {
    selection_key : sel_hash;
    selection_mode : fair;
}

action noop() { }
action setf1(val) { modify_field(data.f1, val); }
action setall(v1, v2, v3, v4) {
    modify_field(data.f1, v1);
    modify_field(data.f2, v2);
    modify_field(data.f3, v3);
    modify_field(data.f4, v4);
}

action_profile sel_profile {
    actions {
        noop;
        setf1;
        setall;
    }
    size : 16384;
    dynamic_action_selection : sel;
}

table test1 {
    reads {
        data.b1 : exact;
    }
    action_profile : sel_profile;
    size : 1024;
}

control ingress {
    apply(test1);
}
