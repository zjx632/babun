#!/usr/bin/env groovy
import static java.lang.System.*

execute()

def execute() {
    File mirrorFile, repoFolder, inputFolder, outputFolder, cygwinFolder, pkgsFile
    boolean downloadOnly
    String arch
    try {
        checkArguments()
        (mirrorFile, repoFolder, inputFolder, outputFolder, cygwinFolder, pkgsFile, downloadOnly, arch) = initEnvironment()
        // install cygwin
        File cygwinInstaller = downloadCygwinInstaller(outputFolder, arch)
        if(downloadOnly) {
            println "downloadOnly flag set to true - Cygwin installation skipped.";
            return
        }
        installCygwin(cygwinInstaller, mirrorFile, repoFolder, cygwinFolder, pkgsFile)
        //cygwinInstaller.delete()

        // handle symlinks
        copySymlinksScripts(inputFolder, cygwinFolder)
        findSymlinks(cygwinFolder)
    } catch (Exception ex) {
        error("ERROR: Unexpected error occurred: " + ex + " . Quitting!", true)
        ex.printStackTrace()
        exit(-1)
    }
}

def checkArguments() {
	println "checkArguments ${this.args.length}"
    if (this.args.length != 7) {
        error("Usage: cygwin.groovy <mirror> <repo_folder> <input_folder> <output_folder> <pkgs_file> <download_only>  <arch>")
        exit(-1)
    }
}

def initEnvironment() {
    File mirrorFile = new File(this.args[0])
	File repoFolder = new File(this.args[1])
    File inputFolder = new File(this.args[2])
    File outputFolder = new File(this.args[3])
    File pkgsFile = new File(this.args[4])
    boolean downloadOnly =  Boolean.parseBoolean(this.args[5])
    if (!outputFolder.exists()) {
        outputFolder.mkdir()
    }
    File cygwinFolder = new File(outputFolder, "cygwin")
    cygwinFolder.mkdir()
    return [mirrorFile, repoFolder, inputFolder, outputFolder, cygwinFolder, pkgsFile, downloadOnly, this.args[6]]
}

def downloadCygwinInstaller(File outputFolder, String arch) {
    File cygwinInstaller = new File(outputFolder, "setup-${arch}.exe")
    if(!cygwinInstaller.exists()) {
        println "Downloading Cygwin installer"
        use(FileBinaryCategory) {
            cygwinInstaller << "http://cygwin.com/setup-${arch}.exe".toURL()
        }
    } else {
        println "Cygwin installer alread exists, skipping the download!";
    }

    return cygwinInstaller
}

def installCygwin(File cygwinInstaller, File mirrorFile, File repoFolder, File cygwinFolder, File pkgsFile) {
    println "Installing cygwin"
    String pkgs = pkgsFile.text.trim().replaceAll("(\\s)+", ",")
    println "Packages to install: ${pkgs}"
    String installCommand = "\"${cygwinInstaller.absolutePath}\" " +
            "--quiet-mode " +
            "--no-admin " +
            "--root \"${cygwinFolder.absolutePath}\" " +
			"--local-package-dir \"${repoFolder.absolutePath}\" " +
            "--no-shortcuts " +
            "--no-startmenu " +
            "--no-desktop " +
			"--categories Base " +
			"--site \"${mirrorFile.text.trim()}\" " +
            "--packages " + pkgs
    println installCommand
    executeCmd(installCommand, 10)
}

def copySymlinksScripts(File inputFolder, File cygwinFolder) {
    new AntBuilder().copy(todir: "${cygwinFolder.absolutePath}/etc/postinstall", quiet: true) {
        fileset(dir: "${inputFolder.absolutePath}/symlinks", defaultexcludes:"no")
    }
}

def findSymlinks(File cygwinFolder) {
    String symlinksFindScript = "/etc/postinstall/symlinks_find.sh"
    String findSymlinksCmd = "${cygwinFolder.absolutePath}/bin/bash.exe --norc --noprofile \"${symlinksFindScript}\""
    executeCmd(findSymlinksCmd, 10)
    new File(cygwinFolder, symlinksFindScript).renameTo(new File(cygwinFolder, symlinksFindScript + ".done"))
}

def executeCmd(String command, int timeout) {
    println "Executing: ${command}"
    def process = command.execute()
    addShutdownHook { process.destroy() }
    process.consumeProcessOutput(out, err)
    process.waitForOrKill(timeout * 60000)
    assert process.exitValue() == 0
}

def error(String message, boolean noPrefix = false) {
    err.println((noPrefix ? "" : "ERROR: ") + message)
}

class FileBinaryCategory {
    def static leftShift(File file, URL url) {
        url.withInputStream { is ->
            file.withOutputStream { os ->
                def bs = new BufferedOutputStream(os)
                bs << is
            }
        }
    }
}
