local AddonName = "BunkerAutoQuest"
local BunkerAutoQuest = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0");
BunkerAutoQuest.enabled = true;
BunkerAutoQuest.events = {"GOSSIP_SHOW","QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE"}

local scrapQuestId = 38175;
local scrapItemId = 113681;

function BunkerAutoQuest:OnInitialize()
    BunkerAutoQuest:RegisterEventsForKristen();
end

function BunkerAutoQuest:GOSSIP_SHOW()
    if not BunkerAutoQuest:StartQuestAutoTurnIn() then return end
    print "SELECT";
    if IsQuestFlaggedCompleted(scrapQuestId) then
        return
    elseif GetQuestLogIndexByID(scrapQuestId) > 0 then
        SelectGossipActiveQuest(1);
    else
        SelectGossipAvailableQuest(1);
    end
end

function BunkerAutoQuest:QUEST_DETAIL()
    if not BunkerAutoQuest:StartQuestAutoTurnIn() then return end
    print "ACCEPT";
    AcceptQuest();
end

function BunkerAutoQuest:QUEST_PROGRESS()
    if not BunkerAutoQuest:StartQuestAutoTurnIn() then return end
    print "COMPLETE1"
    CompleteQuest();
end

function BunkerAutoQuest:QUEST_COMPLETE()
    if not BunkerAutoQuest:StartQuestAutoTurnIn() then return end
    print "COMPLETE2"
    GetQuestReward(2);
end

BunkerAutoQuest:RegisterChatCommand("bunkerautoquest", "SlashCommand")
function BunkerAutoQuest:SlashCommand(msg, editbox)
    BunkerAutoQuest:Toggle();
end

function BunkerAutoQuest:Toggle()
    if BunkerAutoQuest.enabled then
        BunkerAutoQuest.enabled = false
    else
        BunkerAutoQuest.enabled = true
    end
end

function BunkerAutoQuest:StartQuestAutoTurnIn()
    return BunkerAutoQuest.enabled 
        and BunkerAutoQuest:IsKristenStoneforge() 
        and BunkerAutoQuest:HasEnoughScraps();
end

function BunkerAutoQuest:IsKristenStoneforge()
    local guid = UnitGUID("target")
    if guid == nil then
        return false
    end
    local npcId = select (6, strsplit ("-", guid));
    return 77377 == tonumber(npcId);
end

function BunkerAutoQuest:HasEnoughScraps()
    -- TODO implementation
    return GetItemCount(scrapItemId, false, false) >= 25;
end

function BunkerAutoQuest:RegisterEventsForKristen()
    for _,event in pairs(BunkerAutoQuest.events) do
        print("RegisterEvent",event)
        BunkerAutoQuest:RegisterEvent(event);
    end
end

function BunkerAutoQuest:UnregisterEventsForKristen()
    for _,event in pairs(BunkerAutoQuest.events) do
        print("UnregisterEvent",event)
        BunkerAutoQuest:UnregisterEvent(event);
    end
end