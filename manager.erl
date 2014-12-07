-module(manager).
-export([start/1]).

start(CookerCount) ->
    start_proc(CookerCount, []).

start_proc(0,CookerList) ->
    order_loop(CookerList, [], []);
start_proc(CookerCount, CookerList) ->
    NewCooker = spawn(cooker,start,[]),
    start_proc(CookerCount-1,[NewCooker|CookerList]).

order_loop(AvailableList, BusyList, OrderList) ->
    receive
        {order, Customer, Menu} ->
            {NewAvailableList, NewBusyList, NewOrderList} = 
                assign_cooker(AvailableList, BusyList, [{Customer, Menu}|OrderList]),
            order_loop(NewAvailableList, NewBusyList, NewOrderList);
        {cookerfree, Cooker} ->
            {NewAvailableList, NewBusyList} = free_cooker(Cooker, AvailableList, BusyList),
            {NewAvailableList1, NewBusyList1, NewOrderList} = assign_cooker(NewAvailableList, NewBusyList, OrderList),
            order_loop(NewAvailableList1, NewBusyList1, NewOrderList)
    end.

free_cooker(Cooker, AvailableList, BusyList) ->
    NewBusyList = lists:delete(Cooker, BusyList),
    NewAvailableList = [Cooker|AvailableList],
    {NewAvailableList, NewBusyList}.

assign_cooker(AvailableList, BusyList, []) ->
    {AvailableList, BusyList, []};
assign_cooker([], BusyList, OrderList) ->
    {[], BusyList, OrderList};
assign_cooker([AH|AT] = AvailableList, BusyList, [OH|OT] = OrderList) ->
    NewAvailableList = AT,
    NewBusyList = [AH|BusyList],
    NewOrderList = OT,
    {Customer, Menu} = OH,
    AH ! {order, Customer, Menu},
    io:format("assign cooker ~s to make food for ~s~n", [pid_to_list(AH), Customer]),
    {NewAvailableList, NewBusyList, NewOrderList}.
