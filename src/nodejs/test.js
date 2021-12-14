const jtffci = require("./lib/jtff-lib-ci");
const config = require("../../config.json");

// jtffci.copyMiz("Theatre_Syrien_VIDE_JTFF_READY.miz", "testcopy.miz");
// jtffci.mizUpdateSettings("Theatre_Syrien_VIDE_JTFF_READY.miz", "testcopy.miz");
// jtffci.mizUpdateSettings("Theatre_Syrien_VIDE_JTFF_READY.miz", "workspace-syria.miz");

// console.log([
//     config.missionTemplates[0].prefix,
//     '_',
//     config.missionTemplates[0].theatre,
//     ".miz"
// ].join(""));
// console.log([
//     config.general.missionPrefix,
//     '_',
//     config.missionTemplates[0].theatre,
//     '_',
//     config.general.missionSuffix,
//     '_',
//     jtffci.displayVersion(jtffci.getVersionFromPackageJson()),
//     ".miz"
// ].join(""));

// config.missionTemplates.forEach(missionTemplate => {
//     jtffci.mizUpdate([
//         missionTemplate.prefix,
//         '_',
//         missionTemplate.theatre,
//         ".miz"
//     ].join(""), [
//         config.general.missionPrefix,
//         '_',
//         missionTemplate.theatre,
//         '_',
//         config.general.missionSuffix,
//         '_',
//         jtffci.displayVersion(jtffci.getVersionFromPackageJson()),
//         ".miz"
//     ].join(""),missionTemplate.theatre);
// });

// jtffci.mizUpdate([
//     config.missionTemplates[0].prefix,
//     '_',
//     config.missionTemplates[0].theatre,
//     ".miz"
// ].join(""), [
//     config.general.missionPrefix,
//     '_',
//     config.missionTemplates[0].theatre,
//     '_',
//     config.general.missionSuffix,
//     '_',
//     jtffci.displayVersion(jtffci.getVersionFromPackageJson()),
//     ".miz"
// ].join(""),config.missionTemplates[0].theatre);
