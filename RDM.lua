local profile = {};

local Settings = {

    --will only swap out staves while user is wearing a staff
    Staff = false,

    --variable to check sync level to current gear evaluation
    CurrentLevel = 0,
};

-- weapons not shown
-- 2x Wise Wizard's Anelace
-- 2x Temple Knight Army Sword
-- Fencing Degen
-- Buzzard Tuck
-- 2x Centurion's Sword

-- shields not shown
-- Viking Shiled
-- Decurion's Shield


-- sets suffixed _Priority are evaluated by sync level
local sets = {

    --atk+
    ['TP_Priority'] = {
        Head = {'Walkure Mask','Erd. Headband'},
        Neck = {'Tiger Stole'},
        Ear1 = {'Dodge Earring'},
        Ear2 = {'Dodge Earring'},
        Body = {'Scorpion Harness', 'Crow Jupon', 'Mrc.Cpt. Doublet'},
        Hands = {'Ryl.Ftm. Gloves'},
        Ring1 = {'Victory Ring', 'Courage Ring'},
        Ring2 = {'Victory Ring', 'Courage Ring'},
        Back = {'Amemet Mantle', 'Traveler\'s Mantle'},
        Waist = {'Quick Belt', 'Mrc.Cpt. Belt'},
        Legs = {'Cmb.Cst. Slacks', 'Martial Slacks'},
        Feet = {'Crow Gaiters', 'Light Soleas'},
    },

    --eva+
    ['IDLE_Priority'] = {
        Head = {'Erd. Headband'},
        Neck = {'Black Neckerchief'},
        Ear1 = {'Dodge Earring'},
        Ear2 = {'Dodge Earring'},
        Body = {'Scorpion Harness', 'Crow Jupon', 'Mrc.Cpt. Doublet'},
        Hands = {'Scentless Armlets'},
        Ring1 = {'Genius Ring', 'Eremite\'s Ring'},
        Ring2 = {'Genius Ring', 'Eremite\'s Ring'},
        Back = {'Traveler\'s Mantle'},
        Waist = {'Ryl.Kgt. Belt', 'Mrc.Cpt. Belt'},
        Legs = {'Martial Slacks'},
        Feet = {'Crow Gaiters', 'Light Soleas'},
    },
    ['INT_Priority'] = {
        Head = {'Warlock\'s Chapeau', 'Erd. Headband'},
        Neck = {'Black Neckerchief'},
        Ear1 = {'Morion Earring'},
        Ear2 = {'Morion Earring'},
        Body = {'Justaucorps +1', 'Baron\'s Saio'},
        Hands = {'Mage\'s Mitts'},
        Ring1 = {'Genius Ring', 'Eremite\'s Ring'},
        Ring2 = {'Genius Ring', 'Eremite\'s Ring'},
        Back = {'Black Cape +1'},
        Waist = {'Ryl.Kgt. Belt', 'Mrc.Cpt. Belt'},
        Legs = {'Magic Cuisses', 'Mage\'s Slacks'},
        Feet = {'Warlock\'s Boots', 'Tct.Mgc. Pigaches'},
    },
    ['MND_Priority'] = {
        Head = {'Lgn. Circlet'},
        Neck = {'Justice Badge'},
        Ear1 = {'Geist Earring'},
        Ear2 = {'Geist Earring'},
        Body = {'Justaucorps +1', 'Baron\'s Saio'},
        Hands = {'Devotee\'s Mitts'},
        Ring1 = {'Serenity Ring', 'Saintly Ring'},
        Ring2 = {'Serenity Ring', 'Saintly Ring'},
        Back = {'White Cape +1'},
        Waist = {'Ryl.Kgt. Belt', 'Mrc.Cpt. Belt'},
        Legs = {'Magic Cuisses'},
        Feet = {'Warlock\'s Boots', 'Crow Gaiters'},
    },
    ['WORK'] = {
        Body = 'Worker Tunica',
        Hands = 'Worker Gloves',
        Legs = 'Worker Hose',
        Feet = 'Worker Boots',
    },
    ['RLB'] = {
        Head = 'Erd. Headband',
        Neck = 'Black Neckerchief',
        Ear1 = 'Morion Earring',
        Ear2 = 'Morion Earring',
        Body = 'Justaucorps +1',
        Hands = 'Mage\'s Mitts',
        Ring1 = 'Victory Ring',
        Ring2 = 'Victory Ring',
        Back = 'Black Cape +1',
        Waist = 'Ryl.Kgt. Belt',
        Legs = 'Magic Cuisses',
        Feet = 'Tct.Mgc. Pigaches',
    },
};
profile.Sets = sets;

profile.Packer = {
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
end

profile.HandleDefault = function()
    local player = gData.GetPlayer();
    local equip = gData.GetEquipment();

    --wrapped because unequipped causes issues
    if (equip.Main ~= nil) then

        --check for staff by seeing if name ends in "Staff"
        Settings.Staff = string.match(equip.Main.Name, 'Staff$');
    end

    --check for new sync level
    if (player.MainJobSync ~= Settings.CurrentLevel) then

        --set level
        Settings.CurrentLevel = player.MainJobSync;
        gFunc.EvaluateLevels(profile.Sets, Settings.CurrentLevel);
    end

    --handle default player conditions
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.TP);

        --dual wield+
        if (player.SubJob == 'NIN') then gFunc.Equip('Waist', 'Sarashi'); end

    elseif (player.Status == 'Idle') then
        gFunc.EquipSet(sets.IDLE);
	if (Settings.Staff) then gFunc.Equip('Main', 'Earth Staff'); end

    elseif (player.Status == 'Resting') then
        --placeholder for resting gear
        gFunc.EquipSet(sets.IDLE);
	if (Settings.Staff) then gFunc.Equip('Main', 'Dark Staff'); end

    else
        -- unknown status
        gFunc.EquipSet(sets.IDLE);
	if (Settings.Staff) then gFunc.Equip('Main', 'Earth Staff'); end
    end
end

profile.HandleAbility = function()
end

profile.HandleItem = function()

    --resource gathering items [DOES NOT WORK]
    --local item = gData.GetAction();
    --if (item.Name == 'Pickaxe' or
        --item.Name == 'Sickle' or
        --item.Name == 'Hatchet') then
        --gFunc.EquipSet(sets.WORK);
    --end
end

profile.HandlePrecast = function()
    gFunc.Equip('Head', 'Warlock\'s Chapeau')
end

profile.HandleMidcast = function()
    local action = gData.GetAction()

    --int to all black magic and dia spells
    --(will also match Diabolos, Diamondhide, and other spells that start with dia)
    if (action.Type == 'Black Magic' or string.match(action.Name, '^Dia')) then
        gFunc.EquipSet(sets.INT);

    --mnd to white magic
    elseif (action.Type == 'White Magic') then
        gFunc.EquipSet(sets.MND);
    end

    --hooks for magic types
    if (action.Skill ~= nil) then
        if (action.Skill == 'Enhancing Magic') then gFunc.Equip('Legs', 'Warlock\'s Tights');
        elseif (action.Skill == 'Healing Magic') then
            gFunc.Equip('Legs', 'Warlock\'s Tights');
            gFunc.Equip('Neck', 'Healing Torque');
        elseif (action.Skill == 'Elemental Magic') then gFunc.Equip('Head', 'Warlock\'s Chapeau');
        elseif (action.Skill == 'Enfeebling Magic') then gFunc.Equip('Body', 'Warlock\'s Tabard'); end
    end

    --staves
    if (Settings.Staff and action.Element ~= nil) then
        if (action.Element == 'Fire') then gFunc.Equip('Main', 'Fire Staff');
        elseif (action.Element == 'Water') then gFunc.Equip('Main', 'Water Staff');
        elseif (action.Element == 'Thunder') then gFunc.Equip('Main', 'Thunder Staff');
        elseif (action.Element == 'Earth') then gFunc.Equip('Main', 'Earth Staff');
        elseif (action.Element == 'Wind') then gFunc.Equip('Main', 'Wind Staff');
        elseif (action.Element == 'Ice') then gFunc.Equip('Main', 'Ice Staff');
        elseif (action.Element == 'Light') then gFunc.Equip('Main', 'Light Staff');
        elseif (action.Element == 'Dark') then gFunc.Equip('Main', 'Dark Staff'); end
    end

end

profile.HandlePreshot = function()
end

profile.HandleMidshot = function()
end

profile.HandleWeaponskill = function()
    local action = gData.GetAction()
    if (action.Name == 'Red Lotus Blade') then
        gFunc.EquipSet(sets.RLB);
    end
end

return profile;
