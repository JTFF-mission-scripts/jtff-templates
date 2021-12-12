"use strict";

const { exec } = require("child_process");
const jszip = require("jszip");
const fs = require("fs");
const path = require("path");
const { promisify } = require('util');
const lstat = promisify(fs.lstat);

function getVersionFromPackageJson() {
    return getVersionObject(require("../../../package.json").version);
}
function setVersionfromString(strVersion) {
    return setVersion(getVersionObject(strVersion))
}
function setVersion(versionObject) {
    exec(
        "npm pkg set version=\'"
        + displayVersion(versionObject)
        + "\'"
        , (error, stdout, stderr) => {
            if (error) {
                console.log(`error: ${error.message}`);
                return;
            }
            if (stderr) {
                console.log(`stderr: ${stderr}`);
                return;
            }
            console.log(`stdout: ${stdout}`);
        });

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


module.exports = {
    getVersionFromPackageJson: getVersionFromPackageJson,
    setVersionfromString: setVersionfromString,
    setVersion: setVersion,
    displayVersion: displayVersion,
    getVersionObject: getVersionObject,
    nextMajor: nextMajor,
    nextMinor: nextMinor,
    nextPatch: nextPatch,
    copyMiz: copyMiz,
    mizUpdate: mizUpdate,
}
