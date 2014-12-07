-module(restaurant).
-export([open/0, order/2]).

order(Customer, Menu) ->
    register(Customer, self()),
    manager ! {order, Customer, Menu},
    receive
        {order, ready} -> 
            {_, _, Cursecond} = time(),
            io:format('food for ~s is ready! at ~s.~n', [Customer, integer_to_list(Cursecond)]),
            unregister(Customer)
    end.

make_order(Customer, Menu) ->
    spawn(restaurant, order, [Customer, Menu]).

open() ->
    Manager = spawn(manager, start, [3]),
    register(manager, Manager),
    make_order('Cobe', [pizza, hamburger]),
    make_order('Tom', [pizza, cola]),
    make_order('Bill', [cola]),
    make_order('Yee', [hamburger]).

