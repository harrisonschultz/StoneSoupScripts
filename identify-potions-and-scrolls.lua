local infinite_loop_safety_net = 0
local infinite_loop_safety_net_max = 100

local auto_identify_scrolls_and_potions = false
local remaining_unidentified_scrolls_and_potions = false
local identify_scrolls_with_scrolls_of_identify = false
local check_for_poison_gas = false

function ready()
    if auto_identify_scrolls_and_potions and infinite_loop_safety_net < infinite_loop_safety_net_max then
        infinite_loop_safety_net = infinite_loop_safety_net + 1
        allies = initialize_ally_table()

        if not remaining_unidentified_scrolls_and_potions then
            stop_identifying('Auto Identify Stopped - nothing left to identify.')
        elseif safe_to_identify(allies) then
            identify_scrolls_and_potions()
        else 
            crawl.sendkeys('5');
        end
    end
end

function safe_to_identify(allies)
    if do_I_have_summons(allies) then
        notify_print('Auto Identify - waiting for summons to disappear.')
        return false
    end

    if you.silenced() then
        notify_print('Auto Identify - waiting for silence to wear off')
        return false
    end

    if check_for_poison_gas then
        if is_there_poison_gas_nearby() then
            notify_print('Auto Identify - waiting for poison gas to dissipate')
            return false
        else
            check_for_poison_gas = false
        end
    end

    return true
end

function c_message(text, channel)
    if string.find(string.lower(text), 'it was a scroll of poison.') then
        check_for_poison_gas = true
    end
end


function c_interrupt_activity(aname, iname, cause, extra)
    if string.find(aname, "rest") and not string.find(string.lower(extra), "done waiting") and auto_identify_scrolls_and_potions then
        stop_identifying('Auto Identify Stopped - rest interrupted.')
    end

    return false
end

function c_interrupt_activity(aname, iname, cause, extra)
    if string.find(aname, "rest") and not string.find(string.lower(extra), "done waiting") and auto_identify_scrolls_and_potions then
        stop_identifying('Auto Identify Stopped - rest interrupted.')
    end

    return false
end

function do_I_have_summons(monster_table)
    return table_length(monster_table) > 0
end

function is_there_poison_gas_nearby()
    local los = 4

    for y = los, -los, -1 do
        for x = -los, los do
            local cloud = view.cloud_at(x, y)
            if cloud and string.find(cloud, "poison gas") then
                return true
            end
        end
    end

    return false
end

function initialize_ally_table()
    local los = you.los()
    local allies = {}
    local count = 0

    for y = los, -los, -1 do
        for x = -los, los do
            local monster_details = monster.get_monster_at(x, y)
            if monster_details and monster_details:attitude() == 4 then
                allies[count] = monster_details
                count = count + 1
            end
        end
    end

    return allies
end

function identify_scrolls_and_potions() 
    local item_list = items.inventory()
    local scroll_unidentified_list = {}
    local potion_unidentified_list = {}
    local scroll_of_identify_letter = nil
    local scroll_indexer = 0
    local potion_indexer = 0

    for _, item in pairs(item_list) do
        if string.find(string.lower(item:name()), "scroll") then
            if not item.fully_identified then
                scroll_unidentified_list[scroll_indexer] = item
                scroll_indexer = scroll_indexer + 1 
            elseif string.find(item:name(), "identify") then
                scroll_of_identify_letter = items.index_to_letter(item.slot)
            end
        end
        if string.find(item:name(), "potion") then
            if not item.fully_identified then
                potion_unidentified_list[potion_indexer] = item
                potion_indexer = potion_indexer + 1 
            end
        end
    end

    if table_length(scroll_unidentified_list) > 0 then
        scroll_unidentified_list = sort_item_array(scroll_unidentified_list)
    end
    if table_length(potion_unidentified_list) > 0 then
        potion_unidentified_list = sort_item_array(potion_unidentified_list)
    end
    
  

    if identify_scrolls_with_scrolls_of_identify then
        if scroll_of_identify_letter and (table_length(scroll_unidentified_list) > 0 or table_length(potion_unidentified_list) > 0) then
            remaining_unidentified_scrolls_and_potions = true 
        else
            remaining_unidentified_scrolls_and_potions = false
        end
        
        if scroll_of_identify_letter then
            if table_length(scroll_unidentified_list) > 0 then
                identify_item(scroll_of_identify_letter, scroll_unidentified_list[0])
            elseif table_length(potion_unidentified_list) > 0 then
                identify_item(scroll_of_identify_letter, potion_unidentified_list[0])
            end
        end
    else
        if table_length(scroll_unidentified_list) > 0 or (table_length(potion_unidentified_list) > 0 and scroll_of_identify_letter) then
            remaining_unidentified_scrolls_and_potions = true 
        else
            remaining_unidentified_scrolls_and_potions = false
        end

        if scroll_of_identify_letter and table_length(potion_unidentified_list) > 0 then
            identify_item(scroll_of_identify_letter, potion_unidentified_list[0])
        elseif table_length(scroll_unidentified_list) > 0 then
            read_scroll(scroll_unidentified_list[0])
        end
    end
end

function stop_identifying(message)
    if message then
        notify_print(message)
    end
    remaining_unidentified_scrolls_and_potions = false
    auto_identify_scrolls_and_potions = false
    identify_scrolls_with_scrolls_of_identify = false
    infinite_loop_safety_net = 0
end

function identify_item(identify_scroll_letter, item)
    crawl.sendkeys("r"..identify_scroll_letter..items.index_to_letter(item.slot))
end

function read_scroll(scroll)
    crawl.sendkeys("r"..items.index_to_letter(scroll.slot))
end

function sort_item_array(item_array)
    local items_sorted = false
    local iteration_count = 0
    
    while not items_sorted do
        local last_item = nil
        iteration_count = iteration_count + 1
        items_sorted = true
        for index = 0, table_length(item_array) - 1 do
            local item = item_array[index]
            if last_item then
                if item.quantity > last_item.quantity then
                    items_sorted = false
                    item_array[index - 1] = item
                    item_array[index] = last_item
                else 
                    item_array[index] = item
                    last_item = item
                end
            else
                item_array[index] = item
                last_item = item
            end
        end
    end

    return item_array
end

function start_identify_scrolls_and_potions()
    auto_identify_scrolls_and_potions = true
    identify_scrolls_and_potions()
end

function start_identify_scrolls_and_potions_no_blind()
    auto_identify_scrolls_and_potions = true
    identify_scrolls_with_scrolls_of_identify = true
    identify_scrolls_and_potions()
end

function table_length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function take_action(action, delay)
    if delay then
        crawl.delay(delay)
    end
    crawl.do_commands(action)
end

function notify_print(message)
    crawl.mpr(message, notify_text_channel)
end
