"use strict";

const jszip = require("jszip");
const fs = require("fs");
const path = require("path");
const { promisify } = require('util');
const lstat = promisify(fs.lstat);
const config = require("../../../config.json");
const {google} = require("googleapis");
const {format, parse} = require("lua-json");

function injectScripts(tObject, trObject, mrObject, strTitle, scriptFilesArray, timingInSeconds, hexColor) {
    let nextIndex = Object.keys(trObject).length+1;
    if (nextIndex === 1) {
        tObject['actions'] = {};
        tObject['func'] = {};
        tObject['conditions'] = {};
        tObject['flag'] = {};
        trObject = {};
    }
    let actionSentence = "";
    let actionsObject = {};
    for (const [index, scriptFile] of scriptFilesArray.entries()) {
        actionSentence += "a_do_script_file(getValueResourceByKey(\"" + scriptFile + "\")); "
        actionsObject[index+1] = {
            file: scriptFile,
            predicate: 'a_do_script_file',
        };
        mrObject[scriptFile] = scriptFile;
    }
    actionSentence += "mission.trig.func[" + nextIndex + "]=nil;"
    tObject['actions'][nextIndex] = actionSentence;
    tObject['func'][nextIndex] = "if mission.trig.conditions[" + nextIndex + "]() then mission.trig.actions[" + nextIndex + "]() end";
    tObject['conditions'][nextIndex] = "return(c_time_after(" + timingInSeconds + ") )";
    tObject['flag'][nextIndex] = true;
    trObject[nextIndex] = {
        rules: {
            1: {
                coalitionlist: 'red',
                seconds: timingInSeconds,
                predicate: 'c_time_after',
                zone: ''
            }
        },
        eventlist: '',
        comment: strTitle,
        actions: actionsObject,
        predicate: 'triggerOnce',
        colorItem: hexColor
    };
    return {tObject: tObject,trObject: trObject, mrObject: mrObject};
}


function getVersion() {
    return getVersionObject(config.general.missionVersion);
}

function setVersionfromString(strVersion) {
    return setVersion(getVersionObject(strVersion))
}
function setVersion(versionObject) {
    config.general.missionVersion = displayVersion(versionObject);
    let data = JSON.stringify(config, null, 4);
    fs.writeFileSync("config.json", data);
}
function displayVersion(versionObject) {
    return [versionObject.major, versionObject.minor, versionObject.releaseSuffix ? versionObject.patch + '-' + versionObject.releaseSuffix : versionObject.patch].join('.')
}
function getVersionObject(strVersion) {
    const [major, minor, interimPatch] = strVersion.split('.', 3);
    const [patch, releaseSuffix] = interimPatch.split('-', 2);
    return {
        major: parseInt(major),
        minor: parseInt(minor),
        patch: parseInt(patch),
        releaseSuffix: releaseSuffix ? releaseSuffix : null
    };
}
function nextMajor(versionObject) {
    const newVersionObject = versionObject;
    newVersionObject.major = newVersionObject.major + 1;
    return newVersionObject;
}
function nextMinor(versionObject) {
    const newVersionObject = versionObject;
    newVersionObject.minor = newVersionObject.minor + 1;
    return newVersionObject;
}
function nextPatch(versionObject) {
    const newVersionObject = versionObject;
    newVersionObject.patch = newVersionObject.patch + 1;
    return newVersionObject;
}

async function mizOpen(mizPath) {
    var MizFile = new jszip();
    const mizData = fs.readFileSync(mizPath);
    return MizFile.loadAsync(mizData);
}

async function mizUpdate(mizPath, copyPath, strTheatreSettings) {
    const zip = await mizOpen(mizPath);
    mizUpdateSrcLuaFiles(zip);
    mizUpdateLibLuaFiles(zip);
    if (strTheatreSettings === null) {
        console.log("no theatre specified ! TODO inject fake settings");
    } else {
        mizUpdateSettingsLuaFiles(zip, strTheatreSettings);
    }
    await mizUpdateSoundFolders(zip);
    const inputZip = await zip.generateAsync({
        type:'nodebuffer',
        streamFiles:true,
        compression: "DEFLATE",
        compressionOptions: {
            level: 9
        }
    });
    fs.writeFileSync(copyPath? copyPath: mizPath, inputZip);
}

async function mizInjectMissionDataFile(mizPath, missionObject) {
    const zip = await mizOpen(mizPath);
    mizUpdateMissionDataFile(zip, missionObject);
    const inputZip = await zip.generateAsync({
        type:'nodebuffer',
        streamFiles:true,
        compression: "DEFLATE",
        compressionOptions: {
            level: 9
        }
    });
    fs.writeFileSync(mizPath, inputZip);
}

async function mizInjectSettingsFolder(mizPath, settingsFolder) {
    const zip = await mizOpen(mizPath);
    for (let file of fs.readdirSync(settingsFolder).filter( file => file.endsWith(".lua"))) {
        mizUpdateLuaFile(zip,[
            settingsFolder,
            "/",
            file].join(""));
    }
    const inputZip = await zip.generateAsync({
        type:'nodebuffer',
        streamFiles:true,
        compression: "DEFLATE",
        compressionOptions: {
            level: 9
        }
    });
    fs.writeFileSync(mizPath, inputZip);
}

async function mizInjectMapResourceFile(mizPath, mapResourceObject) {
    const zip = await mizOpen(mizPath);
    mizUpdateMapResourceFile(zip, mapResourceObject);
    const inputZip = await zip.generateAsync({
        type:'nodebuffer',
        streamFiles:true,
        compression: "DEFLATE",
        compressionOptions: {
            level: 9
        }
    });
    fs.writeFileSync(mizPath, inputZip);
}


function mizUpdateLuaFile(zip, filePath) {
    zip.remove("l10n/DEFAULT/" + path.basename(filePath));
    var stream = fs.createReadStream(filePath);
    zip.file("l10n/DEFAULT/" + path.basename(filePath) , stream);
}

function mizUpdateSrcLuaFiles(zip) {
    for (let file of fs.readdirSync('src').filter( file => file.endsWith(".lua"))) {
        console.log('updating src/' + file + ' file in miz file');
        mizUpdateLuaFile(zip, "src/" + file);
    };
}

function mizUpdateMissionDataFile(zip, missionObject) {
    zip.remove("mission");
    let missionLuaT = format(missionObject, {singleQuote : false})
    missionLuaT = missionLuaT
        .split('\n')
        .slice(1,-1)
        .join('\n')
        .slice(0,-1)
        .replace(/\[\"(\d+)\"\] = /g,"[$1] = ");
    zip.file("mission", missionLuaT);
}

function mizUpdateMapResourceFile(zip, mapResourceObject) {
    zip.remove("l10n/DEFAULT/mapResource");
    let mapResourceLuaT = format(mapResourceObject, {singleQuote : false})
    mapResourceLuaT = mapResourceLuaT
        .split('\n')
        .slice(1,-1)
        .join('\n')
        .slice(0,-1)
        .replace(/\[\"(\d+)\"\] = /g,"[$1] = ");
    zip.file("l10n/DEFAULT/mapResource", mapResourceLuaT);
}


function mizOpenMissionData(zipStream) {
    return zipStream.file("mission").async("string");
}

function mizOpenMapResource(zipStream) {
    return zipStream.file("l10n/DEFAULT/mapResource").async("string");
}

function mizUpdateLibLuaFiles(zip) {
    for (let file of fs.readdirSync('lib').filter( file => file.endsWith(".lua"))) {
        console.log('updating lib/' + file + ' file in miz file');
        mizUpdateLuaFile(zip, "lib/" + file);
    };
}

function mizUpdateSettingsLuaFiles(zip, strTheatre) {
    for (let file of fs.readdirSync('settings/'+strTheatre).filter( file => file.endsWith(".lua"))) {
        console.log('updating settings/'+strTheatre+'/' + file + ' file in miz file');
        mizUpdateLuaFile(zip, 'settings/'+strTheatre+'/' + file);
    };
}
async function mizUpdateSoundFolders(zip) {
    const folderArray = fs.readdirSync('resources/sounds');
    for (const folder of folderArray) {
        if(zip.folder(new RegExp(folder)).length > 0 ) {
            await mizUpdateSingleSoundFolder(zip, folder);
        }
    }
}

async function mizUpdateSingleSoundFolder(zip, folder) {
    console.log('adding sound files from resources/sounds/' + folder + ' folder...');
    zip = zip.remove(folder).folder(folder);
    await addFilesToZip(zip, 'resources/sounds/' + folder, fs.readdirSync('resources/sounds/' + folder));
}

async function addFilesToZip (zip, directoryPath, filesToInclude) {
    const promiseArr = await filesToInclude.map(async file => {
        const filePath = path.join(directoryPath, file)
        try {
            const fileStats = await lstat(filePath)
            const isDirectory = fileStats.isDirectory()
            if (isDirectory) {
                const directory = zip.remove(file).folder(file)
                const subFiles = fs.readdirSync(filePath)
                return addFilesToZip(directory, filePath, subFiles)
            } else {
                // console.log('added file : '+file);
                return zip.file(file, fs.createReadStream(filePath))
            }
        } catch (err) {
            console.log(err)
            return Promise.resolve()
        }
    })
    return Promise.all(promiseArr)
}
async function copyMiz(srcMizPath, dstMizPath) {
    await fs.createReadStream(srcMizPath).pipe(fs.createWriteStream(dstMizPath));
}

async function getMissionObjectFromMiz(MizPath) {
    let luaTable = 'return { \n' + await mizOpenMissionData(await mizOpen(MizPath)) + ' }';
    return parse(luaTable).mission;
}

async function getMapResourceObjectFromMiz(MizPath) {
    let luaTable = 'return { \n' + await mizOpenMapResource(await mizOpen(MizPath)) + ' }';
    return parse(luaTable).mapResource;
}

function getDestinationMizFilePaths() {
    const returnArray = config.missionTemplates.map(missionTemplate => {
        return config.general.missionFolder + '/'
            + config.general.missionPrefix + '_'
            + missionTemplate.theatre + '_'
            + config.general.missionSuffix
            + '_' + config.general.missionVersion + '.miz'
    });
    return returnArray;
}

function getGeneratedMizFilePaths() {
    return fs.readdirSync(config.general.missionFolder + '/')
        .filter(file => file.endsWith((".miz")))
        .map(mizFile => {
            return config.general.missionFolder + '/' + mizFile;
        });
}

function publishMizFiles(credentials) {
    const jwtClient = new google.auth.JWT(
        credentials.client_email,
        null,
        credentials.private_key,
        config.google.scopes
    );
    jwtClient.authorize(function(err, tokens) {
        if (err) {
            console.log(err);
            throw err;
        } else {
            console.log("Successfully connected!");
            const drive = google.drive({version: 'v3', jwtClient});
            fs.readdirSync(config.general.missionFolder)
                .filter(file => file.endsWith('.pub.json'))
                .map(file => {
                    // console.log(config.general.missionFolder+'/'+file);
                    fs.readFile(config.general.missionFolder+'/'+file, function(err, data) {
                        if (err) throw err;
                        data = JSON.parse(data.toString());
                        // console.log(data);
                        drive.files.list({
                            q: `'${data.gdriveFolder}' in parents and trashed = false and name = '${path.basename(data.mizFiles)}'`,
                            auth: jwtClient
                        }).then( rsp => {
                            // console.log(rsp.data.files);
                            // console.log(path.basename(data.mizFiles));
                            const fileMetadata = {
                                'name': path.basename(data.mizFiles),
                                parents: [data.gdriveFolder]
                            };
                            const media = {
                                mimeType: 'application/zip',
                                body: fs.createReadStream(data.mizFiles)
                            };
                            if (rsp.data.files.length > 0 ) {
                                drive.files.update({
                                    fileId: rsp.data.files[0].id,
                                    auth: jwtClient,
                                    media: media
                                }, (err, file) => {
                                    if (err) {
                                        // Handle error
                                        console.error(err);
                                    } else {
                                        console.log('File updated Id: ', file.id);
                                    }
                                });
                            } else {
                                drive.files.create({
                                    resource: fileMetadata,
                                    media: media,
                                    auth: jwtClient,
                                    fields: 'id'
                                }, (err, file) => {
                                    if (err) {
                                        // Handle error
                                        console.error(err);
                                    } else {
                                        console.log('File created Id: ', file.id);
                                    }
                                });
                            }
                        });
                    });
                });
        }
    });
}

module.exports = {
    getVersion: getVersion,
    setVersionfromString: setVersionfromString,
    setVersion: setVersion,
    displayVersion: displayVersion,
    getVersionObject: getVersionObject,
    nextMajor: nextMajor,
    nextMinor: nextMinor,
    nextPatch: nextPatch,
    copyMiz: copyMiz,
    mizUpdate: mizUpdate,
    getDestinationMizFilePaths: getDestinationMizFilePaths,
    getGeneratedMizFilePaths: getGeneratedMizFilePaths,
    publishMizFiles: publishMizFiles,
    getMissionObjectFromMiz: getMissionObjectFromMiz,
    getMapResourceObjectFromMiz: getMapResourceObjectFromMiz,
    mizInjectMissionDataFile: mizInjectMissionDataFile,
    mizInjectMapResourceFile: mizInjectMapResourceFile,
    injectScripts: injectScripts,
    mizUpdateSrcLuaFiles: mizUpdateSrcLuaFiles,
    mizUpdateLibLuaFiles: mizUpdateLibLuaFiles,
    mizOpen: mizOpen,
    addFilesToZip: addFilesToZip,
    mizUpdateLuaFile: mizUpdateLuaFile,
    mizInjectSettingsFolder: mizInjectSettingsFolder
}
