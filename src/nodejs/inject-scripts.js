const jtffci = require("./lib/jtff-lib-ci");
const config = require("../../config.json");
const fs = require("fs");
const path = require("path");
const prompt = require('prompt');

fs.mkdirSync(config.general.missionFolder,{ recursive: true });
if (fs.existsSync([
    config.general.missionFolder,
    "/",
    path.parse(process.env.npm_config_mission).name
].join(""))) {
    fs.rmSync([
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name
        ].join(""),
        { recursive: true }
    );
}
fs.mkdirSync([
        config.general.missionFolder,
        "/",
        path.parse(process.env.npm_config_mission).name,
        "/settings"
    ].join(""),
    { recursive: true }
);
fs.mkdirSync([
        config.general.missionFolder,
        "/",
        path.parse(process.env.npm_config_mission).name,
        "/src"
    ].join(""),
    { recursive: true }
);


const prompt_properties = [
    {
        name: 'inject_tankers',
        validator: /^y\b|n\b|o\b|yes\b|no\b|non\b|oui\b/i,
        warning: 'inject_tankers must be yes/y/o/oui or no/n/non',
        default: 'n'
    },
    {
        name: 'inject_airboss',
        validator: /^y\b|n\b|o\b|yes\b|no\b|non\b|oui\b/i,
        warning: 'inject_airboss must be yes/y/o/oui or no/n/non',
        default: 'n'
    },
    {
        name: 'inject_beacons',
        validator: /^y\b|n\b|o\b|yes\b|no\b|non\b|oui\b/i,
        warning: 'inject_beacons must be yes/y/o/oui or no/n/non',
        default: 'n'
    },
    {
        name: 'inject_awacs',
        validator: /^y\b|n\b|o\b|yes\b|no\b|non\b|oui\b/i,
        warning: 'inject_awacs must be yes/y/o/oui or no/n/non',
        default: 'n'
    },
    {
        name: 'inject_atis',
        validator: /^y\b|n\b|o\b|yes\b|no\b|non\b|oui\b/i,
        warning: 'inject_atis must be yes/y/o/oui or no/n/non',
        default: 'n'
    },
    {
        name: 'inject_A2A',
        validator: /^y\b|n\b|o\b|yes\b|no\b|non\b|oui\b/i,
        warning: 'inject_A2A must be yes/y/o/oui or no/n/non',
        default: 'n'
    },
    {
        name: 'inject_mission',
        validator: /^y\b|n\b|o\b|yes\b|no\b|non\b|oui\b/i,
        warning: 'inject_mission must be yes/y/o/oui or no/n/non',
        default: 'y'
    },
    {
        name: 'inject_A2G',
        validator: /^y\b|n\b|o\b|yes\b|no\b|non\b|oui\b/i,
        warning: 'inject_A2G must be yes/y/o/oui or no/n/non',
        default: 'n'
    }
];

prompt.start();
prompt.get(prompt_properties, async function (prompt_err, prompt_result) {
    if (prompt_err) {
        console.log(prompt_err);
        return 1;
    }
    console.log('Command-line input received:');
    console.log('  inject_tankers scripts: ' + (/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_tankers));
    console.log('  inject_airboss scripts: ' + (/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_airboss));
    console.log('  inject_beacons scripts: ' + (/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_beacons));
    console.log('  inject_awacs scripts: ' + (/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_awacs));
    console.log('  inject_atis scripts: ' + (/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_atis));
    console.log('  inject_A2A scripts: ' + (/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_A2A));
    console.log('  inject_mission specific scripts: ' + (/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_mission));
    console.log('  inject_A2G scripts: ' + (/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_A2G));

    const zip = await jtffci.mizOpen(process.env.npm_config_mission);
    jtffci.mizUpdateSrcLuaFiles(zip);
    jtffci.mizUpdateLibLuaFiles(zip);
    // injection des fichiers son Generaux
    const generalSoundFolder = zip.remove('General').folder('General');
    await jtffci.addFilesToZip(generalSoundFolder, 'resources/sounds/General', fs.readdirSync('resources/sounds/General'));

    const inputZip = await zip.generateAsync({
        type: 'nodebuffer',
        streamFiles: true,
        compression: "DEFLATE",
        compressionOptions: {
            level: 9
        }
    });
    fs.writeFileSync([
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name,
            "/",
            path.basename(process.env.npm_config_mission)
        ].join(""),
        inputZip);


    const missionObject = await jtffci.getMissionObjectFromMiz(
        [
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name,
            "/",
            path.basename(process.env.npm_config_mission)
        ].join("")
    );
    let mapResourceObject = await jtffci.getMapResourceObjectFromMiz(
        [
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name,
            "/",
            path.basename(process.env.npm_config_mission)
        ].join("")
    );
    if (Array.isArray(mapResourceObject)) {
        if (mapResourceObject.length === 0) {
            mapResourceObject = {};
        }
    }
    // injection Moose
    let tuple = jtffci.injectScripts(
        missionObject['trig'],
        missionObject['trigrules'],
        mapResourceObject,
        'Moose load',
        ['Moose_.lua'],
        10,
        '0x008000ff'
    );
    missionObject['trig'] = tuple.tObject;
    missionObject['trigrules'] = tuple.trObject;
    mapResourceObject = tuple.mrObject;
    // injection Mist
    tuple = jtffci.injectScripts(
        missionObject['trig'],
        missionObject['trigrules'],
        mapResourceObject,
        'Mist load',
        ['mist_4_5_107.lua'],
        13,
        '0x008000ff'
    );
    missionObject['trig'] = tuple.tObject;
    missionObject['trigrules'] = tuple.trObject;
    mapResourceObject = tuple.mrObject;
    // injection Skynet
    tuple = jtffci.injectScripts(
        missionObject['trig'],
        missionObject['trigrules'],
        mapResourceObject,
        'Skynet load',
        ['skynet-iads-compiled.lua'],
        15,
        '0x008000ff'
    );
    missionObject['trig'] = tuple.tObject;
    missionObject['trigrules'] = tuple.trObject;
    mapResourceObject = tuple.mrObject;
    // injection Librairies JTFF
    tuple = jtffci.injectScripts(
        missionObject['trig'],
        missionObject['trigrules'],
        mapResourceObject,
        'Load Libraries',
        ['010-root_menus.lua', '020-mission_functions.lua', 'hypeman.lua'],
        16,
        '0xffff00ff'
    );
    missionObject['trig'] = tuple.tObject;
    missionObject['trigrules'] = tuple.trObject;
    mapResourceObject = tuple.mrObject;

    let settingsArray = [];
    settingsArray.push(
        {
            file: "settings-hypeman.lua",
        },
    );
    // injection de la gestion des Set_Clients
    tuple = jtffci.injectScripts(
        missionObject['trig'],
        missionObject['trigrules'],
        mapResourceObject,
        'Set clients',
        ['110-set_clients.lua'],
        21,
        '0xff0000ff'
    );
    missionObject['trig'] = tuple.tObject;
    missionObject['trigrules'] = tuple.trObject;
    mapResourceObject = tuple.mrObject;
    // injection des Tankers et OndemandTankers
    if ((/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_tankers)) {
        settingsArray.push(
            {
                file: "settings-tankers.lua",
                objectName: "TankersConfig"
            },
            {
                file: "settings-ondemandtankers.lua",
                objectName: "OnDemandTankersConfig"
            },
        );
        tuple = jtffci.injectScripts(
            missionObject['trig'],
            missionObject['trigrules'],
            mapResourceObject,
            'Tankers',
            ['120-tankers.lua'],
            22,
            '0xff0000ff'
        );
        missionObject['trig'] = tuple.tObject;
        missionObject['trigrules'] = tuple.trObject;
        mapResourceObject = tuple.mrObject;
    }
    if ((/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_airboss)) {
        // injection des fichiers son Airboss
        const zip = await jtffci.mizOpen([
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name,
            "/",
            path.basename(process.env.npm_config_mission)
        ].join(""));
        const airbossSoundFolder = zip.remove('AIRBOSS').folder('AIRBOSS');
        await jtffci.addFilesToZip(airbossSoundFolder, 'resources/sounds/AIRBOSS', fs.readdirSync('resources/sounds/AIRBOSS'));
        const inputZip = await zip.generateAsync({
            type: 'nodebuffer',
            streamFiles: true,
            compression: "DEFLATE",
            compressionOptions: {
                level: 9
            }
        });
        fs.writeFileSync([
                config.general.missionFolder,
                "/",
                path.parse(process.env.npm_config_mission).name,
                "/",
                path.basename(process.env.npm_config_mission)
            ].join(""),
            inputZip);
        settingsArray.push(
            {
                file: "settings-airboss.lua",
                objectName: "AirBossConfig"
            },
            {
                file: "settings-pedros.lua",
                objectName: "PedrosConfig"
            },
        );
        tuple = jtffci.injectScripts(
            missionObject['trig'],
            missionObject['trigrules'],
            mapResourceObject,
            'Airboss',
            ['130-airboss.lua', '135-pedro.lua'],
            23,
            '0xff0000ff'
        );
        missionObject['trig'] = tuple.tObject;
        missionObject['trigrules'] = tuple.trObject;
        mapResourceObject = tuple.mrObject;
    }
    if ((/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_beacons)) {
        settingsArray.push(
            {
                file: "settings-beacons.lua",
                objectName: "BeaconsConfig"
            },
        );
        tuple = jtffci.injectScripts(
            missionObject['trig'],
            missionObject['trigrules'],
            mapResourceObject,
            'Beacons',
            ['140-beacons.lua'],
            24,
            '0xff0000ff'
        );
        missionObject['trig'] = tuple.tObject;
        missionObject['trigrules'] = tuple.trObject;
        mapResourceObject = tuple.mrObject;
    }
    if ((/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_awacs)) {
        settingsArray.push(
            {
                file: "settings-awacs.lua",
                objectName: "AwacsConfig"
            },
        );
        tuple = jtffci.injectScripts(
            missionObject['trig'],
            missionObject['trigrules'],
            mapResourceObject,
            'Awacs',
            ['150-awacs.lua'],
            25,
            '0xff0000ff'
        );
        missionObject['trig'] = tuple.tObject;
        missionObject['trigrules'] = tuple.trObject;
        mapResourceObject = tuple.mrObject;
    }
    if ((/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_atis)) {
        // injection des fichiers son ATIS
        const zip = await jtffci.mizOpen([
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name,
            "/",
            path.basename(process.env.npm_config_mission)
        ].join(""));
        const atisSoundFolder = zip.remove('ATIS').folder('ATIS');
        await jtffci.addFilesToZip(atisSoundFolder, 'resources/sounds/ATIS', fs.readdirSync('resources/sounds/ATIS'));
        const inputZip = await zip.generateAsync({
            type: 'nodebuffer',
            streamFiles: true,
            compression: "DEFLATE",
            compressionOptions: {
                level: 9
            }
        });
        fs.writeFileSync([
                config.general.missionFolder,
                "/",
                path.parse(process.env.npm_config_mission).name,
                "/",
                path.basename(process.env.npm_config_mission)
            ].join(""),
            inputZip);
        settingsArray.push(
            {
                file: "settings-atis.lua",
                objectName: "AtisConfig"
            },
        );
        tuple = jtffci.injectScripts(
            missionObject['trig'],
            missionObject['trigrules'],
            mapResourceObject,
            'ATIS',
            ['160-atis.lua'],
            26,
            '0xff0000ff'
        );
        missionObject['trig'] = tuple.tObject;
        missionObject['trigrules'] = tuple.trObject;
        mapResourceObject = tuple.mrObject;
    }
    if ((/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_A2A)) {
        settingsArray.push(
            {
                file: "settings-capzone.lua",
                objectName: "TrainingCAPConfig"
            },
            {
                file: "settings-foxzone.lua",
                objectName: "FoxRangesConfig"
            },
            {
                file: "settings-RAT.lua",
                objectName: "RATConfig"
            },
        );
        tuple = jtffci.injectScripts(
            missionObject['trig'],
            missionObject['trigrules'],
            mapResourceObject,
            'Air To Air',
            ['170-cap_zone_training.lua', '173-fox_zone_training.lua', '176-random_air_traffic.lua'],
            27,
            '0xff0000ff'
        );
        missionObject['trig'] = tuple.tObject;
        missionObject['trigrules'] = tuple.trObject;
        mapResourceObject = tuple.mrObject;
    }
    if ((/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_mission)) {
        fs.copyFileSync('templates/src/180-mission.lua',
            [
                config.general.missionFolder,
                "/",
                path.parse(process.env.npm_config_mission).name,
                "/src/180-mission.lua"
            ].join("")
        );
        const zip = await jtffci.mizOpen([
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name,
            "/",
            path.basename(process.env.npm_config_mission)
        ].join(""));

        jtffci.mizUpdateLuaFile(zip, [
                config.general.missionFolder,
                "/",
                path.parse(process.env.npm_config_mission).name,
                "/src/180-mission.lua"
            ].join("")
        );
        const inputZip = await zip.generateAsync({
            type: 'nodebuffer',
            streamFiles: true,
            compression: "DEFLATE",
            compressionOptions: {
                level: 9
            }
        });
        fs.writeFileSync([
                config.general.missionFolder,
                "/",
                path.parse(process.env.npm_config_mission).name,
                "/",
                path.basename(process.env.npm_config_mission)
            ].join(""),
            inputZip);
        tuple = jtffci.injectScripts(
            missionObject['trig'],
            missionObject['trigrules'],
            mapResourceObject,
            'Mission specific',
            ['180-mission.lua'],
            28,
            '0xff0000ff'
        );
        missionObject['trig'] = tuple.tObject;
        missionObject['trigrules'] = tuple.trObject;
        mapResourceObject = tuple.mrObject;
    }
    if ((/^y\b|o\b|yes\b|oui\b/i).test(prompt_result.inject_A2G)) {
        // injection des fichiers son Range
        const zip = await jtffci.mizOpen([
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name,
            "/",
            path.basename(process.env.npm_config_mission)
        ].join(""));
        const rangeSoundFolder = zip.remove('RANGE').folder('RANGE');
        await jtffci.addFilesToZip(rangeSoundFolder, 'resources/sounds/RANGE', fs.readdirSync('resources/sounds/RANGE'));
        const inputZip = await zip.generateAsync({
            type: 'nodebuffer',
            streamFiles: true,
            compression: "DEFLATE",
            compressionOptions: {
                level: 9
            }
        });
        fs.writeFileSync([
                config.general.missionFolder,
                "/",
                path.parse(process.env.npm_config_mission).name,
                "/",
                path.basename(process.env.npm_config_mission)
            ].join(""),
            inputZip);
        settingsArray.push(
            {
                file: "settings-ranges.lua",
                objectName: "RangeConfig"
            },
            {
                file: "settings-training_ranges.lua",
                objectName: "TrainingRangeConfig"
            },
            {
                file: "settings-fac_ranges.lua",
                objectName: "FACRangeConfig"
            },
            {
                file: "settings-skynet.lua",
                objectName: "SkynetConfig"
            },
        );
        tuple = jtffci.injectScripts(
            missionObject['trig'],
            missionObject['trigrules'],
            mapResourceObject,
            'Air To Ground',
            ['190-ranges.lua', '193-training_ranges.lua', '196-fac_ranges.lua', '199-skynet.lua'],
            29,
            '0xff0000ff'
        );
        missionObject['trig'] = tuple.tObject;
        missionObject['trigrules'] = tuple.trObject;
        mapResourceObject = tuple.mrObject;
    }
    for (let settingsObject of settingsArray) {
        fs.copyFileSync(
            [
                'templates/settings/',
                settingsObject.file
            ].join(""),
            [
                config.general.missionFolder,
                "/",
                path.parse(process.env.npm_config_mission).name,
                "/settings/",
                settingsObject.file
            ].join("")
        );
    }
    await jtffci.mizInjectSettingsFolder(
        [
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name,
            "/",
            path.basename(process.env.npm_config_mission)
        ].join(""),
        [
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name,
            "/settings"
        ].join("")
    );
    if (settingsArray.length > 0) {
        tuple = jtffci.injectScripts(
            missionObject['trig'],
            missionObject['trigrules'],
            mapResourceObject,
            'Mission Settings',
            settingsArray.map(settingsObject => settingsObject.file),
            15,
            '0xffff00ff'
        );
        missionObject['trig'] = tuple.tObject;
        missionObject['trigrules'] = tuple.trObject;
        mapResourceObject = tuple.mrObject;
    }
    // Sauvegarde de la mission avec scripts injectés
    await jtffci.mizInjectMissionDataFile(
        [
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name,
            "/",
            path.basename(process.env.npm_config_mission)
        ].join(""),
        {mission: missionObject}
    );
    await jtffci.mizInjectMapResourceFile(
        [
            config.general.missionFolder,
            "/",
            path.parse(process.env.npm_config_mission).name,
            "/",
            path.basename(process.env.npm_config_mission)
        ].join(""),
        {mapResource: mapResourceObject}
    );
    console.log('...Done...');
    process.exit(0);
});
