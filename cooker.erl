-module(cooker).
-export([start/0]).

start() ->
    idle().

idle() ->
    receive
        {order, Customer, Menu} -> cook(Customer, Menu)
    end.

cook(Customer, [H|T]) ->
    case H of
        pizza ->
            timer:sleep(1000),
            io:format("pizza for ~s is ready~n", [Customer]);
        cola ->
            timer:sleep(500),
            io:format("cola for ~s is ready~n", [Customer]);
        hamburger ->
            timer:sleep(1500),
            io:format("hamburger for ~s is ready~n", [Customer])
    end,
    cook(Customer, T);
cook(Customer, []) ->
    serve(Customer).

serve(Customer) ->
    io:format("serving food for ~s~n", [Customer]),
    Customer ! {order, ready},
    manager ! {cookerfree, self()},
    idle().