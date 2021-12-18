"use strict";

const jszip = require("jszip");
const fs = require("fs");
const path = require("path");
const { promisify } = require('util');
const lstat = promisify(fs.lstat);
const config = require("../../../config.json");
const {google} = require("googleapis");

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
function mizUpdate(mizPath, copyPath, strTheatreSettings) {
    var MizFile = new jszip();
    fs.readFile(mizPath, function(err, mizData) {
        if (err) throw err;
        MizFile.loadAsync(mizData).then(async function (zip) {
            mizUpdateSrcLuaFiles(zip);
            mizUpdateSettingsLuaFiles(zip, strTheatreSettings);
            mizUpdateSoundFolders(zip);
            zip.generateNodeStream({
                type:'nodebuffer',
                streamFiles:true,
                compression: "DEFLATE",
                compressionOptions: {
                    level: 9
                }
            }).pipe(fs.createWriteStream(copyPath? copyPath: mizPath))
                .on('finish', function () {
                    // JSZip generates a readable stream with a "end" event,
                    // but is piped here in a writable stream which emits a "finish" event.
                    console.log((copyPath? copyPath: mizPath) + " written.");
                });
        });
    });
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
function mizUpdateSettingsLuaFiles(zip, strTheatre) {
    for (let file of fs.readdirSync('settings/'+strTheatre).filter( file => file.endsWith(".lua"))) {
        console.log('updating settings/'+strTheatre+'/' + file + ' file in miz file');
        mizUpdateLuaFile(zip, 'settings/'+strTheatre+'/' + file);
    };
}
function mizUpdateSoundFolders(zip) {
    console.log('adding sound files from resources/sounds folder...');
    addFilesToZip(zip, 'resources/sounds', fs.readdirSync('resources/sounds'));
}
function addFilesToZip (zip, directoryPath, filesToInclude) {
    const promiseArr = filesToInclude.map(async file => {
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
}
