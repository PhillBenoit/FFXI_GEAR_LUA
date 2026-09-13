-- BLU example for Horizon.
-- attribute assicians are guesses
-- breath spells in retail rely on HP.  Have not implemented that.
-- Magic Accuracy has been lumped into INT gear becuase I have no MACC gear.
-- Gear Level Sync down to 30
-- USES HUME MALE RSE
-- If you think my gear sucks, you're welcome to buy me better gear

local profile = {};

local Settings = {

    --will only swap out staves while user is wearing a staff
    Staff = false,

    --variable to check sync level to current gear evaluation
    CurrentLevel = 0,
};

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
        Ring1 = {'Rajas Ring', 'Courage Ring'},
        Ring2 = {'Victory Ring', 'Courage Ring'},
        Back = {'Amemet Mantle', 'Traveler\'s Mantle'},
        Waist = {'Quick Belt', 'Mrc.Cpt. Belt'},
        Legs = {'Cmb.Cst. Slacks', 'Martial Slacks'},
        Feet = {'Magus Charuqs', 'Crow Gaiters', 'Light Soleas'},
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
        Feet = {'Magus Charuqs', 'Crow Gaiters', 'Light Soleas'},
    },
    ['INT_Priority'] = {
        Head = {'Magus Keffiyeh', 'Erd. Headband'},
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
        Feet = {'Tct.Mgc. Pigaches'},
    },
    ['MND_Priority'] = {
        Head = {'Magus Keffiyeh', 'Lgn. Circlet'},
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
        Feet = {'Crow Gaiters'},
    },
    ['STR_Priority'] = {
        Neck = {'Spike Necklace'},
        Body = {'Magus Jubbah'},
        Hands = {'Enkelados\'s Brc.', 'Custom M Gloves'},
        Ring1 = {'Rajas Ring', 'Courage Ring'},
        Ring2 = {'Victory Ring', 'Courage Ring'},
        Back = {'Amemet Mantle'},
        Waist = {'Ryl.Kgt. Belt'},
    },
    ['DEX_Priority'] = {
        Neck = {'Spike Necklace'},
        Body = {'Magus Jubbah', 'Mrc.Cpt. Doublet'},
        Hands = {'Custom M Gloves'},
        Ring1 = {'Rajas Ring'},
        Ring2 = {'Fluorite Ring'},
        Waist = {'Ryl.Kgt. Belt', 'Mrc.Cpt. Belt'},
    },
    ['VIT'] = {
        Ring1 = 'Chrysoberyl Ring',
        Ring2 = 'Chrysoberyl Ring',
        Waist = 'Warrior\'s Belt +1',
        Legs = 'Magus Shalwar',
    },
    ['AGI_Priority'] = {
        Ear1 = {'Wing Earring'},
        Ear2 = {'Wing Earring'},
        Body = {'Mrc.Cpt. Doublet'},
        Ring1 = {'Jadeite Ring'},
        Ring2 = {'Jadeite Ring'},
        Waist = {'Ryl.Kgt. Belt', 'Mrc.Cpt. Belt'},
        Legs = {'Magus Shalwar', 'Martial Slacks'},
    },
    ['CHR_Priority'] = {
        Ring1 = {'Moon Ring'},
        Ring2 = {'Moon Ring'},
        Waist = {'Ryl.Kgt. Belt', 'Mrc.Cpt. Belt'},
    },
    ['RLB_Priority'] = {
        Head = {'Magus Keffiyeh', 'Erd. Headband'},
        Neck = {'Black Neckerchief'},
        Ear1 = {'Morion Earring'},
        Ear2 = {'Morion Earring'},
        Body = {'Magus Jubbah', 'Baron\'s Saio'},
        Hands = {'Enkelados\'s Brc.'},
        Ring1 = {'Rajas Ring', 'Courage Ring'},
        Ring2 = {'Victory Ring', 'Courage Ring'},
        Back = {'Black Cape +1'},
        Waist = {'Ryl.Kgt. Belt', 'Mrc.Cpt. Belt'},
        Legs = {'Magic Cuisses', 'Mage\'s Slacks'},
        Feet = {'Tct.Mgc. Pigaches'},
    },
    ['SB_Priority'] = {
        Head = {'Magus Keffiyeh', 'Lgn. Circlet'},
        Neck = {'Justice Badge'},
        Ear1 = {'Geist Earring'},
        Ear2 = {'Geist Earring'},
        Body = {'Magus Jubbah', 'Baron\'s Saio'},
        Hands = {'Enkelados\'s Brc.', 'Devotee\'s Mitts'},
        Ring1 = {'Rajas Ring', 'Courage Ring'},
        Ring2 = {'Victory Ring', 'Courage Ring'},
        Back = {'White Cape +1'},
        Waist = {'Ryl.Kgt. Belt', 'Mrc.Cpt. Belt'},
        Legs = {'Magic Cuisses'},
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
end

profile.HandlePrecast = function()
end

profile.HandleMidcast = function()
    local action = gData.GetAction()

    local StrSpells = T{'Battle Dance', 'Uppercut', 'Death Scissors', 'Dimensional Death',
        'Empty Thrash', 'Spinal Cleave', 'Vertical Cleave'};
    local DexSpells = T{'Foot Kick', 'Head Butt', 'Claw Cyclone', 'Smite of Rage', 'Terror Touch',
        'Sickle Slash', 'Vanity Dive', 'Frenetic Rip', 'Frypan', 'Hysteric Barrage', 'Tail slap',
        'Disseverment'};
    local VitSpells = T{'Power Attack', 'Sprout Smack', 'Grand Slam', 'Quad. Continuum',
        'Self-Destruct', 'Hecatomb Wave', 'Flying Hip Press', 'Sandspin', 'Metallic Body', 'Cocoon',
        'Magnetite Cloud', 'Filamented Hold', 'Poison Breath', 'Bad Breath', 'Body Slam',
        'Diamondhide', 'Warm-Up', 'Cannonball'};
    local AgiSpells = T{'Wild Oats', 'Feather Storm', 'Helldive', 'Pinecone Bomb', 'Jet Stream',
        'Refueling', 'Feather Barrier', 'Occultation', 'Hydro Shot', 'Feather Tickle',
        'Voracious Trunk', 'Zephyr Mantle'};
    local IntSpells = T{'Queasyshroom', 'Mandibular Bite', 'Blastbomb', 'Bomb Toss', 'Sound Blast',
        'Ice Break', 'Cold Wave', 'Chaotic Eye', 'Stinking Gas', 'Frightful Roar', 'Auroral Drape',
        'Blitzstrahl', 'Cursed Sphere', 'Venom Shell', 'Blood Drain', 'Soporific', 'Death Ray',
        'Digest', 'MP Drainkiss', 'Geist Wall', 'Blood Saber', 'Jettatura', 'Eyes On Me',
        'Maelstrom','Memento Mori', 'Infrasonics', 'Frost Breath', 'Sandspray', 'Enervation',
        'Firespit', 'Heat Breath', 'Lowing', 'Temporal Shift', 'Actinic Burst', 'Reactor Cool',
        'Plasma Charge'};
    local MndSpells = T{'Screwdriver', 'Healing Breeze', 'Awful Eye', 'Pollen', 'Sheep Song',
        'Wild Carrot', 'Blank Gaze', 'Magic Fruit', 'Winds of Promy.', 'Amplification',
        'Mind Blast', 'Ram Charge', 'Magic Hammer', 'Exuviation'};
    local ChrSpells = T{'Bludgeon', 'Mysterious Light', 'Radiant Breath', 'Light of Penance',
        '1000 Needles', 'Yawn', 'Saline Coat'};

    local FireStaff = T{'Firespit', 'Lowing', 'Blastbomb', 'Bomb Toss', 'Sound Blast',
        'Self-Destruct'};
    local WaterStaff = T{'Maelstrom', 'Amplification', 'Cursed Sphere', 'Venom Shell',
        'Awful Eye', 'Poison Breath'};
    local ThunderStaff = T{'Mind Blast', 'Temporal Shift', 'Plasma Charge', 'Blitzstrahl'};
    local EarthStaff = T{'Bad Breath', 'Sandspray', 'Warm-Up', 'Diamondhide',
        'Filamented Hold', 'Magnetite Cloud', 'Cocoon', 'Sandspin', 'Metallic Body'};
    local WindStaff = T{'Feather Tickle', 'Voracious Trunk', 'Zephyr Mantle', 'Chaotic Eye',
        'Stinking Gas', 'Mysterious Light', 'Refueling', 'Frightful Roar', 'Hecatomb Wave',
        'Feather Barrier', 'Flying Hip Press', 'Auroral Drape', 'Occultation'};
    local IceStaff = T{'Memento Mori', 'Infrasonics', 'Frost Breath', 'Reactor Cool',
        'Ice Break', 'Cold Wave'};
    local LightStaff = T{'1000 Needles', 'Yawn', 'Saline Coat', 'Actinic Burst', 'Magic Hammer',
        'Exuviation', 'Healing Breeze', 'Pollen', 'Sheep Song', 'Wild Carrot', 'Blank Gaze',
        'Radiant Breath', 'Light of Penance', 'Magic Fruit', 'Winds of Promy.'};
    local DarkStaff = T{'Eyes On Me', 'Enervation', 'Blood Drain', 'Soporific', 'Death Ray',
        'Digest', 'MP Drainkiss', 'Geist Wall', 'Blood Saber', 'Jettatura'};

    if (StrSpells:contains(action.Name)) then gFunc.EquipSet(sets.STR);
    elseif (DexSpells:contains(action.Name)) then gFunc.EquipSet(sets.DEX);
    elseif (VitSpells:contains(action.Name)) then gFunc.EquipSet(sets.VIT);
    elseif (AgiSpells:contains(action.Name)) then gFunc.EquipSet(sets.AGI);
    elseif (IntSpells:contains(action.Name)) then gFunc.EquipSet(sets.INT);
    elseif (MndSpells:contains(action.Name)) then gFunc.EquipSet(sets.MND);
    elseif (ChrSpells:contains(action.Name)) then gFunc.EquipSet(sets.CHR); end

    --Blue Magic Skill increase
    if (action.Type == 'Blue Magic') then gFunc.Equip('Body', 'Magus Jubbah'); end

    --staves
    if (Settings.Staff) then
        if (FireStaff:contains(action.Name)) then gFunc.Equip('Main', 'Fire Staff');
        elseif (LightStaff:contains(action.Name)) then gFunc.Equip('Main', 'Light Staff');
        elseif (WaterStaff:contains(action.Name)) then gFunc.Equip('Main', 'Water Staff');
        elseif (ThunderStaff:contains(action.Name)) then gFunc.Equip('Main', 'Thunder Staff');
        elseif (EarthStaff:contains(action.Name)) then gFunc.Equip('Main', 'Earth Staff');
        elseif (WindStaff:contains(action.Name)) then gFunc.Equip('Main', 'Wind Staff');
        elseif (IceStaff:contains(action.Name)) then gFunc.Equip('Main', 'Ice Staff');
        elseif (DarkStaff:contains(action.Name)) then gFunc.Equip('Main', 'Dark Staff'); end
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
    elseif (action.Name == 'Shining Blade') then
        gFunc.EquipSet(sets.SB);
    elseif (action.Name == 'Seraph Blade') then
        gFunc.EquipSet(sets.SB);
    elseif (action.Name == 'Savage Blade') then
        gFunc.EquipSet(sets.SB);
    elseif (action.Name == 'Vorpal Blade') then
        gFunc.EquipSet(sets.STR);
    end
end

return profile;
