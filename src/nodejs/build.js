const jtffci = require("./lib/jtff-lib-ci");
const config = require("./lib/config.json");

config.missionTemplates.forEach(missionTemplate => {
    jtffci.mizUpdate([
        missionTemplate.prefix,
        '_',
        missionTemplate.theatre,
        ".miz"
    ].join(""), [
        config.general.missionPrefix,
        '_',
        missionTemplate.theatre,
        '_',
        config.general.missionSuffix,
        '_',
        jtffci.displayVersion(jtffci.getVersionFromPackageJson()),
        ".miz"
    ].join(""),missionTemplate.theatre);
});
