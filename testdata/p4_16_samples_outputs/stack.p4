header h {
}

parser p() {
    state start {
        h[4] stack;
        stack[3].setValid();
        h b = stack[3];
        b = stack.last;
        stack[2] = b;
        b = stack.next;
        stack.push_front(2);
        stack.pop_front(2);
        transition accept;
    }
}

parser Simple();
package top(Simple par);
top(p()) main;
