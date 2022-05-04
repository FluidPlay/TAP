function widget:GetInfo()
    return {
        name = "Options",
        desc = "",
        author = "Floris",
        date = "September 2016",
        layer = -99990,
        enabled = true,
        handler = true,
    }
end

--[[
--[[
--   Add option, at:
--   function init
]]--

VFS.Include("gamedata/taptools.lua")

local texts = {        -- fallback (if you want to change this, also update: language/en.lua, or it will be overwritten)
    basic = 'Basic',
    advanced = 'Advanced',
    group = {
        graphics = 'Graphics',
        interface = 'Interface',
        game = 'Game',
        control = 'Control',
        audio = 'Audio',
        notifications = 'Notifications',
        dev = 'Dev',
    },
    presetnames = {'lowest', 'low', 'medium', 'high', 'ultra'},
    option = {
        preset = 'Load graphics preset',
        preset_descr = 'Wont reapply the preset every time you restart a game.\n\nSave custom preset with /savepreset name\nRightclick to delete a custom preset',
        resolution = 'Resolution',
        resolution_descr = 'WARNING: sometimes freezes game engine in windowed mode',
        fullscreen = 'Fullscreen',
        borderless = 'Borderless window',
        borderless_descr = 'Changes will be applied next game.\n\n(dont forget to turn off the \'fullscreen\' option next game)',
        windowpos = 'Move window position',
        windowpos_descr = 'Toggle and move window position with the arrow keys or by dragging',
        vsync = 'V-sync',
        vsync_spec = 'only when spectator',
        vsync_spec_descr = 'Only enable vsync when being spectator',
        vsync_level = 'divider',
        vsync_level_descr = 'Lowers max framerate, resticting fps. (set to 1 to have max fps)\nneeds vsync option above to be enabled.\nNOTE: does not always work!\n(I like to use this when I\'m spectating on my 144hz laptop)',
        limitidlefps = 'Limit FPS when idle/offscreen',
        limitidlefps_descr = 'Reduces fps when idle (by setting vsync to a high number)\n(for borderless window and fullscreen need engine not have focus)\nMakes your pc more responsive/cooler when you do stuff outside the game\nCamera movement will break idle mode',
        msaa = 'Anti Aliasing',
        msaa_descr = 'Enables multisample anti-aliasing. NOTE: Can be expensive!\n\nChanges will be applied next game',
        cas_sharpness = 'Contrast Adaptive Sharpen',
        cas_sharpness_descr = 'How much sharpening should be applied to the image',
        shadowslider = 'Shadows',
        shadowslider_descr = 'Set shadow detail',
        shadows_opacity = 'opacity',
        sun = 'Sun',
        sun_y = 'height',
        sun_x = 'pos X',
        sun_z = 'pos Z',
        sun_reset = 'reset map default',
        darkenmap = 'Darken map',
        darkenmap_descr = 'Darkens the whole map (not the units)\n\nRemembers setting per map\nUse /resetmapdarkness if you want to reset all stored map settings',
        darkenmap_darkenfeatures = 'darken features',
        darkenmap_darkenfeatures_descr = 'Darkens features (trees, wrecks, ect..) along with darken map slider above\n\nNOTE: Can be CPU intensive: it cycles through all visible features\nand renders them another time.',
        fog = 'Fog',
        fog_start = 'start',
        fog_start_descr = 'NOTE: remembers setting per map',
        fog_end = 'end',
        fog_end_descr = 'NOTE: remembers setting per map',
        fog_reset = 'reset map default',
        ssao = 'SSAO',
        ssao_descr = 'SSAO quality level\nlow quality looks more grainy (when closeup and moving the camera or units)\n\nWARNING: might introduce a bit of lag',
        ssao_strength = 'strength',
        outline = 'Unit outline',
        outline_descr = 'Adds a small outline to all units which makes them crisp.',
        outline_width = 'width',
        outline_width_descr = 'Set the width of the outline\n\nOutline size stays the same regardless of viewing distance',
        outline_mult = 'opacity',
        outline_mult_descr = 'Set the relative strength of the outline',
        outline_color = 'white',
        outline_color_descr = 'Black (off) or white (on) colored outline ',
        bloomdeferred = 'Bloom (unit)',
        bloomdeferred_descr = 'Unit highlights and lights will glow.\n\n(via deferred rendering = less lag)',
        bloomdeferredbrightness = 'brightness',
        bloom = 'Bloom (global)',
        bloom_descr = 'Bloom will make the map and units glow\n\n(might result in more laggy experience)',
        bloombrightness = 'brightness',
        mapedgeextension = 'Map edge extension',
        mapedgeextension_descr = 'Mirrors the map at screen edges and darkens and decolorizes them\n\nEnable shaders for best result',
        mapedgeextension_brightness = 'brightness',
        mapedgeextension_curvature = 'curvature',
        mapedgeextension_curvature_descr = 'Curve the mirrored edges away into the floor/seabed',
        water = 'Water type',
        decals = 'Ground decals',
        decals_descr = 'Set how long map decals will stay.\n\nDecals are ground scars, footsteps/tracks and shading under buildings',
        grounddetail = 'Ground detail',
        grounddetail_descr = 'Set how detailed the map mesh/model is',
        disticon = 'Strategic icon distance',
        disticon_descr = 'Set a lower value to get better performance',
        iconscale = 'scale',
        iconscale_descr = 'Note that the minimap icon size is affected as well',
        featuredrawdist = 'Feature draw distance',
        featuredrawdist_descr = 'Features (trees, stones, wreckage) stop being displayed at this distance',
        particles = 'Particle limit',
        particles_descr = 'Particle limit used for explosions, smoke, fire and missiletrails\n\nBeware, a too low value can result in the particle bugdget being reached,\nand effects no longer show up',
        lighteffects = 'Lights',
        lighteffects_descr = 'Adds lights to projectiles, lasers and explosions.\n\nRequires shaders.',
        lighteffects_life = 'lifetime',
        lighteffects_life_descr = 'lifetime of explosion lights',
        lighteffects_brightness = 'brightness',
        lighteffects_brightness_descr = 'Set the brightness of the lights',
        lighteffects_radius = 'radius',
        lighteffects_radius_descr = 'Set the radius of the lights\n\nWARNING: the bigger the radius the heavier on the GPU',
        dof = 'Depth of Field',
        dof_descr = 'Applies out of focus blur',
        dof_autofocus = 'autofocus',
        dof_autofocus_descr = 'Disable to have mouse position focus',
        dof_fstop = 'f-stop',
        dof_fstop_descr = 'Set amount of blur\n\nOnly works if autofocus is off',
        nanoparticles = 'Nano particles',
        airjets = 'Jet engine fx',
        airjets_descr = 'Jet engine thrusters, additional lighting.',
        jetenginefx_lights = 'add lights  (needs \'Lights\')',
        jetenginefx_lights_descr = 'Adds a light to air engine thrusters (fighters and scouts excluded)',
        airjets_limitfps = 'no fighters/scouts below fps',
        airjets_limitfps_descr = 'disable for fighters and scouts when average FPS gets below this amount',
        airjets_disablefps = 'disable below fps',
        airjets_disablefps_descr = 'disable when average FPS gets below this amount',
        treewind = 'Tree Wind',
        treewind_descr = 'Makes trees wave in the wind.\n\n(will not apply too every tree type)',
        heatdistortion = 'Heat distortion fx',
        heatdistortion_descr = 'Adds a distortion effect to explosions and flames',
        clouds = 'Clouds',
        clouds_opacity = 'opacity',
        snow = 'Snow',
        snow_descr = 'Snow widget (By default.. maps with wintery names have snow applied)',
        snowmap = 'enabled on this map',
        snowmap_descr = 'It will remember what you toggled for every map\n\n(by default: maps with wintery names have this toggled)',
        snowautoreduce = 'auto reduce',
        snowautoreduce_descr = 'Automaticly reduce snow when average FPS gets lower\n\n(re-enabling this needs time to readjust  to average fps again',
        snowamount = 'amount',
        snowamount_descr = 'disable "auto reduce" option to see the max snow amount you have set',
        resurrectionhalos = 'Resurrected unit halos',
        resurrectionhalos_descr = 'Gives units have have been resurrected a little halo above it.',
        tombstones = 'Tombstones',
        tombstones_descr = 'Displays tombstones where commanders died',
        snddevice = 'Sound device',
        snddevice_descr = 'Select a sound device\ndefault means your default OS playback device\n\nNOTE: Changes require a restart',
        sndvolmaster = 'Master volume',
        sndvolgeneral = 'general',
        sndvolbattle = 'battle',
        sndvolui = 'interface',
        sndvolunitreply = 'unit reply',
        sndairabsorption = 'Air absorption',
        sndairabsorption_descr = 'Air absorption is basically a low-pass filter relative to distance between\nsound source and listener, so when in your base or zoomed out, front battles\nwill be heard as only low frequencies',
        sndvolmusic = 'Music volume',
        loadscreen_music = 'music starts on loadscreen',
        loadscreen_music_descr = 'Music when displaying the startup load screen',
        scav_messages = 'Scavenger written notifications',
        scav_voicenotifs = 'Scavenger voice notifications',
        scav_voicenotifs_descr = 'Toggle the scavenger announcer voice',
        notifications_tutorial = 'Tutorial mode',
        notifications_tutorial_descr = 'Additional messages that guide you how to play\n\nIt remembers what has been played already\n(Re)enabling this will reset this',
        notifications_messages = 'Written notifications',
        notifications_messages_descr = 'Displays notifications on screen',
        notifications_spoken = 'Voice notifications',
        notifications_spoken_descr = 'Plays voice notifications',
        notifications_volume = 'volume',
        notifications_volume_descr = 'NOTE: it also uses interface volume channel (Sound tab)',
        notifications_playtrackedplayernotifs = 'tracked cam/player notifs',
        notifications_playtrackedplayernotifs_descr = 'Displays notifications from the perspective of the currently camera tracked player',
        hwcursor = 'Hardware cursor',
        hwcursor_descr = 'When disabled: mouse cursor refresh rate will equal to your ingame fps',
        cursorsize = 'Cursor size',
        cursorsize_descr = 'Note that cursor already auto scales according to screen resolution\n\nFurther adjust size and snap to a smaller/larger size',
        crossalpha = 'Cursor \'cross\' alpha',
        crossalpha_descr = 'Opacity of mouse icon in center of screen when you are in camera pan mode\n\n(The\'icon\' has a dot in center with 4 arrows pointing in all directions)',
        middleclicktoggle = 'Middleclick toggles camera move',
        middleclicktoggle_descr = 'Enable camera pan toggle via single middlemouse click',
        containmouse = 'Contain mouse',
        containmouse_descr = 'When in windowed mode, this prevents your mouse from moving out of it',
        screenedgemove = 'Screen edge moves camera',
        screenedgemove_descr = 'If mouse is close to screen edge this will move camera\n\nChanges will be applied next game',
        screenedgemovewidth = 'edge width',
        screenedgemovewidth_descr = 'In percentage of screen border',
        screenedgemovedynamic = 'variable speed',
        screenedgemovedynamic_descr = 'Enable if scrolling speed should fade with edge distance.',
        camera = 'Camera',
        camerashake = 'shake',
        camerashake_descr = 'Set the amount of camerashake on explosions',
        camerasmoothness = 'smoothing',
        camerasmoothness_descr = 'How smooth should the transitions between camera movement be?',
        camerapanspeed = 'middleclick grab speed',
        camerapanspeed_descr = 'Smoothness of camera panning mode',
        cameramovespeed = 'move speed',
        cameramovespeed_descr = 'Smoothness of camera moving mode',
        scrollspeed = 'scroll zoom speed',
        scrollinverse = 'reverse scrolling',
        lockcamera_transitiontime = 'Tracking cam smoothing',
        lockcamera_transitiontime_descr = 'When viewing a players camera...\nhow smooth should the transitions between camera movement be?',
        interface = 'Interface',
        uiscale = 'scale',
        guiopacity = 'opacity',
        guitilescale = 'background tile scale',
        guitileopacity = 'opacity',
        guishader = 'blur',
        guishader_descr = 'Blurs the world under every user interface element',
        guishaderintensity = '   intensity',
        font = 'font',
        font_descr = 'Regular read friendly font used for text',
        font2 = 'font 2',
        font2_descr = 'Stylistic font mainly used for names/buttons/titles',
        teamcolors = 'Player colors: auto generated ingame',
        teamcolors_descr = 'Replaces lobby colors with a auto generated color palette based one\n\nNOTE: reloads all widgets because these need to update their colors',
        sameteamcolors = 'team colorisation',
        sameteamcolors_descr = 'Use the same teamcolor for all the players in a team\n\nNOTE: reloads all widgets because these need to update their teamcolors',
        minimap = 'Minimap',
        minimap_enlarged = 'enlarged',
        minimap_enlarged_descr = 'Relocates the order-menu to make room for the minimap',
        simpleminimapcolors = 'simple colors',
        simpleminimapcolors_descr = 'Enable simple minimap teamcolors\nRed is enemy,blue is ally and you are green!',
        minimapiconsize = 'icon scale',
        buildmenu = 'Build menu',
        buildmenu_makefancy = 'fancy',
        buildmenu_makefancy_descr = 'Adds extra gradients and highlights',
        buildmenu_bottom = 'bottom position',
        buildmenu_bottom_descr = 'Relocate the buildmenu to the bottom of the screen',
        buildmenu_alwaysshow = 'always show',
        buildmenu_alwaysshow_descr = 'Not hiding when no builders are selected',
        buildmenu_prices = 'prices',
        buildmenu_prices_descr = 'Unit prices in the buildmenu\n\n(when disabled: still show when hovering icon)',
        buildmenu_groupicon = 'group icon',
        buildmenu_groupicon_descr = 'Group icons in the buildmenu',
        buildmenu_radaricon = 'radar icon',
        buildmenu_radaricon_descr = 'Radar icons in the buildmenu',
        buildmenu_tooltip = 'tooltips',
        buildmenu_tooltip_descr = 'Tooltip when hovering over a unit in the buildmenu',
        info = 'Info',
        buildpower = 'build power usage bar',
        buildpower_descr = 'Adds a vertical build power usage bar to the right of the info UI ',
        ordermenu = 'Ordermenu',
        ordermenu_colorize = 'colorize',
        ordermenu_bottompos = 'bottom position',
        ordermenu_bottompos_descr = 'Relocate the ordermenu to the bottom of the screen',
        ordermenu_alwaysshow = 'always show',
        ordermenu_alwaysshow_descr = 'Not hiding when no buttons are available',
        ordermenu_hideset = 'hide common commands',
        ordermenu_hideset_descr = 'Hide the ordermenu commands that have shortcuts:\n\nMove, Stop, Attack, Patrol, Fight, Wait, Guard, Reclaim, Repair, D-Gun',
        advplayerlist = 'Playerlist',
        advplayerlist_scale = 'scale',
        advplayerlist_scale_descr = 'Resize the playerlist (and its addons)',
        advplayerlist_showid = 'show Team ID',
        advplayerlist_showid_descr = 'show team ID',
        advplayerlist_country = 'show country flag',
        advplayerlist_country_descr = 'show country flag',
        advplayerlist_rank = 'show rank icon',
        advplayerlist_rank_descr = 'show rank icon',
        advplayerlist_side = 'show faction icon',
        advplayerlist_side_descr = 'show side/faction icon',
        advplayerlist_skill = 'show skill number',
        advplayerlist_skill_descr = 'show trueskill number',
        advplayerlist_cpuping = 'show cpuping number',
        advplayerlist_cpuping_descr = 'show cpu/ping usage/value',
        advplayerlist_share = 'show share buttons',
        advplayerlist_share_descr = 'show (quick) share buttons\n\nNOTE: auto hides when having no team members',
        mascot = 'mascot',
        mascot_descr = 'Shows a mascot on top of the playerslist',
        unittotals = 'unit totals',
        unittotals_descr = 'Show your unit totals on top of the playerlist',
        musicplayer = 'music player',
        musicplayer_descr = 'Show music player on top of playerlist',
        console = 'Console',
        consolemaxlines = 'max lines',
        consolefontsize = 'font size',
        idlebuilders = 'List idle builders',
        idlebuilders_descr = 'Displays a row of idle builder units at the bottom of the screen',
        buildbar = 'Factory build bar',
        buildbar_descr = 'Displays a column of factories at the right side of the screen\nhover and click units to quickly add to the factory queue',
        teamplatter = 'Unit team platters',
        teamplatter_descr = 'Shows a team color platter above all visible units',
        teamplatter_opacity = 'opacity',
        teamplatter_opacity_descr = 'Set the opacity of the team spotters',
        teamplatter_skipownteam = 'skip own units',
        teamplatter_skipownteam_descr = 'Doesnt draw platters for yourself',
        enemyspotter = 'Enemy spotters',
        enemyspotter_descr = 'Draws smoothed circles under enemy units\n\nDisables when enemy is single colored or alone',
        enemyspotter_opacity = 'opacity',
        enemyspotter_opacity_descr = 'Set the opacity of the enemy-spotter rings',
        fancyselectedunits = 'Selection Unit Platters',
        fancyselectedunits_descr = 'Draws a platter under selected units\n\nNOTE: this widget can be heavy when having lots of units selected',
        fancyselectedunits_baseopacity = 'opacity',
        fancyselectedunits_baseopacity_descr = 'Set the opacity of the highlight on selected units',
        fancyselectedunits_teamcoloropacity = 'teamcolor amount',
        fancyselectedunits_teamcoloropacity_descr = 'Set the amount of teamcolor used for the base platter',
        highlightselunits = 'Selection Unit Highlight',
        highlightselunits_descr = 'Highlights unit models when selected',
        highlightselunits_opacity = 'opacity',
        highlightselunits_opacity_descr = 'Set the opacity of the highlight on selected units',
        highlightselunits_teamcolor = 'use teamcolor',
        highlightselunits_teamcolor_descr = 'Use teamcolor instead of unit health coloring',
        metalspots = 'Metalspot indicators',
        metalspots_descr = 'Shows a circle around metal spots with the amount of metal in it',
        metalspots_opacity = 'opacity',
        metalspots_opacity_descr = 'Display metal values in the center',
        metalspots_values = 'show values',
        metalspots_values_descr = 'Display metal values (during game)\nPre-gamestart or when in metalmap view (f4) this will always be shown\n\nNote that it\'s significantly enough more costly to draw the text values',
        metalspots_metalviewonly = 'limit to F4 (metalmap) view',
        metalspots_metalviewonly_descr = 'Limit display to only during pre-gamestart or when in metalmap view (f4)',
        healthbars = 'Health bars',
        healthbarsscale = 'scale',
        healthbarsdistance = 'draw distance',
        healthbarsvariable = 'variable sizes',
        healthbarsvariable_descr = 'Increases healthbar sizes for bigger units',
        healthbarshide = 'show health only when selected',
        healthbarshide_descr = 'Hide the healthbar and rely on damaged unit looks',
        rankicons = 'Rank icons',
        rankicons_descr = 'Shows a rank icon depending on experience next to units',
        rankicons_distance = 'draw distance',
        rankicons_scale = 'scale',
        allycursors = 'Ally cursors',
        allycursors_descr = 'Shows the position of ally cursors',
        allycursors_playername = 'player name',
        allycursors_playername_descr = 'Shows the player name next to the cursor',
        allycursors_spectatorname = 'spectator name',
        allycursors_spectatorname_descr = 'Shows the spectator name next to the cursor',
        allycursors_showdot = 'cursor dot',
        allycursors_showdot_descr = 'Shows a dot at the center of ally cursor position',
        allycursors_lights = 'lights (non-specs)',
        allycursors_lights_descr = 'Adds a colored light to every ally cursor',
        allycursors_lightradius = '   radius',
        allycursors_lightstrength = '   strength',
        cursorlight = 'Cursor light',
        cursorlight_descr = 'Adds a light at/above your cursor position',
        cursorlight_lightradius = 'radius',
        cursorlight_lightstrength = 'strength',
        showbuilderqueue = 'Show builder queue',
        showbuilderqueue_descr = 'Shows ghosted buildings about to be built on the map',
        unitenergyicons = 'Unit insufficient energy icons',
        unitenergyicons_descr = 'Shows a red power bolt above units that cant fire their most e consuming weapon\nwhen you haven\'t enough energy available.',
        unitenergyicons_self = 'limit to own units',
        unitenergyicons_self_descr = 'Only show above your own units',
        nametags_icon = 'Commander name on icon',
        nametags_icon_descr = 'Show commander name when its displayed as icon',
        commandsfx = 'Command FX',
        commandsfx_descr = 'Shows unit target lines when you give orders\n\nThe commands from your teammates are shown as well',
        commandsfxfilterai = 'filter AI teams',
        commandsfxfilterai_descr = 'Hide commands for AI teams',
        commandsfxopacity = 'opacity',
        displaydps = 'Display DPS',
        displaydps_descr = 'Display the \'Damage Per Second\' done where target are hit',
        givenunits = 'Given unit icons',
        givenunits_descr = 'Tags given units with \'new\' icon',
        radarrange = 'Radar range',
        radarrange_descr = 'Displays the range of radar coverage with a green line',
        defrange = 'Defense ranges',
        defrange_descr = 'Displays range of defenses (enemy and ally)',
        defrange_allyair = 'Ally Air',
        defrange_allyair_descr = 'Show Range For Ally Air',
        defrange_allyground = 'Ally Ground',
        defrange_allyground_descr = 'Show Range For Ally Ground',
        defrange_allynuke = 'Ally Nuke',
        defrange_allynuke_descr = 'Show Range For Ally Air Nuke',
        defrange_enemyair = 'Enemy Air',
        defrange_enemyair_descr = 'Show Range For Enemy Air',
        defrange_enemyground = 'Enemy Ground',
        defrange_enemyground_descr = 'Show Range For Enemy Ground',
        defrange_enemynuke = 'Enemy Nuke',
        defrange_enemynuke_descr = 'Show Range For Enemy Nuke',
        allyselunits_select = 'Tracking player: select units',
        allyselunits_select_descr = 'When viewing a players camera, this selects what the player has selected',
        lockcamera_hideenemies = 'only show tracked player viewpoint',
        lockcamera_hideenemies_descr = 'When viewing a players camera, this will display what the tracked player sees',
        lockcamera_los = 'show tracked player LoS',
        lockcamera_los_descr = 'When viewing a players camera and los, shows shaded los ranges too',
        playertv_countdown = 'Player TV countdown',
        playertv_countdown_descr = 'Countdown time before it switches player',
        loadscreen_tips = 'Loadscreen tips',
        loadscreen_tips_descr = 'Show tips at the startup load screen',
        networksmoothing = 'Network smoothing',
        networksmoothing_descr = 'Adds additional delay to assure smooth gameplay and stability\nDisable for increased responsiveness: if you have a quality network connection\n\nChanges will be applied next game',
        autoquit = 'Auto quit',
        autoquit_descr = 'Automatically quits after the game ends.\n...unless the mouse has been moved within a few seconds.',
        smartselect_includebuildings = 'Include structures in area-selection',
        smartselect_includebuildings_descr = 'When rectangle-drag-selecting an area, include building units too?\n\ndisabled: non-mobile units will be excluded\n(except: nanos always will be selected)',
        smartselect_includebuilders = 'include builders   (if above is off)',
        smartselect_includebuilders_descr = 'When rectangle-drag-selecting an area, exclude builder units',
        onlyfighterspatrol = 'Only fighters patrol',
        onlyfighterspatrol_descr = 'Only fighters obey a factory\'s patrol route after leaving airlab.',
        fightersfly = 'Set fighters on Fly mode',
        fightersfly_descr = 'Setting fighters on Fly mode when created',
        builderpriority = 'Builder Priority Restriction',
        builderpriority_descr = 'Sets builders (nanos, labs and cons) on low priority mode\n\nLow priority mode means that builders will only spend energy when its available.\nUsage: Set the most important builders on high and leave the rest on low priority',
        builderpriority_nanos = 'nanos',
        builderpriority_nanos_descr = 'Toggle to set low priority',
        builderpriority_cons = 'cons',
        builderpriority_cons_descr = 'Toggle to set low priority',
        builderpriority_labs = 'labs',
        builderpriority_labs_descr = 'Toggle to set low priority',
        autocloakpopups = 'Auto cloak popups',
        autocloakpopups_descr = 'Auto cloaks Pit Bull and Ambusher',
        unitreclaimer = 'Unit Reclaimer',
        unitreclaimer_descr = 'Reclaim units in an area. Hover over a unit and drag an area-reclaim circle',
        autogroup_immediate = 'Autogroup immediate mode',
        autogroup_immediate_descr = 'Units built/resurrected/received are added to autogroups immediately,\ninstead when they get to be idle.\n\n(add units to autogroup with ALT+number)',
        factoryguard = 'Factory guard (builders)',
        factoryguard_descr = 'Newly created builders will assist their source factory',
        factoryholdpos = 'Factory hold position',
        factoryholdpos_descr = 'Sets factories and units they produce, to hold position automatically (not aircraft)',
        factoryrepeat = 'Factory auto-repeat',
        factoryrepeat_descr = 'Sets new factories on Repeat mode',
        transportai = 'Transport AI',
        transportai_descr = 'Transport units automatically pick up new units going to factory waypoint.',
        settargetdefault = 'Set-target as default',
        settargetdefault_descr = 'Replace default attack command to a set-target command\n(when rightclicked on enemy unit)',
        dgunnogroundenemies = 'Dont snap DGun to ground units',
        dgunnogroundenemies_descr = 'Prevents dgun aim to snap onto enemy ground units.\nholding SHIFT will still target units\n\nWill still snap to air, ships and hovers (when on water)',
        singleplayerpause = 'Pause when in settings/quit/lobby',
        singleplayerpause_descr = 'Exclusively in singleplayer mode...\n\nPauses the game when showing the settings/quit window or lobby',
        customwidgets = 'Allow custom widgets',
        customwidgets_descr = 'enable loading of custom widgets (placed inside spring/luaui/widgets_bar)',
        profiler = 'Widget profiler',
        framegrapher = 'Frame grapher',
        autocheat = 'Auto enable cheats for $VERSION',
        autocheat_descr = 'does: /cheat, /globallos, /godmode',
        restart = 'Restart',
        restart_descr = 'Restarts the game',
        startboxeditor = 'Startbox editor',
        startboxeditor_descr = 'LMB to draw (either clicks or drag), RMB to accept a polygon, D to remove last polygon\nS to add a team startbox to startboxes_mapname.txt\n(S overwites the export file for the first team)',
        tonemap = 'Unit tonemapping',
        envAmbient = 'ambient %',
        unitSunMult = 'sun mult',
        unitExposureMult = 'exposure mult',
        modelGamma = 'gamma value',
        tonemapDefaults = 'restore defaults',
        debugcolvol = 'Draw Collision Volumes',
        fog_color_reset = 'reset map default',
        map_voidwater = 'Map VoidWater',
        map_voidground = 'Map VoidGround',
        map_splatdetailnormaldiffusealpha = 'Map splatDetailNormalDiffuseAlpha',
        map_splattexmults = 'Map Splat Tex Mult',
        map_splattexacales = 'Map Splat Tex Scales',
        GroundShadowDensity = 'GroundShadowDensity',
        UnitShadowDensity = 'UnitShadowDensity',
        color_groundambient = 'Ground ambient',
        color_grounddiffuse = 'Ground diffuse',
        color_groundspecular = 'Ground specular',
        color_unitambient = 'Unit ambient',
        color_unitdiffuse = 'Unit diffuse',
        color_unitspecular = 'Unit specular',
        suncolor = 'Sun',
        skycolor = 'Sky',
        sunlighting_reset = 'Reset ground/unit coloring',
        sunlighting_reset_descr = 'resets ground/unit ambient/diffuse/specular colors',
        red = 'red',
        green = 'green',
        blue = 'blue',
    },
}

local ui_opacity = Spring.GetConfigFloat("ui_opacity", 0.6)

local advSettings = false

local initialized = false

local pauseGameWhenSingleplayer = true

local maxNanoParticles = 5000

local cameraTransitionTime = 0.12
local cameraPanTransitionTime = 0.03

local widgetOptionColor = '\255\160\160\160'
local musicOptionColor = '\255\130\160\130'

local firstlaunchsetupDone = false

local playSounds = true
local buttonclick = 'LuaUI/Sounds/tock.wav'
local paginatorclick = 'LuaUI/Sounds/buildbar_waypoint.wav'
local sliderdrag = 'LuaUI/Sounds/buildbar_rem.wav'
local selectclick = 'LuaUI/Sounds/buildbar_click.wav'
local selectunfoldclick = 'LuaUI/Sounds/buildbar_hover.wav'
local selecthoverclick = 'LuaUI/Sounds/hover.wav'
local toggleonclick = 'LuaUI/Sounds/switchon.wav'
local toggleoffclick = 'LuaUI/Sounds/switchoff.wav'

local fontfile = "fonts/" .. Spring.GetConfigString("bar_font", "Kelson Sans Regular.otf") --Poppins-Regular.otf")
local fontfile2 = "fonts/" .. Spring.GetConfigString("bar_font2", "WatchtowerMiddle-LM6Z.otf") --Exo2-SemiBold.otf")

local vsx, vsy = Spring.GetViewGeometry()
local fontfileScale = (0.5 + (vsx * vsy / 5700000))
local fontfileSize = 36
local fontfileOutlineSize = 7
local fontfileOutlineStrength = 1
local fontfileScale2 = fontfileScale * 1.2

local pauseGameWhenSingleplayerExecuted = false

local backwardTex = ":l:LuaUI/Images/backward.dds"
local forwardTex = ":l:LuaUI/Images/forward.dds"

local screenHeightOrg = 520
local screenWidthOrg = 1050
local screenHeight = screenHeightOrg
local screenWidth = screenWidthOrg

local customScale = 1
local centerPosX = 0.5
local centerPosY = 0.5
local screenX = math.floor((vsx * centerPosX) - (screenWidth / 2))
local screenY = math.floor((vsy * centerPosY) + (screenHeight / 2))

local wsx, wsy, wpx, wpy = Spring.GetWindowGeometry()
local ssx, ssy, spx, spy = Spring.GetScreenGeometry()

local changesRequireRestart = false

local useNetworkSmoothing = false

local customMapSunPos = {}
local customMapFog = {}

local isSpec = Spring.GetSpectatingState()

local show = false
local prevShow = show

local spIsGUIHidden = Spring.IsGUIHidden
local spGetGroundHeight = Spring.GetGroundHeight

local os_clock = os.clock

local chobbyInterface, font, font2, backgroundGuishader, currentGroupTab, windowList, optionButtonBackward, optionButtonForward
local groupRect, titleRect, countDownOptionID, countDownOptionClock, sceduleOptionApply, checkedForWaterAfterGamestart, checkedWidgetDataChanges
local savedConfig, forceUpdate, sliderValueChanged, selectOptionsList, showSelectOptions, prevSelectHover, showPresetButtons
local fontOption, draggingSlider, lastSliderSound, selectClickAllowHide, draggingSliderPreDragValue

local glColor = gl.Color
local glTexRect = gl.TexRect
local glRotate = gl.Rotate
local glTexture = gl.Texture
local glCreateList = gl.CreateList
local glCallList = gl.CallList
local glDeleteList = gl.DeleteList
local glPopMatrix = gl.PopMatrix
local glPushMatrix = gl.PushMatrix
local glTranslate = gl.Translate
local glScale = gl.Scale
local glBlending = gl.Blending
local GL_SRC_ALPHA = GL.SRC_ALPHA
local GL_ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA
local GL_ONE = GL.ONE

local RectRound = Spring.FlowUI.Draw.RectRound
local TexturedRectRound = Spring.FlowUI.Draw.TexturedRectRound
local elementCorner = Spring.FlowUI.elementCorner
local UiElement = Spring.FlowUI.Draw.Element
local UiButton = Spring.FlowUI.Draw.Button
local UiSlider = Spring.FlowUI.Draw.Slider
local UiSliderKnob = Spring.FlowUI.Draw.SliderKnob
local UiToggle = Spring.FlowUI.Draw.Toggle
local UiSelector = Spring.FlowUI.Draw.Selector

local bgpadding = Spring.FlowUI.elementPadding

local numPlayers = 0
local scavengersAIEnabled = false
local teams = Spring.GetTeamList()
for i = 1, #teams do
    local _,_,_, isAiTeam = Spring.GetTeamInfo(teams[i], false)
    local luaAI = Spring.GetTeamLuaAI(teams[i])
    if luaAI and luaAI ~= "" and string.sub(luaAI, 1, 12) == 'ScavengersAI' then
        scavengersAIEnabled = true
    end
    if not luaAI and not isAiTeam and teams[i] ~= Spring.GetGaiaTeamID() then
        numPlayers = numPlayers + 1
    end
end
local isSinglePlayer = numPlayers == 1

local skipUnpauseOnHide = false
local skipUnpauseOnLobbyHide = false

local desiredWaterValue = 4
local waterDetected = false
local heightmapChangeBuffer = {}

local vsx, vsy = Spring.GetViewGeometry()
local widgetScale = (0.5 + (vsx * vsy / 5700000)) * customScale

local myTeamID = Spring.GetMyTeamID()
local amNewbie = (Spring.GetTeamRulesParam(myTeamID, 'isNewbie') == 1)

local vsyncLevel = 1
local vsyncEnabled = false
local vsyncOnlyForSpec = false

local defaultMapSunPos = { gl.GetSun("pos") }
local defaultSunLighting = {
    groundAmbientColor = { gl.GetSun("ambient") },
    unitAmbientColor = { gl.GetSun("ambient", "unit") },
    groundDiffuseColor = { gl.GetSun("diffuse") },
    unitDiffuseColor = { gl.GetSun("diffuse", "unit") },
    groundSpecularColor = { gl.GetSun("specular") },
    unitSpecularColor = { gl.GetSun("specular", "unit") },
}
local defaultFog = {
    fogStart = gl.GetAtmosphere("fogStart"),
    fogEnd = gl.GetAtmosphere("fogEnd"),
    fogColor = { gl.GetAtmosphere("fogColor") },
}
local options = {}
local optionGroups = {}
local optionButtons = {}
local optionHover = {}
local optionSelect = {}
local windowRect = { 0, 0, 0, 0 }
local showOnceMore = false        -- used because of GUI shader delay
local resettedTonemapDefault = false
local heightmapChangeClock

local presetNames = {}
local presets = {}
local customPresets = {}

local startScript = VFS.LoadFile("_script.txt")
if not startScript then
    local modoptions = ''
    for key, value in pairs(Spring.GetModOptions()) do
        modoptions = modoptions .. key .. '=' .. value .. ';';
    end

    startScript = [[[game]
	{
		[allyteam1]
		{
			numallies=0;
		}
		[team1]
		{
			teamleader=0;
			allyteam=1;
		}
		[ai0]
		{
			shortname=Null AI;
			name=AI: Null AI;
			team=1;
			host=0;
		}
		[modoptions]
		{
			]] .. modoptions .. [[
		}
		[allyteam0]
		{
			numallies=0;
		}
		[team0]
		{
			teamleader=0;
			allyteam=0;
		}
		[player0]
		{
			team=0;
			name=]] .. select(1, Spring.GetPlayerInfo(Spring.GetMyPlayerID())) .. [[;
		}
		mapname=]] .. Game.mapName .. [[;
		myplayername=]] .. select(1, Spring.GetPlayerInfo(Spring.GetMyPlayerID())) .. [[;
		ishost=1;
		gametype=]] .. Game.gameName .. ' ' .. Game.gameVersion .. [[;
		nohelperais=0;
	}
	]]
end

local function setEngineFont()
    local relativesize = 0.75
    --"fonts/FreeSansBold.otf"
    Spring.SetConfigInt("SmallFontSize", fontfileSize * fontfileScale * relativesize)
    Spring.SetConfigInt("SmallFontOutlineWidth", fontfileOutlineSize * fontfileScale * relativesize * 0.85)
    Spring.SetConfigInt("SmallFontOutlineWeight", 2)

    Spring.SetConfigInt("FontSize", fontfileSize * fontfileScale * relativesize)
    Spring.SetConfigInt("FontOutlineWidth", fontfileOutlineSize * fontfileScale * relativesize * 0.85)
    Spring.SetConfigInt("FontOutlineWeight", 2)

    Spring.SendCommands("font " .. Spring.GetConfigString("bar_font2", "WatchtowerMiddle-LM6Z.otf"))

    -- set spring engine default font cause it cant thee game archive fonts on launch
    Spring.SetConfigString("SmallFontFile", "FreeSansBold.otf")
    Spring.SetConfigString("FontFile", "FreeSansBold.otf")

end

setEngineFont()
function widget:ViewResize()
    vsx, vsy = Spring.GetViewGeometry()
    widgetScale = ((vsx + vsy) / 2000) * 0.65 * customScale
    widgetScale = widgetScale * (1 - (0.11 * ((vsx / vsy) - 1.78)))        -- make smaller for ultrawide screens

    screenHeight = math.floor(screenHeightOrg * widgetScale)
    screenWidth = math.floor(screenWidthOrg * widgetScale)
    screenX = math.floor((vsx * centerPosX) - (screenWidth / 2))
    screenY = math.floor((vsy * centerPosY) + (screenHeight / 2))

    bgpadding = Spring.FlowUI.elementPadding
    elementCorner = Spring.FlowUI.elementCorner

    --font = WG['fonts'].getFont(fontfile)
    --font2 = WG['fonts'].getFont(fontfile2)
    font = gl.LoadFont(FontPath, loadedFontSize, 24, 1.25)
    font2 = gl.LoadFont(FontPath, loadedFontSize, 24, 1.25)
    local newFontfileScale = (0.5 + (vsx * vsy / 5700000))
    if fontfileScale ~= newFontfileScale then
        fontfileScale = newFontfileScale
        setEngineFont()
    end

    if windowList then
        gl.DeleteList(windowList)
    end
    windowList = gl.CreateList(DrawWindow)
end

local engineVersion = 104 -- just filled this in here incorrectly but old engines arent used anyway
if Engine and Engine.version then
    local function Split(s, separator)
        local results = {}
        for part in s:gmatch("[^" .. separator .. "]+") do
            results[#results + 1] = part
        end
        return results
    end
    engineVersion = Split(Engine.version, '-')
    if engineVersion[2] ~= nil and engineVersion[3] ~= nil then
        engineVersion = tonumber(string.gsub(engineVersion[1], '%.', '') .. engineVersion[2])
    else
        engineVersion = tonumber(Engine.version)
    end
end

function lines(str)
    local t = {}
    local function helper(line)
        t[#t + 1] = line
        return ""
    end
    helper((str:gsub("(.-)\r?\n", helper)))
    return t
end

function tableMerge(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function getOptionByID(id)
    for i, option in pairs(options) do
        if option.id == id then
            return i
        end
    end
    return false
end

function orderOptions()
    local groupOptions = {}
    for id, group in pairs(optionGroups) do
        groupOptions[group.id] = {}
    end
    for i, option in pairs(options) do
        if option.type ~= 'label' then
            groupOptions[option.group][#groupOptions[option.group] + 1] = option
        end
    end
    local newOptions = {}
    local newOptionsCount = 0
    for id, group in pairs(optionGroups) do
        --if advSettings or group.id ~= 'dev' then
        local grOptions = groupOptions[group.id]
        if #grOptions > 0 then
            local name = group.name
            if group.id == 'gfx' then
                name = group.name .. '                                          \255\130\130\130' .. vsx .. ' x ' .. vsy
            end
            newOptionsCount = newOptionsCount + 1
            newOptions[newOptionsCount] = { id = "group_" .. group.id, name = name, type = "label" }
        end
        for i, option in pairs(grOptions) do
            newOptionsCount = newOptionsCount + 1
            newOptions[newOptionsCount] = option
        end
        --end
    end
    options = deepcopy(newOptions)
end

function mouseoverGroupTab(id)
    if optionGroups[id].id == currentGroupTab then
        return
    end

    local tabFontSize = 16 * widgetScale
    local groupMargin = math.floor(bgpadding * 0.8)
    glBlending(GL_SRC_ALPHA, GL_ONE)
    RectRound(groupRect[id][1] + groupMargin, groupRect[id][2], groupRect[id][3] - groupMargin, groupRect[id][4] - groupMargin, groupMargin * 1.8, 1, 1, 0, 0, { 1, 1, 1, 0 }, { 1, 1, 1, 0.07 })
    -- gloss
    RectRound(groupRect[id][1] + groupMargin, groupRect[id][4] - groupMargin - ((groupRect[id][4] - groupRect[id][2]) * 0.5), groupRect[id][3] - groupMargin, groupRect[id][4] - groupMargin, groupMargin * 1.8, 1, 1, 0, 0, { 1, 1, 1, 0 }, { 1, 1, 1, 0.1 })
    RectRound(groupRect[id][1] + groupMargin, groupRect[id][2], groupRect[id][3] - groupMargin, groupRect[id][2] + groupMargin + ((groupRect[id][4] - groupRect[id][2]) * 0.5), groupMargin * 1.25, 0, 0, 0, 0, { 1, 1, 1, 0.05 }, { 0, 0, 0, 0 })
    glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

    font2:Begin()
    font2:SetTextColor(1, 0.9, 0.66, 1)
    font2:SetOutlineColor(0.4, 0.3, 0.15, 0.4)
    font2:Print(optionGroups[id].name, groupRect[id][1] + ((groupRect[id][3] - groupRect[id][1]) / 2), screenY + (8*widgetScale), tabFontSize, "con")
    font2:End()
end

local startColumn = 1        -- used for navigation
local maxShownColumns = 3
local maxColumnRows = 0    -- gets calculated
local totalColumns = 0        -- gets calculated
function DrawWindow()

    orderOptions()

    glTexture(false)
    local x = screenX --rightwards
    local y = screenY --upwards
    windowRect = { screenX, screenY - screenHeight, screenX + screenWidth, screenY }
    --RectRound(windowRect[1], windowRect[2], windowRect[3], windowRect[4], 8, 0, 1, 1, 1, { 0.05, 0.05, 0.05, WG['guishader'] and 0.8 or 0.88 }, { 0, 0, 0, WG['guishader'] and 0.8 or 0.88 })
    --RectRound(x, y - screenHeight, x + screenWidth, y, 5.5, 1, 1, 1, 1, { 0.25, 0.25, 0.25, 0.2 }, { 0.5, 0.5, 0.5, 0.2 })

    -- background
    UiElement(screenX, screenY - screenHeight, screenX + screenWidth, screenY, 0, 1, 1, 1, 1,1,1,1, ui_opacity + 0.2)

    -- title
    local groupMargin = math.floor(bgpadding * 0.8)
    local color = '\255\255\255\255'
    local color2 = '\255\125\125\125'
    local title = "" .. color .. texts.basic .. color2 .. "  /  " .. texts.advanced
    if advSettings then
        title = "" .. color2 .. texts.basic.."  /  " .. color .. texts.advanced
    end
    local titleFontSize = 18 * widgetScale
    titleRect = { screenX, screenY, math.floor(screenX + (font2:GetTextWidth(title) * titleFontSize) + (titleFontSize*1.5)), math.floor(screenY + (titleFontSize*1.7)) }

    -- title drawing
    RectRound(titleRect[1], titleRect[2], titleRect[3], titleRect[4], elementCorner, 1, 1, 0, 0, WG['guishader'] and { 0, 0, 0, 0.8 } or { 0, 0, 0, 0.85 }, WG['guishader'] and { 0.05, 0.05, 0.05, 0.8 } or { 0.05, 0.05, 0.05, 0.85 })
    RectRound(titleRect[1] + groupMargin, titleRect[4] - groupMargin - ((titleRect[4] - titleRect[2]) * 0.5), titleRect[3] - groupMargin, titleRect[4] - groupMargin, elementCorner*0.66, 1, 1, 0, 0, { 1, 0.95, 0.85, 0.03 }, { 1, 0.95, 0.85, 0.15 })

    font2:Begin()
    font2:SetTextColor(1, 1, 1, 1)
    font2:SetOutlineColor(0, 0, 0, 0.4)
    font2:Print(title, screenX + (titleFontSize * 0.75), screenY + (8*widgetScale), titleFontSize, "on")
    font2:End()

    -- group tabs
    local tabFontSize = 16 * widgetScale
    local xpos = titleRect[3]
    groupRect = {}
    for id, group in pairs(optionGroups) do
        groupRect[id] = { xpos, titleRect[2], math.floor(xpos + (font2:GetTextWidth(group.name) * tabFontSize) + (33*widgetScale)), titleRect[4] }
        if advSettings or group.id ~= 'dev' then
            xpos = groupRect[id][3]
            if currentGroupTab == nil or currentGroupTab ~= group.id then
                RectRound(groupRect[id][1], groupRect[id][2], groupRect[id][3], groupRect[id][4], elementCorner, 1, 1, 0, 0, WG['guishader'] and { 0, 0, 0, 0.8 } or { 0, 0, 0, 0.85 }, WG['guishader'] and { 0.05, 0.05, 0.05, 0.8 } or { 0.05, 0.05, 0.05, 0.85 })
                RectRound(groupRect[id][1] + groupMargin, groupRect[id][2], groupRect[id][3] - groupMargin, groupRect[id][4] - groupMargin, elementCorner*0.8, 1, 1, 0, 0, { 0.44, 0.35, 0.18, 0.2 }, { 0.68, 0.55, 0.25, 0.2 })

                glBlending(GL_SRC_ALPHA, GL_ONE)
                -- gloss
                RectRound(groupRect[id][1] + groupMargin, groupRect[id][4] - groupMargin - ((groupRect[id][4] - groupRect[id][2]) * 0.5), groupRect[id][3] - groupMargin, groupRect[id][4] - groupMargin, bgpadding*1.2, 1, 1, 0, 0, { 1, 0.88, 0.66, 0 }, { 1, 0.88, 0.66, 0.1 })
                glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

                font2:Begin()
                font2:SetTextColor(0.7, 0.58, 0.44, 1)
                font2:SetOutlineColor(0, 0, 0, 0.4)
                font2:Print(group.name, groupRect[id][1] + ((groupRect[id][3] - groupRect[id][1]) / 2), screenY + (8*widgetScale), tabFontSize, "con")
                font2:End()
            else
                RectRound(groupRect[id][1], groupRect[id][2], groupRect[id][3], groupRect[id][4], elementCorner, 1, 1, 0, 0, WG['guishader'] and { 0, 0, 0, 0.8 } or { 0, 0, 0, 0.85 }, WG['guishader'] and { 0.05, 0.05, 0.05, 0.8 } or { 0.05, 0.05, 0.05, 0.85 })
                RectRound(groupRect[id][1] + groupMargin, groupRect[id][2] - bgpadding, groupRect[id][3] - groupMargin, groupRect[id][4] - groupMargin, elementCorner*0.8, 1, 1, 0, 0, { 0.7, 0.7, 0.7, 0.15 }, { 0.8, 0.8, 0.8, 0.15 })
                --glColor(1,1,1,Spring.GetConfigFloat("ui_tileopacity", 0.012))
                --local bgtexSize = math.floor(bgpadding * Spring.GetConfigFloat("ui_tilescale", 7))
                --TexturedRectRound(groupRect[id][1] + groupMargin, groupRect[id][2] - bgpadding, groupRect[id][3] - groupMargin, groupRect[id][4] - groupMargin, bgpadding*1.2, 1, 1, 0, 0,  bgtexSize, (groupRect[id][1] + groupMargin)/vsx/bgtexSize, (groupRect[id][2]+bgpadding)/vsy/bgtexSize, "LuaUI/Images/backgroundtile.png")
                font2:Begin()
                font2:SetTextColor(1, 0.75, 0.4, 1)
                font2:SetOutlineColor(0, 0, 0, 0.4)
                font2:Print(group.name, groupRect[id][1] + ((groupRect[id][3] - groupRect[id][1]) / 2), screenY + (8*widgetScale), tabFontSize, "con")
                font2:End()
            end
        end
    end

    font:Begin()
    local width = screenWidth / 3
    --gl.Color(0.66,0.66,0.66,0.08)
    --RectRound(x+width+width+6,y-screenHeight,x+width+width+width,y,6)

    -- description background
    --gl.Color(0.55,0.48,0.22,0.14)
    RectRound(x+bgpadding, y +bgpadding - screenHeight, x + width + width, y + bgpadding - screenHeight + (87*widgetScale), elementCorner*0.66, 0, 1, 0, 1, { 1, 0.85, 0.55, 0.04 }, { 1, 0.85, 0.55, 0.075 })

    -- draw options
    local oHeight = math.floor(15 * widgetScale)
    local oPadding = math.floor(6 * widgetScale)
    y = math.floor(math.floor(y - oPadding - (17 * widgetScale)))
    local oWidth = math.floor((screenWidth / 3) - oPadding - oPadding)
    local yHeight = math.floor(screenHeight - (102 * widgetScale) - oPadding)
    local xPos = math.floor(x + oPadding + (5 * widgetScale))
    local xPosMax = xPos + oWidth - oPadding - oPadding
    local yPosMax = y - yHeight
    local boolPadding = math.floor(3.5 * widgetScale)
    local boolWidth = math.floor(40 * widgetScale)
    local sliderWidth = math.floor(110 * widgetScale)
    local selectWidth = math.floor(140 * widgetScale)
    local i = 0
    local rows = 0
    local column = 1
    local drawColumnPos = 1

    maxColumnRows = math.floor((y - yPosMax + oPadding) / (oHeight + oPadding + oPadding))
    local numOptions = #options
    if currentGroupTab ~= nil then
        numOptions = 0
        for i, option in pairs(options) do
            if option.group == currentGroupTab and (advSettings or option.basic) then
                numOptions = numOptions + 1
            end
        end
    end
    totalColumns = math.ceil(numOptions / maxColumnRows)

    optionButtons = {}
    optionHover = {}

    -- draw navigation... backward/forward
    if totalColumns > maxShownColumns then
        local buttonSize = 52 * widgetScale
        local buttonMargin = 18 * widgetScale
        local startX = x + screenWidth
        local startY = screenY - screenHeight + buttonMargin

        glColor(1, 1, 1, 1)

        if (startColumn - 1) + maxShownColumns < totalColumns then
            optionButtonForward = { startX - buttonSize - buttonMargin, startY, startX - buttonMargin, startY + buttonSize }
            glColor(1, 1, 1, 1)
            glTexture(forwardTex)
            glTexRect(optionButtonForward[1], optionButtonForward[2], optionButtonForward[3], optionButtonForward[4])
            glTexture(false)
        else
            optionButtonForward = nil
        end

        font:SetTextColor(1, 1, 1, 0.4)
        font:Print(math.ceil(startColumn / maxShownColumns) .. ' / ' .. math.ceil(totalColumns / maxShownColumns), startX - (buttonSize * 2.6) - buttonMargin, startY + buttonSize / 2.6, buttonSize / 2.9, "rn")
        if startColumn > 1 then
            if optionButtonForward == nil then
                optionButtonBackward = { startX - buttonSize - buttonMargin, startY, startX - buttonMargin, startY + buttonSize }
            else
                optionButtonBackward = { startX - (buttonSize * 2) - buttonMargin - (buttonMargin / 1.5), startY, startX - (buttonSize * 1) - buttonMargin - (buttonMargin / 1.5), startY + buttonSize }
            end
            glColor(1, 1, 1, 1)
            glTexture(backwardTex)
            glTexRect(optionButtonBackward[1], optionButtonBackward[2], optionButtonBackward[3], optionButtonBackward[4])
            glTexture(false)
        else
            optionButtonBackward = nil
        end
    end

    -- require restart notification
    if changesRequireRestart then
        font:SetTextColor(1, 0.35, 0.35, 1)
        font:SetOutlineColor(0, 0, 0, 0.4)
        font:Print("...made changes that require restart", screenX + screenWidth - (3 * widgetScale), screenY - screenHeight + (3 * widgetScale), 15 * widgetScale, "rn")
    end

    -- draw options
    local yPos
    for oid, option in pairs(options) do
        if advSettings or option.basic and option.group ~= 'Dev' then
            if currentGroupTab == nil or option.group == currentGroupTab then
                yPos = math.floor(y - (((oHeight + oPadding + oPadding) * i) - oPadding))
                if yPos - oHeight < yPosMax then
                    i = 0
                    column = column + 1
                    if column >= startColumn and rows > 0 then
                        drawColumnPos = drawColumnPos + 1
                    end
                    if drawColumnPos > 3 then
                        break
                    end
                    if rows > 0 then
                        xPos = math.floor(x + (((screenWidth / 3)) * (drawColumnPos - 1)))
                        xPosMax = math.floor(xPos + oWidth)
                    end
                    yPos = y - (((oHeight + oPadding + oPadding) * i) - oPadding)
                end

                if column >= startColumn then
                    rows = rows + 1
                    --option name
                    color = '\255\225\225\225  '
                    if option.type == 'label' then
                        color = '\255\235\200\125'
                    end

                    font:SetTextColor(1, 1, 1, 1)
                    font:Print(color .. option.name, xPos + (oPadding / 2), yPos - (oHeight / 3) - oPadding, oHeight, "no")

                    -- define hover area
                    optionHover[oid] = { math.floor(xPos), math.floor(yPos - oHeight - oPadding), math.floor(xPosMax), math.floor(yPos + oPadding) }

                    -- option controller
                    local rightPadding = 4
                    if option.type == 'bool' then
                        optionButtons[oid] = {}
                        optionButtons[oid] = { math.floor(xPosMax - boolWidth - rightPadding), math.floor(yPos - oHeight), math.floor(xPosMax - rightPadding), math.floor(yPos) }
                        UiToggle(optionButtons[oid][1], optionButtons[oid][2], optionButtons[oid][3], optionButtons[oid][4], option.value)

                    elseif option.type == 'slider' then
                        local sliderSize = oHeight * 0.75
                        local sliderPos = 0
                        if option.steps then
                            local min, max = option.steps[1], option.steps[1]
                            for k, v in ipairs(option.steps) do
                                if v > max then
                                    max = v
                                end
                                if v < min then
                                    min = v
                                end
                            end
                            sliderPos = (option.value - min) / (max - min)
                        else
                            sliderPos = (option.value - option.min) / (option.max - option.min)
                        end
                        UiSlider(math.floor(xPosMax - (sliderSize / 2) - sliderWidth - rightPadding), math.floor(yPos - ((oHeight / 7) * 4.5)), math.floor(xPosMax - (sliderSize / 2) - rightPadding), math.floor(yPos - ((oHeight / 7) * 2.8)))
                        UiSliderKnob(math.floor(xPosMax - (sliderSize / 2) - sliderWidth + (sliderWidth * sliderPos) - rightPadding), math.floor(yPos - oHeight + ((oHeight) / 2)), math.floor(sliderSize/2))
                        optionButtons[oid] = { xPosMax - (sliderSize / 2) - sliderWidth + (sliderWidth * sliderPos) - (sliderSize / 2) - rightPadding, yPos - oHeight + ((oHeight - sliderSize) / 2), xPosMax - (sliderSize / 2) - sliderWidth + (sliderWidth * sliderPos) + (sliderSize / 2) - rightPadding, yPos - ((oHeight - sliderSize) / 2) }
                        optionButtons[oid].sliderXpos = { xPosMax - (sliderSize / 2) - sliderWidth - rightPadding, xPosMax - (sliderSize / 2) - rightPadding }

                    elseif option.type == 'select' then
                        optionButtons[oid] = { math.floor(xPosMax - selectWidth - rightPadding), math.floor(yPos - oHeight), math.floor(xPosMax - rightPadding), math.floor(yPos) }
                        UiSelector(optionButtons[oid][1], optionButtons[oid][2], optionButtons[oid][3], optionButtons[oid][4], option.value)

                        if option.options[tonumber(option.value)] ~= nil then
                            if option.id == 'font2' then
                                font:End()
                                font2:Begin()
                                font2:SetTextColor(1, 1, 1, 1)
                                font2:Print(option.options[tonumber(option.value)], xPosMax - selectWidth + 5 - rightPadding, yPos - (oHeight / 3) - oPadding, oHeight * 0.85, "no")
                                font2:End()
                                font:Begin()
                            else
                                font:SetTextColor(1, 1, 1, 1)
                                font:Print(option.options[tonumber(option.value)], xPosMax - selectWidth + 5 - rightPadding, yPos - (oHeight / 3) - oPadding, oHeight * 0.85, "no")
                            end
                        end
                    end
                end
                i = i + 1
            end
        end
    end
    font:End()
end

local sec = 0
local lastUpdate = 0
--local minGroundDetail = 3
--if Platform ~= nil and Platform.gpuVendor == 'Intel' then
--	minGroundDetail = 2
--end
function widget:Update(dt)

    if countDownOptionID and countDownOptionClock and countDownOptionClock < os_clock() then
        applyOptionValue(countDownOptionID)
        countDownOptionID = nil
        countDownOptionClock = nil
    end

    if not initialized then
        return
    end

    if sceduleOptionApply then
        if sceduleOptionApply[1] <= os.clock() then
            applyOptionValue(sceduleOptionApply[2], true, true)
            sceduleOptionApply = nil
        end
    end

    if WG['advplayerlist_api'] and not WG['advplayerlist_api'].GetLockPlayerID() then
        --if select(7, Spring.GetMouseState()) then	-- when camera panning
        --	Spring.SetCameraState(Spring.GetCameraState(), cameraPanTransitionTime)
        --else
        Spring.SetCameraState(Spring.GetCameraState(), cameraTransitionTime)
        --end
    end
    sec = sec + dt

    --Spring.SetConfigInt("MaxDynamicModelLights", 0)

    Spring.SetConfigInt("ROAM", 1)
    Spring.SendCommands("mapmeshdrawer 2")
    if tonumber(Spring.GetConfigInt("GroundDetail", 1) or 1) < 100 then
        Spring.SendCommands("GroundDetail " .. 100)
    end
    -- Setting basic map mesh rendering cause of performance tanking bug: https://springrts.com/mantis/view.php?id=6340
    -- /mapmeshdrawer    (unsynced)  Switch map-mesh rendering modes: 0=GCM, 1=HLOD, 2=ROAM
    -- NOTE: doing this on initialize() wont work
    --if not mapmeshdrawerChecked then
    --	local OS = ''
    --	if Platform.osFamily then
    --		OS = Platform.osFamily .. (Platform.osVersion and ' '..Platform.osVersion or '')
    --	end
    --	if string.find(string.lower(OS), 'mac') then		-- MAC OS aka Masterbel crashes With ROAM 0
    --		Spring.SetConfigInt("ROAM", 1)
    --		Spring.SendCommands("mapmeshdrawer 2")
    --	elseif tonumber(Spring.GetConfigInt("skipforceroam",0) or 0) ~= 1 then		-- added this option because maybe some people crash because of roam 0?
    --		if tonumber(Spring.GetConfigInt("ROAM",1) or 1) ~= 0 then
    --			Spring.SetConfigInt("ROAM", 0)
    --		end
    --		Spring.SendCommands("mapmeshdrawer 1")
    --		-- ground detail
    --		if tonumber(Spring.GetConfigInt("GroundDetail",1) or 1) < minGroundDetail then
    --			Spring.SendCommands("GroundDetail "..minGroundDetail)
    --		end
    --		if tonumber(Spring.GetConfigInt("GroundDetail",1) or 1) > 3 then
    --			Spring.SendCommands("GroundDetail 3")
    --		end
    --	end
    --	mapmeshdrawerChecked = true
    --end

    -- check if there is water shown 	(we do this because basic water 0 saves perf when no water is rendered)
    if not waterDetected then
        -- in case of modoption waterlevel has been made to show water
        if not checkedForWaterAfterGamestart and Spring.GetGameFrame() <= 30 then
            detectWater()
            checkedForWaterAfterGamestart = true
        end
        if heightmapChangeClock and heightmapChangeClock + 1 < os_clock() then
            for k, coords in pairs(heightmapChangeBuffer) do
                local x = coords[1]
                local z = coords[2]
                while x <= coords[3] do
                    z = coords[2]
                    while z <= coords[4] do
                        if spGetGroundHeight(x, z) <= 0 then
                            waterDetected = true
                            Spring.SendCommands("water " .. desiredWaterValue)
                            break
                        end
                        z = z + 8
                    end
                    if waterDetected then
                        break
                    end
                    x = x + 8
                end
            end
            heightmapChangeClock = nil
            heightmapChangeBuffer = {}
        end
    end

    if show and (sec > lastUpdate + 0.5 or forceUpdate) then
        sec = 0
        forceUpdate = nil
        lastUpdate = sec

        local changes = true
        for i, option in ipairs(options) do
            if options[i].widget ~= nil and options[i].type == 'bool' and options[i].value ~= GetWidgetToggleValue(options[i].widget) then
                options[i].value = GetWidgetToggleValue(options[i].widget)
                changes = true
            end
        end
        if ui_opacity ~= Spring.GetConfigFloat("ui_opacity", 0.6) then
            ui_opacity = Spring.GetConfigFloat("ui_opacity", 0.6)
            changes = true
        end
        if changes then
            if windowList then
                gl.DeleteList(windowList)
            end
            windowList = gl.CreateList(DrawWindow)
        end
        options[getOptionByID('sndvolmaster')].value = tonumber(Spring.GetConfigInt("snd_volmaster", 40) or 40)    -- update value because other widgets can adjust this too
        if getOptionByID('sndvolmusic') then
            if WG['music'] and WG['music'].GetMusicVolume then
                options[getOptionByID('sndvolmusic')].value = WG['music'].GetMusicVolume()
            else
                options[getOptionByID('sndvolmusic')].value = tonumber(Spring.GetConfigInt("snd_volmusic", 20) or 20)
            end
        end
    end
end

function widget:CommandNotify(cmdID, cmdParams, cmdOptions)
    if show then
        --on window
        local mx, my, ml = Spring.GetMouseState()
        if IsOnRect(mx, my, windowRect[1], windowRect[2], windowRect[3], windowRect[4]) then
            return true
        elseif titleRect and IsOnRect(mx, my, titleRect[1], titleRect[2], titleRect[3], titleRect[4]) then
            return true
        elseif groupRect ~= nil then
            for id, group in pairs(optionGroups) do
                if advSettings or group.id ~= 'dev' then
                    if IsOnRect(mx, my, groupRect[id][1], groupRect[id][2], groupRect[id][3], groupRect[id][4]) then
                        return true
                    end
                end
            end
        end
    end
end

function widget:RecvLuaMsg(msg, playerID)
    if msg:sub(1, 18) == 'LobbyOverlayActive' then
        chobbyInterface = (msg:sub(1, 19) == 'LobbyOverlayActive1')
        if isSinglePlayer and pauseGameWhenSingleplayer and not skipUnpauseOnHide then
            local _, gameSpeed, isPaused = Spring.GetGameSpeed()
            if chobbyInterface and isPaused then
                skipUnpauseOnLobbyHide = true
            end
            if not skipUnpauseOnLobbyHide then
                Spring.SendCommands("pause "..(chobbyInterface and '1' or '0'))
                pauseGameWhenSingleplayerExecuted = chobbyInterface
            end
        end
    end
end

local quitscreen = false
local prevQuitscreen = false
function widget:DrawScreen()

    -- pause/unpause when the options/quitscreen interface shows
    local _, gameSpeed, isPaused = Spring.GetGameSpeed()
    if not isPaused then
        skipUnpauseOnHide = false
        skipUnpauseOnLobbyHide = false
    end
    local showToggledOff = false
    if isSinglePlayer and pauseGameWhenSingleplayer and prevShow ~= show then
        if show and isPaused then
            skipUnpauseOnHide = true
        end
        if not skipUnpauseOnHide then
            Spring.SendCommands("pause "..(show and '1' or '0'))    -- cause several widgets are still using old colors
            showToggledOff = not show
            pauseGameWhenSingleplayerExecuted = show
        end
    end
    --quitscreen = (WG['topbar'] and WG['topbar'].showingQuit() or false) --TODO: Fix
    quitscreen = false
    if isSinglePlayer and pauseGameWhenSingleplayer and prevQuitscreen ~= quitscreen then
        if quitscreen and isPaused and not showToggledOff then
            skipUnpauseOnHide = true
        end
        if not skipUnpauseOnHide then
            Spring.SendCommands("pause "..(quitscreen and '1' or '0'))    -- cause several widgets are still using old colors
            pauseGameWhenSingleplayerExecuted = quitscreen
        end
    end
    prevQuitscreen = quitscreen

    -- doing it here so other widgets having higher layer number value are also loaded
    if not initialized then
        init()
        initialized = true
    else

        if chobbyInterface then
            return
        end
        if spIsGUIHidden() then
            return
        end

        -- update new slider value
        if sliderValueChanged then
            gl.DeleteList(windowList)
            windowList = gl.CreateList(DrawWindow)
            sliderValueChanged = nil
        end

        if selectOptionsList then
            if WG['guishader'] then
                WG['guishader'].RemoveScreenRect('options_select')
                WG['guishader'].removeRenderDlist(selectOptionsList)
            end
            glDeleteList(selectOptionsList)
            selectOptionsList = nil
        end

        if (show or showOnceMore) and windowList then

            if getOptionByID('tweakui') and widgetHandler.tweakMode ~= nil then
                options[getOptionByID('tweakui')].value = widgetHandler.tweakMode
            end

            --on window
            local mx, my, ml = Spring.GetMouseState()
            if IsOnRect(mx, my, windowRect[1], windowRect[2], windowRect[3], windowRect[4]) then
                Spring.SetMouseCursor('cursornormal')
            end
            if groupRect ~= nil then
                for id, group in pairs(optionGroups) do
                    if advSettings or group.id ~= 'dev' then
                        if IsOnRect(mx, my, groupRect[id][1], groupRect[id][2], groupRect[id][3], groupRect[id][4]) then
                            Spring.SetMouseCursor('cursornormal')
                            break
                        end
                    end
                end
            end
            if titleRect ~= nil and IsOnRect(mx, my, titleRect[1], titleRect[2], titleRect[3], titleRect[4]) then
                Spring.SetMouseCursor('cursornormal')
            end

            -- draw the options panel
            glCallList(windowList)
            if WG['guishader'] then
                if backgroundGuishader ~= nil then
                    glDeleteList(backgroundGuishader)
                end
                backgroundGuishader = glCreateList(function()
                    -- background
                    RectRound(screenX, screenY - screenHeight, screenX + screenWidth, screenY, elementCorner, 0, 1, 1, 1)
                    -- title
                    RectRound(titleRect[1], titleRect[2], titleRect[3], titleRect[4], elementCorner, 1, 1, 0, 0)
                    -- tabs
                    for id, group in pairs(optionGroups) do
                        if advSettings or group.id ~= 'dev' then
                            if groupRect[id] then
                                RectRound(groupRect[id][1], groupRect[id][2], groupRect[id][3], groupRect[id][4], elementCorner, 1, 1, 0, 0)
                            end
                        end
                    end
                end)
                WG['guishader'].InsertDlist(backgroundGuishader, 'options')
            end
            showOnceMore = false

            -- mouseover (highlight and tooltip)
            local description = ''
            if titleRect ~= nil and IsOnRect(mx, my, titleRect[1], titleRect[2], titleRect[3], titleRect[4]) then
                local groupMargin = math.floor(bgpadding * 0.8)
                -- gloss
                glBlending(GL_SRC_ALPHA, GL_ONE)
                RectRound(titleRect[1] + groupMargin, titleRect[2], titleRect[3] - groupMargin, titleRect[4] - groupMargin, groupMargin * 1.8, 1, 1, 0, 0, { 1, 1, 1, 0 }, { 1, 1, 1, 0.12 })
                RectRound(titleRect[1] + groupMargin, titleRect[4] - groupMargin - ((titleRect[4] - titleRect[2]) * 0.5), titleRect[3] - groupMargin, titleRect[4] - groupMargin, groupMargin * 1.8, 1, 1, 0, 0, { 1, 0.88, 0.66, 0 }, { 1, 0.88, 0.66, 0.09 })
                glBlending(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
            end
            if groupRect ~= nil then
                for id, group in pairs(optionGroups) do
                    if advSettings or group.id ~= 'dev' then
                        if IsOnRect(mx, my, groupRect[id][1], groupRect[id][2], groupRect[id][3], groupRect[id][4]) then
                            mouseoverGroupTab(id)
                        end
                    end
                end
            end
            if optionButtonForward ~= nil and IsOnRect(mx, my, optionButtonForward[1], optionButtonForward[2], optionButtonForward[3], optionButtonForward[4]) then
                RectRound(optionButtonForward[1], optionButtonForward[2], optionButtonForward[3], optionButtonForward[4], (optionButtonForward[4] - optionButtonForward[2]) / 12, 2, 2, 2, 2, ml and { 1, 0.91, 0.66, 0.1 } or { 1, 0.91, 0.66, 0.3 }, { 1, 0.91, 0.66, 0.2 })
            end
            if optionButtonBackward ~= nil and IsOnRect(mx, my, optionButtonBackward[1], optionButtonBackward[2], optionButtonBackward[3], optionButtonBackward[4]) then
                RectRound(optionButtonBackward[1], optionButtonBackward[2], optionButtonBackward[3], optionButtonBackward[4], (optionButtonBackward[4] - optionButtonBackward[2]) / 12, 2, 2, 2, 2, ml and { 1, 0.91, 0.66, 0.1 } or { 1, 0.91, 0.66, 0.3 }, { 1, 0.91, 0.66, 0.2 })
            end

            if not showSelectOptions then
                for i, o in pairs(optionHover) do
                    if IsOnRect(mx, my, o[1], o[2], o[3], o[4]) and options[i].type ~= 'label' then
                        RectRound(o[1] - 4, o[2], o[3] + 4, o[4], 2, 2, 2, 2, 2, options[i].onclick and { 0.5, 1, 0.2, 0.1 } or { 1, 1, 1, 0.045 }, options[i].onclick and { 0.5, 1, 0.2, 0.2 } or { 1, 1, 1, 0.09 })
                        font:Begin()
                        if options[i].description ~= nil then
                            description = options[i].description
                            font:Print('\255\235\190\122' .. options[i].description, screenX + (15*widgetScale), screenY - screenHeight + (65*widgetScale), 16*widgetScale, "no")
                        end
                        font:SetTextColor(0.46, 0.4, 0.3, 0.45)
                        font:Print('/option ' .. options[i].id, screenX + screenWidth * 0.659, screenY - screenHeight + (8*widgetScale), 14*widgetScale, "nr")
                        font:End()
                    end
                end
                for i, o in pairs(optionButtons) do
                    if IsOnRect(mx, my, o[1], o[2], o[3], o[4]) then
                        RectRound(o[1], o[2], o[3], o[4], 1, 2, 2, 2, 2, { 0.5, 0.5, 0.5, 0.22 }, { 1, 1, 1, 0.22 })
                        if WG['tooltip'] ~= nil and options[i].type == 'slider' then
                            local value = options[i].value
                            if options[i].steps then
                                value = NearestValue(options[i].steps, value)
                            else
                                local decimalValue, floatValue = math.modf(options[i].step)
                                if floatValue ~= 0 then
                                    value = string.format("%." .. string.len(string.sub('' .. options[i].step, 3)) .. "f", value)    -- do rounding via a string because floats show rounding errors at times
                                end
                            end
                            WG['tooltip'].ShowTooltip('options_showvalue', value)
                        end
                    end
                end
            end

            -- draw select options
            if showSelectOptions ~= nil then

                -- highlight all that are affected by presets
                if options[showSelectOptions].id == 'preset' then
                    for optionID, _ in pairs(presets['lowest']) do
                        local optionKey = getOptionByID(optionID)
                        if optionHover[optionKey] ~= nil then
                            RectRound(optionHover[optionKey][1], optionHover[optionKey][2] + 1.33, optionHover[optionKey][3], optionHover[optionKey][4] - 1.33, 1, 2, 2, 2, 2, { 0, 0, 0, 0.15 }, { 1, 1, 1, 0.15 })
                        end
                    end
                end

                local oHeight = optionButtons[showSelectOptions][4] - optionButtons[showSelectOptions][2]
                local oPadding = math.floor(4 * widgetScale)
                y = optionButtons[showSelectOptions][4] - oPadding
                local yPos = y
                optionSelect = {}
                for i, option in pairs(options[showSelectOptions].options) do
                    yPos = y - (((oHeight + oPadding + oPadding) * i) - oPadding)
                end

                selectOptionsList = glCreateList(function()
                    RectRound(optionButtons[showSelectOptions][1], yPos - oHeight - oPadding, optionButtons[showSelectOptions][3], optionButtons[showSelectOptions][4], 2, 2, 2, 2, 2, { 0.28, 0.28, 0.28, WG['guishader'] and 0.84 or 0.94 }, { 0.33, 0.33, 0.33, WG['guishader'] and 0.84 or 0.94 })
                    RectRound(optionButtons[showSelectOptions][1], optionButtons[showSelectOptions][2], optionButtons[showSelectOptions][3], optionButtons[showSelectOptions][4], 2, 2, 2, 2, 2, { 0.5, 0.5, 0.5, 0.1 }, { 1, 1, 1, 0.1 })
                    for i, option in pairs(options[showSelectOptions].options) do
                        yPos = math.floor(y - (((oHeight + oPadding + oPadding) * i) - oPadding))
                        if IsOnRect(mx, my, optionButtons[showSelectOptions][1], yPos - oHeight - oPadding, optionButtons[showSelectOptions][3], yPos + oPadding) then
                            RectRound(optionButtons[showSelectOptions][1], math.floor(yPos - oHeight - oPadding), optionButtons[showSelectOptions][3], math.floor(yPos + oPadding), 2, 2, 2, 2, 2, { 0.5, 0.5, 0.5, 0.3 }, { 1, 1, 1, 0.3 })
                            if playSounds and (prevSelectHover == nil or prevSelectHover ~= i) then
                                Spring.PlaySoundFile(selecthoverclick, 0.04, 'ui')
                            end
                            prevSelectHover = i
                        end
                        optionSelect[#optionSelect + 1] = { optionButtons[showSelectOptions][1], yPos - oHeight - oPadding, optionButtons[showSelectOptions][3], yPos + oPadding, i }

                        if options[showSelectOptions].optionsFont and fontOption then
                            fontOption[i]:Begin()
                            fontOption[i]:Print('\255\255\255\255' .. option, optionButtons[showSelectOptions][1] + 7, yPos - (oHeight / 2.25) - oPadding, oHeight * 0.85, "no")
                            fontOption[i]:End()
                        else
                            font:Begin()
                            font:Print('\255\255\255\255' .. option, optionButtons[showSelectOptions][1] + 7, yPos - (oHeight / 2.25) - oPadding, oHeight * 0.85, "no")
                            font:End()
                        end
                    end
                end)
                if WG['guishader'] then
                    WG['guishader'].InsertScreenRect(optionButtons[showSelectOptions][1], yPos - oHeight - oPadding, optionButtons[showSelectOptions][3], optionButtons[showSelectOptions][4], 'options_select')
                    WG['guishader'].insertRenderDlist(selectOptionsList)
                else
                    glCallList(selectOptionsList)
                end
            elseif prevSelectHover ~= nil then
                prevSelectHover = nil
            end
        else
            if WG['guishader'] then
                WG['guishader'].DeleteDlist('options')
            end
        end
        if checkedWidgetDataChanges == nil then
            checkedWidgetDataChanges = true
            loadAllWidgetData()
        end
    end

    prevShow = show
end

function saveOptionValue(widgetName, widgetApiName, widgetApiFunction, configVar, configValue, widgetApiFunctionParam)
    -- if widgetApiFunctionParam not defined then it uses configValue
    if widgetHandler.configData[widgetName] == nil then
        widgetHandler.configData[widgetName] = {}
    end
    if widgetHandler.configData[widgetName][configVar[1]] == nil then
        widgetHandler.configData[widgetName][configVar[1]] = {}
    end
    if configVar[2] ~= nil and widgetHandler.configData[widgetName][configVar[1]][configVar[2]] == nil then
        widgetHandler.configData[widgetName][configVar[1]][configVar[2]] = {}
    end
    if configVar[2] ~= nil then
        if configVar[3] ~= nil then
            widgetHandler.configData[widgetName][configVar[1]][configVar[2]][configVar[3]] = configValue
        else
            widgetHandler.configData[widgetName][configVar[1]][configVar[2]] = configValue
        end
    else
        widgetHandler.configData[widgetName][configVar[1]] = configValue
    end
    if widgetApiName ~= nil and WG[widgetApiName] ~= nil and WG[widgetApiName][widgetApiFunction] ~= nil then
        if widgetApiFunctionParam ~= nil then
            WG[widgetApiName][widgetApiFunction](widgetApiFunctionParam)
        else
            WG[widgetApiName][widgetApiFunction](configValue)
        end
    end
end

function loadPreset(preset)
    for optionID, value in pairs(presets[preset]) do
        local i = getOptionByID(optionID)
        if options[i] ~= nil then
            options[i].value = value
            applyOptionValue(i, true)
        end
    end

    if windowList then
        gl.DeleteList(windowList)
    end
    windowList = gl.CreateList(DrawWindow)
end

function widget:KeyPress(key)
    if key == 27 then
        -- ESC
        if showSelectOptions then
            showSelectOptions = nil
            --elseif draggingSlider ~= nil then
            --	options[draggingSlider].value = draggingSliderPreDragValue
            --	draggingSlider = nil
            --	sliderValueChanged = nil
            --	draggingSliderPreDragValue = nil
        else
            show = false
        end
    end
end

function IsOnRect(x, y, BLcornerX, BLcornerY, TRcornerX, TRcornerY)

    -- check if the mouse is in a rectangle
    return x >= BLcornerX and x <= TRcornerX and y >= BLcornerY and y <= TRcornerY
end

function round(value, numDecimalPlaces)
    return string.format("%0." .. numDecimalPlaces .. "f", math.round(value, numDecimalPlaces))
end

function NearestValue(table, number)
    local smallestSoFar, smallestIndex
    for i, y in ipairs(table) do
        if not smallestSoFar or (math.abs(number - y) < smallestSoFar) then
            smallestSoFar = math.abs(number - y)
            smallestIndex = i
        end
    end
    return table[smallestIndex]
end

function getSliderValue(draggingSlider, mx)
    local sliderWidth = optionButtons[draggingSlider].sliderXpos[2] - optionButtons[draggingSlider].sliderXpos[1]
    local value = (mx - optionButtons[draggingSlider].sliderXpos[1]) / sliderWidth
    local min, max
    if options[draggingSlider].steps then
        min, max = options[draggingSlider].steps[1], options[draggingSlider].steps[1]
        for k, v in ipairs(options[draggingSlider].steps) do
            if v > max then
                max = v
            end
            if v < min then
                min = v
            end
        end
    else
        min = options[draggingSlider].min
        max = options[draggingSlider].max
    end
    value = min + ((max - min) * value)
    if value < min then
        value = min
    end
    if value > max then
        value = max
    end
    if options[draggingSlider].steps ~= nil then
        value = NearestValue(options[draggingSlider].steps, value)
    elseif options[draggingSlider].step ~= nil then
        value = math.floor((value + (options[draggingSlider].step / 2)) / options[draggingSlider].step) * options[draggingSlider].step
    end
    return value    -- is a string now :(
end

function widget:MouseWheel(up, value)
    local x, y = Spring.GetMouseState()
    if show then
        return true
    end
end

function widget:MouseMove(mx, my)
    if draggingSlider ~= nil then
        local newValue = getSliderValue(draggingSlider, mx)
        if options[draggingSlider].value ~= newValue then
            options[draggingSlider].value = newValue
            sliderValueChanged = true
            applyOptionValue(draggingSlider)    -- disabled so only on release it gets applied
            if playSounds and (lastSliderSound == nil or os_clock() - lastSliderSound > 0.04) then
                lastSliderSound = os_clock()
                Spring.PlaySoundFile(sliderdrag, 0.4, 'ui')
            end
        end
    end
end

function widget:TweakMousePress(x, y, button)
    --return mouseEvent(x, y, button, false)
end

function widget:TweakMouseRelease(x, y, button)
    --return mouseEvent(x, y, button, true)
end

function widget:MousePress(x, y, button)
    return mouseEvent(x, y, button, false)
end

function widget:MouseRelease(x, y, button)
    return mouseEvent(x, y, button, true)
end

function mouseEvent(mx, my, button, release)
    if spIsGUIHidden() then
        return false
    end

    if show then
        local returnTrue
        if button == 3 then
            if titleRect ~= nil and IsOnRect(mx, my, titleRect[1], titleRect[2], titleRect[3], titleRect[4]) then
                return
            end
            if showSelectOptions ~= nil and options[showSelectOptions].id == 'preset' then
                for i, o in pairs(optionSelect) do
                    if IsOnRect(mx, my, o[1], o[2], o[3], o[4]) then
                        if presetNames[o[5]] and customPresets[presetNames[o[5]]] ~= nil then
                            deletePreset(presetNames[o[5]])
                            if playSounds then
                                Spring.PlaySoundFile(selectclick, 0.5, 'ui')
                            end
                            if selectClickAllowHide ~= nil or not IsOnRect(mx, my, optionButtons[showSelectOptions][1], optionButtons[showSelectOptions][2], optionButtons[showSelectOptions][3], optionButtons[showSelectOptions][4]) then
                                showSelectOptions = nil
                                selectClickAllowHide = nil
                            else
                                selectClickAllowHide = true
                            end
                            return
                        end
                    end
                end
            end
        elseif button == 1 then
            if release then

                if titleRect ~= nil and IsOnRect(mx, my, titleRect[1], titleRect[2], titleRect[3], titleRect[4]) then
                    -- showhow rightmouse doesnt get triggered :S
                    advSettings = not advSettings
                    startColumn = 1
                    if currentGroupTab == 'dev' then
                        currentGroupTab = 'gfx'
                    end
                    return
                end
                -- navigation buttons
                if optionButtonForward ~= nil and IsOnRect(mx, my, optionButtonForward[1], optionButtonForward[2], optionButtonForward[3], optionButtonForward[4]) then
                    startColumn = startColumn + maxShownColumns
                    if startColumn > totalColumns + (maxShownColumns - 1) then
                        startColumn = (totalColumns - maxShownColumns) + 1
                    end
                    if playSounds then
                        Spring.PlaySoundFile(paginatorclick, 0.6, 'ui')
                    end
                    showSelectOptions = nil
                    selectClickAllowHide = nil
                    if windowList then
                        gl.DeleteList(windowList)
                    end
                    windowList = gl.CreateList(DrawWindow)
                    return
                end
                if optionButtonBackward ~= nil and IsOnRect(mx, my, optionButtonBackward[1], optionButtonBackward[2], optionButtonBackward[3], optionButtonBackward[4]) then
                    startColumn = startColumn - maxShownColumns
                    if startColumn < 1 then
                        startColumn = 1
                    end
                    if playSounds then
                        Spring.PlaySoundFile(paginatorclick, 0.6, 'ui')
                    end
                    showSelectOptions = nil
                    selectClickAllowHide = nil
                    if windowList then
                        gl.DeleteList(windowList)
                    end
                    windowList = gl.CreateList(DrawWindow)
                    return
                end

                -- apply new slider value
                if draggingSlider ~= nil then
                    options[draggingSlider].value = getSliderValue(draggingSlider, mx)
                    applyOptionValue(draggingSlider)
                    draggingSlider = nil
                    draggingSliderPreDragValue = nil
                    return
                end

                -- select option
                if showSelectOptions ~= nil then
                    for i, o in pairs(optionSelect) do
                        if IsOnRect(mx, my, o[1], o[2], o[3], o[4]) then
                            options[showSelectOptions].value = o[5]
                            applyOptionValue(showSelectOptions)
                            if playSounds then
                                Spring.PlaySoundFile(selectclick, 0.5, 'ui')
                            end
                        end
                    end
                    if selectClickAllowHide ~= nil or not IsOnRect(mx, my, optionButtons[showSelectOptions][1], optionButtons[showSelectOptions][2], optionButtons[showSelectOptions][3], optionButtons[showSelectOptions][4]) then
                        showSelectOptions = nil
                        selectClickAllowHide = nil
                    else
                        selectClickAllowHide = true
                    end
                    return
                end
            end

            local tabClicked = false
            if show and groupRect ~= nil then
                for id, group in pairs(optionGroups) do
                    if advSettings or group.id ~= 'dev' then
                        if IsOnRect(mx, my, groupRect[id][1], groupRect[id][2], groupRect[id][3], groupRect[id][4]) then
                            if not release then
                                currentGroupTab = group.id
                                startColumn = 1
                                showSelectOptions = nil
                                selectClickAllowHide = nil
                                if playSounds then
                                    Spring.PlaySoundFile(paginatorclick, 0.9, 'ui')
                                end
                            end
                            tabClicked = true
                            returnTrue = true
                        end
                    end
                end
            end


            if tabClicked then

            elseif IsOnRect(mx, my, windowRect[1], windowRect[2], windowRect[3], windowRect[4]) then	-- on window


                if release then

                    -- select option
                    if showSelectOptions == nil then
                        if showPresetButtons then
                            for preset, pp in pairs(presets) do
                                if IsOnRect(mx, my, pp.pos[1], pp.pos[2], pp.pos[3], pp.pos[4]) then
                                    loadPreset(preset)
                                end
                            end
                        end

                        for i, o in pairs(optionButtons) do

                            if options[i].type == 'bool' and IsOnRect(mx, my, o[1], o[2], o[3], o[4]) then
                                options[i].value = not options[i].value
                                applyOptionValue(i)
                                if playSounds then
                                    if options[i].value then
                                        Spring.PlaySoundFile(toggleonclick, 0.75, 'ui')
                                    else
                                        Spring.PlaySoundFile(toggleoffclick, 0.75, 'ui')
                                    end
                                end
                            elseif options[i].type == 'slider' and IsOnRect(mx, my, o[1], o[2], o[3], o[4]) then

                            elseif options[i].type == 'select' and IsOnRect(mx, my, o[1], o[2], o[3], o[4]) then

                            elseif options[i].onclick ~= nil and IsOnRect(mx, my, optionHover[i][1], optionHover[i][2], optionHover[i][3], optionHover[i][4]) then
                                options[i].onclick(i)
                            end
                        end
                    end
                else
                    -- mousepress

                    if not showSelectOptions then
                        for i, o in pairs(optionButtons) do
                            if options[i].type == 'slider' and (IsOnRect(mx, my, o.sliderXpos[1], o[2], o.sliderXpos[2], o[4]) or IsOnRect(mx, my, o[1], o[2], o[3], o[4])) then
                                draggingSlider = i
                                draggingSliderPreDragValue = options[draggingSlider].value
                                local newValue = getSliderValue(draggingSlider, mx)
                                if options[draggingSlider].value ~= newValue then
                                    options[draggingSlider].value = getSliderValue(draggingSlider, mx)
                                    applyOptionValue(draggingSlider)    -- disabled so only on release it gets applied
                                    if playSounds then
                                        Spring.PlaySoundFile(sliderdrag, 0.3, 'ui')
                                    end
                                end
                            elseif options[i].type == 'select' and IsOnRect(mx, my, o[1], o[2], o[3], o[4]) then

                                if playSounds then
                                    Spring.PlaySoundFile(selectunfoldclick, 0.6, 'ui')
                                end
                                if showSelectOptions == nil then
                                    showSelectOptions = i
                                elseif showSelectOptions == i then
                                    --showSelectOptions = nil
                                end
                            end
                        end
                    end
                end

                if button == 1 or button == 3 then
                    return true
                end
                -- on title
            elseif titleRect ~= nil and IsOnRect(mx, my, (titleRect[1] * widgetScale) - ((vsx * (widgetScale - 1)) / 2), (titleRect[2] * widgetScale) - ((vsy * (widgetScale - 1)) / 2), (titleRect[3] * widgetScale) - ((vsx * (widgetScale - 1)) / 2), (titleRect[4] * widgetScale) - ((vsy * (widgetScale - 1)) / 2)) then
                --currentGroupTab = nil
                --startColumn = 1
                returnTrue = true
            elseif not tabClicked then
                if release and draggingSlider == nil then
                    showOnceMore = true        -- show once more because the guishader lags behind, though this will not fully fix it
                    show = false
                end
                return true
            end

            if show then
                if windowList then
                    gl.DeleteList(windowList)
                end
                windowList = gl.CreateList(DrawWindow)
            end
            if returnTrue then
                return true
            end
        end

        if IsOnRect(mx, my, windowRect[1], windowRect[2], windowRect[3], windowRect[4]) then
            return true
        end
    end
end

function GetWidgetToggleValue(widgetname)
    if widgetHandler.orderList[widgetname] == nil or widgetHandler.orderList[widgetname] == 0 then
        return false
    elseif widgetHandler.orderList[widgetname] >= 1
            and widgetHandler.knownWidgets ~= nil
            and widgetHandler.knownWidgets[widgetname] ~= nil then
        if widgetHandler.knownWidgets[widgetname].active then
            return true
        else
            return 0.5
        end
    end
end

-- configVar = table, add more entries the deeper the configdata table var is: example: {'Config','console','maxlines'}  (limit = 3 deep)
function loadWidgetData(widgetName, optionId, configVar)
    if widgetHandler.knownWidgets[widgetName] ~= nil then
        if getOptionByID(optionId) and widgetHandler.configData[widgetName] ~= nil and widgetHandler.configData[widgetName][configVar[1]] ~= nil then
            if configVar[2] ~= nil and widgetHandler.configData[widgetName][configVar[1]][configVar[2]] ~= nil then
                if configVar[3] ~= nil and widgetHandler.configData[widgetName][configVar[1]][configVar[2]][configVar[3]] ~= nil then
                    options[getOptionByID(optionId)].value = widgetHandler.configData[widgetName][configVar[1]][configVar[2]][configVar[3]]
                    return true
                else
                    options[getOptionByID(optionId)].value = widgetHandler.configData[widgetName][configVar[1]][configVar[2]]
                    return true
                end
            elseif options[getOptionByID(optionId)].value ~= widgetHandler.configData[widgetName][configVar[1]] then
                options[getOptionByID(optionId)].value = widgetHandler.configData[widgetName][configVar[1]]
                return true
            end
        end
    end
end

function lines(str)
    local t = {}
    local function helper(line)
        table.insert(t, line)
        return ""
    end
    helper((str:gsub("(.-)\r?\n", helper)))
    return t
end

function applyOptionValue(i, skipRedrawWindow, force)
    if options[i] == nil then
        return
    end

    if options[i].restart then
        changesRequireRestart = true
    end

    local id = options[i].id

    if options[i].widget ~= nil then
        if options[i].value then
            if widgetHandler.orderList[options[i].widget] < 0.5 then
                widgetHandler:EnableWidget(options[i].widget)
            end
        else
            if widgetHandler.orderList[options[i].widget] > 0 then
                widgetHandler:ToggleWidget(options[i].widget)
            else
                widgetHandler:DisableWidget(options[i].widget)
            end
        end
        forceUpdate = true
        if id == "teamcolors" then
            Spring.SendCommands("luarules reloadluaui")    -- cause several widgets are still using old colors
        end
    end

    if options[i].onchange then
        options[i].onchange(i, options[i].value, force)
    end

    if skipRedrawWindow == nil then
        if windowList then
            gl.DeleteList(windowList)
        end
        windowList = gl.CreateList(DrawWindow)
    end
end


-- loads values via stored game config in luaui/configs
function loadAllWidgetData()

    for i, option in pairs(options) do
        if option.onload then
            option.onload(i)
        end
    end
end

-- detect potatos
local isPotatoCpu = false
local isPotatoGpu = false
local gpuMem = (Platform.gpuMemorySize and Platform.gpuMemorySize or 1000) / 1000
if Platform ~= nil and Platform.gpuVendor == 'Intel' then
    isPotatoGpu = true
end
if gpuMem and gpuMem < 1800 then
    isPotatoGpu = true
end

local engine64 = true
function init()

    presetNames = texts.presetnames    -- defined so these get listed in the right order
    presets = {
        [presetNames[1]] = {
            bloom = false,
            bloomdeferred = false,
            ssao = 1,
            mapedgeextension = false,
            lighteffects = false,
            airjets = false,
            heatdistortion = false,
            snow = false,
            particles = 15000,
            nanoparticles = 1500,
            nanobeamamount = 6,
            treeradius = 0,
            --treewind = false,
            guishader = false,
            decals = 0,
            --grounddetail = 70,
            darkenmap_darkenfeatures = false,
            enemyspotter_highlight = false,
        },
        [presetNames[2]] = {
            bloom = false,
            bloomdeferred = true,
            ssao = 1,
            mapedgeextension = false,
            lighteffects = true,
            airjets = true,
            heatdistortion = true,
            snow = false,
            particles = 20000,
            nanoparticles = 3000,
            nanobeamamount = 8,
            treeradius = 200,
            --treewind = false,
            guishader = false,
            decals = 0,
            --grounddetail = 100,
            darkenmap_darkenfeatures = false,
            enemyspotter_highlight = false,
        },
        [presetNames[3]] = {
            bloom = true,
            bloomdeferred = true,
            ssao = 1,
            mapedgeextension = true,
            lighteffects = true,
            airjets = true,
            heatdistortion = true,
            snow = true,
            particles = 25000,
            nanoparticles = 5000,
            nanobeamamount = 12,
            treeradius = 400,
            --treewind = false,
            guishader = true,
            decals = 2,
            --grounddetail = 140,
            darkenmap_darkenfeatures = false,
            enemyspotter_highlight = false,
        },
        [presetNames[4]] = {
            bloom = true,
            bloomdeferred = true,
            ssao = 2,
            mapedgeextension = true,
            lighteffects = true,
            airjets = true,
            heatdistortion = true,
            snow = true,
            particles = 30000,
            nanoparticles = 9000,
            nanobeamamount = 20,
            treeradius = 800,
            --treewind = true,
            guishader = true,
            decals = 4,
            --grounddetail = 180,
            darkenmap_darkenfeatures = false,
            enemyspotter_highlight = false,
        },
        [presetNames[5]] = {
            bloom = true,
            bloomdeferred = true,
            ssao = 3,
            mapedgeextension = true,
            lighteffects = true,
            airjets = true,
            heatdistortion = true,
            snow = true,
            particles = 40000,
            nanoparticles = 15000,
            nanobeamamount = 40,
            treeradius = 800,
            --treewind = true,
            guishader = true,
            decals = 5,
            --grounddetail = 200,
            darkenmap_darkenfeatures = true,
            enemyspotter_highlight = true,
        },
    }
    customPresets = {}

    local supportedResolutions = {}
    local soundDevices = { 'default' }
    local soundDevicesByName = { [''] = 1 }
    local infolog = VFS.LoadFile("infolog.txt")
    if infolog then
        local fileLines = lines(infolog)
        local desktop = ''
        local addResolutions
        for i, line in ipairs(fileLines) do
            if addResolutions then
                local resolution = string.match(line, '[0-9]*x[0-9]*')
                if resolution and string.len(resolution) >= 7 then
                    local resolution = string.gsub(resolution, "x", " x ")
                    local resolutionX = string.match(resolution, '[0-9]*')
                    local resolutionY = string.gsub(string.match(resolution, 'x [0-9]*'), 'x ', '')
                    if tonumber(resolutionX) >= 640 and tonumber(resolutionY) >= 480 and resolution ~= desktop then
                        supportedResolutions[#supportedResolutions + 1] = resolution
                    end
                else
                    addResolutions = nil
                    --break
                end
            end
            if string.find(line, '	display=') and not supportedResolutions[1] then
                if addResolutions then
                    --break
                end
                addResolutions = true
                local width = string.sub(string.match(line, 'w=([0-9]*)'), 1)
                local height = string.sub(string.match(line, 'h=([0-9]*)'), 1)
                desktop = width .. ' x ' .. height
                supportedResolutions[#supportedResolutions + 1] = desktop
            end
            if string.find(line, '     %[') then
                addResolutions = nil
                local device = string.sub(string.match(line, '     %[([0-9a-zA-Z _%-%(%)]*)'), 1)
                soundDevices[#soundDevices + 1] = device
                soundDevicesByName[device] = #soundDevices
            end
            -- scan for shader version error
            if string.find(line, 'error: GLSL 1.50 is not supported') then
                Spring.SetConfigInt("LuaShaders", 0)
            end
            -- scan for shader version error
            if string.find(line, '_win32') or string.find(line, '_linux32') then
                engine64 = false
            end

            -- look for system hardware
            if string.find(line, 'Physical CPU Cores') then
                if tonumber(string.match(line, '([0-9].*)')) and tonumber(string.match(line, '([0-9].*)')) <= 2 then
                    isPotatoCpu = true
                end
            end
            if string.find(line, 'Logical CPU Cores') then
                if tonumber(string.match(line, '([0-9].*)')) and tonumber(string.match(line, '([0-9].*)')) <= 2 then
                    isPotatoCpu = true
                end
            end

            if string.find(line:lower(), 'hardware config: ') then
                --if string.find(line:lower() 'core(tm)2') then
                --	isPotatoCpu = true
                --end
                local s_ram = string.match(line, '([0-9]*MB RAM)')
                if s_ram ~= nil then
                    s_ram = string.gsub(s_ram, " RAM", "")
                    if tonumber(s_ram) and tonumber(s_ram) < 6500 then
                        isPotatoCpu = true
                    end
                end
            end
        end
        -- adding some widescreen resolutions for local testing
        --supportedResolutions[#supportedResolutions+1] = '3840 x 1440'
        --supportedResolutions[#supportedResolutions+1] = '2560 x 1200'
        --supportedResolutions[#supportedResolutions+1] = '2560 x 1080'
        --supportedResolutions[#supportedResolutions+1] = '2560 x 900'
    end


    --isPotatoCpu = true	-- enable to test
    --isPotatoGpu = true	-- enable to test

    -- restrict options for potato systems
    if isPotatoCpu or isPotatoGpu then
        if isPotatoCpu then
            Spring.Echo('potato CPU detected')
        end
        if isPotatoCpu then
            Spring.Echo('potato Graphics Card detected')
        end
        presetNames = { 'lowest', 'low', 'medium' }
    end

    -- if you want to add an option it should be added here, and in applyOptionValue(), if option needs shaders than see the code below the options definition
    optionGroups = {
        { id = 'gfx', name = texts.group.graphics },
        { id = 'ui', name = texts.group.interface },
        { id = 'game', name = texts.group.game },
        { id = 'control', name = texts.group.control },
        { id = 'snd', name = texts.group.audio },
        { id = 'notif', name = texts.group.notifications },
        { id = 'dev', name = texts.group.dev },
    }

    if not currentGroupTab or Spring.GetGameFrame() == 0 then
        currentGroupTab = optionGroups[1].id
    else
        -- check if group exists
        local found = false
        for id, group in pairs(optionGroups) do
            if group.id == currentGroupTab then
                found = true
                break
            end
        end
        if not found then
            currentGroupTab = optionGroups[1].id
        end
    end

    options = {
        -- PRESET
        { id = "preset", group = "gfx", basic = true, name = texts.option.preset, type = "select", options = presetNames, value = 0, description = texts.option.preset_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.Echo('Loading preset:   ' .. options[i].options[value])
              options[i].value = 0
              loadPreset(presetNames[value])
          end,
        },
        --GFX
        { id = "resolution", group = "gfx", basic = true, name = texts.option.resolution, type = "select", options = supportedResolutions, value = 0, description = texts.option.resolution_descr,
          onchange = function(i, value)
              local resolutionX = string.match(options[i].options[options[i].value], '[0-9]*')
              local resolutionY = string.gsub(string.match(options[i].options[options[i].value], 'x [0-9]*'), 'x ', '')
              if tonumber(Spring.GetConfigInt("Fullscreen", 1) or 1) == 1 then
                  Spring.SendCommands("Fullscreen 0")
                  Spring.SetConfigInt("XResolution", tonumber(resolutionX))
                  Spring.SetConfigInt("YResolution", tonumber(resolutionY))
                  Spring.SendCommands("Fullscreen 1")
              else
                  Spring.SendCommands("Fullscreen 1")
                  Spring.SetConfigInt("XResolutionWindowed", tonumber(resolutionX))
                  Spring.SetConfigInt("YResolutionWindowed", tonumber(resolutionY))
                  Spring.SendCommands("Fullscreen 0")
              end
              checkResolution()
          end,
        },
        { id = "fullscreen", group = "gfx", basic = true, name = texts.option.fullscreen, type = "bool", value = tonumber(Spring.GetConfigInt("Fullscreen", 1) or 1) == 1,
          onchange = function(i, value)
              if value then
                  options[getOptionByID('borderless')].value = false
                  applyOptionValue(getOptionByID('borderless'))
                  local xres = tonumber(Spring.GetConfigInt('XResolutionWindowed', ssx))
                  local yres = tonumber(Spring.GetConfigInt('YResolutionWindowed', ssy))
                  Spring.SetConfigInt("XResolution", xres)
                  Spring.SetConfigInt("YResolution", yres)
              else
                  local xres = tonumber(Spring.GetConfigInt('XResolution', ssx))
                  local yres = tonumber(Spring.GetConfigInt('YResolution', ssy))
                  Spring.SetConfigInt("XResolutionWindowed", xres)
                  Spring.SetConfigInt("YResolutionWindowed", yres)
              end
              checkResolution()
              Spring.SendCommands("Fullscreen " .. (value and 1 or 0))
              Spring.SetConfigInt("Fullscreen", (value and 1 or 0))
          end, },
        { id = "borderless", group = "gfx", basic = true, name = texts.option.borderless, type = "bool", value = tonumber(Spring.GetConfigInt("WindowBorderless", 1) or 1) == 1, description = texts.option.borderless_descr,
          onchange = function(i, value)
              Spring.SetConfigInt("WindowBorderless", (value and 1 or 0))
              if value then
                  options[getOptionByID('fullscreen')].value = false
                  applyOptionValue(getOptionByID('fullscreen'))
                  Spring.SetConfigInt("WindowPosX", 0)
                  Spring.SetConfigInt("WindowPosY", 0)
                  Spring.SetConfigInt("WindowState", 0)
              else
                  Spring.SetConfigInt("WindowPosX", 0)
                  Spring.SetConfigInt("WindowPosY", 0)
                  Spring.SetConfigInt("WindowState", 1)
              end
              checkResolution()
          end,
        },
        { id = "windowpos", group = "gfx", basic = true, widget = "Move Window Position", name = texts.option.windowpos, type = "bool", value = GetWidgetToggleValue("Move Window Position"), description = texts.option.windowpos_descr,
          onchange = function(i, value)
              Spring.SetConfigInt("FullscreenEdgeMove", (value and 1 or 0))
              Spring.SetConfigInt("WindowedEdgeMove", (value and 1 or 0))
          end,
        },
        { id = "vsync", group = "gfx", basic = true, name = texts.option.vsync, type = "bool", value = vsyncEnabled, description = '',
          onchange = function(i, value)
              vsyncEnabled = value
              local vsync = 0
              if vsyncEnabled then
                  if not vsyncOnlyForSpec or isSpec then
                      vsync = vsyncLevel
                      options[getOptionByID('vsync')].value = true
                  else
                      options[getOptionByID('vsync')].value = 0.5
                  end
              end
              Spring.SetConfigInt("VSync", vsync)
          end,
        },
        { id = "vsync_spec", group = "gfx", basic = true, name = widgetOptionColor .. "   "..texts.option.vsync_spec, type = "bool", value = vsyncOnlyForSpec, description = texts.option.vsync_spec_descr,
          onchange = function(i, value)
              vsyncOnlyForSpec = value
              if isSpec and vsyncEnabled then
                  Spring.SetConfigInt("VSync", (vsyncOnlyForSpec and vsyncLevel or 0))
              end
              if vsyncEnabled then
                  local id = getOptionByID('vsync')
                  options[id].onchange(id, options[id].value)
              end
          end,
        },
        { id = "vsync_level", group = "gfx", name = widgetOptionColor .. "   "..texts.option.vsync_level, type = "slider", min = 1, max = 3, step = 1, value = vsyncLevel, description = texts.option.vsync_level_descr,
          onchange = function(i, value)
              vsyncLevel = value
              local vsync = 0
              if vsyncEnabled and (not isSpec or vsyncOnlyForSpec) then
                  vsync = vsyncLevel
              end
              Spring.SetConfigInt("VSync", vsync)
          end,
        },
        { id = "limitidlefps", group = "gfx", widget = "Limit idle FPS", name = texts.option.limitidlefps, type = "bool", value = GetWidgetToggleValue("Limit idle FPS"), description = texts.option.limitidlefps_descr },

        { id = "msaa", group = "gfx", basic = true, name = texts.option.msaa, type = "slider", min = 0, max = 8, step = 1, restart = true, value = tonumber(Spring.GetConfigInt("MSAALevel", 1) or 2), description = texts.option.msaa_descr,
          onchange = function(i, value)
              Spring.SetConfigInt("MSAALevel", value)
          end,
        },

        { id = "cas_sharpness", group = "gfx", name = texts.option.cas_sharpness, min = 0.25, max = 0.85, step = 0.01, type = "slider", value = 0.7, description = texts.option.cas_sharpness_descr,
          onload = function(i)
              loadWidgetData("Contrast Adaptive Sharpen", "cas_sharpness", { 'SHARPNESS' })
          end,
          onchange = function(i, value)
              saveOptionValue('Contrast Adaptive Sharpen', 'cas', 'setSharpness', { 'SHARPNESS' }, options[getOptionByID('cas_sharpness')].value)
          end,
        },

        { id = "shadowslider", group = "gfx", basic = true, name = texts.option.shadowslider, type = "slider", steps = { 2048, 3072, 4096, 8192 }, value = tonumber(Spring.GetConfigInt("ShadowMapSize", 1) or 4096), description = texts.option.shadowslider_descr,
          onchange = function(i, value)
              local enabled = (value < 1000) and 0 or 1
              Spring.SendCommands("shadows " .. enabled .. " " .. value)
              Spring.SetConfigInt("Shadows", enabled)
              Spring.SetConfigInt("ShadowMapSize", value)
          end,
        },
        { id = "shadows_opacity", group = "gfx", name = widgetOptionColor .. "   "..texts.option.shadows_opacity, type = "slider", min = 0.3, max = 1, step = 0.01, value = gl.GetSun("shadowDensity"), description = '',
          onchange = function(i, value)
              Spring.SetSunLighting({ groundShadowDensity = value, modelShadowDensity = value })
          end,
        },
        { id = "sun_y", group = "gfx", name = texts.option.sun.. widgetOptionColor .. "  "..texts.option.sun_y, type = "slider", min = 0.05, max = 0.9999, step = 0.0001, value = select(2, gl.GetSun("pos")), description = '',
          onchange = function(i, value)
              local sunX, sunY, sunZ = gl.GetSun("pos")
              sunY = value
              if sunY < options[getOptionByID('sun_y')].min then
                  sunY = options[getOptionByID('sun_y')].min
              end
              if sunY > options[getOptionByID('sun_y')].max then
                  sunY = options[getOptionByID('sun_y')].max
              end
              options[getOptionByID('sun_y')].value = sunY
              Spring.SetSunDirection(sunX, sunY, sunZ)
              -- just so that map/model lighting gets updated
              Spring.SetSunLighting({ groundShadowDensity = gl.GetSun("shadowDensity"), modelShadowDensity = gl.GetSun("shadowDensity") })
              customMapSunPos[Game.mapName] = { gl.GetSun("pos") }
          end,
        },
        { id = "sun_x", group = "gfx", name = widgetOptionColor .. "   "..texts.option.sun_x, type = "slider", min = -0.9999, max = 0.9999, step = 0.0001, value = select(1, gl.GetSun("pos")), description = '',
          onchange = function(i, value)
              local sunX, sunY, sunZ = gl.GetSun("pos")
              sunX = value
              if sunX < options[getOptionByID('sun_x')].min then
                  sunX = options[getOptionByID('sun_x')].min
              end
              if sunX > options[getOptionByID('sun_x')].max then
                  sunX = options[getOptionByID('sun_x')].max
              end
              options[getOptionByID('sun_x')].value = sunX
              Spring.SetSunDirection(sunX, sunY, sunZ)
              -- just so that map/model lighting gets updated
              Spring.SetSunLighting({ groundShadowDensity = gl.GetSun("shadowDensity"), modelShadowDensity = gl.GetSun("shadowDensity") })
              customMapSunPos[Game.mapName] = { gl.GetSun("pos") }
          end,
        },
        { id = "sun_z", group = "gfx", name = widgetOptionColor .. "   "..texts.option.sun_z, type = "slider", min = -0.9999, max = 0.9999, step = 0.0001, value = select(3, gl.GetSun("pos")), description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              local sunX, sunY, sunZ = gl.GetSun("pos")
              sunZ = value
              if sunZ < options[getOptionByID('sun_z')].min then
                  sunZ = options[getOptionByID('sun_z')].min
              end
              if sunZ > options[getOptionByID('sun_z')].max then
                  sunZ = options[getOptionByID('sun_z')].max
              end
              options[getOptionByID('sun_z')].value = sunZ
              Spring.SetSunDirection(sunX, sunY, sunZ)
              -- just so that map/model lighting gets updated
              Spring.SetSunLighting({ groundShadowDensity = gl.GetSun("shadowDensity"), modelShadowDensity = gl.GetSun("shadowDensity") })
              customMapSunPos[Game.mapName] = { gl.GetSun("pos") }
          end,
        },
        { id = "sun_reset", group = "gfx", name = widgetOptionColor .. "   "..texts.option.sun_reset, type = "bool", value = false, description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              options[getOptionByID('sun_x')].value = defaultMapSunPos[1]
              options[getOptionByID('sun_y')].value = defaultMapSunPos[2]
              options[getOptionByID('sun_z')].value = defaultMapSunPos[3]
              options[getOptionByID('sun_reset')].value = false
              Spring.SetSunDirection(defaultMapSunPos[1], defaultMapSunPos[2], defaultMapSunPos[3])
              -- just so that map/model lighting gets updated
              Spring.SetSunLighting({ groundShadowDensity = gl.GetSun("shadowDensity"), modelShadowDensity = gl.GetSun("shadowDensity") })
              Spring.Echo('resetted map sun defaults')
              customMapSunPos[Game.mapName] = nil
          end,
        },

        { id = "darkenmap", group = "gfx", name = texts.option.darkenmap, min = 0, max = 0.5, step = 0.01, type = "slider", value = 0, description = texts.option.darkenmap_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Darken map', 'darkenmap', 'setMapDarkness', { 'maps', Game.mapName:lower() }, value)
          end,
        },
        { id = "darkenmap_darkenfeatures", group = "gfx", name = widgetOptionColor .. "   "..texts.option.darkenmap_darkenfeatures, type = "bool", value = false, description = texts.option.darkenmap_darkenfeatures_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Darken map', 'darkenmap', 'setDarkenFeatures', { 'darkenFeatures' }, value)
          end,
        },

        { id = "fog_start", group = "gfx", name = texts.option.fog .. widgetOptionColor .. "  "..texts.option.fog_start, type = "slider", min = 0, max = 1.99, step = 0.01, value = gl.GetAtmosphere("fogStart"), description = texts.option.fog_start_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              if value >= options[getOptionByID('fog_end')].value then
                  options[getOptionByID('fog_end')].value = value + 0.01
                  applyOptionValue(getOptionByID('fog_end'))
              end
              Spring.SetAtmosphere({ fogStart = value })
              customMapFog[Game.mapName] = { fogStart = gl.GetAtmosphere("fogStart"), fogEnd = gl.GetAtmosphere("fogStart") }
          end,
        },
        { id = "fog_end", group = "gfx", name = widgetOptionColor .. "   "..texts.option.fog_end, type = "slider", min = 0.5, max = 2, step = 0.01, value = gl.GetAtmosphere("fogEnd"), description = texts.option.fog_end_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              if value <= options[getOptionByID('fog_start')].value then
                  options[getOptionByID('fog_start')].value = value - 0.01
                  applyOptionValue(getOptionByID('fog_start'))
              end
              Spring.SetAtmosphere({ fogEnd = value })
              customMapFog[Game.mapName] = { fogStart = gl.GetAtmosphere("fogStart"), fogEnd = gl.GetAtmosphere("fogEnd") }
          end,
        },
        { id = "fog_reset", group = "gfx", name = widgetOptionColor .. "   "..texts.option.fog_reset, type = "bool", value = false, description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              options[getOptionByID('fog_start')].value = defaultFog.fogStart
              options[getOptionByID('fog_end')].value = defaultFog.fogEnd
              options[getOptionByID('fog_reset')].value = false
              Spring.SetAtmosphere({ fogStart = defaultFog.fogStart, fogEnd = defaultFog.fogEnd })
              Spring.Echo('resetted map fog defaults')
              customMapFog[Game.mapName] = nil
          end,
        },

        { id = "ssao", group = "gfx", basic = true, name = texts.option.ssao, type = "select", options = { 'disabled', 'enabled', 'high'}, value = 0, description = texts.option.ssao_descr,
          onchange = function(i, value)
              if value == 1 then
                  widgetHandler:DisableWidget("SSAO")
              else
                  if not GetWidgetToggleValue("SSAO") then
                      widgetHandler:EnableWidget("SSAO")
                  end
                  saveOptionValue('SSAO', 'ssao', 'setPreset', { 'preset' }, value - 1)
              end
          end,
          onload = function(i)
              if not GetWidgetToggleValue("SSAO") then
                  options[getOptionByID('ssao')].value = 1
              else
                  loadWidgetData("SSAO", "ssao", { 'preset' })
                  options[getOptionByID('ssao')].value = options[getOptionByID('ssao')].value + 1
              end
          end,
        },
        { id = "ssao_strength", group = "gfx", name = widgetOptionColor .. "   "..texts.option.ssao_strength, type = "slider", min = 4, max = 15, step = 1, value = 8, description = '',
          onchange = function(i, value)
              saveOptionValue('SSAO', 'ssao', 'setStrength', { 'strength' }, value)
          end,
          onload = function(i)
              loadWidgetData("SSAO", "ssao_strength", { 'strength' })
          end,
        },
        --{id="ssao_radius", group="gfx", name=widgetOptionColor.."   radius", type="slider", min=4, max=6, step=1, value=5, description='',
        -- onchange=function(i,value) saveOptionValue('SSAO', 'ssao', 'setRadius', {'radius'}, value) end,
        -- onload=function(i) loadWidgetData("SSAO", "ssao_radius", {'radius'}) end,
        --},

        { id = "outline", group = "gfx", basic = true, widget = "Outline", name = texts.option.outline, type = "bool", value = GetWidgetToggleValue("Outline"), description = texts.option.outline_descr },
        { id = "outline_width", group = "gfx", basic = true, name = widgetOptionColor .. "   "..texts.option.outline_width, min = 1, max = 3, step = 1, type = "slider", value = 1, description = texts.option.outline_width_descr,
          onload = function(i)
              loadWidgetData("Outline", "outline_width", { 'DILATE_HALF_KERNEL_SIZE' })
          end,
          onchange = function(i, value)
              saveOptionValue('Outline', 'outline', 'setWidth', { 'DILATE_HALF_KERNEL_SIZE' }, value)
          end
        },
        { id = "outline_mult", group = "gfx", basic = true, name = widgetOptionColor .. "   "..texts.option.outline_mult, min = 0.1, max = 1, step = 0.1, type = "slider", value = 0.5, description = texts.option.outline_mult_descr,
          onload = function(i)
              loadWidgetData("Outline", "outline_mult", { 'STRENGTH_MULT' })
          end,
          onchange = function(i, value)
              saveOptionValue('Outline', 'outline', 'setMult', { 'STRENGTH_MULT' }, value)
          end,
        },
        { id = "outline_color", group = "gfx", name = widgetOptionColor .. "   "..texts.option.outline_color, type = "bool", value = false, description = texts.option.outline_color_descr,
          onload = function(i)
              loadWidgetData("Outline", "outline_color", { 'whiteColored' })
          end,
          onchange = function(i, value)
              saveOptionValue('Outline', 'outline', 'setColor', { 'whiteColored' }, value)
          end,
        },

        { id = "bloomdeferred", group = "gfx", basic = true, widget = "Bloom Shader Deferred", name = texts.option.bloomdeferred, type = "bool", value = GetWidgetToggleValue("Bloom Shader Deferred"), description = texts.option.bloomdeferred_descr },
        { id = "bloomdeferredbrightness", group = "gfx", name = widgetOptionColor .. "   "..texts.option.bloomdeferredbrightness, type = "slider", min = 0.5, max = 2, step = 0.05, value = 1, description = '',
          onchange = function(i, value)
              saveOptionValue('Bloom Shader Deferred', 'bloomdeferred', 'setBrightness', { 'glowAmplifier' }, value)
          end,
          onload = function(i)
              loadWidgetData("Bloom Shader Deferred", "bloomdeferredbrightness", { 'glowAmplifier' })
          end,
        },

        { id = "bloom", group = "gfx", basic = true, widget = "Bloom Shader", name = texts.option.bloom, type = "bool", value = GetWidgetToggleValue("Bloom Shader"), description = texts.option.bloom_descr},
        { id = "bloombrightness", group = "gfx", name = widgetOptionColor .. "   "..texts.option.bloombrightness, type = "slider", min = 0.1, max = 0.4, step = 0.05, value = 0.2, description = '',
          onchange = function(i, value)
              saveOptionValue('Bloom Shader', 'bloom', 'setBrightness', { 'basicAlpha' }, value)
          end,
          onload = function(i)
              loadWidgetData("Bloom Shader", "bloombrightness", { 'basicAlpha' })
          end,
        },

        { id = "mapedgeextension", group = "gfx", basic = true, widget = "Map Edge Extension", name = texts.option.mapedgeextension, type = "bool", value = GetWidgetToggleValue("Map Edge Extension"), description = texts.option.mapedgeextension_descr },

        { id = "mapedgeextension_brightness", group = "gfx", name = widgetOptionColor .. "   "..texts.option.mapedgeextension_brightness, min = 0.2, max = 1, step = 0.01, type = "slider", value = 0.3, description = '',
          onload = function(i)
              loadWidgetData("Map Edge Extension", "mapedgeextension_brightness", { 'brightness' })
          end,
          onchange = function(i, value)
              saveOptionValue('Map Edge Extension', 'mapedgeextension', 'setBrightness', { 'brightness' }, value)
          end,
        },
        { id = "mapedgeextension_curvature", group = "gfx", name = widgetOptionColor .. "   "..texts.option.mapedgeextension_curvature, type = "bool", value = true, description = texts.option.mapedgeextension_curvature_descr,
          onload = function(i)
              loadWidgetData("Map Edge Extension", "mapedgeextension_curvature", { 'curvature' })
          end,
          onchange = function(i, value)
              saveOptionValue('Map Edge Extension', 'mapedgeextension', 'setCurvature', { 'curvature' }, value)
          end,
        },

        { id = "water", group = "gfx", basic = true, name = texts.option.water, type = "select", options = { 'basic', 'reflective', 'dynamic', 'reflective&refractive', 'bump-mapped' }, value = desiredWaterValue + 1,
          onload = function(i)
          end,
          onchange = function(i, value)
              desiredWaterValue = value - 1
              if waterDetected then
                  Spring.SendCommands("water " .. desiredWaterValue)
              end
          end,
        },

        { id = "decals", group = "gfx", basic = true, name = texts.option.decals, type = "slider", min = 0, max = 5, step = 1, value = tonumber(Spring.GetConfigInt("GroundDecals", 1) or 1), description = texts.option.decals_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigInt("GroundDecals", value)
              Spring.SendCommands("GroundDecals " .. value)
              Spring.SetConfigInt("GroundScarAlphaFade", 1)
          end,
        },
        { id = "grounddetail", group = "gfx", basic = true, name = texts.option.grounddetail, type = "slider", min = 100, max = 200, step = 1, value = tonumber(Spring.GetConfigInt("GroundDetail", 100) or 100), description = texts.option.grounddetail_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigInt("GroundDetail", value)
              Spring.SendCommands("GroundDetail " .. value)
          end,
        },

        { id = "disticon", group = "gfx", basic = true, name = texts.option.disticon, type = "slider", min = 60, max = 700, step = 10, value = tonumber(Spring.GetConfigInt("UnitIconDist", 1) or 160), description = texts.option.disticon_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SendCommands("disticon " .. value)
              Spring.GetConfigInt("UnitIconDist", value)
          end,
        },
        { id = "iconscale", group = "gfx", basic = true, name = widgetOptionColor .. "   "..texts.option.iconscale, type = "slider", min = 0.85, max = 1.8, step = 0.05, value = tonumber(Spring.GetConfigFloat("UnitIconScale", 1.15) or 1.05), description = texts.option.iconscale_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              if countDownOptionClock and countDownOptionClock < os_clock() then
                  -- else sldier gets too sluggish when constantly updating
                  Spring.SendCommands("luarules uniticonscale " .. value)
                  countDownOptionID = nil
                  countDownOptionClock = nil
              else
                  countDownOptionID = getOptionByID('iconscale')
                  countDownOptionClock = os_clock() + 0.9
              end
          end,
        },

        { id = "featuredrawdist", group = "gfx", name = texts.option.featuredrawdist, type = "slider", min = 2500, max = 15000, step = 500, value = tonumber(Spring.GetConfigInt("FeatureDrawDistance", 999999)), description = texts.option.featuredrawdist_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              --if getOptionByID('featurefadedist') and value < options[getOptionByID('featurefadedist')].value then
              --	  options[getOptionByID('featurefadedist')].value = value
              --	  Spring.SetConfigInt("FeatureFadeDistance", value)
              --end
              Spring.SetConfigInt("FeatureFadeDistance", math.floor(value*0.8))
              Spring.SetConfigInt("FeatureDrawDistance", value)
          end,
        },
        --{id="featurefadedist", group="gfx", name=widgetOptionColor.."   fade distance", type="slider", min=2500, max=15000, step=500, value=tonumber(Spring.GetConfigInt("FeatureFadeDistance",4500) or 400), description='Features (trees, stones, wreckage) start fading away from this distance',
        --	onload = function(i) end,
        --	onchange = function(i, value)
        --		if getOptionByID('featuredrawdist') and value > options[getOptionByID('featuredrawdist')].value then
        --			options[getOptionByID('featuredrawdist')].value = value
        --			Spring.SetConfigInt("FeatureDrawDistance",value)
        --		end
        --		Spring.SetConfigInt("FeatureFadeDistance",value)
        --	end,
        --},

        { id = "particles", group = "gfx", basic = true, name = texts.option.particles, type = "slider", min = 10000, max = 40000, step = 1000, value = tonumber(Spring.GetConfigInt("MaxParticles", 1) or 15000), description = texts.option.particles_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigInt("MaxParticles", value)
          end,
        },

        { id = "lighteffects", group = "gfx", basic = true, name = texts.option.lighteffects, type = "bool", value = GetWidgetToggleValue("Light Effects"), description = texts.option.lighteffects_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              if value then
                  if widgetHandler.orderList["Deferred rendering"] ~= nil then
                      widgetHandler:EnableWidget("Deferred rendering")
                  end
                  widgetHandler:EnableWidget("Light Effects")
              else
                  if widgetHandler.orderList["Deferred rendering"] ~= nil then
                      widgetHandler:DisableWidget("Deferred rendering")
                  end
                  widgetHandler:DisableWidget("Light Effects")
              end
          end,
        },
        { id = "lighteffects_life", group = "gfx", name = widgetOptionColor .. "   "..texts.option.lighteffects_life, min = 0.4, max = 0.9, step = 0.05, type = "slider", value = 0.75, description = texts.option.lighteffects_life_descr,
          onload = function(i)
              loadWidgetData("Light Effects", "lighteffects_life", { 'globalLifeMult' })
          end,
          onchange = function(i, value)
              saveOptionValue('Light Effects', 'lighteffects', 'setLife', { 'globalLifeMult' }, value)
          end,
        },
        { id = "lighteffects_brightness", group = "gfx", name = widgetOptionColor .. "   "..texts.option.lighteffects_brightness, min = 0.8, max = 2, step = 0.1, type = "slider", value = 1.3, description = texts.option.lighteffects_brightness_descr,
          onload = function(i)
              loadWidgetData("Light Effects", "lighteffects_brightness", { 'globalLightMult' })
          end,
          onchange = function(i, value)
              saveOptionValue('Light Effects', 'lighteffects', 'setGlobalBrightness', { 'globalLightMult' }, value)
          end,
        },
        { id = "lighteffects_radius", group = "gfx", name = widgetOptionColor .. "   "..texts.option.lighteffects_radius, min = 1, max = 1.6, step = 0.1, type = "slider", value = 1.3, description = texts.option.lighteffects_radius_descr,
          onload = function(i)
              loadWidgetData("Light Effects", "lighteffects_radius", { 'globalRadiusMult' })
          end,
          onchange = function(i, value)
              saveOptionValue('Light Effects', 'lighteffects', 'setGlobalRadius', { 'globalRadiusMult' }, value)
          end,
        },
        --{id="lighteffects_laserbrightness", group="gfx", name=widgetOptionColor.."   laser brightness", min=0.4, max=2, step=0.1, type="slider", value=1.2, description='laser lights brightness RELATIVE to global light brightness set above\n\n(only applies to real map and model lighting)',
        --		 onload = function(i) loadWidgetData("Light Effects", "lighteffects_laserbrightness", {'globalLightMultLaser'}) end,
        --		 onchange = function(i, value) saveOptionValue('Light Effects', 'lighteffects', 'setLaserBrightness', {'globalLightMultLaser'}, value) end,
        --		},
        --{id="lighteffects_laserradius", group="gfx", name=widgetOptionColor.."   laser radius", min=0.5, max=1.6, step=0.1, type="slider", value=1, description='laser lights radius RELATIVE to global light radius set above\n\n(only applies to real map and model lighting)',
        --		 onload = function(i) loadWidgetData("Light Effects", "lighteffects_laserradius", {'globalRadiusMultLaser'}) end,
        --		 onchange = function(i, value) saveOptionValue('Light Effects', 'lighteffects', 'setLaserRadius', {'globalRadiusMultLaser'}, value) end,
        --		},

        { id = "dof", group = "gfx", widget = "Depth of Field", name = texts.option.dof, type = "bool", value = GetWidgetToggleValue("Depth of Field"), description = texts.option.dof_descr },
        { id = "dof_autofocus", group = "gfx", name = widgetOptionColor .. "   "..texts.option.dof_autofocus, type = "bool", value = true, description = texts.option.dof_autofocus_descr,
          onload = function(i)
              loadWidgetData("Depth of Field", "dof_autofocus", { 'autofocus' })
          end,
          onchange = function(i, value)
              saveOptionValue('Depth of Field', 'dof', 'setAutofocus', { 'autofocus' }, value)
          end,
        },
        { id = "dof_fstop", group = "gfx", name = widgetOptionColor .. "   "..texts.option.dof_fstop, type = "slider", min = 1, max = 6, step = 0.1, value = 2, description = texts.option.dof_fstop_descr,
          onload = function(i)
              loadWidgetData("Depth of Field", "dof_fstop", { 'fStop' })
          end,
          onchange = function(i, value)
              saveOptionValue('Depth of Field', 'dof', 'setFstop', { 'fStop' }, value)
          end,
        },

        --{id="nanoeffect", group="gfx", name="Nano effect", type="select", options={'beam','particles'}, value=tonumber(Spring.GetConfigInt("NanoEffect",1) or 1), description='Sets nano effect\n\nBeams more expensive than particles',
        -- onload = function(i) end,
        -- onchange = function(i, value)
        --	 Spring.SetConfigInt("NanoEffect",value)
        --	 if value == 1 then
        --		 Spring.SetConfigInt("MaxNanoParticles",0)
        --	 else
        --		 Spring.SetConfigInt("MaxNanoParticles",maxNanoParticles)
        --	 end
        -- end,
        --},
        --{id="lighteffects_nanolaser", group="gfx", name=widgetOptionColor.."   beam light  (needs 'Lights')", type="bool", value=true, description='Shows a light for every build/reclaim nanolaser',
        --		 onload = function(i) loadWidgetData("Light Effects", "lighteffects_nanolaser", {'enableNanolaser'}) end,
        --		 onchange = function(i, value) saveOptionValue('Light Effects', 'lighteffects', 'setNanolaser', {'enableNanolaser'}, value) end,
        --		},
        --{id="nanobeamicon", group="gfx", name=widgetOptionColor.."   beam when uniticon", type="bool", value=tonumber(Spring.GetConfigInt("NanoLaserIcon",0) or 0) == 1, description='Shows nano beams when unit is displayed as icon',
        --		 onload = function(i) end,
        --		 onchange = function(i, value) Spring.SendCommands("luarules uniticonlasers "..value) end,
        --		},
        --{id="nanobeamamount", group="gfx", name=widgetOptionColor.."   beam amount", type="slider", min=6, max=40, step=1, value=tonumber(Spring.GetConfigInt("NanoBeamAmount",10) or 10), description='Not number of total beams (but total of new beams per gameframe)\n\nBeams aren\'t cheap so lower this setting for better performance',
        -- onload = function(i) end,
        -- onchange = function(i, value) Spring.SetConfigInt("NanoBeamAmount",value) end,
        --},
        { id = "nanoparticles", group = "gfx", name = texts.option.nanoparticles, type = "slider", min = 3000, max = 20000, step = 1000, value = maxNanoParticles, description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              maxNanoParticles = value
              if not options[getOptionByID('nanoeffect')] or options[getOptionByID('nanoeffect')].value == 2 then
                  Spring.SetConfigInt("MaxNanoParticles", value)
              end
          end,
        },
        { id = "airjets", group = "gfx", widget = "Airjets", name = texts.option.airjets, type = "bool", value = GetWidgetToggleValue("Airjets"), description = texts.option.airjets_descr },
        { id = "jetenginefx_lights", group = "gfx", name = widgetOptionColor .. "   "..texts.option.jetenginefx_lights, type = "bool", value = true, description = texts.option.jetenginefx_lights_descr,
          onload = function(i)
              loadWidgetData("Light Effects", "lups_jetenginefx_lights", { 'enableThrusters' })
          end,
          onchange = function(i, value)
              saveOptionValue('Light Effects', 'lighteffects', 'setThrusters', { 'enableThrusters' }, value)
          end,
        },
        { id = "airjets_limitfps", group = "gfx", name = widgetOptionColor .. "   "..texts.option.airjets_limitfps, type = "slider", min = 5, max = 30, step = 1, value = 22, description = texts.option.airjets_limitfps_descr,
          onload = function(i)
              loadWidgetData("Airjets", "airjets_limitfps", { 'limitAtAvgFps' })
          end,
          onchange = function(i, value)
              if value - 5 <= options[getOptionByID('airjets_disablefps')].value then
                  options[getOptionByID('airjets_disablefps')].value = value - 6
                  applyOptionValue(getOptionByID('airjets_disablefps'))
              end
              saveOptionValue('Airjets', 'airjets', 'setLimitFps', { 'limitAtAvgFps' }, value)
          end,
        },
        { id = "airjets_disablefps", group = "gfx", name = widgetOptionColor .. "   "..texts.option.airjets_disablefps, type = "slider", min = 0, max = 15, step = 1, value = 11, description = texts.option.airjets_disablefps_descr,
          onload = function(i)
              loadWidgetData("Airjets", "airjets_disablefps", { 'disableAtAvgFps' })
          end,
          onchange = function(i, value)
              if value + 5 >= options[getOptionByID('airjets_limitfps')].value then
                  options[getOptionByID('airjets_limitfps')].value = value + 6
                  applyOptionValue(getOptionByID('airjets_limitfps'))
              end
              saveOptionValue('Airjets', 'airjets', 'setDisableFps', { 'disableAtAvgFps' }, value)
          end,
        },

        --{id="treeradius", group="gfx", name="Tree render distance", type="slider", min=0, max=2000, step=50, restart=true, value=tonumber(Spring.GetConfigInt("TreeRadius",1) or 1000), description='Applies to SpringRTS engine default trees\n\nChanges will be applied next game',
        --		 onload = function(i) end,
        --		 onchange = function(i, value) Spring.SetConfigInt("TreeRadius",value) end,
        --		},
        {id="treewind", group="gfx", basic=true, name=texts.option.treewind, type="bool", value=tonumber(Spring.GetConfigInt("TreeWind",1) or 1) == 1, description = texts.option.treewind_descr,
         onload = function(i) end,
         onchange = function(i, value)
             Spring.SendCommands("luarules treewind "..(value and 1 or 0))
             Spring.SetConfigInt("TreeWind",(value and 1 or 0))
         end,
        },
        { id = "heatdistortion", group = "gfx", basic = true, widget = "Lups", name = texts.option.heatdistortion, type = "bool", value = GetWidgetToggleValue("Lups"), description = texts.option.heatdistortion_descr },

        { id = "clouds", group = "gfx", basic = true, widget = "Volumetric Clouds", name = texts.option.clouds, type = "bool", value = GetWidgetToggleValue("Volumetric Clouds"), description = '' },
        { id = "clouds_opacity", group = "gfx", name = widgetOptionColor .. "   "..texts.option.clouds_opacity, type = "slider", min = 0.2, max = 1.4, step = 0.05, value = 1, description = '',
          onload = function(i)
              loadWidgetData("Volumetric Clouds", "clouds_opacity", { 'opacityMult' })
          end,
          onchange = function(i, value)
              saveOptionValue('Volumetric Clouds', 'clouds', 'setOpacity', { 'opacityMult' }, value)
          end,
        },

        { id = "snow", group = "gfx", basic = true, widget = "Snow", name = texts.option.snow, type = "bool", value = GetWidgetToggleValue("Snow"), description = texts.option.snow_descr },
        { id = "snowmap", group = "gfx", name = widgetOptionColor .. "   "..texts.option.snowmap, type = "bool", value = true, description = texts.option.snowmap_descr,
          onload = function(i)
              loadWidgetData("Snow", "snowmap", { 'snowMaps', Game.mapName:lower() })
          end,
          onchange = function(i, value)
              saveOptionValue('Snow', 'snow', 'setSnowMap', { 'snowMaps', Game.mapName:lower() }, value)
          end,
        },
        { id = "snowautoreduce", group = "gfx", name = widgetOptionColor .. "   "..texts.option.snowautoreduce, type = "bool", value = true, description = texts.option.snowautoreduce_descr,
          onload = function(i)
              loadWidgetData("Snow", "snowautoreduce", { 'autoReduce' })
          end,
          onchange = function(i, value)
              saveOptionValue('Snow', 'snow', 'setAutoReduce', { 'autoReduce' }, value)
          end,
        },
        { id = "snowamount", group = "gfx", name = widgetOptionColor .. "   "..texts.option.snowamount, type = "slider", min = 0.2, max = 3, step = 0.2, value = 1, description = texts.option.snowamount_descr,
          onload = function(i)
              loadWidgetData("Snow", "snowamount", { 'customParticleMultiplier' })
          end,
          onchange = function(i, value)
              saveOptionValue('Snow', 'snow', 'setMultiplier', { 'customParticleMultiplier' }, value)
          end,
        },

        { id = "resurrectionhalos", group = "gfx", widget = "Resurrection Halos", name = texts.option.resurrectionhalos, type = "bool", value = GetWidgetToggleValue("Resurrection Halos"), description = texts.option.resurrectionhalos_descr },
        { id = "tombstones", group = "gfx", widget = "Tombstones", name = texts.option.tombstones, type = "bool", value = GetWidgetToggleValue("Tombstones"), description = texts.option.tombstones_descr },

        -- SND
        { id = "snddevice", group = "snd", name = texts.option.snddevice, type = "select", restart = true, options = soundDevices, value = soundDevicesByName[Spring.GetConfigString("snd_device")], description = texts.option.snddevice_descr,
          onchange = function(i, value)
              if options[i].options[options[i].value] == 'default' then
                  Spring.SetConfigString("snd_device", '')
              else
                  Spring.SetConfigString("snd_device", options[i].options[options[i].value])
              end
          end,
        },
        { id = "sndvolmaster", group = "snd", basic = true, name = texts.option.sndvolmaster, type = "slider", min = 0, max = 200, step = 2, value = tonumber(Spring.GetConfigInt("snd_volmaster", 1) or 100),
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigInt("snd_volmaster", value)
          end,
        },
        { id = "sndvolgeneral", group = "snd", basic = true, name = widgetOptionColor .. "   "..texts.option.sndvolgeneral, type = "slider", min = 0, max = 100, step = 2, value = tonumber(Spring.GetConfigInt("snd_volgeneral", 1) or 100),
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigInt("snd_volgeneral", value)
          end,
        },
        { id = "sndvolbattle", group = "snd", basic = true, name = widgetOptionColor .. "   "..texts.option.sndvolbattle, type = "slider", min = 0, max = 100, step = 2, value = tonumber(Spring.GetConfigInt("snd_volbattle", 1) or 100),
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigInt("snd_volbattle", value)
          end,
        },
        { id = "sndvolui", group = "snd", basic = true, name = widgetOptionColor .. "   "..texts.option.sndvolui, type = "slider", min = 0, max = 100, step = 2, value = tonumber(Spring.GetConfigInt("snd_volui", 1) or 100),
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigInt("snd_volui", value)
          end,
        },
        { id = "sndvolunitreply", group = "snd", basic = true, name = widgetOptionColor .. "   "..texts.option.sndvolunitreply, type = "slider", min = 0, max = 100, step = 2, value = tonumber(Spring.GetConfigInt("snd_volunitreply", 1) or 100),
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigInt("snd_volunitreply", value)
          end,
        },
        { id = "sndairabsorption", group = "snd", name = texts.option.sndairabsorption, type = "slider", min = 0.05, max = 0.4, step = 0.01, value = tonumber(Spring.GetConfigFloat("snd_airAbsorption", .35) or .35), description = texts.option.sndairabsorption_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigFloat("snd_airAbsorption", value)
          end,
        },

        { id = "sndvolmusic", group = "snd", basic = true, name = texts.option.sndvolmusic, type = "slider", min = 0, max = 50, step = 1, value = tonumber(Spring.GetConfigInt("snd_volmusic", 20) or 20),
          onload = function(i)
          end,
          onchange = function(i, value)
              if WG['music'] and WG['music'].SetMusicVolume then
                  WG['music'].SetMusicVolume(value)
              else
                  Spring.SetConfigInt("snd_volmusic", value)
              end
          end,
        },
        { id = "loadscreen_music", group = "snd", basic = true, name = widgetOptionColor.."   "..texts.option.loadscreen_music, type = "bool", value = (Spring.GetConfigInt("music_loadscreen",1) == 1), description = texts.option.loadscreen_music_descr,
          onchange = function(i, value)
              Spring.SetConfigInt("music_loadscreen", (value and 1 or 0))
          end,
        },

        { id = "scav_messages", group = "notif", basic = true, name = texts.option.scav_messages, type = "bool", value = tonumber(Spring.GetConfigInt("scavmessages", 1) or 1) == 1, description = "",
          onchange = function(i, value)
              Spring.SetConfigInt("scavmessages", (value and 1 or 0))
          end,
        },
        { id = "scav_voicenotifs", group = "notif", basic = true, widget = "Scavenger Audio Reciever", name = texts.option.scav_voicenotifs, type = "bool", value = GetWidgetToggleValue("Scavenger Audio Reciever"), description = texts.option.scav_voicenotifs_descr },

        { id = "notifications_tutorial", group = "notif", name = texts.option.notifications_tutorial, basic = true, type = "bool", value = (WG['notifications'] ~= nil and WG['notifications'].getTutorial()), description = texts.option.notifications_tutorial_desc,
          onload = function(i)
              loadWidgetData("Notifications", "notifications_tutorial", { 'tutorialMode' })
          end,
          onchange = function(i, value)
              saveOptionValue('Notifications', 'notifications', 'setTutorial', { 'tutorialMode' }, value)
          end,
        },
        { id = "notifications_messages", group = "notif", name = texts.option.notifications_messages, basic = true, type = "bool", value = (WG['notifications'] ~= nil and WG['notifications'].getMessages()), description = texts.option.notifications_messages_descr,
          onload = function(i)
              loadWidgetData("Notifications", "notifications_messages", { 'displayMessages' })
          end,
          onchange = function(i, value)
              saveOptionValue('Notifications', 'notifications', 'setMessages', { 'displayMessages' }, value)
          end,
        },
        { id = "notifications_spoken", group = "notif", name = texts.option.notifications_spoken, basic = true, type = "bool", value = (WG['notifications'] ~= nil and WG['notifications'].getSpoken()), description = texts.option.notifications_spoken_descr,
          onload = function(i)
              loadWidgetData("Notifications", "notifications_spoken", { 'spoken' })
          end,
          onchange = function(i, value)
              saveOptionValue('Notifications', 'notifications', 'setSpoken', { 'spoken' }, value)
          end,
        },
        { id = "notifications_volume", group = "notif", basic = true, name = texts.option.notifications_volume, type = "slider", min = 0.05, max = 1, step = 0.05, value = 1, description = texts.option.notifications_volume_descr,
          onload = function(i)
              loadWidgetData("Notifications", "notifications_volume", { 'volume' })
          end,
          onchange = function(i, value)
              saveOptionValue('Notifications', 'notifications', 'setVolume', { 'volume' }, value)
          end,
        },
        { id = "notifications_playtrackedplayernotifs", basic = true, group = "notif", name = texts.option.notifications_playtrackedplayernotifs, type = "bool", value = (WG['notifications'] ~= nil and WG['notifications'].getPlayTrackedPlayerNotifs()), description = texts.option.notifications_playtrackedplayernotifs_descr,
          onload = function(i)
              loadWidgetData("Notifications", "notifications_playtrackedplayernotifs", { 'playTrackedPlayerNotifs' })
          end,
          onchange = function(i, value)
              saveOptionValue('Notifications', 'notifications', 'setPlayTrackedPlayerNotifs', { 'playTrackedPlayerNotifs' }, value)
          end,
        },

        -- CONTROL
        { id = "hwcursor", group = "control", basic = true, name = texts.option.hwcursor, type = "bool", value = tonumber(Spring.GetConfigInt("hardwareCursor", 1) or 1) == 1, description = texts.option.hwcursor_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SendCommands("HardwareCursor " .. (value and 1 or 0))
              Spring.SetConfigInt("HardwareCursor", (value and 1 or 0))
          end,
        },
        --{id="cursor", group="control", basic=true, name="Cursor", type="select", options={}, value=1, description='Choose a different mouse cursor style and/or size',
        -- onchange=function(i, value)
        --	 saveOptionValue('Cursors', 'cursors', 'setcursor', {'cursorSet'}, options[i].options[value])
        -- end,
        --},
        { id = "cursorsize", group = "control", basic = true, name = texts.option.cursorsize, type = "slider", min = 0.3, max = 1.7, step = 0.1, value = 1, description = texts.option.cursorsize_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              if WG['cursors'] then
                  WG['cursors'].setsizemult(value)
              end
          end,
        },
        --{ id = "crossalpha", group = "control", name = texts.option.crossalpha, type = "slider", min = 0, max = 1, step = 0.05, value = tonumber(Spring.GetConfigFloat("CrossAlpha", 0.5) or 1), description = texts.option.crossalpha_descr,
        --  onload = function(i)
        --  end,
        --  onchange = function(i, value)
        --	  Spring.SendCommands("cross " .. tonumber(Spring.GetConfigInt("CrossSize", 1) or 10) .. " " .. value)
        --  end,
        --},
        { id = "middleclicktoggle", group = "control", basic = true, name = texts.option.middleclicktoggle, type = "bool", value = (Spring.GetConfigFloat("MouseDragScrollThreshold", 0.3) ~= 0), description = texts.option.middleclicktoggle_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigFloat("MouseDragScrollThreshold", (value and 0.3 or 0))
          end,
        },

        { id = "containmouse", group = "control", basic = true, widget = "Grabinput", name = texts.option.containmouse, type = "bool", value = GetWidgetToggleValue("Grabinput"), description = texts.option.containmouse_descr },

        { id = "screenedgemove", group = "control", basic = true, name = texts.option.screenedgemove, type = "bool", restart = true, value = tonumber(Spring.GetConfigInt("FullscreenEdgeMove", 1) or 1) == 1, description = texts.option.screenedgemove_descr,
          onchange = function(i, value)
              Spring.SetConfigInt("FullscreenEdgeMove", (value and 1 or 0))
              Spring.SetConfigInt("WindowedEdgeMove", (value and 1 or 0))
          end,
        },
        { id = "screenedgemovewidth", group = "control", basic = true, name = widgetOptionColor .. "   "..texts.option.screenedgemovewidth, type = "slider", min = 0, max = 0.1, step = 0.01, value = tonumber(Spring.GetConfigFloat("EdgeMoveWidth", 1) or 0.02), description = texts.option.screenedgemovewidth_descr,
          onchange = function(i, value)
              Spring.SetConfigFloat("EdgeMoveWidth", value)
          end,
        },
        { id = "screenedgemovedynamic", group = "control", name = widgetOptionColor .. "   "..texts.option.screenedgemovedynamic, type = "bool", restart = true, value = tonumber(Spring.GetConfigInt("EdgeMoveDynamic", 1) or 1) == 1, description = texts.option.screenedgemovedynamic_descr,
          onchange = function(i, value)
              Spring.SetConfigInt("EdgeMoveDynamic", (value and 1 or 0))
          end,
        },

        { id = "camera", group = "control", basic = true, name = texts.option.camera, type = "select", options = { 'fps', 'overhead', 'spring', 'rot overhead', 'free' }, value = (tonumber((Spring.GetConfigInt("CamMode", 1) + 1) or 2)),
          onchange = function(i, value)
              Spring.SetConfigInt("CamMode", (value - 1))
              if value == 1 then
                  Spring.SendCommands('viewfps')
              elseif value == 2 then
                  Spring.SendCommands('viewta')
              elseif value == 3 then
                  Spring.SendCommands('viewspring')
              elseif value == 4 then
                  Spring.SendCommands('viewrot')
              elseif value == 5 then
                  Spring.SendCommands('viewfree')
              end
          end,
        },
        { id = "camerashake", group = "control", name = widgetOptionColor .. "   "..texts.option.camerashake, type = "slider", min = 0, max = 200, step = 10, value = 80, description = texts.option.camerashake_descr,
          onload = function(i)
              loadWidgetData("CameraShake", "camerashake", { 'powerScale' })
              if options[i].value > 0 then
                  --widgetHandler:EnableWidget("CameraShake") --TODO: Set this properly
              end
          end,
          onchange = function(i, value)
              saveOptionValue('CameraShake', 'camerashake', 'setStrength', { 'powerScale' }, value)
              if value > 0 then
                  --widgetHandler:EnableWidget("CameraShake")
              end
          end,
        },
        { id = "camerasmoothness", group = "control", name = widgetOptionColor .. "   "..texts.option.camerasmoothness, type = "slider", min = 0.04, max = 2, step = 0.01, value = cameraTransitionTime, description = texts.option.camerasmoothness_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              cameraTransitionTime = value
              --Spring.SetConfigFloat("CamTimeFactor", value)
          end,
        },
        { id = "camerapanspeed", group = "control", basic = true, name = widgetOptionColor .. "   "..texts.option.camerapanspeed, type = "slider", min = -0.01, max = -0.00195, step = 0.0001, value = Spring.GetConfigFloat("MiddleClickScrollSpeed", 0.0035), description = texts.option.camerapanspeed_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigFloat("MiddleClickScrollSpeed", value)
          end,
        },
        { id = "cameramovespeed", group = "control", basic = true, name = widgetOptionColor .. "   "..texts.option.cameramovespeed, type = "slider", min = 0, max = 50, step = 1, value = Spring.GetConfigInt("CamSpringScrollSpeed", 10), description = texts.option.cameramovespeed_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              --cameraPanTransitionTime = value
              Spring.SetConfigInt("FPSScrollSpeed", value)            -- spring default: 10
              Spring.SetConfigInt("OverheadScrollSpeed", value)        -- spring default: 10
              Spring.SetConfigInt("RotOverheadScrollSpeed", value)    -- spring default: 10
              Spring.SetConfigFloat("CamFreeScrollSpeed", value * 50)    -- spring default: 500
              Spring.SetConfigInt("CamSpringScrollSpeed", value)        -- spring default: 10
          end,
        },
        { id = "scrollspeed", group = "control", basic = true, name = widgetOptionColor .. "   "..texts.option.scrollspeed, type = "slider", min = 1, max = 50, step = 1, value = math.abs(tonumber(Spring.GetConfigInt("ScrollWheelSpeed", 1) or 25)), description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              if options[getOptionByID('scrollinverse')].value then
                  Spring.SetConfigInt("ScrollWheelSpeed", -value)
              else
                  Spring.SetConfigInt("ScrollWheelSpeed", value)
              end
          end,
        },
        { id = "scrollinverse", group = "control", basic = true, name = widgetOptionColor .. "   "..texts.option.scrollinverse, type = "bool", value = (tonumber(Spring.GetConfigInt("ScrollWheelSpeed", 1) or 25) < 0), description = "",
          onload = function(i)
          end,
          onchange = function(i, value)
              if value then
                  Spring.SetConfigInt("ScrollWheelSpeed", -options[getOptionByID('scrollspeed')].value)
              else
                  Spring.SetConfigInt("ScrollWheelSpeed", options[getOptionByID('scrollspeed')].value)
              end
          end,
        },

        --{id="fov", group="control", name=widgetOptionColor.."   FOV", type="slider", min=15, max=75, step=1, value=Spring.GetCameraFOV(), description="Camera field of view\n\nDefault: 45",
        -- onload = function(i) end,
        -- onchange = function(i, value)
        --	local current_cam_state = Spring.GetCameraState()
        --	if (current_cam_state.fov) then
        --		current_cam_state.fov = value
        --		Spring.SetCameraState(current_cam_state,0)
        --	end
        -- end,
        --},

        { id = "lockcamera_transitiontime", group = "control", name = texts.option.lockcamera_transitiontime, type = "slider", min = 0.4, max = 1.5, step = 0.01, value = (WG['advplayerlist_api'] ~= nil and WG['advplayerlist_api'].GetLockTransitionTime ~= nil and WG['advplayerlist_api'].GetLockTransitionTime()), description = texts.option.lockcamera_transitiontime_descr,
          onload = function(i)
              loadWidgetData("AdvPlayersList", "lockcamera_transitiontime", { 'transitionTime' })
          end,
          onchange = function(i, value)
              saveOptionValue('AdvPlayersList', 'advplayerlist_api', 'SetLockTransitionTime', { 'transitionTime' }, value)
          end,
        },

        -- INTERFACE
        --{ id = "tweakui", group = "ui", name = "Toggle tweak UI mode", type = "bool", value = false, description = 'Some UI elements have legacy/additional settings available\n\n(ESC to cancel)',
        --  onchange = function(i, value)
        --	  if widgetHandler.tweakMode then
        --		  -- cancel with ESC
        --	  else
        --		  Spring.SendCommands("luaui tweakgui")
        --	  end
        --  end,
        --},
        { id = "uiscale", group = "ui", basic = true, name = texts.option.interface.. widgetOptionColor .. "  "..texts.option.uiscale, type = "slider", min = 0.8, max = 1.1, step = 0.01, value = Spring.GetConfigFloat("ui_scale", 1), description = '',
          onload = function(i)
          end,
          onchange = function(i, value, force)
              if force then
                  Spring.SetConfigFloat("ui_scale", value)
                  Spring.SendCommands("luarules reloadluaui")
              else
                  sceduleOptionApply = {os.clock()+1.5, getOptionByID('uiscale')}
              end
          end,
        },
        { id = "guiopacity", group = "ui", name = widgetOptionColor .. "   "..texts.option.guiopacity, type = "slider", min = 0.3, max = 1, step = 0.01, value = Spring.GetConfigFloat("ui_opacity", 0.6), description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigFloat("ui_opacity", value)
          end,
        },
        { id = "guitilescale", group = "ui", name = widgetOptionColor .. "   "..texts.option.guitilescale, type = "slider", min = 4, max = 40, step = 1, value = Spring.GetConfigFloat("ui_tilescale", 7), description = '',
          onload = function(i)
          end,
          onchange = function(i, value, force)
              if force then
                  Spring.SetConfigFloat("ui_tilescale", value)
                  Spring.SendCommands("luarules reloadluaui")
              else
                  sceduleOptionApply = {os.clock()+1.5, getOptionByID('guitilescale')}
              end
          end,
        },
        { id = "guitileopacity", group = "ui", basic = true, name = widgetOptionColor .. "      "..texts.option.guitileopacity, type = "slider", min = 0, max = 0.03, step = 0.001, value = Spring.GetConfigFloat("ui_tileopacity", 0.011), description = '',
          onload = function(i)
          end,
          onchange = function(i, value, force)
              if force then
                  Spring.SetConfigFloat("ui_tileopacity", value)
                  Spring.SendCommands("luarules reloadluaui")
              else
                  sceduleOptionApply = {os.clock()+1.5, getOptionByID('guitileopacity')}
              end
          end,
        },

        { id = "guishader", group = "ui", basic = true, widget = "GUI Shader", name = widgetOptionColor .. "   "..texts.option.guishader, type = "bool", value = GetWidgetToggleValue("GUI Shader"), description = texts.option.guishader_descr },
        { id = "guishaderintensity", group = "ui", name = widgetOptionColor .. "   "..texts.option.guishaderintensity, type = "slider", min = 0.001, max = 0.005, step = 0.0001, value = 0.0035, description = '',
          onload = function(i)
              loadWidgetData("GUI Shader", "guishaderintensity", { 'blurIntensity' })
          end,
          onchange = function(i, value)
              saveOptionValue('GUI Shader', 'guishader', 'setBlurIntensity', { 'blurIntensity' }, value)
          end,
        },

        { id = "font", group = "ui", name = widgetOptionColor .. "   "..texts.option.font, type = "select", options = {}, value = 1, description = texts.option.font_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              if VFS.FileExists('fonts/' .. options[i].optionsFont[value]) then
                  Spring.SetConfigString("bar_font", options[i].optionsFont[value])
                  Spring.SendCommands("luarules reloadluaui")
              end
          end,
        },
        { id = "font2", group = "ui", name = widgetOptionColor .. "   "..texts.option.font2, type = "select", options = {}, value = 1, description = texts.option.font2_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              if VFS.FileExists('fonts/' .. options[i].optionsFont[value]) then
                  Spring.SetConfigString("bar_font2", options[i].optionsFont[value])
                  Spring.SendCommands("luarules reloadluaui")
              end
          end,
        },


        { id = "teamcolors", group = "ui", basic = true, widget = "Player Color Palette", name = texts.option.teamcolors, type = "bool", value = GetWidgetToggleValue("Player Color Palette"), description = texts.option.teamcolors_descr },
        { id = "sameteamcolors", group = "ui", basic = true, name = widgetOptionColor .. "   "..texts.option.sameteamcolors, type = "bool", value = (WG['playercolorpalette'] ~= nil and WG['playercolorpalette'].getSameTeamColors ~= nil and WG['playercolorpalette'].getSameTeamColors()), description = texts.option.sameteamcolors_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Player Color Palette', 'playercolorpalette', 'setSameTeamColors', { 'useSameTeamColors' }, value)
          end,
        },

        { id = "minimap_enlarged", group = "ui", basic = true, name = texts.option.minimap..widgetOptionColor.."  "..texts.option.minimap_enlarged, type = "bool", value = false, description = texts.option.minimap_enlarged_descr,
          onload = function(i)
              loadWidgetData("Minimap", "minimap_enlarged", { 'enlarged' })
          end,
          onchange = function(i, value)
              saveOptionValue('Minimap', 'minimap', 'setEnlarged', { 'enlarged' }, value)
          end,
        },
        { id = "simpleminimapcolors", group = "ui", name = widgetOptionColor .. "   "..texts.option.simpleminimapcolors, type = "bool", value = tonumber(Spring.GetConfigInt("SimpleMiniMapColors", 0) or 0) == 1, description = texts.option.simpleminimapcolors_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SendCommands("minimap simplecolors  " .. (value and 1 or 0))
              Spring.SetConfigInt("SimpleMiniMapColors", (value and 1 or 0))
          end,
        },
        { id = "minimapiconsize", group = "ui", name = widgetOptionColor .. "   "..texts.option.minimapiconsize, type = "slider", min = 2, max = 5, step = 0.25, value = tonumber(Spring.GetConfigFloat("MinimapIconScale", 3.5) or 1), description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigFloat("MinimapIconScale", value)
              Spring.SendCommands("minimap unitsize " .. value)        -- spring wont remember what you set with '/minimap iconssize #'
          end,
        },

        --{id="los_opacity", group="ui", basic=true, name="LoS"..widgetOptionColor.."  opacity", type="slider", min=0.3, max=1.5, step=0.01, value=1, description='Line-of-Sight opacity',
        -- onload = function(i) loadWidgetData("LOS colors", "los_opacity", {'opacity'}) end,
        -- onchange = function(i, value) saveOptionValue('LOS colors', 'los', 'setOpacity', {'opacity'}, value) end,
        --},
        --{id="los_colorize", group="ui", basic=true, name=widgetOptionColor.."   colorize", type="bool", value=(WG['los']~=nil and WG['los'].getColorize~=nil and WG['los'].getColorize()), description='',
        -- onload = function(i) end,
        -- onchange = function(i, value) saveOptionValue('LOS colors', 'los', 'setColorize', {'colorize'}, value) end,
        --},

        { id = "buildmenu_makefancy", group = "ui", basic = true, name = texts.option.buildmenu .. widgetOptionColor .. "  "..texts.option.buildmenu_makefancy, type = "bool", value = (WG['buildmenu'] ~= nil and WG['buildmenu'].getMakeFancy ~= nil and WG['buildmenu'].getMakeFancy()), description = texts.option.buildmenu_makefancy_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Build menu', 'buildmenu', 'setMakeFancy', { 'showMakeFancy' }, value)
          end,
        },
        { id = "buildmenu_bottom", group = "ui", basic = true, name = widgetOptionColor .. "   "..texts.option.buildmenu_bottom, type = "bool", value = (WG['buildmenu'] ~= nil and WG['buildmenu'].getBottomPosition ~= nil and WG['buildmenu'].getBottomPosition()), description = texts.option.buildmenu_bottom_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Build menu', 'buildmenu', 'setBottomPosition', { 'stickToBottom' }, value)
          end,
        },
        { id = "buildmenu_alwaysshow", group = "ui", basic = true, name = widgetOptionColor .. "   "..texts.option.buildmenu_alwaysshow, type = "bool", value = (WG['buildmenu'] ~= nil and WG['buildmenu'].getAlwaysShow ~= nil and WG['buildmenu'].getAlwaysShow()), description = texts.option.buildmenu_alwaysshow_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Build menu', 'buildmenu', 'setAlwaysShow', { 'alwaysShow' }, value)
          end,
        },
        { id = "buildmenu_prices", group = "ui", basic = true, name = widgetOptionColor .. "   "..texts.option.buildmenu_prices, type = "bool", value = (WG['buildmenu'] ~= nil and WG['buildmenu'].getShowPrice ~= nil and WG['buildmenu'].getShowPrice()), description = texts.option.buildmenu_prices_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Build menu', 'buildmenu', 'setShowPrice', { 'showPrice' }, value)
          end,
        },
        { id = "buildmenu_groupicon", group = "ui", basic = true, name = widgetOptionColor .. "   "..texts.option.buildmenu_groupicon, type = "bool", value = (WG['buildmenu'] ~= nil and WG['buildmenu'].getShowGroupIcon ~= nil and WG['buildmenu'].getShowGroupIcon()), description = texts.option.buildmenu_groupicon_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Build menu', 'buildmenu', 'setShowGroupIcon', { 'showGroupIcon' }, value)
          end,
        },
        { id = "buildmenu_radaricon", group = "ui", basic = true, name = widgetOptionColor .. "   "..texts.option.buildmenu_radaricon, type = "bool", value = (WG['buildmenu'] ~= nil and WG['buildmenu'].getShowRadarIcon ~= nil and WG['buildmenu'].getShowRadarIcon()), description = texts.option.buildmenu_radaricon_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Build menu', 'buildmenu', 'setShowRadarIcon', { 'showRadarIcon' }, value)
          end,
        },
        { id = "buildmenu_tooltip", group = "ui", name = widgetOptionColor .. "   "..texts.option.buildmenu_tooltip, type = "bool", value = (WG['buildmenu'] ~= nil and WG['buildmenu'].getShowTooltip ~= nil and WG['buildmenu'].getShowTooltip()), description = texts.option.buildmenu_tooltip_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Build menu', 'buildmenu', 'setShowTooltip', { 'showTooltip' }, value)
          end,
        },
        --{id="buildmenu_shortcuts", group="ui", basic=true, name=widgetOptionColor.."   shortcuts", type="bool", value=(WG['buildmenu']~=nil and WG['buildmenu'].getShowShortcuts~=nil and WG['buildmenu'].getShowShortcuts()), description='Shortcuts prices in the buildmenu',
        -- onload = function(i) end,
        -- onchange = function(i, value) saveOptionValue('Build menu', 'buildmenu', 'setShowShortcuts', {'showShortcuts'}, value) end,
        --},

        --{ id = "buildmenu_defaultcolls", group = "ui", name = widgetOptionColor .. "   columns", type = "slider", min = 4, max = 6, step = 1, value = 5, description = 'Number of columns when "dynamic columns" is disabled',
        --  onload = function(i)
        --	  loadWidgetData("Build menu", "buildmenu_defaultcolls", { 'defaultColls' })
        --  end,
        --  onchange = function(i, value)
        --	  saveOptionValue('Build menu', 'buildmenu', 'setDefaultColls', { 'defaultColls' }, value)
        --  end,
        --},
        --{ id = "buildmenu_dynamic", group = "ui", name = widgetOptionColor .. "   dynamic columns", type = "bool", value = (WG['buildmenu'] ~= nil and WG['buildmenu'].getDynamicIconsize ~= nil and WG['buildmenu'].getDynamicIconsize()), description = 'Use variable number of columns depending on number of buildoptions available',
        --  onload = function(i)
        --  end,
        --  onchange = function(i, value)
        --	  saveOptionValue('Build menu', 'buildmenu', 'setDynamicIconsize', { 'dynamicIconsize' }, value)
        --  end,
        --},
        --{ id = "buildmenu_mincolls", group = "ui", name = widgetOptionColor .. "      min columns", type = "slider", min = 4, max = 6, step = 1, value = 5, description = '',
        --  onload = function(i)
        --	  loadWidgetData("Build menu", "buildmenu_mincolls", { 'minColls' })
        --  end,
        --  onchange = function(i, value)
        --	  saveOptionValue('Build menu', 'buildmenu', 'setMinColls', { 'minColls' }, value)
        --  end,
        --},
        --{ id = "buildmenu_maxcolls", group = "ui", name = widgetOptionColor .. "      max columns", type = "slider", min = 4, max = 7, step = 1, value = 6, description = '',
        --  onload = function(i)
        --	  loadWidgetData("Build menu", "buildmenu_maxcolls", { 'maxColls' })
        --  end,
        --  onchange = function(i, value)
        --	  saveOptionValue('Build menu', 'buildmenu', 'setMaxColls', { 'maxColls' }, value)
        --  end,
        --},

        { id = "buildpower", group = "ui", basic = true, widget = "Build power", name = texts.option.info..widgetOptionColor.." "..texts.option.buildpower, type = "bool", value = GetWidgetToggleValue("Build power"), description = texts.option.buildpower_descr },

        { id = "ordermenu_colorize", group = "ui", basic = true, name = texts.option.ordermenu .. widgetOptionColor .. "  "..texts.option.ordermenu_colorize, type = "slider", min = 0, max = 1, step = 0.1, value = 0, description = '',
          onload = function(i)
              loadWidgetData("Order menu", "ordermenu_colorize", { 'colorize' })
          end,
          onchange = function(i, value)
              saveOptionValue('Order menu', 'ordermenu', 'setColorize', { 'colorize' }, value)
          end,
        },
        { id = "ordermenu_bottompos", group = "ui", basic = true, name = widgetOptionColor .. "   "..texts.option.ordermenu_bottompos, type = "bool", value = (WG['ordermenu'] ~= nil and WG['ordermenu'].getBottomPosition ~= nil and WG['ordermenu'].getBottomPosition()), description = texts.option.ordermenu_bottompos_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Order menu', 'ordermenu', 'setBottomPosition', { 'stickToBottom' }, value)
          end,
        },
        { id = "ordermenu_alwaysshow", group = "ui", name = widgetOptionColor .. "   "..texts.option.ordermenu_alwaysshow, type = "bool", value = (WG['ordermenu'] ~= nil and WG['ordermenu'].getAlwaysShow ~= nil and WG['ordermenu'].getAlwaysShow()), description = texts.option.ordermenu_alwaysshow_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Order menu', 'ordermenu', 'setAlwaysShow', { 'alwaysShow' }, value)
          end,
        },
        { id = "ordermenu_hideset", group = "ui", basic = true, name = widgetOptionColor .. "   "..texts.option.ordermenu_hideset, type = "bool", value = (WG['ordermenu'] ~= nil and WG['ordermenu'].getDisabledCmd ~= nil and WG['ordermenu'].getDisabledCmd('Move')), description = texts.option.ordermenu_hideset_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              local cmds = {'Move', 'Stop', 'Attack', 'Patrol', 'Fight', 'Wait', 'Guard', 'Reclaim', 'Repair', 'ManualFire'}
              for k, cmd in pairs(cmds) do
                  saveOptionValue('Order menu', 'ordermenu', 'setDisabledCmd', { 'disabledCmd', cmd }, value, {cmd, value})
              end
          end,
        },
        --{ id = "ordermenu_button_move", group = "ui", name = widgetOptionColor .. "   "..texts.option.ordermenu_alwaysshow, type = "bool", value = (WG['ordermenu'] ~= nil and WG['ordermenu'].getDisbledCmd~= nil and WG['ordermenu'].getAlwaysShow()), description = texts.option.ordermenu_alwaysshow_descr,
        --  onload = function(i)
        --  end,
        --  onchange = function(i, value)
        --	  saveOptionValue('Order menu', 'ordermenu', 'setAlwaysShow', { 'alwaysShow' }, value)
        --  end,
        --},


        { id = "advplayerlist_scale", group = "ui", basic = true, name = texts.option.advplayerlist .. widgetOptionColor .. "  "..texts.option.advplayerlist_scale, min = 0.85, max = 1.2, step = 0.01, type = "slider", value = 1, description = texts.option.advplayerlist_scale_descr,
          onload = function(i)
              loadWidgetData("AdvPlayersList", "advplayerlist_scale", { 'customScale' })
          end,
          onchange = function(i, value)
              saveOptionValue('AdvPlayersList', 'advplayerlist_api', 'SetScale', { 'customScale' }, value)
          end,
        },
        { id = "advplayerlist_showid", group = "ui", name = widgetOptionColor .. "   "..texts.option.advplayerlist_showid, type = "bool", value = false, description = texts.option.advplayerlist_showid_descr,
          onload = function(i)
              loadWidgetData("AdvPlayersList", "advplayerlist_showid", { 'm_active_Table', 'id' })
          end,
          onchange = function(i, value)
              saveOptionValue('AdvPlayersList', 'advplayerlist_api', 'SetModuleActive', { 'm_active_Table', 'id' }, value, { 'id', value })
          end,
        },
        { id = "advplayerlist_country", group = "ui", name = widgetOptionColor .. "   "..texts.option.advplayerlist_country, type = "bool", value = true, description = texts.option.advplayerlist_country_descr,
          onload = function(i)
              loadWidgetData("AdvPlayersList", "advplayerlist_country", { 'm_active_Table', 'country' })
          end,
          onchange = function(i, value)
              saveOptionValue('AdvPlayersList', 'advplayerlist_api', 'SetModuleActive', { 'm_active_Table', 'country' }, value, { 'country', value })
          end,
        },
        { id = "advplayerlist_rank", group = "ui", name = widgetOptionColor .. "   "..texts.option.advplayerlist_rank, type = "bool", value = true, description = texts.option.advplayerlist_rank_descr,
          onload = function(i)
              loadWidgetData("AdvPlayersList", "advplayerlist_rank", { 'm_active_Table', 'rank' })
          end,
          onchange = function(i, value)
              saveOptionValue('AdvPlayersList', 'advplayerlist_api', 'SetModuleActive', { 'm_active_Table', 'rank' }, value, { 'rank', value })
          end,
        },
        { id = "advplayerlist_side", group = "ui", name = widgetOptionColor .. "   "..texts.option.advplayerlist_side, type = "bool", value = true, description = texts.option.advplayerlist_side_descr,
          onload = function(i)
              loadWidgetData("AdvPlayersList", "advplayerlist_side", { 'm_active_Table', 'side' })
          end,
          onchange = function(i, value)
              saveOptionValue('AdvPlayersList', 'advplayerlist_api', 'SetModuleActive', { 'm_active_Table', 'side' }, value, { 'side', value })
          end,
        },
        { id = "advplayerlist_skill", group = "ui", name = widgetOptionColor .. "   "..texts.option.advplayerlist_skill, type = "bool", value = true, description = texts.option.advplayerlist_skill_descr,
          onload = function(i)
              loadWidgetData("AdvPlayersList", "advplayerlist_skill", { 'm_active_Table', 'skill' })
          end,
          onchange = function(i, value)
              saveOptionValue('AdvPlayersList', 'advplayerlist_api', 'SetModuleActive', { 'm_active_Table', 'skill' }, value, { 'skill', value })
          end,
        },
        { id = "advplayerlist_cpuping", group = "ui", name = widgetOptionColor .. "   "..texts.option.advplayerlist_cpuping, type = "bool", value = true, description = texts.option.advplayerlist_cpuping_descr,
          onload = function(i)
              loadWidgetData("AdvPlayersList", "advplayerlist_cpuping", { 'm_active_Table', 'cpuping' })
          end,
          onchange = function(i, value)
              saveOptionValue('AdvPlayersList', 'advplayerlist_api', 'SetModuleActive', { 'm_active_Table', 'cpuping' }, value, { 'cpuping', value })
          end,
        },
        { id = "advplayerlist_share", group = "ui", name = widgetOptionColor .. "   "..texts.option.advplayerlist_share, type = "bool", value = true, description = texts.option.advplayerlist_share_descr,
          onload = function(i)
              loadWidgetData("AdvPlayersList", "advplayerlist_share", { 'm_active_Table', 'share' })
          end,
          onchange = function(i, value)
              saveOptionValue('AdvPlayersList', 'advplayerlist_api', 'SetModuleActive', { 'm_active_Table', 'share' }, value, { 'share', value })
          end,
        },
        { id = "mascot", group = "ui", basic = true, widget = "AdvPlayersList Mascot", name = widgetOptionColor .. "   "..texts.option.mascot, type = "bool", value = GetWidgetToggleValue("AdvPlayersList Mascot"), description = texts.option.mascot_descr },
        { id = "unittotals", group = "ui", basic = true, widget = "AdvPlayersList Unit Totals", name = widgetOptionColor .. "   "..texts.option.unittotals, type = "bool", value = GetWidgetToggleValue("AdvPlayersList Unit Totals"), description = texts.option.unittotals_descr },
        { id = "musicplayer", group = "ui", basic = true, widget = "AdvPlayersList Music Player", name = widgetOptionColor .. "   "..texts.option.musicplayer, type = "bool", value = GetWidgetToggleValue("AdvPlayersList Music Player"), description = texts.option.musicplayer,
          onload = function(i)
          end,
          onchange = function(i, value)
              if value then
                  Spring.StopSoundStream()
              end
          end
        },

        { id = "consolemaxlines", group = "ui", name = texts.option.console .. widgetOptionColor .. "  "..texts.option.consolemaxlines, type = "slider", min = 3, max = 9, step = 1, value = 6, description = '',
          onload = function(i)
              loadWidgetData("Red Console (In-game chat only)", "consolemaxlines", { 'Config', 'console', 'maxlines' })
          end,
          onchange = function(i, value)
              saveOptionValue('Red Console (In-game chat only)', 'red_chatonlyconsole', 'setMaxLines', { 'Config', 'console', 'maxlines' }, value)
              saveOptionValue('Red Console (old)', 'red_console', 'setMaxLines', { 'Config', 'console', 'maxlines' }, value)
          end,
        },
        { id = "consolefontsize", group = "ui", name = widgetOptionColor .. "   "..texts.option.consolefontsize, type = "slider", min = 0.9, max = 1.1, step = 0.05, value = 1, description = '',
          onload = function(i)
              loadWidgetData("Red Console (In-game chat only)", "consolefontsize", { 'fontsizeMultiplier' })
          end,
          onchange = function(i, value)
              saveOptionValue('Red Console (In-game chat only)', 'red_chatonlyconsole', 'setFontsize', { 'fontsizeMultiplier' }, value)
              saveOptionValue('Red Console (old)', 'red_console', 'setFontsize', { 'fontsizeMultiplier' }, value)
          end,
        },

        --{id="commanderhurt", group="ui", widget="Commander Hurt Vignette", name="Commander hurt vignette", type="bool", value=GetWidgetToggleValue("Commander Hurt Vignette"), description='Shows a red vignette when commander is out of view and gets damaged'},

        { id = "idlebuilders", group = "ui", basic = true, widget = "Idle Builders", name = texts.option.idlebuilders, type = "bool", value = GetWidgetToggleValue("Idle Builders"), description = texts.option.idlebuilders_descr },

        { id = "buildbar", group = "ui", basic = true, widget = "BuildBar", name = texts.option.buildbar, type = "bool", value = GetWidgetToggleValue("BuildBar"), description = texts.option.buildbar_descr },

        { id = "teamplatter", group = "ui", basic = true, widget = "TeamPlatter", name = texts.option.teamplatter, type = "bool", value = GetWidgetToggleValue("TeamPlatter"), description = texts.option.teamplatter_descr },
        { id = "teamplatter_opacity", basic = true, group = "ui", name = widgetOptionColor .. "   "..texts.option.teamplatter_opacity, min = 0.05, max = 0.4, step = 0.01, type = "slider", value = 0.3, description = texts.option.teamplatter_opacity_descr,
          onload = function(i)
              loadWidgetData("TeamPlatter", "teamplatter_opacity", { 'spotterOpacity' })
          end,
          onchange = function(i, value)
              saveOptionValue('TeamPlatter', 'teamplatter', 'setOpacity', { 'spotterOpacity' }, value)
          end,
        },
        { id = "teamplatter_skipownteam", group = "ui", name = widgetOptionColor .. "   "..texts.option.teamplatter_skipownteam, type = "bool", value = false, description = texts.option.teamplatter_skipownteam_descr,
          onload = function(i)
              loadWidgetData("TeamPlatter", "teamplatter_skipownteam", { 'skipOwnTeam' })
          end,
          onchange = function(i, value)
              saveOptionValue('TeamPlatter', 'teamplatter', 'setSkipOwnTeam', { 'skipOwnTeam' }, value)
          end,
        },

        { id = "enemyspotter", group = "ui", basic = true, widget = "EnemySpotter", name = texts.option.enemyspotter, type = "bool", value = GetWidgetToggleValue("EnemySpotter"), description = texts.option.enemyspotter_descr },
        { id = "enemyspotter_opacity", basic = true, group = "ui", name = widgetOptionColor .. "   "..texts.option.enemyspotter_opacity, min = 0.12, max = 0.4, step = 0.01, type = "slider", value = 0.15, description = texts.option.enemyspotter_opacity_descr,
          onload = function(i)
              loadWidgetData("EnemySpotter", "enemyspotter_opacity", { 'spotterOpacity' })
          end,
          onchange = function(i, value)
              saveOptionValue('EnemySpotter', 'enemyspotter', 'setOpacity', { 'spotterOpacity' }, value)
          end,
        },
        --{id="enemyspotter_highlight", group="ui", name=widgetOptionColor.."   unit highlight", type="bool", value=false, description='Colorize/highlight enemy units',
        --		 onload = function(i) loadWidgetData("EnemySpotter", "enemyspotter_highlight", {'useXrayHighlight'}) end,
        --		 onchange = function(i, value) saveOptionValue('EnemySpotter', 'enemyspotter', 'setHighlight', {'useXrayHighlight'}, value) end,
        --		},


        { id = "fancyselectedunits", group = "ui", basic = true, widget = "Fancy Selected Units", name = "Selection Unit Platters", type = "bool", value = GetWidgetToggleValue("Fancy Selected Units"), description = texts.option.fancyselectedunits_descr },
        --{id="fancyselectedunits_opacity", group="ui", name=widgetOptionColor.."   line opacity", min=0.8, max=1, step=0.01, type="slider", value=0.95, description='Set the opacity of the highlight on selected units',
        -- onload = function(i) loadWidgetData("Fancy Selected Units", "fancyselectedunits_opacity", {'spotterOpacity'}) end,
        -- onchange = function(i, value) saveOptionValue('Fancy Selected Units', 'fancyselectedunits', 'setOpacity', {'spotterOpacity'}, value) end,
        --},
        { id = "fancyselectedunits_baseopacity", group = "ui", name = widgetOptionColor .. "   "..texts.option.fancyselectedunits_baseopacity, min = 0, max = 0.5, step = 0.01, type = "slider", value = 0.15, description = texts.option.fancyselectedunits_baseopacity_descr,
          onload = function(i)
              loadWidgetData("Fancy Selected Units", "fancyselectedunits_baseopacity", { 'baseOpacity' })
          end,
          onchange = function(i, value)
              saveOptionValue('Fancy Selected Units', 'fancyselectedunits', 'setBaseOpacity', { 'baseOpacity' }, value)
          end,
        },
        { id = "fancyselectedunits_teamcoloropacity", group = "ui", name = widgetOptionColor .. "   "..texts.option.fancyselectedunits_teamcoloropacity, min = 0, max = 1, step = 0.01, type = "slider", value = 0.55, description = texts.option.fancyselectedunits_teamcoloropacity_descr,
          onload = function(i)
              loadWidgetData("Fancy Selected Units", "fancyselectedunits_teamcoloropacity", { 'teamcolorOpacity' })
          end,
          onchange = function(i, value)
              saveOptionValue('Fancy Selected Units', 'fancyselectedunits', 'setTeamcolorOpacity', { 'teamcolorOpacity' }, value)
          end,
        },

        { id = "highlightselunits", group = "ui", basic = true, widget = "Highlight Selected Units", name = texts.option.highlightselunits, type = "bool", value = GetWidgetToggleValue("Highlight Selected Units"), description = texts.option.highlightselunits_descr },
        { id = "highlightselunits_opacity", group = "ui", basic = true, name = widgetOptionColor .. "   "..texts.option.highlightselunits_opacity, min = 0.05, max = 0.5, step = 0.01, type = "slider", value = 0.1, description = texts.option.highlightselunits_opacity_descr,
          onload = function(i)
              loadWidgetData("Highlight Selected Units", "highlightselunits_opacity", { 'highlightAlpha' })
          end,
          onchange = function(i, value)
              saveOptionValue('Highlight Selected Units', 'highlightselunits', 'setOpacity', { 'highlightAlpha' }, value)
          end,
        },
        --{id="highlightselunits_shader", group="ui", name=widgetOptionColor.."   use shader", type="bool", value=false, description='Highlight model edges a bit',
        --		 onload = function(i) loadWidgetData("Highlight Selected Units", "highlightselunits_shader", {'useHighlightShader'}) end,
        --		 onchange = function(i, value) saveOptionValue('Highlight Selected Units', 'highlightselunits', 'setShader', {'useHighlightShader'}, value) end,
        --		},
        { id = "highlightselunits_teamcolor", group = "ui", basic = true, name = widgetOptionColor .. "   "..texts.option.highlightselunits_teamcolor, type = "bool", value = false, description = texts.option.highlightselunits_teamcolor_descr,
          onload = function(i)
              loadWidgetData("Highlight Selected Units", "highlightselunits_teamcolor", { 'useTeamcolor' })
          end,
          onchange = function(i, value)
              saveOptionValue('Highlight Selected Units', 'highlightselunits', 'setTeamcolor', { 'useTeamcolor' }, value)
          end,
        },

        { id = "metalspots", group = "ui", basic = true, widget = "Metalspots", name = texts.option.metalspots, type = "bool", value = GetWidgetToggleValue("Metalspots"), description = 'Shows a circle around metal spots with the amount of metal in it' },
        { id = "metalspots_opacity", group = "ui", name = widgetOptionColor .. "   "..texts.option.metalspots_opacity, type = "slider", min = 0.1, max = 1, step = 0.01, value = 0.5, description = 'Display metal values in the center',
          onload = function(i)
              loadWidgetData("Metalspots", "metalspots_opacity", { 'opacity' })
          end,
          onchange = function(i, value)
              WG.metalspots.setShowValue(value)
              saveOptionValue('Metalspots', 'metalspots', 'setOpacity', { 'opacity' }, options[getOptionByID('metalspots_opacity')].value)
          end,
        },
        { id = "metalspots_values", group = "ui", basic = true, name = widgetOptionColor .. "   "..texts.option.metalspots_values, type = "bool", value = true, description = 'Display metal values (during game)\nPre-gamestart or when in metalmap view (f4) this will always be shown\n\nNote that it\'s significantly enough more costly to draw the text values',
          onload = function(i)
              loadWidgetData("Metalspots", "metalspots_values", { 'showValues' })
          end,
          onchange = function(i, value)
              WG.metalspots.setShowValue(value)
              saveOptionValue('Metalspots', 'metalspots', 'setShowValue', { 'showValue' }, options[getOptionByID('metalspots_values')].value)
          end,
        },
        { id = "metalspots_metalviewonly", group = "ui", name = widgetOptionColor .. "   "..texts.option.metalspots_metalviewonly, type = "bool", value = false, description = 'Limit display to only during pre-gamestart or when in metalmap view (f4)',
          onload = function(i)
              loadWidgetData("Metalspots", "metalspots_metalviewonly", { 'metalViewOnly' })
          end,
          onchange = function(i, value)
              saveOptionValue('Metalspots', 'metalspots', 'setMetalViewOnly', { 'showValue' }, options[getOptionByID('metalspots_metalviewonly')].value)
          end,
        },

        { id = "healthbarsscale", group = "ui", name = texts.option.healthbars .. widgetOptionColor .. "  "..texts.option.healthbarsscale, type = "slider", min = 0.6, max = 1.6, step = 0.1, value = 1, description = '',
          onload = function(i)
              loadWidgetData("Health Bars", "healthbarsscale", { 'barScale' })
          end,
          onchange = function(i, value)
              saveOptionValue('Health Bars', 'healthbars', 'setScale', { 'barScale' }, value)
          end,
        },
        { id = "healthbarsdistance", group = "ui", name = widgetOptionColor .. "   "..texts.option.healthbarsdistance, type = "slider", min = 0.4, max = 6, step = 0.1, value = 1, description = '',
          onload = function(i)
              loadWidgetData("Health Bars", "healthbarsdistance", { 'drawDistanceMult' })
          end,
          onchange = function(i, value)
              saveOptionValue('Health Bars', 'healthbars', 'setDrawDistance', { 'drawDistanceMult' }, value)
          end,
        },
        { id = "healthbarsvariable", group = "ui", name = widgetOptionColor .. "   "..texts.option.healthbarsvariable, type = "bool", value = (WG['healthbar'] ~= nil and WG['healthbar'].getVariableSizes()), description = texts.option.healthbarsvariable_descr,
          onload = function(i)
              loadWidgetData("Health Bars", "healthbarsvariable", { 'variableBarSizes' })
          end,
          onchange = function(i, value)
              saveOptionValue('Health Bars', 'healthbars', 'setVariableSizes', { 'variableBarSizes' }, value)
          end,
        },
        { id = "healthbarshide", group = "ui", name = widgetOptionColor .. "   "..texts.option.healthbarshide, type = "bool", value = (WG['nametags'] ~= nil and WG['nametags'].getDrawForIcon()), description = texts.option.healthbarshide_descr,
          onload = function(i)
              loadWidgetData("Health Bars", "healthbarshide", { 'hideHealthbars' })
          end,
          onchange = function(i, value)
              saveOptionValue('Health Bars', 'healthbars', 'setHideHealth', { 'hideHealthbars' }, value)
          end,
        },

        { id = "rankicons", group = "ui", basic = true, widget = "Rank Icons", name = texts.option.rankicons, type = "bool", value = GetWidgetToggleValue("Rank Icons"), description = texts.option.rankicons_descr },
        { id = "rankicons_distance", group = "ui", name = widgetOptionColor .. "   "..texts.option.rankicons_distance, type = "slider", min = 0.4, max = 2, step = 0.1, value = (WG['rankicons'] ~= nil and WG['rankicons'].getDrawDistance ~= nil and WG['rankicons'].getDrawDistance()), description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Rank Icons', 'rankicons', 'setDrawDistance', { 'distanceMult' }, value)
          end,
        },
        { id = "rankicons_scale", group = "ui", name = widgetOptionColor .. "   "..texts.option.rankicons_scale, type = "slider", min = 0.3, max = 3, step = 0.1, value = (WG['rankicons'] ~= nil and WG['rankicons'].getScale ~= nil and WG['rankicons'].getScale()), description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('Rank Icons', 'rankicons', 'setScale', { 'iconsizeMult' }, value)
          end,
        },

        { id = "allycursors", group = "ui", basic = true, widget = "AllyCursors", name = texts.option.allycursors, type = "bool", value = GetWidgetToggleValue("AllyCursors"), description = texts.option.allycursors_descr },
        { id = "allycursors_playername", group = "ui", name = widgetOptionColor .. "   "..texts.option.allycursors_playername, type = "bool", value = true, description = texts.option.allycursors_playername_descr,
          onload = function(i)
              loadWidgetData("AllyCursors", "allycursors_playername", { 'showPlayerName' })
          end,
          onchange = function(i, value)
              saveOptionValue('AllyCursors', 'allycursors', 'setPlayerNames', { 'showPlayerName' }, value)
          end,
        },
        { id = "allycursors_spectatorname", group = "ui", name = widgetOptionColor .. "   "..texts.option.allycursors_spectatorname, type = "bool", value = true, description = texts.option.allycursors_spectatorname_descr,
          onload = function(i)
              loadWidgetData("AllyCursors", "allycursors_spectatorname", { 'showSpectatorName' })
          end,
          onchange = function(i, value)
              saveOptionValue('AllyCursors', 'allycursors', 'setSpectatorNames', { 'showSpectatorName' }, value)
          end,
        },
        { id = "allycursors_showdot", group = "ui", name = widgetOptionColor .. "   "..texts.option.allycursors_showdot, type = "bool", value = true, description = texts.option.allycursors_showdot_descr,
          onload = function(i)
              loadWidgetData("AllyCursors", "allycursors_showdot", { 'showCursorDot' })
          end,
          onchange = function(i, value)
              saveOptionValue('AllyCursors', 'allycursors', 'setCursorDot', { 'showCursorDot' }, value)
          end,
        },
        { id = "allycursors_lights", group = "ui", name = widgetOptionColor .. "   "..texts.option.allycursors_lights, type = "bool", value = true, description = texts.option.allycursors_lights_descr,
          onload = function(i)
              loadWidgetData("AllyCursors", "allycursors_lights", { 'addLights' })
          end,
          onchange = function(i, value)
              saveOptionValue('AllyCursors', 'allycursors', 'setLights', { 'addLights' }, options[getOptionByID('allycursors_lights')].value)
          end,
        },
        { id = "allycursors_lightradius", group = "ui", name = widgetOptionColor .. "      "..texts.option.allycursors_lightradius, type = "slider", min = 0.15, max = 1, step = 0.05, value = 0.5, description = '',
          onload = function(i)
              loadWidgetData("AllyCursors", "allycursors_lightradius", { 'lightRadiusMult' })
          end,
          onchange = function(i, value)
              saveOptionValue('AllyCursors', 'allycursors', 'setLightRadius', { 'lightRadiusMult' }, value)
          end,
        },
        { id = "allycursors_lightstrength", group = "ui", name = widgetOptionColor .. "      "..texts.option.allycursors_lightstrength, type = "slider", min = 0.1, max = 1.2, step = 0.05, value = 0.85, description = '',
          onload = function(i)
              loadWidgetData("AllyCursors", "allycursors_lightstrength", { 'lightStrengthMult' })
          end,
          onchange = function(i, value)
              saveOptionValue('AllyCursors', 'allycursors', 'setLightStrength', { 'lightStrengthMult' }, value)
          end,
        },

        { id = "cursorlight", group = "ui", basic = true, widget = "Cursor Light", name = texts.option.cursorlight, type = "bool", value = GetWidgetToggleValue("Cursor Light"), description = texts.option.cursorlight_descr },
        { id = "cursorlight_lightradius", group = "ui", name = widgetOptionColor .. "   "..texts.option.cursorlight_lightradius, type = "slider", min = 0.15, max = 1, step = 0.05, value = 1.5, description = '',
          onload = function(i)
              loadWidgetData("Cursor Light", "cursorlight_lightradius", { 'lightRadiusMult' })
          end,
          onchange = function(i, value)
              saveOptionValue('Cursor Light', 'cursorlight', 'setLightRadius', { 'lightRadiusMult' }, value)
          end,
        },
        { id = "cursorlight_lightstrength", group = "ui", name = widgetOptionColor .. "   "..texts.option.cursorlight_lightstrength, type = "slider", min = 0.1, max = 1.2, step = 0.05, value = 0.2, description = '',
          onload = function(i)
              loadWidgetData("Cursor Light", "cursorlight_lightstrength", { 'lightStrengthMult' })
          end,
          onchange = function(i, value)
              saveOptionValue('Cursor Light', 'cursorlight', 'setLightStrength', { 'lightStrengthMult' }, value)
          end,
        },

        { id = "showbuilderqueue", group = "ui", basic = true, widget = "Show Builder Queue", name = texts.option.showbuilderqueue, type = "bool", value = GetWidgetToggleValue("Show Builder Queue"), description = texts.option.showbuilderqueue_descr },

        { id = "unitenergyicons", group = "ui", basic = true, widget = "Unit energy icons", name = texts.option.unitenergyicons, type = "bool", value = GetWidgetToggleValue("Unit energy icons"), description = texts.option.unitenergyicons_descr },
        { id = "unitenergyicons_self", group = "ui", name = widgetOptionColor .. "   "..texts.option.unitenergyicons_self, type = "bool", value = (WG['unitenergyicons'] ~= nil and WG['unitenergyicons'].getOnlyShowOwnTeam()), description = texts.option.unitenergyicons_self_descr,
          onload = function(i)
              loadWidgetData("Unit energy icons", "unitenergyicons_self", { 'onlyShowOwnTeam' })
          end,
          onchange = function(i, value)
              saveOptionValue('Unit energy icons', 'unitenergyicons', 'setOnlyShowOwnTeam', { 'onlyShowOwnTeam' }, value)
          end,
        },


        { id = "nametags_icon", group = "ui", name = texts.option.nametags_icon, type = "bool", value = (WG['nametags'] ~= nil and WG['nametags'].getDrawForIcon()), description = texts.option.nametags_icon_descr,
          onload = function(i)
              loadWidgetData("Commander Name Tags", "nametags_icon", { 'drawForIcon' })
          end,
          onchange = function(i, value)
              saveOptionValue('Commander Name Tags', 'nametags', 'setDrawForIcon', { 'drawForIcon' }, value)
          end,
        },

        { id = "commandsfx", group = "ui", basic = true, widget = "Commands FX", name = texts.option.commandsfx, type = "bool", value = GetWidgetToggleValue("Commands FX"), description = texts.option.commandsfx_descr },
        { id = "commandsfxfilterai", group = "ui", name = widgetOptionColor .. "   "..texts.option.commandsfxfilterai, type = "bool", value = true, description = texts.option.commandsfxfilterai_descr,
          onload = function(i)
              loadWidgetData("Commands FX", "commandsfxfilterai", { 'filterAIteams' })
          end,
          onchange = function(i, value)
              saveOptionValue('Commands FX', 'commandsfx', 'setFilterAI', { 'filterAIteams' }, value)
          end,
        },
        { id = "commandsfxopacity", group = "ui", name = widgetOptionColor .. "   "..texts.option.commandsfxopacity, type = "slider", min = 0.25, max = 1, step = 0.1, value = 1, description = '',
          onload = function(i)
              loadWidgetData("Commands FX", "commandsfxopacity", { 'opacity' })
          end,
          onchange = function(i, value)
              saveOptionValue('Commands FX', 'commandsfx', 'setOpacity', { 'opacity' }, value)
          end,
        },

        { id = "displaydps", group = "ui", basic = true, name = texts.option.displaydps, type = "bool", value = tonumber(Spring.GetConfigInt("DisplayDPS", 0) or 0) == 1, description = texts.option.displaydps_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              Spring.SetConfigInt("DisplayDPS", (value and 1 or 0))
          end,
        },
        { id = "givenunits", group = "ui", widget = "Given Units", name = texts.option.givenunits, type = "bool", value = GetWidgetToggleValue("Given Units"), description = texts.option.giveunits_descr },

        { id = "radarrange", group = "ui", widget = "Radar Range", name = texts.option.radarrange, type = "bool", value = GetWidgetToggleValue("Radar Range"), description = texts.option.radarrange_descr },

        { id = "defrange", group = "ui", widget = "Defense Range", name = texts.option.defrange, type = "bool", value = GetWidgetToggleValue("Defense Range"), description = texts.option.displaydps_descr },
        { id = "defrange_allyair", group = "ui", name = widgetOptionColor .. "   "..texts.option.defrange_allyair, type = "bool", value = (WG['defrange'] ~= nil and WG['defrange'].getAllyAir ~= nil and WG['defrange'].getAllyAir()), description = texts.option.defrange_allyair_descr,
          onload = function(i)
              loadWidgetData("Defense Range", "defrange_allyair", { 'enabled', 'ally', 'air' })
          end,
          onchange = function(i, value)
              if widgetHandler.configData["Defense Range"] == nil then
                  widgetHandler.configData["Defense Range"] = {}
              end
              if widgetHandler.configData["Defense Range"].enabled == nil then
                  widgetHandler.configData["Defense Range"].enabled = { ally = { air = false, ground = false, nuke = false }, enemy = { air = true, ground = true, nuke = true } }
              end
              saveOptionValue('Defense Range', 'defrange', 'setAllyAir', { 'enabled', 'ally', 'air' }, value)
          end,
        },
        { id = "defrange_allyground", group = "ui", name = widgetOptionColor .. "   "..texts.option.defrange_allyground, type = "bool", value = (WG['defrange'] ~= nil and WG['defrange'].getAllyGround ~= nil and WG['defrange'].getAllyGround()), description = texts.option.defrange_allyground_descr,
          onload = function(i)
              loadWidgetData("Defense Range", "defrange_allyground", { 'enabled', 'ally', 'ground' })
          end,
          onchange = function(i, value)
              if widgetHandler.configData["Defense Range"] == nil then
                  widgetHandler.configData["Defense Range"] = {}
              end
              if widgetHandler.configData["Defense Range"].enabled == nil then
                  widgetHandler.configData["Defense Range"].enabled = { ally = { air = false, ground = false, nuke = false }, enemy = { air = true, ground = true, nuke = true } }
              end
              saveOptionValue('Defense Range', 'defrange', 'setAllyGround', { 'enabled', 'ally', 'ground' }, value)
          end,
        },
        { id = "defrange_allynuke", group = "ui", name = widgetOptionColor .. "   "..texts.option.defrange_allynuke, type = "bool", value = (WG['defrange'] ~= nil and WG['defrange'].getAllyNuke ~= nil and WG['defrange'].getAllyNuke()), description = texts.option.defrange_allynuke_descr,
          onload = function(i)
              loadWidgetData("Defense Range", "defrange_allynuke", { 'enabled', 'ally', 'nuke' })
          end,
          onchange = function(i, value)
              if widgetHandler.configData["Defense Range"] == nil then
                  widgetHandler.configData["Defense Range"] = {}
              end
              if widgetHandler.configData["Defense Range"].enabled == nil then
                  widgetHandler.configData["Defense Range"].enabled = { ally = { air = false, ground = false, nuke = false }, enemy = { air = true, ground = true, nuke = true } }
              end
              saveOptionValue('Defense Range', 'defrange', 'setAllyNuke', { 'enabled', 'ally', 'nuke' }, value)
          end,
        },
        { id = "defrange_enemyair", group = "ui", name = widgetOptionColor .. "   "..texts.option.defrange_enemyair, type = "bool", value = (WG['defrange'] ~= nil and WG['defrange'].getEnemyAir ~= nil and WG['defrange'].getEnemyAir()), description = texts.option.defrange_enemyair_descr,
          onload = function(i)
              loadWidgetData("Defense Range", "defrange_enemyair", { 'enabled', 'enemy', 'air' })
          end,
          onchange = function(i, value)
              if widgetHandler.configData["Defense Range"] == nil then
                  widgetHandler.configData["Defense Range"] = {}
              end
              if widgetHandler.configData["Defense Range"].enabled == nil then
                  widgetHandler.configData["Defense Range"].enabled = { ally = { air = false, ground = false, nuke = false }, enemy = { air = true, ground = true, nuke = true } }
              end
              saveOptionValue('Defense Range', 'defrange', 'setEnemyAir', { 'enabled', 'enemy', 'air' }, value)
          end,
        },
        { id = "defrange_enemyground", group = "ui", name = widgetOptionColor .. "   "..texts.option.defrange_allyground, type = "bool", value = (WG['defrange'] ~= nil and WG['defrange'].getEnemyGround ~= nil and WG['defrange'].getEnemyGround()), description = texts.option.defrange_allyground_descr,
          onload = function(i)
              loadWidgetData("Defense Range", "defrange_enemyground", { 'enabled', 'enemy', 'ground' })
          end,
          onchange = function(i, value)
              if widgetHandler.configData["Defense Range"] == nil then
                  widgetHandler.configData["Defense Range"] = {}
              end
              if widgetHandler.configData["Defense Range"].enabled == nil then
                  widgetHandler.configData["Defense Range"].enabled = { ally = { air = false, ground = false, nuke = false }, enemy = { air = true, ground = true, nuke = true } }
              end
              saveOptionValue('Defense Range', 'defrange', 'setEnemyGround', { 'enabled', 'enemy', 'ground' }, value)
          end,
        },
        { id = "defrange_enemynuke", group = "ui", name = widgetOptionColor .. "   ".. texts.option.defrange_enemynuke, type = "bool", value = (WG['defrange'] ~= nil and WG['defrange'].getEnemyNuke ~= nil and WG['defrange'].getEnemyNuke()), description = texts.option.defrange_enemynuke_descr,
          onload = function(i)
              loadWidgetData("Defense Range", "defrange_enemynuke", { 'enabled', 'enemy', 'nuke' })
          end,
          onchange = function(i, value)
              if widgetHandler.configData["Defense Range"] == nil then
                  widgetHandler.configData["Defense Range"] = {}
              end
              if widgetHandler.configData["Defense Range"].enabled == nil then
                  widgetHandler.configData["Defense Range"].enabled = { ally = { air = false, ground = false, nuke = false }, enemy = { air = true, ground = true, nuke = true } }
              end
              saveOptionValue('Defense Range', 'defrange', 'setEnemyNuke', { 'enabled', 'enemy', 'nuke' }, value)
          end,
        },

        { id = "allyselunits_select", group = "ui", name =  texts.option.allyselunits_select, type = "bool", value = (WG['allyselectedunits'] ~= nil and WG['allyselectedunits'].getSelectPlayerUnits()), description = texts.option.allyselunits_select_descr,
          onload = function(i)
              loadWidgetData("Ally Selected Units", "allyselunits_select", { 'selectPlayerUnits' })
          end,
          onchange = function(i, value)
              saveOptionValue('Ally Selected Units', 'allyselectedunits', 'setSelectPlayerUnits', { 'selectPlayerUnits' }, value)
          end,
        },
        { id = "lockcamera_hideenemies", group = "ui", name = widgetOptionColor .. "   ".. texts.option.lockcamera_hideenemies, type = "bool", value = (WG['advplayerlist_api'] ~= nil and WG['advplayerlist_api'].GetLockHideEnemies()), description = texts.option.lockcamera_hideenemies_descr,
          onload = function(i)
              loadWidgetData("AdvPlayersList", "lockcamera_hideenemies", { 'lockcameraHideEnemies' })
          end,
          onchange = function(i, value)
              saveOptionValue('AdvPlayersList', 'advplayerlist_api', 'SetLockHideEnemies', { 'lockcameraHideEnemies' }, value)
          end,
        },
        { id = "lockcamera_los", group = "ui", name = widgetOptionColor .. "   ".. texts.option.lockcamera_los, type = "bool", value = (WG['advplayerlist_api'] ~= nil and WG['advplayerlist_api'].GetLockLos()), description = texts.option.lockcamera_los_descr,
          onload = function(i)
              loadWidgetData("AdvPlayersList", "lockcamera_los", { 'lockcameraLos' })
          end,
          onchange = function(i, value)
              saveOptionValue('AdvPlayersList', 'advplayerlist_api', 'SetLockLos', { 'lockcameraLos' }, value)
          end,
        },

        { id = "playertv_countdown", group = "ui", name = texts.option.playertv_countdown, type = "slider", min = 8, max = 60, step = 1, value = (WG['playertv'] ~= nil and WG['playertv'].GetPlayerChangeDelay()) or 40, description = texts.option.playertv_countdown_descr,
          onload = function(i)
              loadWidgetData("Player-TV", "playertv_countdown", { 'playerChangeDelay' })
          end,
          onchange = function(i, value)
              saveOptionValue('Player-TV', 'playertv', 'SetPlayerChangeDelay', { 'playerChangeDelay' }, value)
          end,
        },

        { id = "loadscreen_tips", group = "ui", name = texts.option.loadscreen_tips, type = "bool", value = (Spring.GetConfigInt("loadscreen_tips",1) == 1), description = texts.option.loadscreen_tips_descr,
          onchange = function(i, value)
              Spring.SetConfigInt("loadscreen_tips", (value and 1 or 0))
          end,
        },


        -- GAME
        { id = "networksmoothing", restart = true, basic = true, group = "game", name = texts.option.networksmoothing, type = "bool", value = useNetworkSmoothing, description = texts.option.networksmoothing_descr,
          onload = function(i)
              options[i].onchange(i, options[i].value)
          end,
          onchange = function(i, value)
              useNetworkSmoothing = value
              if useNetworkSmoothing then
                  Spring.SetConfigInt("UseNetMessageSmoothingBuffer", 1)
                  Spring.SetConfigInt("NetworkLossFactor", 0)
                  Spring.SetConfigInt("LinkOutgoingBandwidth", 98304)
                  Spring.SetConfigInt("LinkIncomingSustainedBandwidth", 98304)
                  Spring.SetConfigInt("LinkIncomingPeakBandwidth", 98304)
                  Spring.SetConfigInt("LinkIncomingMaxPacketRate", 128)
              else
                  Spring.SetConfigInt("UseNetMessageSmoothingBuffer", 1)
                  Spring.SetConfigInt("NetworkLossFactor", 2)
                  Spring.SetConfigInt("LinkOutgoingBandwidth", 196608)
                  Spring.SetConfigInt("LinkIncomingSustainedBandwidth", 196608)
                  Spring.SetConfigInt("LinkIncomingPeakBandwidth", 196608)
                  Spring.SetConfigInt("LinkIncomingMaxPacketRate", 1024)
              end
          end,
        },
        { id = "autoquit", group = "game", basic = true, widget = "Autoquit", name = texts.option.autoquit, type = "bool", value = GetWidgetToggleValue("Autoquit"), description = texts.option.autoquit_descr },

        { id = "smartselect_includebuildings", group = "game", basic = true, name = texts.option.smartselect_includebuildings, type = "bool", value = false, description = texts.option.smartselect_includebuildings_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('SmartSelect', 'smartselect', 'setIncludeBuildings', { 'selectBuildingsWithMobile' }, value)
          end,
        },
        { id = "smartselect_includebuilders", group = "game", basic = true, name = widgetOptionColor .. "   "..texts.option.smartselect_includebuilders, type = "bool", value = true, description = texts.option.smartselect_includebuilders_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              saveOptionValue('SmartSelect', 'smartselect', 'setIncludeBuilders', { 'includeBuilders' }, value)
          end,
        },

        { id = "onlyfighterspatrol", group = "game", basic = true, widget = "OnlyFightersPatrol", name = texts.option.onlyfighterspatrol, type = "bool", value = GetWidgetToggleValue("Autoquit"), description = texts.option.onlyfighterspatrol_descr },
        { id = "fightersfly", group = "game", basic = true, widget = "Set fighters on Fly mode", name = texts.option.fightersfly, type = "bool", value = GetWidgetToggleValue("Set fighters on Fly mode"), description = texts.option.fightersfly_descr },

        {
            id = "builderpriority",
            group = "game",
            basic = true,
            widget = "Builder Priority",
            name = texts.option.builderpriority,
            type = "bool",
            value = GetWidgetToggleValue("Builder Priority"),
            description = texts.option.builderpriority_descr,
        },

        {
            id = "builderpriority_nanos",
            group = "game",
            name = widgetOptionColor .. "   "..texts.option.builderpriority_nanos,
            type = "bool",
            value = (
                    WG['builderpriority'] ~= nil
                            and WG['builderpriority'].getLowPriorityNanos ~= nil
                            and WG['builderpriority'].getLowPriorityNanos()
            ),
            description = texts.option.builderpriority_nanos_descr,
            onload = function(i)
                loadWidgetData("Builder Priority", "builderpriority_nanos", { 'lowpriorityNanos' })
            end,
            onchange = function(i, value)
                saveOptionValue('Builder Priority', 'builderpriority', 'setLowPriorityNanos', { 'lowpriorityNanos' }, value)
            end,
        },

        {
            id = "builderpriority_cons",
            group = "game",
            name = widgetOptionColor .. "   "..texts.option.builderpriority_cons,
            type = "bool",
            value = (
                    WG['builderpriority'] ~= nil
                            and WG['builderpriority'].getLowPriorityCons ~= nil
                            and WG['builderpriority'].getLowPriorityCons()
            ),
            description = texts.option.builderpriority_cons_descr,
            onload = function(i)
                loadWidgetData("Builder Priority", "builderpriority_cons", { 'lowpriorityCons' })
            end,
            onchange = function(i, value)
                saveOptionValue('Builder Priority', 'builderpriority', 'setLowPriorityCons', { 'lowpriorityCons' }, value)
            end,
        },

        {
            id = "builderpriority_labs",
            group = "game",
            name = widgetOptionColor .. "   "..texts.option.builderpriority_labs,
            type = "bool",
            value = (
                    WG['builderpriority'] ~= nil
                            and WG['builderpriority'].getLowPriorityLabs ~= nil
                            and WG['builderpriority'].getLowPriorityLabs()
            ),
            description = texts.option.builderpriority_labs_descr,
            onload = function(i)
                loadWidgetData("Builder Priority", "builderpriority_labs", { 'lowpriorityLabs' })
            end,
            onchange = function(i, value)
                saveOptionValue('Builder Priority', 'builderpriority', 'setLowPriorityLabs', { 'lowpriorityLabs' }, value)
            end,
        },

        { id = "autocloakpopups", group = "game", basic = true, widget = "Auto Cloak Popups", name = texts.option.autocloakpopups, type = "bool", value = GetWidgetToggleValue("Auto Cloak Popups"), description = texts.option.autocloakpopups_descr },

        { id = "unitreclaimer", group = "game", basic = true, widget = "Unit Reclaimer", name = texts.option.unitreclaimer, type = "bool", value = GetWidgetToggleValue("Unit Reclaimer"), description = texts.option.unitreclaimer_descr },

        { id = "autogroup_immediate", group = "game", basic = true, name = texts.option.autogroup_immediate, type = "bool", value = (WG['autogroup'] ~= nil and WG['autogroup'].getImmediate ~= nil and WG['autogroup'].getImmediate()), description = texts.option.autogroup_immediate_descr,
          onload = function(i)
              loadWidgetData("Auto Group", "autogroup_immediate", { 'config', 'immediate', 'value' })
          end,
          onchange = function(i, value)
              if widgetHandler.configData["Auto Group"] == nil then
                  widgetHandler.configData["Auto Group"] = {}
              end
              if widgetHandler.configData["Auto Group"].config == nil then
                  widgetHandler.configData["Auto Group"].config = { immediate = { value = value } }
              else
                  widgetHandler.configData["Auto Group"].config.immediate.value = value
              end
              saveOptionValue('Auto Group', 'autogroup', 'setImmediate', { 'config', 'immediate', 'value' }, value)
          end,
        },

        { id = "factoryguard", group = "game", basic = true, widget = "FactoryGuard", name = texts.option.factoryguard, type = "bool", value = GetWidgetToggleValue("FactoryGuard"), description = texts.option.factoryguard_descr },
        { id = "factoryholdpos", group = "game", basic = true, widget = "Factory hold position", name = texts.option.factoryholdpos, type = "bool", value = GetWidgetToggleValue("Factory hold position"), description = texts.option.factoryholdpos_descr },
        { id = "factoryrepeat", group = "game", basic = true, widget = "Factory Auto-Repeat", name = texts.option.factoryrepeat, type = "bool", value = GetWidgetToggleValue("Factory Auto-Repeat"), description = texts.option.factoryrepeat_descr },

        { id = "transportai", group = "game", basic = true, widget = "Transport AI", name = texts.option.transportai, type = "bool", value = GetWidgetToggleValue("Transport AI"), description = texts.option.transportai_descr },
        { id = "settargetdefault", group = "game", basic = true, widget = "Set target default", name = texts.option.settargetdefault, type = "bool", value = GetWidgetToggleValue("Set target default"), description = texts.option.settargetdefault_descr },
        { id = "dgunnogroundenemies", group = "game", widget = "DGun no ground enemies", name = texts.option.dgunnogroundenemies, type = "bool", value = GetWidgetToggleValue("DGun no ground enemies"), description = texts.option.dgunnogroundenemies_descr },

        { id = "singleplayerpause", group = "game", name = texts.option.singleplayerpause, type = "bool", value = pauseGameWhenSingleplayer, description = texts.option.singleplayerpause_descr,
          onchange = function(i, value)
              pauseGameWhenSingleplayer = value
              if isSinglePlayer and show then
                  local _, gameSpeed, isPaused = Spring.GetGameSpeed()
                  if pauseGameWhenSingleplayer then
                      Spring.SendCommands("pause "..(pauseGameWhenSingleplayer and  '1' or '0'))
                      pauseGameWhenSingleplayerExecuted = pauseGameWhenSingleplayer
                  elseif pauseGameWhenSingleplayerExecuted then
                      Spring.SendCommands("pause 0")
                      pauseGameWhenSingleplayerExecuted = false
                  end
              end
          end,
        },

        -- DEV
        { id = "customwidgets", group = "dev", name = texts.option.customwidgets, type = "bool", value = widgetHandler.allowUserWidgets, description = texts.option.customwidgets_descr,
          onchange = function(i, value)
              widgetHandler.__allowUserWidgets = value
              Spring.SendCommands("luarules reloadluaui")
          end,
        },
        { id = "profiler", group = "dev", widget = "Widget Profiler", name = texts.option.profiler, type = "bool", value = GetWidgetToggleValue("Widget Profiler"), description = "" },
        { id = "framegrapher", group = "dev", widget = "Frame Grapher", name = texts.option.framegrapher, type = "bool", value = GetWidgetToggleValue("Frame Grapher"), description = "" },

        { id = "autocheat", group = "dev", widget = "Auto cheat", name = texts.option.autocheat, type = "bool", value = GetWidgetToggleValue("Auto cheat"), description = texts.option.autocheat_descr },
        { id = "restart", group = "dev", name = texts.option.restart, type = "bool", value = false, description = texts.option.restart_descr,
          onchange = function(i, value)
              options[getOptionByID('restart')].value = false
              Spring.Restart("", startScript)
          end,
        },
        { id = "startboxeditor", group = "dev", widget = "Startbox Editor", name = texts.option.startboxeditor, type = "bool", value = GetWidgetToggleValue("Startbox Editor"), description = texts.option.startboxeditor_descr },

        { id = "tonemapA", group = "dev", name = texts.option.tonemap .. widgetOptionColor .. "  1", type = "slider", min = 0, max = 7, step = 0.01, value = Spring.GetConfigFloat("tonemapA", 4.8), description = "",
          onchange = function(i, value)
              Spring.SetConfigFloat("tonemapA", value)
              Spring.SendCommands("luarules updatesun")
              Spring.SendCommands("luarules GlassUpdateSun")
          end,
        },
        { id = "tonemapB", group = "dev", name = widgetOptionColor .. "   2", type = "slider", min = 0, max = 2, step = 0.01, value = Spring.GetConfigFloat("tonemapB", 0.8), description = "",
          onchange = function(i, value)
              Spring.SetConfigFloat("tonemapB", value)
              Spring.SendCommands("luarules updatesun")
              Spring.SendCommands("luarules GlassUpdateSun")
          end,
        },
        { id = "tonemapC", group = "dev", name = widgetOptionColor .. "   3", type = "slider", min = 0, max = 5, step = 0.01, value = Spring.GetConfigFloat("tonemapC", 3.35), description = "",
          onchange = function(i, value)
              Spring.SetConfigFloat("tonemapC", value)
              Spring.SendCommands("luarules updatesun")
              Spring.SendCommands("luarules GlassUpdateSun")
          end,
        },
        { id = "tonemapD", group = "dev", name = widgetOptionColor .. "   4", type = "slider", min = 0, max = 3, step = 0.01, value = Spring.GetConfigFloat("tonemapD", 1.0), description = "",
          onchange = function(i, value)
              Spring.SetConfigFloat("tonemapD", value)
              Spring.SendCommands("luarules updatesun")
              Spring.SendCommands("luarules GlassUpdateSun")
          end,
        },
        { id = "tonemapE", group = "dev", name = widgetOptionColor .. "   5", type = "slider", min = 0, max = 3, step = 0.01, value = Spring.GetConfigFloat("tonemapE", 1.15), description = "",
          onchange = function(i, value)
              Spring.SetConfigFloat("tonemapE", value)
              Spring.SendCommands("luarules updatesun")
              Spring.SendCommands("luarules GlassUpdateSun")
          end,
        },
        { id = "envAmbient", group = "dev", name = widgetOptionColor .. "   "..texts.option.envAmbient, type = "slider", min = 0, max = 1, step = 0.01, value = Spring.GetConfigFloat("envAmbient", 0.3), description = "",
          onchange = function(i, value)
              Spring.SetConfigFloat("envAmbient", value)
              Spring.SendCommands("luarules updatesun")
              Spring.SendCommands("luarules GlassUpdateSun")
          end,
        },
        { id = "unitSunMult", group = "dev", name = widgetOptionColor .. "   "..texts.option.unitSunMult, type = "slider", min = 0.4, max = 2.5, step = 0.05, value = Spring.GetConfigFloat("unitSunMult", 1.35), description = "",
          onchange = function(i, value)
              Spring.SetConfigFloat("unitSunMult", value)
              Spring.SendCommands("luarules updatesun")
              Spring.SendCommands("luarules GlassUpdateSun")
          end,
        },
        { id = "unitExposureMult", group = "dev", name = widgetOptionColor .. "   "..texts.option.unitExposureMult, type = "slider", min = 0.5, max = 2, step = 0.01, value = Spring.GetConfigFloat("unitExposureMult", 1.0), description = "",
          onchange = function(i, value)
              Spring.SetConfigFloat("unitExposureMult", value)
              Spring.SendCommands("luarules updatesun")
              Spring.SendCommands("luarules GlassUpdateSun")
          end,
        },
        { id = "modelGamma", group = "dev", name = widgetOptionColor .. "   "..texts.option.modelGamma, type = "slider", min = 0.8, max = 2.4, step = 0.05, value = Spring.GetConfigFloat("modelGamma", 1.0), description = "",
          onchange = function(i, value)
              Spring.SetConfigFloat("modelGamma", value)
              Spring.SendCommands("luarules updatesun")
              Spring.SendCommands("luarules GlassUpdateSun")
          end,
        },
        { id = "tonemapDefaults", group = "dev", name = widgetOptionColor .. "   "..texts.option.tonemapDefaults, type = "bool", value = GetWidgetToggleValue("Unit Reclaimer"), description = "",
          onchange = function(i, value)
              Spring.SetConfigFloat("tonemapA", 3.41) --4.8
              Spring.SetConfigFloat("tonemapB", 1.18) --0.8
              Spring.SetConfigFloat("tonemapC", 3.45) --3.35
              Spring.SetConfigFloat("tonemapD", 0.88) --1.0
              Spring.SetConfigFloat("tonemapE", 0.99) --1.15
              Spring.SetConfigFloat("envAmbient", 0.3)
              Spring.SetConfigFloat("unitSunMult", 1.65) --1.35
              Spring.SetConfigFloat("unitExposureMult", 1.03) --1.0
              Spring.SetConfigFloat("modelGamma", 1.05) --1.0
              options[getOptionByID('tonemapA')].value = Spring.GetConfigFloat("tonemapA")
              options[getOptionByID('tonemapB')].value = Spring.GetConfigFloat("tonemapB")
              options[getOptionByID('tonemapC')].value = Spring.GetConfigFloat("tonemapC")
              options[getOptionByID('tonemapD')].value = Spring.GetConfigFloat("tonemapD")
              options[getOptionByID('tonemapE')].value = Spring.GetConfigFloat("tonemapE")
              options[getOptionByID('envAmbient')].value = Spring.GetConfigFloat("envAmbient")
              options[getOptionByID('unitSunMult')].value = Spring.GetConfigFloat("unitSunMult")
              options[getOptionByID('unitExposureMult')].value = Spring.GetConfigFloat("unitExposureMult")
              options[getOptionByID('modelGamma')].value = Spring.GetConfigFloat("modelGamma")
              Spring.SendCommands("luarules updatesun")
              Spring.SendCommands("luarules GlassUpdateSun")
              options[getOptionByID('tonemapDefaults')].value = false
          end,
        },
        { id = "debugcolvol", group = "dev", name = texts.option.debugcolvol, type = "bool", value = false, description = "",
          onchange = function(i, value)
              Spring.SendCommands("DebugColVol " .. (value and '1' or '0'))
          end,
        },
        { id = "fog_r", group = "dev", name = texts.option.fog..widgetOptionColor .. "  "..texts.option.red, type = "slider", min = 0, max = 1, step = 0.01, value = select(1, gl.GetAtmosphere("fogColor")), description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              local fogColor = { gl.GetAtmosphere("fogColor") }
              Spring.SetAtmosphere({ fogColor = {value, fogColor[2], fogColor[3], fogColor[4]} })
          end,
        },
        { id = "fog_g", group = "dev", name = widgetOptionColor .. "   "..texts.option.green, type = "slider", min = 0, max = 1, step = 0.01, value = select(2, gl.GetAtmosphere("fogColor")), description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              local fogColor = { gl.GetAtmosphere("fogColor") }
              Spring.SetAtmosphere({ fogColor = {fogColor[1], value, fogColor[3], fogColor[4]} })
          end,
        },
        { id = "fog_b", group = "dev", name = widgetOptionColor .. "   "..texts.option.blue, type = "slider", min = 0, max = 1, step = 0.01, value = select(3, gl.GetAtmosphere("fogColor")), description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              local fogColor = { gl.GetAtmosphere("fogColor") }
              Spring.SetAtmosphere({ fogColor = {fogColor[1], fogColor[2], value, fogColor[4]} })
          end,
        },
        { id = "fog_color_reset", group = "dev", name = widgetOptionColor .. "   "..texts.option.fog_color_reset, type = "bool", value = false, description = '',
          onload = function(i)
          end,
          onchange = function(i, value)
              options[getOptionByID('fog_r')].value = defaultFog.fogColor[1]
              options[getOptionByID('fog_g')].value = defaultFog.fogColor[2]
              options[getOptionByID('fog_b')].value = defaultFog.fogColor[3]
              options[getOptionByID('fog_color_reset')].value = false
              Spring.SetAtmosphere({ fogColor = defaultFog.fogColor })
              Spring.Echo('resetted map fog color defaults')
          end,
        },
        --{id="debugdrawai", group="dev", name="Debug draw AI", type="bool", value=false, description="",	-- seems only for engine AI
        --  onchange=function(i, value)
        --	  Spring.SendCommands("DebugDrawAI "..(value and '1' or '0'))
        --  end,
        --},

        { id = "map_voidwater", group = "dev", name = texts.option.map_voidwater, type = "bool", value = false, description = "",
          onload = function(i)
              options[i].value = gl.GetMapRendering("voidWater")
          end,
          onchange = function(i, value)
              Spring.SetMapRenderingParams({ voidWater = value })
          end,
        },
        { id = "map_voidground", group = "dev", name = texts.option.map_voidground, type = "bool", value = false, description = "",
          onload = function(i)
              options[i].value = gl.GetMapRendering("voidGround")
          end,
          onchange = function(i, value)
              Spring.SetMapRenderingParams({ voidGround = value })
          end,
        },

        { id = "map_splatdetailnormaldiffusealpha", group = "dev", name = texts.option.map_splatdetailnormaldiffusealpha, type = "bool", value = false, description = "",
          onload = function(i)
              options[i].value = gl.GetMapRendering("splatDetailNormalDiffuseAlpha")
          end,
          onchange = function(i, value)
              Spring.SetMapRenderingParams({ splatDetailNormalDiffuseAlpha = value })
          end,
        },

        { id = "map_splattexmults_r", group = "dev", name = texts.option.map_splattexmults .. widgetOptionColor .. "   0", type = "slider", min = 0, max = 1.5, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b, a = gl.GetMapRendering("splatTexMults")
              options[i].value = r
          end,
          onchange = function(i, value)
              local r, g, b, a = gl.GetMapRendering("splatTexMults")
              Spring.SetMapRenderingParams({ splatTexMults = { value, g, b, a } })
          end,
        },
        { id = "map_splattexmults_g", group = "dev", name = widgetOptionColor .. "   1", type = "slider", min = 0, max = 1.5, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b, a = gl.GetMapRendering("splatTexMults")
              options[i].value = g
          end,
          onchange = function(i, value)
              local r, g, b, a = gl.GetMapRendering("splatTexMults")
              Spring.SetMapRenderingParams({ splatTexMults = { r, value, b, a } })
          end,
        },
        { id = "map_splattexmults_b", group = "dev", name = widgetOptionColor .. "   2", type = "slider", min = 0, max = 1.5, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b, a = gl.GetMapRendering("splatTexMults")
              options[i].value = b
          end,
          onchange = function(i, value)
              local r, g, b, a = gl.GetMapRendering("splatTexMults")
              Spring.SetMapRenderingParams({ splatTexMults = { r, g, value, a } })
          end,
        },
        { id = "map_splattexmults_a", group = "dev", name = widgetOptionColor .. "   3", type = "slider", min = 0, max = 1.5, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b, a = gl.GetMapRendering("splatTexMults")
              options[i].value = a
          end,
          onchange = function(i, value)
              local r, g, b, a = gl.GetMapRendering("splatTexMults")
              Spring.SetMapRenderingParams({ splatTexMults = { r, g, b, value } })
          end,
        },

        { id = "map_splattexacales_r", group = "dev", name = texts.option.map_splattexacales .. widgetOptionColor .. "   0", type = "slider", min = 0, max = 0.02, step = 0.0001, value = 0, description = "",
          onload = function(i)
              local r, g, b, a = gl.GetMapRendering("splatTexScales")
              options[i].value = r
          end,
          onchange = function(i, value)
              local r, g, b, a = gl.GetMapRendering("splatTexScales")
              Spring.SetMapRenderingParams({ splatTexScales = { value, g, b, a } })
          end,
        },
        { id = "map_splattexacales_g", group = "dev", name = widgetOptionColor .. "   1", type = "slider", min = 0, max = 0.02, step = 0.0001, value = 0, description = "",
          onload = function(i)
              local r, g, b, a = gl.GetMapRendering("splatTexScales")
              options[i].value = g
          end,
          onchange = function(i, value)
              local r, g, b, a = gl.GetMapRendering("splatTexScales")
              Spring.SetMapRenderingParams({ splatTexScales = { r, value, b, a } })
          end,
        },
        { id = "map_splattexacales_b", group = "dev", name = widgetOptionColor .. "   2", type = "slider", min = 0, max = 0.02, step = 0.0001, value = 0, description = "",
          onload = function(i)
              local r, g, b, a = gl.GetMapRendering("splatTexScales")
              options[i].value = b
          end,
          onchange = function(i, value)
              local r, g, b, a = gl.GetMapRendering("splatTexScales")
              Spring.SetMapRenderingParams({ splatTexScales = { r, g, value, a } })
          end,
        }, { id = "map_splattexacales_a", group = "dev", name = widgetOptionColor .. "   3", type = "slider", min = 0, max = 0.02, step = 0.0001, value = 0, description = "",
             onload = function(i)
                 local r, g, b, a = gl.GetMapRendering("splatTexScales")
                 options[i].value = a
             end,
             onchange = function(i, value)
                 local r, g, b, a = gl.GetMapRendering("splatTexScales")
                 Spring.SetMapRenderingParams({ splatTexScales = { r, g, b, value } })
             end,
        },


        { id = "GroundShadowDensity", group = "dev", name = texts.option.GroundShadowDensity .. widgetOptionColor .. "  ", type = "slider", min = 0, max = 1.5, step = 0.001, value = 0, description = "",
          onload = function(i)
              local groundshadowDensity = gl.GetSun("shadowDensity", "ground")
              options[i].value = groundshadowDensity
          end,
          onchange = function(i, value)
              Spring.SetSunLighting({ groundShadowDensity = value })
              Spring.SendCommands("luarules updatesun")
          end,
        },

        { id = "UnitShadowDensity", group = "dev", name = texts.option.UnitShadowDensity .. widgetOptionColor .. "  ", type = "slider", min = 0, max = 1.5, step = 0.001, value = 0, description = "",
          onload = function(i)
              local groundshadowDensity = gl.GetSun("shadowDensity", "unit")
              options[i].value = groundshadowDensity
          end,
          onchange = function(i, value)
              Spring.SetSunLighting({ modelShadowDensity = value })
              Spring.SendCommands("luarules updatesun")
          end,
        },

        { id = "color_groundambient_r", group = "dev", name = texts.option.color_groundambient .. widgetOptionColor .. "  "..texts.option.red, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("ambient")
              options[i].value = r
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("ambient")
              Spring.SetSunLighting({ groundAmbientColor = { value, g, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_groundambient_g", group = "dev", name = widgetOptionColor .. "   "..texts.option.green, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("ambient")
              options[i].value = g
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("ambient")
              Spring.SetSunLighting({ groundAmbientColor = { r, value, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_groundambient_b", group = "dev", name = widgetOptionColor .. "   "..texts.option.blue, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("ambient")
              options[i].value = b
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("ambient")
              Spring.SetSunLighting({ groundAmbientColor = { r, g, value } })
              Spring.SendCommands("luarules updatesun")
          end,
        },

        { id = "color_grounddiffuse_r", group = "dev", name = texts.option.color_grounddiffuse .. widgetOptionColor .. "  "..texts.option.red, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("diffuse")
              options[i].value = r
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("diffuse")
              Spring.SetSunLighting({ groundDiffuseColor = { value, g, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_grounddiffuse_g", group = "dev", name = widgetOptionColor .. "   "..texts.option.green, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("diffuse")
              options[i].value = g
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("diffuse")
              Spring.SetSunLighting({ groundDiffuseColor = { r, value, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_grounddiffuse_b", group = "dev", name = widgetOptionColor .. "   "..texts.option.blue, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("diffuse")
              options[i].value = b
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("diffuse")
              Spring.SetSunLighting({ groundDiffuseColor = { r, g, value } })
              Spring.SendCommands("luarules updatesun")
          end,
        },

        { id = "color_groundspecular_r", group = "dev", name = texts.option.color_groundspecular .. widgetOptionColor .. "  "..texts.option.red, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("specular")
              options[i].value = r
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("specular")
              Spring.SetSunLighting({ groundSpecularColor = { value, g, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_groundspecular_g", group = "dev", name = widgetOptionColor .. "   "..texts.option.green, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("specular")
              options[i].value = g
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("specular")
              Spring.SetSunLighting({ groundSpecularColor = { r, value, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_groundspecular_b", group = "dev", name = widgetOptionColor .. "   "..texts.option.blue, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("specular")
              options[i].value = b
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("specular")
              Spring.SetSunLighting({ groundSpecularColor = { r, g, value } })
              Spring.SendCommands("luarules updatesun")
          end,
        },


        { id = "color_unitambient_r", group = "dev", name = texts.option.color_unitambient .. widgetOptionColor .. "  "..texts.option.red, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("ambient", "unit")
              options[i].value = r
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("ambient", "unit")
              Spring.SetSunLighting({ unitAmbientColor = { value, g, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_unitambient_g", group = "dev", name = widgetOptionColor .. "   "..texts.option.green, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("ambient", "unit")
              options[i].value = g
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("ambient", "unit")
              Spring.SetSunLighting({ unitAmbientColor = { r, value, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_unitambient_b", group = "dev", name = widgetOptionColor .. "   "..texts.option.blue, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("ambient", "unit")
              options[i].value = b
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("ambient", "unit")
              Spring.SetSunLighting({ unitAmbientColor = { r, g, value } })
              Spring.SendCommands("luarules updatesun")
          end,
        },

        { id = "color_unitdiffuse_r", group = "dev", name = texts.option.color_unitdiffuse .. widgetOptionColor .. "  "..texts.option.red, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("diffuse", "unit")
              options[i].value = r
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("diffuse", "unit")
              Spring.SetSunLighting({ unitDiffuseColor = { value, g, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_unitdiffuse_g", group = "dev", name = widgetOptionColor .. "   "..texts.option.green, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("diffuse", "unit")
              options[i].value = g
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("diffuse", "unit")
              Spring.SetSunLighting({ unitDiffuseColor = { r, value, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_unitdiffuse_b", group = "dev", name = widgetOptionColor .. "   "..texts.option.blue, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("diffuse", "unit")
              options[i].value = b
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("diffuse", "unit")
              Spring.SetSunLighting({ unitDiffuseColor = { r, g, value } })
              Spring.SendCommands("luarules updatesun")
          end,
        },

        { id = "color_unitspecular_r", group = "dev", name = texts.option.color_unitspecular .. widgetOptionColor .. "  "..texts.option.red, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("specular", "unit")
              options[i].value = r
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("specular", "unit")
              Spring.SetSunLighting({ unitSpecularColor = { value, g, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_unitspecular_g", group = "dev", name = widgetOptionColor .. "   "..texts.option.green, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("specular", "unit")
              options[i].value = g
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("specular", "unit")
              Spring.SetSunLighting({ unitSpecularColor = { r, value, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "color_unitspecular_b", group = "dev", name = widgetOptionColor .. "   "..texts.option.blue, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetSun("specular", "unit")
              options[i].value = b
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetSun("specular", "unit")
              Spring.SetSunLighting({ unitSpecularColor = { r, g, value } })
              Spring.SendCommands("luarules updatesun")
          end,
        },

        { id = "suncolor_r", group = "dev", name = "Sun" .. widgetOptionColor .. "  "..texts.option.red, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetAtmosphere("sunColor")
              options[i].value = r
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetAtmosphere("sunColor")
              Spring.SetAtmosphere({ sunColor = { value, g, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "suncolor_g", group = "dev", name = widgetOptionColor .. "   "..texts.option.green, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetAtmosphere("sunColor")
              options[i].value = g
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetAtmosphere("sunColor")
              Spring.SetAtmosphere({ sunColor = { r, value, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "suncolor_b", group = "dev", name = widgetOptionColor .. "   "..texts.option.blue, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetAtmosphere("sunColor")
              options[i].value = b
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetAtmosphere("sunColor")
              Spring.SetAtmosphere({ sunColor = { r, g, value } })
              Spring.SendCommands("luarules updatesun")
          end,
        },

        { id = "skycolor_r", group = "dev", name = texts.option.skycolor .. widgetOptionColor .. "  "..texts.option.red, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetAtmosphere("skyColor")
              options[i].value = r
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetAtmosphere("skyColor")
              Spring.SetAtmosphere({ skyColor = { value, g, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "skycolor_g", group = "dev", name = widgetOptionColor .. "   "..texts.option.green, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetAtmosphere("skyColor")
              options[i].value = g
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetAtmosphere("skyColor")
              Spring.SetAtmosphere({ skyColor = { r, value, b } })
              Spring.SendCommands("luarules updatesun")
          end,
        },
        { id = "skycolor_b", group = "dev", name = widgetOptionColor .. "   "..texts.option.blue, type = "slider", min = 0, max = 1, step = 0.001, value = 0, description = "",
          onload = function(i)
              local r, g, b = gl.GetAtmosphere("skyColor")
              options[i].value = b
          end,
          onchange = function(i, value)
              local r, g, b = gl.GetAtmosphere("skyColor")
              Spring.SetAtmosphere({ skyColor = { r, g, value } })
              Spring.SendCommands("luarules updatesun")
          end,
        },

        { id = "sunlighting_reset", group = "dev", name = texts.option.sunlighting_reset, type = "bool", value = false, description = texts.option.sunlighting_reset_descr,
          onload = function(i)
          end,
          onchange = function(i, value)
              options[getOptionByID('sunlighting_reset')].value = false
              -- just so that map/model lighting gets updated
              Spring.SetSunLighting(defaultSunLighting)
              --customMapSunPos[Game.mapName] = nil
              Spring.Echo('resetted ground/unit coloring')
              init()
          end,
        },
    }

    -- air absorption does nothing on 32 bit engine version
    if not engine64 then
        options[getOptionByID('sndairabsorption')] = nil
    end

    -- reset tonemap defaults (only once)
    if not resettedTonemapDefault then
        local optionID = getOptionByID('tonemapDefaults')
        options[optionID].value = true
        applyOptionValue(optionID)
        resettedTonemapDefault = true
    end

    if not string.find(string.upper(Game.gameVersion), "$VERSION") then
        options[getOptionByID('restart')] = nil
    end

    -- dynamic sun settings applied by gadget: disable user controls
    if Spring.GetModOptions and (tonumber(Spring.GetModOptions().night) or 0) ~= 0 then
        options[getOptionByID('shadows_opacity')] = nil
        options[getOptionByID('sun_y')] = nil
        options[getOptionByID('sun_x')] = nil
        options[getOptionByID('sun_z')] = nil
        options[getOptionByID('sun_reset')] = nil
    end

    if not scavengersAIEnabled and (Spring.GetModOptions and (tonumber(Spring.GetModOptions().scavengers) or 0) ~= 0) then
        options[getOptionByID('scav_voicenotifs')] = nil
        options[getOptionByID('scav_messages')] = nil
    end

    -- set lowest quality shadows for Intel GPU (they eat fps but dont show)
    --if Platform ~= nil and Platform.gpuVendor == 'Intel' then
    --	options[getOptionByID('shadowslider')] = nil
    --	options[getOptionByID('shadows_opacity')] = nil
    --end

    -- add fonts
    if getOptionByID('font') then
        local fonts = {}
        local fontsFull = {}
        local fontsn = {}
        local files = VFS.DirList('fonts', '*')
        fontOption = {}
        for k, file in ipairs(files) do
            local name = string.sub(file, 7)
            local ext = string.sub(name, string.len(name) - 2)
            if name ~= 'FreeSansBold.otf' and ext == 'otf' or ext == 'ttf' then
                name = string.sub(name, 1, string.len(name) - 4)
                if not fontsn[name:lower()] then
                    fonts[#fonts + 1] = name
                    fontsFull[#fontsFull + 1] = string.sub(file, 7)
                    fontsn[name:lower()] = true
                    local fontScale = (0.5 + (vsx * vsy / 5700000))
                    fontOption[#fonts] = gl.LoadFont("fonts/" .. fontsFull[#fontsFull], 20 * fontScale, 5 * fontScale, 1.5)
                end
            end
        end

        options[getOptionByID('font')].options = fonts
        options[getOptionByID('font')].optionsFont = fontsFull
        local fname = Spring.GetConfigString("bar_font", "Kelson Sans Regular.otf"):lower() --Poppins-Regular.otf
        options[getOptionByID('font')].value = getSelectKey(getOptionByID('font'), string.sub(fname, 1, string.len(fname) - 4))

        options[getOptionByID('font2')].options = fonts
        options[getOptionByID('font2')].optionsFont = fontsFull
        local fname = Spring.GetConfigString("bar_font2", "WatchtowerMiddle-LM6Z.otf"):lower() --Exo2-SemiBold.otf
        options[getOptionByID('font2')].value = getSelectKey(getOptionByID('font2'), string.sub(fname, 1, string.len(fname) - 4))
    end

    -- set sun minimal height
    if getOptionByID('sun_y') then
        if select(2, gl.GetSun("pos")) < options[getOptionByID('sun_y')].min then
            Spring.SetSunDirection(select(1, gl.GetSun("pos")), options[getOptionByID('sun_y')].min, select(3, gl.GetSun("pos")))
        end
    end

    -- set minimal shadow opacity
    if getOptionByID('shadows_opacity') then
        if gl.GetSun("shadowDensity") < options[getOptionByID('shadows_opacity')].min then
            Spring.SetSunLighting({ groundShadowDensity = options[getOptionByID('shadows_opacity')].min, modelShadowDensity = options[getOptionByID('shadows_opacity')].min })
        end
    end

    -- fsaa is deprecated in 104.x
    if tonumber(Spring.GetConfigInt("FSAALevel", 0)) > 0 then
        local fsaa = tonumber(Spring.GetConfigInt("FSAALevel", 0))
        if fsaa > 8 then
            fsaa = 8
        end
        Spring.SetConfigInt("MSAALevel", fsaa)
        Spring.SetConfigInt("FSAALevel", 0)
    end

    -- reduce options for potatoes
    if isPotatoGpu or isPotatoCpu then

        local id = getOptionByID('shadowslider')
        options[id].steps = { 0, 2048, 3072 }
        if options[id].value > 3072 then
            options[id].value = 3072
            options[id].onchange(id, options[id].value)
        end

        if isPotatoGpu then
            options[getOptionByID('msaa')].max = 2
            local id = getOptionByID('ssao')
            if id and GetWidgetToggleValue(options[id].widget) then
                widgetHandler:DisableWidget(options[id].widget)
            end
            options[id] = nil
            options[getOptionByID('ssao_strength')] = nil

            local id = getOptionByID('bloom')
            if id and GetWidgetToggleValue(options[id].widget) then
                widgetHandler:DisableWidget(options[id].widget)
            end
            options[id] = nil
            options[getOptionByID('bloom_brightness')] = nil

            local id = getOptionByID('guishader')
            if id and GetWidgetToggleValue(options[id].widget) then
                widgetHandler:DisableWidget(options[id].widget)
            end
            options[id] = nil
            options[getOptionByID('guishaderintensity')] = nil

            local id = getOptionByID('dof')
            if id and GetWidgetToggleValue(options[id].widget) then
                widgetHandler:DisableWidget(options[id].widget)
            end
            options[id] = nil
            options[getOptionByID('dof_autofocus')] = nil
            options[getOptionByID('dof_fstop')] = nil

            local id = getOptionByID('clouds')
            if id and GetWidgetToggleValue(options[id].widget) then
                widgetHandler:DisableWidget(options[id].widget)
            end
            options[id] = nil
            options[getOptionByID('could_opacity')] = nil
        end
    end

    -- remove engine particles if nano beams are enabled
    if options[getOptionByID('nanoeffect')] and options[getOptionByID('nanoeffect')].value == 1 then
        Spring.SetConfigInt("MaxNanoParticles", 0)
    else
        -- set min engine particles
        if Spring.GetConfigInt("MaxNanoParticles") < options[getOptionByID('nanoparticles')].min then
            Spring.SetConfigInt("MaxNanoParticles", options[getOptionByID('nanoparticles')].min)
        end
    end

    -- loads values via stored game config in luaui/configs
    loadAllWidgetData()

    -- while we have set config-ints, that isnt enough to have these settings applied ingame
    if savedConfig and Spring.GetGameFrame() == 0 then
        for k, v in pairs(savedConfig) do
            if getOptionByID(k) then
                applyOptionValue(getOptionByID(k))
            end
        end
        changesRequireRestart = false
    end

    -- detect AI
    local aiDetected = false
    local t = Spring.GetTeamList()
    for _, teamID in ipairs(t) do
        if select(4, Spring.GetTeamInfo(teamID, false)) then
            aiDetected = true
        end
    end
    if not aiDetected then
        options[getOptionByID('commandsfxfilterai')] = nil
    end

    if #supportedResolutions < 2 then
        options[getOptionByID('resolution')] = nil
    else
        for id, res in pairs(options[getOptionByID('resolution')].options) do
            if res == vsx .. ' x ' .. vsy then
                options[getOptionByID('resolution')].value = id
                break
            end
        end
    end

    -- add sound notification widget sound toggle options
    if widgetHandler.knownWidgets["Notifications"] then
        local soundList
        if WG['notifications'] ~= nil then
            soundList = WG['notifications'].getSoundList()
        elseif widgetHandler.configData["Notifications"] ~= nil and widgetHandler.configData["Notifications"].soundList ~= nil then
            soundList = widgetHandler.configData["Notifications"].soundList
        end
        if type(soundList) == 'table' then
            local newOptions = {}
            local count = 0
            for i, option in pairs(options) do
                count = count + 1
                newOptions[count] = option
                if option.id == 'notifications_playtrackedplayernotifs' then
                    for k, v in pairs(soundList) do
                        count = count + 1
                        newOptions[count] = { id = "notifications_notif_" .. v[1], group = "notif", basic = true, name = widgetOptionColor .. "   " .. v[1], type = "bool", value = v[2], description = v[3],
                                              onchange = function(i, value)
                                                  saveOptionValue('Notifications', 'notifications', 'setSound' .. v[1], { 'soundList' }, value)
                                              end,
                            --onclick = function()
                            --	if WG['notifications'] ~= nil and WG['notifications'].playNotif then
                            --		WG['notifications'].playNotif(v[1])
                            --	end
                            --end,
                        }
                    end
                end
            end
            options = newOptions
        end
    else
        options[getOptionByID('notifications')] = nil
        options[getOptionByID('notifications_volume')] = nil
        options[getOptionByID('notifications_playtrackedplayernotifs')] = nil
    end

    if widgetHandler.knownWidgets["AdvPlayersList Music Player"] then
        local tracksConfig = {}
        if WG['music'] ~= nil and WG['music'].getTracksConfig ~= nil then
            tracksConfig = WG['music'].getTracksConfig()
        elseif widgetHandler.configData["AdvPlayersList Music Player"] ~= nil and widgetHandler.configData["AdvPlayersList Music Player"].tracksConfig ~= nil then
            tracksConfig = widgetHandler.configData["AdvPlayersList Music Player"].tracksConfig
        end
        local musicList = {}
        if type(tracksConfig) == 'table' then
            local tracksConfigSorted = {}
            for n in pairs(tracksConfig) do
                table.insert(tracksConfigSorted, n)
            end
            table.sort(tracksConfigSorted)

            for i, track in ipairs(tracksConfigSorted) do
                local params = tracksConfig[track]
                if params[2] == 'peace' then
                    musicList[#musicList + 1] = { track, params[1], params[2] }
                end
            end
            for i, track in ipairs(tracksConfigSorted) do
                local params = tracksConfig[track]
                if params[2] == 'war' then
                    musicList[#musicList + 1] = { track, params[1], params[2] }
                end
            end
        end
        local newOptions = {}
        local count = 0
        for i, option in pairs(options) do
            count = count + 1
            newOptions[count] = option
            if option.id == 'loadscreen_music' then
                for k, v in pairs(musicList) do
                    count = count + 1
                    local trackName = string.gsub(v[1], "sounds/music/peace/", "")
                    trackName = string.gsub(trackName, "sounds/music/war/", "")
                    trackName = string.gsub(trackName, ".ogg", "")
                    local optionName, numLines = font:WrapText(trackName, (screenWidth * 0.37)*widgetScale)
                    if numLines > 1 then
                        local l = lines(optionName)
                        if string.sub(l[1], string.len(l[1])) == ' ' then	-- check if line ends with a space
                            l[1] = string.sub(l[1], 1, string.len(l[1])-1)	-- strip last character
                        end
                        optionName = l[1]..'...'
                    end
                    newOptions[count] = { id = "music_track" .. v[1], group = "snd", basic = true, name = musicOptionColor .. optionName, type = "bool", value = v[2], description = v[3] .. '\n\n' .. trackName,
                                          onchange = function(i, value)
                                              if not WG['music'] and widgetHandler.configData["AdvPlayersList Music Player"] ~= nil and widgetHandler.configData["AdvPlayersList Music Player"].tracksConfig ~= nil then
                                                  if widgetHandler.configData["AdvPlayersList Music Player"].tracksConfig[ v[1] ] then
                                                      widgetHandler.configData["AdvPlayersList Music Player"].tracksConfig[ v[1] ][1] = value
                                                  end
                                              else
                                                  saveOptionValue('AdvPlayersList Music Player', 'music', 'setTrack' .. v[1], { 'tracksConfig' }, value)
                                              end
                                          end,
                                          onclick = function()
                                              if WG['music'] ~= nil and WG['music'].playTrack then
                                                  WG['music'].playTrack(v[1])
                                              end
                                          end,
                    }
                end
            end
        end
        options = newOptions
    end

    if not widgetHandler.knownWidgets["Player-TV"] then
        options[getOptionByID('playertv_countdown')] = nil
    end

    -- cursors
    if (WG['cursors'] == nil) then
        options[getOptionByID('cursor')] = nil
        options[getOptionByID('cursorsize')] = nil
    else
        local cursorsets = {}
        local cursor = 1
        local cursoroption
        cursorsets = WG['cursors'].getcursorsets()
        local cursorname = WG['cursors'].getcursor()
        for i, c in pairs(cursorsets) do
            if c == cursorname then
                cursor = i
                break
            end
        end
        if getOptionByID('cursor') then
            options[getOptionByID('cursor')].options = cursorsets
            options[getOptionByID('cursor')].value = cursor
        end
        if WG['cursors'].getsizemult then
            options[getOptionByID('cursorsize')].value = WG['cursors'].getsizemult()
        else
            options[getOptionByID('cursorsize')] = nil
        end
    end
    if widgetHandler.knownWidgets["SSAO"] == nil then
        options[getOptionByID('ssao')] = nil
        options[getOptionByID('ssao_strength')] = nil
        options[getOptionByID('ssao_radius')] = nil
    end
    if widgetHandler.knownWidgets["Bloom Shader"] == nil then
        options[getOptionByID('bloombrightness')] = nil
        options[getOptionByID('bloomsize')] = nil
        options[getOptionByID('bloomquality')] = nil
    end
    if widgetHandler.knownWidgets["Bloom Shader Deferred"] == nil then
        options[getOptionByID('bloomdeferredbrightness')] = nil
        options[getOptionByID('bloomdeferredsize')] = nil
        options[getOptionByID('bloomdeferredquality')] = nil
    end

    if WG['healthbars'] == nil then
        options[getOptionByID('healthbarsscale')] = nil
    elseif WG['healthbars'].getScale ~= nil then
        options[getOptionByID('healthbarsscale')].value = WG['healthbars'].getScale()
    end

    if WG['smartselect'] == nil then
        options[getOptionByID('smartselect_includebuildings')] = nil
        options[getOptionByID('smartselect_includebuilders')] = nil
    else
        options[getOptionByID('smartselect_includebuildings')].value = WG['smartselect'].getIncludeBuildings()
        options[getOptionByID('smartselect_includebuilders')].value = WG['smartselect'].getIncludeBuilders()
    end

    if WG['snow'] ~= nil and WG['snow'].getSnowMap ~= nil then
        options[getOptionByID('snowmap')].value = WG['snow'].getSnowMap()
    end

    if WG['darkenmap'] == nil then
        options[getOptionByID('darkenmap')] = nil
        options[getOptionByID('darkenmap_darkenfeatures')] = nil
    else
        options[getOptionByID('darkenmap')].value = WG['darkenmap'].getMapDarkness()
        options[getOptionByID('darkenmap_darkenfeatures')].value = WG['darkenmap'].getDarkenFeatures()
    end

    -- not sure if needed: remove vsync option when its done by monitor (freesync/gsync) -> config value is set as 'x'
    if Spring.GetConfigInt("VSync", 1) == 'x' then
        options[getOptionByID('vsync')] = nil
        options[getOptionByID('vsync_spec')] = nil
        options[getOptionByID('vsync_level')] = nil
    else
        -- doing this in order to detect if vsync is actually on due to the only when spectator setting
        local id = getOptionByID('vsync')
        options[id].onchange(id, options[id].value)
    end


    if not widgetHandler.knownWidgets["Commander Name Tags"] then
        options[getOptionByID('nametags_icon')] = nil
    end

    if WG['playercolorpalette'] == nil or WG['playercolorpalette'].getSameTeamColors == nil then
        options[getOptionByID('sameteamcolors')] = nil
    end

    if WG['advplayerlist_api'] == nil or WG['advplayerlist_api'].GetLockTransitionTime == nil then
        options[getOptionByID('lockcamera_transitiontime')] = nil
    end

    -- disable options when widget isnt available
    if widgetHandler.knownWidgets["Outline"] == nil then
        options[getOptionByID('outline')] = nil
        options[getOptionByID("outline_width")] = nil
        options[getOptionByID("outline_mult")] = nil
        options[getOptionByID("outline_color")] = nil
    end

    if widgetHandler.knownWidgets["Contrast Adaptive Sharpen"] == nil then
        options[getOptionByID("cas_sharpness")] = nil
    end

    if widgetHandler.knownWidgets["Fancy Selected Units"] == nil then
        options[getOptionByID('fancyselectedunits')] = nil
        options[getOptionByID("fancyselectedunits_opacity")] = nil
        options[getOptionByID("fancyselectedunits_baseopacity")] = nil
        options[getOptionByID("fancyselectedunits_teamcoloropacity")] = nil
    end

    if widgetHandler.knownWidgets["Defense Range"] == nil then
        options[getOptionByID('defrange')] = nil
        options[getOptionByID("defrange_allyair")] = nil
        options[getOptionByID("defrange_allyground")] = nil
        options[getOptionByID("defrange_allynuke")] = nil
        options[getOptionByID("defrange_enemyair")] = nil
        options[getOptionByID("defrange_enemyground")] = nil
        options[getOptionByID("defrange_enemynuke")] = nil
    end

    if widgetHandler.knownWidgets["Auto Group"] == nil then
        options[getOptionByID("autogroup_immediate")] = nil
    end

    if widgetHandler.knownWidgets["Highlight Selected Units"] == nil then
        options[getOptionByID('highlightselunits')] = nil
        options[getOptionByID("highlightselunits_opacity")] = nil
        options[getOptionByID("highlightselunits_shader")] = nil
        options[getOptionByID("highlightselunits_teamcolor")] = nil
    end

    if widgetHandler.knownWidgets["Light Effects"] == nil or widgetHandler.knownWidgets["Deferred rendering"] == nil then
        options[getOptionByID('lighteffects')] = nil
        options[getOptionByID("lighteffects_brightness")] = nil
        options[getOptionByID("lighteffects_laserbrightness")] = nil
        options[getOptionByID("lighteffects_radius")] = nil
        options[getOptionByID("lighteffects_laserradius")] = nil
        options[getOptionByID("lighteffects_nanolaser")] = nil
    end

    if widgetHandler.knownWidgets["TeamPlatter"] == nil then
        options[getOptionByID('teamplatter_opacity')] = nil
        options[getOptionByID('teamplatter_skipownunits')] = nil
    end

    if widgetHandler.knownWidgets["EnemySpotter"] == nil then
        options[getOptionByID('enemyspotter_opacity')] = nil
        options[getOptionByID('enemyspotter_highlight')] = nil
    end

    local processedOptions = {}
    local processedOptionsCount = 0
    local insert = true
    for i, option in pairs(options) do
        insert = true
        if option.type == 'slider' and not option.steps then
            if type(option.value) ~= 'number' then
                option.value = option.min
            end
            if option.value < option.min then
                option.value = option.min
            end
            if option.value > option.max then
                option.value = option.max
            end
        end
        if option.widget ~= nil and widgetHandler.knownWidgets[option.widget] == nil then
            insert = false
        end
        if insert then
            processedOptionsCount = processedOptionsCount + 1
            processedOptions[processedOptionsCount] = option
        end
    end
    options = processedOptions

    if windowList then
        gl.DeleteList(windowList)
    end
    windowList = gl.CreateList(DrawWindow)
end

function deletePreset(name)
    Spring.Echo('deleted preset:  ' .. name)
    customPresets[name] = nil
    presets[name] = nil
    local newPresetNames = {}
    for _, presetName in ipairs(presetNames) do
        if presetName ~= name then
            table.insert(newPresetNames, presetName)
        end
    end
    presetNames = newPresetNames
    options[getOptionByID('preset')].options = presetNames
    if windowList then
        gl.DeleteList(windowList)
    end
    windowList = gl.CreateList(DrawWindow)
end

function savePreset(name)
    if name == nil then
        name = 'custom'
        local i = 1
        while customPresets[name] ~= nil do
            i = i + 1
            name = 'custom' .. i
        end
    end
    if presets[name] ~= nil then
        Spring.Echo("preset '" .. name .. "' already exists")
    else
        local preset = {}
        for optionID, _ in pairs(presets['lowest']) do
            if options[getOptionByID(optionID)] ~= nil then
                preset[optionID] = options[getOptionByID(optionID)].value
            end
        end
        customPresets[name] = preset
        presets[name] = preset
        table.insert(presetNames, name)
        options[getOptionByID('preset')].options = presetNames
        Spring.Echo('saved preset: ' .. name)
        if windowList then
            gl.DeleteList(windowList)
        end
        windowList = gl.CreateList(DrawWindow)
    end
end

function checkResolution()
    -- resize resolution if is larger than screen resolution
    wsx, wsy, wpx, wpy = Spring.GetWindowGeometry()
    ssx, ssy, spx, spy = Spring.GetScreenGeometry()
    if wsx > ssx or wsy > ssy then
        if tonumber(Spring.GetConfigInt("Fullscreen", 1) or 1) == 1 then
            Spring.SendCommands("Fullscreen 0")
        else
            Spring.SendCommands("Fullscreen 1")
        end
        Spring.SetConfigInt("XResolution", tonumber(ssx))
        Spring.SetConfigInt("YResolution", tonumber(ssy))
        Spring.SetConfigInt("XResolutionWindowed", tonumber(ssx))
        Spring.SetConfigInt("YResolutionWindowed", tonumber(ssy))
        if tonumber(Spring.GetConfigInt("Fullscreen", 1) or 1) == 1 then
            Spring.SendCommands("Fullscreen 0")
        else
            Spring.SendCommands("Fullscreen 1")
        end
    end
end

function widget:PlayerChanged(playerID)
    local prevIsSpec = isSpec
    isSpec = Spring.GetSpectatingState()
    if isSpec and isSpec ~= prevIsSpec and vsyncEnabled and vsyncOnlyForSpec then
        local id = getOptionByID('vsync')
        options[id].onchange(id, options[id].value)
    end
end

function widget:UnsyncedHeightMapUpdate(x1, z1, x2, z2)
    if not waterDetected and Spring.GetGameFrame() > 30 then
        if heightmapChangeClock == nil then
            heightmapChangeClock = os_clock()
        end
        heightmapChangeBuffer[#heightmapChangeBuffer + 1] = { x1 * 8, z1 * 8, x2 * 8, z2 * 8 }
    end
end

function detectWater()
    for x = 1, Game.mapSizeX do
        for z = 1, Game.mapSizeZ do
            if spGetGroundHeight(x, z) <= 0 then
                waterDetected = true
                Spring.SendCommands("water " .. desiredWaterValue)
                break
            end
        end
        if waterDetected then
            break
        end
    end
end

function widget:Initialize()

    if WG['lang'] then
        texts = WG['lang'].getText('options')
    end

    widget:ViewResize()

    prevShow = show

    if firstlaunchsetupDone == false then
        firstlaunchsetupDone = true

        Spring.Echo('First time setup:  done')
        Spring.SetConfigFloat("snd_airAbsorption", 0.35)

        -- Set lower defaults for potato systems
        if gpuMem and gpuMem < 3300 then
            Spring.SetConfigInt("MSAALevel", 2)
        end
        if isPotatoGpu then
            Spring.SendCommands("water 0")
            Spring.SetConfigInt("Water", 0)

            Spring.SendCommands("advmapshading 0")
            Spring.SendCommands("Shadows 0 1024")
            Spring.SetConfigInt("Shadows", 0)
            Spring.SetConfigInt("ShadowMapSize", 1024)
            Spring.SetConfigInt("MSAALevel", 0)
            Spring.SetConfigFloat("ui_opacity", 0.66)	-- set to be more opaque cause guishader isnt availible
        else
            Spring.SendCommands("water 4")
            Spring.SetConfigInt("Water", 4)
        end

        local minMaxparticles = 12000
        if tonumber(Spring.GetConfigInt("MaxParticles", 1) or 0) < minMaxparticles then
            Spring.SetConfigInt("MaxParticles", minMaxparticles)
            Spring.Echo('First time setup:  setting MaxParticles config value to ' .. minMaxparticles)
        end
    end

    -- Sets necessary spring configuration parameters, so shaded units look the way they should
    --Spring.SetConfigInt("CubeTexGenerateMipMaps", 1)
    --Spring.SetConfigInt("CubeTexSizeReflection", 2048)

    if Spring.GetGameFrame() == 0 then
        detectWater()

        -- set vsync
        local vsync = 0
        if vsyncEnabled and (not isSpec or vsyncOnlyForSpec) then
            vsync = vsyncLevel
        end
        Spring.SetConfigInt("VSync", vsync)
    end
    if not waterDetected then
        Spring.SendCommands("water 0")
    end

    Spring.SetConfigFloat("CamTimeFactor", 1)

    Spring.SetConfigString("InputTextGeo", "0.35 0.72 0.03 0.04")    -- input chat position posX, posY, ?, ?

    if Spring.GetGameFrame() == 0 then
        -- set minimum particle amount
        if tonumber(Spring.GetConfigInt("MaxParticles", 1) or 10000) <= 10000 then
            Spring.SetConfigInt("MaxParticles", 10000)
        end

        if Spring.GetConfigInt("MaxSounds", 128) < 64 then
            Spring.SetConfigInt("MaxSounds", 64)
        end

        -- limit music volume
        if Spring.GetConfigInt("snd_volmusic", 20) > 50 then
            Spring.SetConfigInt("snd_volmusic", 50)
        end

        -- enable advanced map shading
        --if Spring.GetConfigInt("AdvMapShading", 0) ~= 1 then
        --	Spring.SetConfigInt("AdvMapShading", 1)
        --end

        -- enable advanced model shading
        if Spring.GetConfigInt("AdvModelShading", 0) ~= 1 then
            Spring.SetConfigInt("AdvModelShading", 1)
        end
        -- enable normal mapping
        if Spring.GetConfigInt("NormalMapping", 0) ~= 1 then
            Spring.SetConfigInt("NormalMapping", 1)
            Spring.SendCommands("luarules normalmapping 1")
        end
        -- disable clouds
        if Spring.GetConfigInt("AdvSky", 0) ~= 0 then
            Spring.SetConfigInt("AdvSky", 0)
        end
        -- disable grass
        if Spring.GetConfigInt("GrassDetail", 0) ~= 0 then
            Spring.SetConfigInt("GrassDetail", 0)
        end
        -- limit MSAA
        if Spring.GetConfigInt("MSAALevel", 0) > 8 then
            Spring.SetConfigInt("MSAALevel", 8)
        end
        --if Spring.GetConfigInt("UsePBO",0) == 0 then
        --	Spring.SetConfigInt("UsePBO",1)
        --end
        --if Platform ~= nil and Platform.gpuVendor ~= 'Nvidia' and Platform.gpuVendor ~= 'AMD' then
        --	Spring.SetConfigInt("UsePBO",0)
        --end

        -- enable shadows at gamestart
        --if Spring.GetConfigInt("Shadows",0) ~= 1 then
        --	Spring.SetConfigInt("Shadows",1)
        --	Spring.SendCommands("Shadows 1")
        --end
        -- set lowest quality shadows for Intel GPU (they eat fps but dont really show, but without any shadows enables it looks glitchy)
        --if Platform ~= nil and Platform.gpuVendor == 'Intel' then
        --	Spring.SendCommands("Shadows 1 1000")
        --end

        -- set custom user map sun position
        if customMapSunPos[Game.mapName] and customMapSunPos[Game.mapName][1] then
            Spring.SetSunDirection(customMapSunPos[Game.mapName][1], customMapSunPos[Game.mapName][2], customMapSunPos[Game.mapName][3])
            Spring.SetSunLighting({ groundShadowDensity = gl.GetSun("shadowDensity"), modelShadowDensity = gl.GetSun("shadowDensity") })
        end
        if customMapFog[Game.mapName] and customMapFog[Game.mapName] then
            Spring.SetAtmosphere(customMapFog[Game.mapName])
        end

        -- disable fog
        --Spring.SetAtmosphere({fogStart = 0.99999, fogEnd = 1.0, fogColor = {1.0, 1.0, 1.0, 0.0}})
    end

    Spring.SendCommands("minimap unitsize " .. (Spring.GetConfigFloat("MinimapIconScale", 3.5)))        -- spring wont remember what you set with '/minimap iconssize #'

    Spring.SendCommands({ "bind f10 options" })

    checkResolution()

    WG['options'] = {}
    WG['options'].toggle = function(state)
        local newShow = state
        if newShow == nil then
            newShow = not show
        end
        if newShow and WG['topbar'] then
            -- WG['topbar'].hideWindows()   --TODO: Fix (tobar)
        end
        show = newShow
    end
    WG['options'].isvisible = function()
        return show
    end
    WG['options'].getOptionValue = function(option)
        if getOptionByID(option) then
            return options[getOptionByID(option)].value
        end
    end
    WG['options'].getCameraSmoothness = function()
        return cameraTransitionTime
    end
    WG['options'].disallowEsc = function()
        if showSelectOptions then
            --or draggingSlider then
            return true
        else
            return false
        end
    end

    presets = tableMerge(presets, customPresets)
    for preset, _ in pairs(customPresets) do
        table.insert(presetNames, preset)
    end
    --init()
end

function widget:Shutdown()
    if windowList then
        glDeleteList(windowList)
    end
    if fontOption then
        for i, font in pairs(fontOption) do
            gl.DeleteFont(fontOption[i])
        end
    end
    if WG['guishader'] then
        WG['guishader'].DeleteDlist('options')
    end
    if selectOptionsList then
        if WG['guishader'] then
            WG['guishader'].RemoveScreenRect('options_select')
            WG['guishader'].removeRenderDlist(selectOptionsList)
        end
        glDeleteList(selectOptionsList)
        selectOptionsList = nil
    end
    WG['options'] = nil
end

local function Split(s, separator)
    local results = {}
    for part in s:gmatch("[^" .. separator .. "]+") do
        results[#results + 1] = part
    end
    return results
end

local lastOptionCommand = 0
function widget:TextCommand(command)
    if string.find(command, "options", nil, true) == 1 and string.len(command) == 7 then
        local newShow = not show
        if newShow and WG['topbar'] and WG['topbar'].hideWindows then
            WG['topbar'].hideWindows()
        end
        show = newShow
    end
    if os_clock() > lastOptionCommand + 1 and string.sub(command, 1, 7) == "option " then
        -- clock check is needed because toggling widget will somehow do an identical call of widget:TextCommand(command)
        local option = string.sub(command, 8)
        local optionID = getOptionByID(option)
        if optionID then
            if options[optionID].type == 'bool' then
                lastOptionCommand = os_clock()
                options[optionID].value = not options[optionID].value
                applyOptionValue(optionID)
            else
                show = true
            end
        else
            option = Split(option, ' ')
            optionID = option[1]
            if optionID then
                optionID = getOptionByID(optionID)
                if optionID and option[2] then
                    lastOptionCommand = os_clock()
                    if options[optionID].type == 'select' then
                        local selectKey = getSelectKey(optionID, option[2])
                        if selectKey then
                            options[optionID].value = selectKey
                            applyOptionValue(optionID)
                        end
                    elseif options[optionID].type == 'bool' then
                        if option[2] == '0' then
                            options[optionID].value = false
                        else
                            options[optionID].value = true
                        end
                        applyOptionValue(optionID)
                    else
                        options[optionID].value = tonumber(option[2])
                        applyOptionValue(optionID)
                    end
                end
            end
        end
    end
    if string.find(command, "savepreset", nil, true) == 1 then
        local words = Split(command, ' ')
        if words[2] then
            savePreset(words[2])
        else
            savePreset()
        end
    end
end

function getSelectKey(i, value)
    for k, v in pairs(options[i].options) do
        if v == value then
            return k
        end
    end
    return false
end

function widget:GetConfigData(data)
    return {
        vsyncLevel = vsyncLevel,
        vsyncOnlyForSpec = vsyncOnlyForSpec,
        vsyncEnabled = vsyncEnabled,
        firsttimesetupDone = firstlaunchsetupDone,
        resettedTonemapDefault = resettedTonemapDefault,
        customPresets = customPresets,
        cameraTransitionTime = cameraTransitionTime,
        cameraPanTransitionTime = cameraPanTransitionTime,
        maxNanoParticles = maxNanoParticles,
        currentGroupTab = currentGroupTab,
        show = show,
        pauseGameWhenSingleplayerExecuted = pauseGameWhenSingleplayerExecuted,
        pauseGameWhenSingleplayer = pauseGameWhenSingleplayer,
        advSettings = advSettings,
        defaultMapSunPos = defaultMapSunPos,
        defaultSunLighting = defaultSunLighting,
        defaultFog = defaultFog,
        mapChecksum = Game.mapChecksum,
        customMapSunPos = customMapSunPos,
        customMapFog = customMapFog,
        useNetworkSmoothing = useNetworkSmoothing,
        desiredWaterValue = desiredWaterValue,
        waterDetected = waterDetected,

        disticon = { 'UnitIconDist', tonumber(Spring.GetConfigInt("UnitIconDist", 85) or 85) }, --was: 160
        particles = { 'MaxParticles', tonumber(Spring.GetConfigInt("MaxParticles", 1) or 15000) },
        --nanoparticles = {'MaxNanoParticles', tonumber(Spring.GetConfigInt("MaxNanoParticles",1) or 500)},	-- already saved above in: maxNanoParticles
        decals = { 'GroundDecals', tonumber(Spring.GetConfigInt("GroundDecals", 1) or 1) },
        --grounddetail = {'GroundDetail', tonumber(Spring.GetConfigInt("GroundDetail",1) or 1)},
        camera = { 'CamMode', tonumber(Spring.GetConfigInt("CamMode", 1) or 1) },
        --treewind = {'TreeWind', tonumber(Spring.GetConfigInt("TreeWind",1) or 1)},
        hwcursor = { 'HardwareCursor', tonumber(Spring.GetConfigInt("HardwareCursor", 1) or 1) },
        sndvolmaster = { 'snd_volmaster', tonumber(Spring.GetConfigInt("snd_volmaster", 40) or 40) },
        sndvolbattle = { 'snd_volbattle', tonumber(Spring.GetConfigInt("snd_volbattle", 40) or 40) },
        sndvolunitreply = { 'snd_volunitreply', tonumber(Spring.GetConfigInt("snd_volunitreply", 40) or 40) },
        --sndvolmusic = {'snd_volmusic', tonumber(Spring.GetConfigInt("snd_volmusic",20) or 20)},
        guiopacity = { 'ui_opacity', tonumber(Spring.GetConfigFloat("ui_opacity", 0.6) or 0.66) },
        scrollwheelspeed = { 'ScrollWheelSpeed', tonumber(Spring.GetConfigInt("ScrollWheelSpeed", 25) or 25) },
    }
end

function widget:SetConfigData(data)
    if data.vsyncEnabled ~= nil then
        vsyncEnabled = data.vsyncEnabled
    end
    if data.vsyncOnlyForSpec ~= nil then
        vsyncOnlyForSpec = data.vsyncOnlyForSpec
    end
    if data.vsyncLevel ~= nil then
        vsyncLevel = data.vsyncLevel
    end
    if data.desiredWaterValue ~= nil then
        desiredWaterValue = data.desiredWaterValue
    end
    if data.waterDetected and Spring.GetGameFrame() > 0 then
        waterDetected = data.waterDetected
    end
    if data.firsttimesetupDone ~= nil then
        firstlaunchsetupDone = data.firsttimesetupDone
    end
    if data.resettedTonemapDefault ~= nil then
        resettedTonemapDefault = data.resettedTonemapDefault
    end
    if data.customPresets ~= nil then
        customPresets = data.customPresets
    end
    if data.cameraTransitionTime ~= nil then
        cameraTransitionTime = data.cameraTransitionTime
    end
    if data.cameraPanTransitionTime ~= nil then
        cameraPanTransitionTime = data.cameraPanTransitionTime
    end
    if data.maxNanoParticles ~= nil then
        maxNanoParticles = data.maxNanoParticles
    end
    if data.currentGroupTab ~= nil then
        currentGroupTab = data.currentGroupTab
    end
    if data.show ~= nil and Spring.GetGameFrame() > 0 then
        show = data.show
    end
    if data.pauseGameWhenSingleplayerExecuted ~= nil and Spring.GetGameFrame() > 0 then
        pauseGameWhenSingleplayerExecuted = data.pauseGameWhenSingleplayerExecuted
    end
    if data.pauseGameWhenSingleplayer ~= nil then
        pauseGameWhenSingleplayer = data.pauseGameWhenSingleplayer
    end
    if data.advSettings ~= nil then
        advSettings = data.advSettings
    end
    if data.savedConfig ~= nil then
        savedConfig = data.savedConfig
        for k, v in pairs(savedConfig) do
            Spring.SetConfigFloat(v[1], v[2])
        end
    end
    if data.mapChecksum and data.mapChecksum == Game.mapChecksum then
        if data.defaultMapSunPos ~= nil then
            defaultMapSunPos = data.defaultMapSunPos
        end
        if data.defaultSunLighting ~= nil then
            defaultSunLighting = data.defaultSunLighting
        end
        if data.defaultFog ~= nil and type(data.defaultFog.fogStart) ~= 'table' then
            defaultFog = data.defaultFog
        end
    end
    if data.customMapSunPos then
        customMapSunPos = data.customMapSunPos
    end
    if data.customMapFog then
        customMapFog = data.customMapFog
    end
    if data.useNetworkSmoothing then
        useNetworkSmoothing = data.useNetworkSmoothing
    end
end
