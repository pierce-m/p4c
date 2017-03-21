#include <core.p4>
#include <v1model.p4>

control empty();
package top(empty e);
control Ing() {
    bit<32> a;
    bool tmp_1;
    bool tmp_2;
    @name("cond") action cond_0() {
        tmp_1 = tmp_1;
        tmp_2 = tmp_2;
        tmp_1 = tmp_1;
    }
    action act() {
        a = 32w2;
    }
    table tbl_act() {
        actions = {
            act();
        }
        const default_action = act();
    }
    table tbl_cond() {
        actions = {
            cond_0();
        }
        const default_action = cond_0();
    }
    apply {
        tbl_act.apply();
        tbl_cond.apply();
    }
}

top(Ing()) main;