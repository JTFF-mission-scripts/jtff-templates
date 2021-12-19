const jtffci = require("./lib/jtff-lib-ci");
const config = require("../../config.json");
const fs = require("fs");
const path = require("path");


fs.mkdirSync(config.general.missionFolder, { recursive: true });
config.missionTemplates.map(async missionTemplate => {
    await jtffci.mizUpdate([
        missionTemplate.prefix,
        '_',
        missionTemplate.theatre,
        ".miz"
    ].join(""), [
        missionTemplate.prefix,
        '_',
        missionTemplate.theatre,
        "-new.miz"
    ].join(""), missionTemplate.theatre);
    if (fs.existsSync([
        missionTemplate.prefix,
        '_',
        missionTemplate.theatre,
        ".miz"
    ].join(""))) {
        fs.unlinkSync([
            missionTemplate.prefix,
            '_',
            missionTemplate.theatre,
            ".miz"
        ].join(""));
    }
    fs.renameSync([
            missionTemplate.prefix,
            '_',
            missionTemplate.theatre,
            "-new.miz"
        ].join(""),
        [
            missionTemplate.prefix,
            '_',
            missionTemplate.theatre,
            ".miz"
        ].join("")
    );
});
