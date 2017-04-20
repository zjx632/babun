#!/usr/bin/env groovy
import static java.lang.System.*

execute()

def execute() {
    File rootFolder, cygwinFolder, outputFolder
    try {
        checkArguments()
        (rootFolder, cygwinFolder, outputFolder, babunBranch) = initEnvironment()
        copyCygwin(rootFolder, cygwinFolder, outputFolder)
        installCore(rootFolder, outputFolder, babunBranch)
    } catch (Exception ex) {
        error("ERROR: Unexpected error occurred: " + ex + " . Quitting!", true)
        ex.printStackTrace()
        exit(-1)
    }
}

def checkArguments() {
    if (this.args.length != 4) {
        error("Usage: core.groovy <babun_root> <cygwin_folder> <output_folder> <babun_branch>")
        exit(-1)
    }
}

def initEnvironment() {
    File rootFolder = new File(this.args[0])
    File cygwinFolder = new File(this.args[1])
    File outputFolder = new File(this.args[2])
    String babunBranch = this.args[3]
    if (!outputFolder.exists()) {
        outputFolder.mkdir()
    }
    return [rootFolder, cygwinFolder, outputFolder, babunBranch]
}

def copyCygwin(File rootFolder, File cygwinFolder, File outputFolder) {
    new AntBuilder().copy( todir: "${outputFolder.absolutePath}/cygwin", quiet: true ) {
      fileset( dir: "${cygwinFolder.absolutePath}", defaultexcludes:"no" )
    }
}

// -----------------------------------------------------
// TODO - EXTERNALIZE THE INSTALLATION OF THE BABUN CORE
// THIS SHOULD BE A SEPARATE SHELL SCRIPT
// IT WILL ENABLE INSTALLING THE CORE ON OSX!!!
// -----------------------------------------------------
def installCore(File rootFolder, File outputFolder, String babunBranch) {
    // rebase dll's
    executeCmd("${outputFolder.absolutePath}/cygwin/bin/dash.exe -c '/usr/bin/rebaseall'", 5)

    // setup bash invoked
    String bash = "${outputFolder.absolutePath}/cygwin/bin/bash.exe -l"

    // checkout babun
    String repo = "\$( cygpath '${rootFolder.absolutePath}' )"
    String src = "/usr/local/etc/babun/source"
    String clone = "git -c 'http.sslverify=false' clone " +
        "\$( git --git-dir=\\\"${repo}/.git\\\" config --get remote.origin.url ) ${src}"
    String checkout = "git --git-dir='${src}/.git' --work-tree='${src}' checkout ${babunBranch}"
    executeCmd("${bash} -c \"${clone}; ${checkout};\"", 5)

    // remove windows new line feeds
    String dos2unix = "find /usr/local/etc/babun/source/babun-core -type f -exec dos2unix {} \\;"
    executeCmd("${bash} -c \"${dos2unix}\"", 5)

    // make installer executable
    String chmod = "find /usr/local/etc/babun/source/babun-core -type f -regex '.*sh' -exec chmod u+x {} \\;"
    executeCmd("${bash} -c \"${chmod}\"", 5)

    // invoke init.sh
    executeCmd("${bash} \"/usr/local/etc/babun/source/babun-core/tools/init.sh\"", 5)

    // run babun installer - yay!
    executeCmd("${bash} \"/usr/local/etc/babun/source/babun-core/plugins/install.sh\"", 5)
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
