module pico() { translate([ 0, 0, 1 ]) rotate(a = [ 90, 0, 90 ]) import("Unnamed-Raspberry\ Pi\ Pico-R004.amf", convexity = 3); }

module pico_test() { pico(); }

// pico_test();
