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

control c(inout bit<32> arg) {
    action a() {
    }
    action b() {
    }
    table t(inout bit<32> x) {
        key = {
            x: exact;
        }
        actions = {
            a;
            b;
        }
        default_action = a;
    }
    apply {
        switch (t.apply(arg).action_run) {
            a: {
                t.apply(arg);
            }
            b: {
                arg = arg + 1;
            }
        }

    }
}

control proto(inout bit<32> arg);
package top(proto p);
top(c()) main;
