const jtffci = require("./lib/jtff-lib-ci");
const config = require("../../config.json");
const fs = require("fs");


fs.mkdirSync(config.general.missionFolder, { recursive: true });
config.missionTemplates.forEach(missionTemplate => {
    jtffci.mizUpdate([
        missionTemplate.prefix,
        '_',
        missionTemplate.theatre,
        ".miz"
    ].join(""), [
        config.general.missionFolder+'/'+config.general.missionPrefix,
        '_',
        missionTemplate.theatre,
        '_',
        config.general.missionSuffix,
        '_',
        jtffci.displayVersion(jtffci.getVersion()),
        ".miz"
    ].join(""),missionTemplate.theatre);
});
