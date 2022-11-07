[TableOfContents](/TableOfContents#)

# Accessing Slaves

    for (String slave: Jenkins.instance.getSlaves()) {
        println slave;
    }

# iltering slaves by label substring

    def result = []
    for (Slave slave: Jenkins.instance.getSlaves()) {
    //    println slave.getNodeName() + ": " + slave.getNodeDescription() + ", " + slave.getLabelString();
        if ( slave.getLabelString().contains("farm")) {
          result += slave.getNodeName()
        }
    }
    println result.toString()

# Code for filtering

In
[](https://github.com/jenkinsci/matrix-project-plugin/blob/master/src/main/java/hudson/matrix/FilterScript.java)

Need to add binding for slaves accessor in apply at about line 88.

# possible alternate approach

define a parameter plugin which sets a parameter as the node name, or
NODE\_NAME env variable.

See for instance
[](https://wiki.jenkins-ci.org/display/JENKINS/Global+Variable+String+Parameter+Plugin)

# pipelines

attempt 1:

    stage "test-build"
    node('farm') {
        // clean workspace
        step([$class: 'WsCleanup'])
        // setup env..
        // copy the deployment unit from another Job
        step ([$class: 'CopyArtifact',
              projectName: '5-prepare-tarball',
              filter: 'squid-*-r*.tar.gz']);
        step ([$class: 'CopyArtifact',
              projectName: '5-prepare-tarball',
              filter: 'test-suite-r*.tar.gz']);
        sh "tar xfz squid-*-r*.tar.gz"
        squiddir = sh(returnStdout: true, script: 'ls squid-* | grep -v gz$').trim()
        dir(squiddir) {
            sh 'tar xfz ../test-suite-r*.tar.gz'
            sh './test-builds.sh --verbose --aggressively-use-config-cache'
        }
    }

Discuss this page using the "Discussion" link in the main menu
