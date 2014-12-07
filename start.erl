#!/usr/bin/env escript
-mode(compile).
main()->
    Cooker = restaurant:open();
    restaurant:order(Cooker, "Tom", [pizza, cola]);
    restaurant:order(Cooker, "Cobe", [pizza, hamburger]).