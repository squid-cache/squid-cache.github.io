##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

= Auto-Scaling build farm =
BuildFarm/DockerBuildFarm is very lightweight and it makes maximum use of available resources. But it can't increase resources on demand, and release them when not needed anymore. For that a different mechanism can be used, base don the Jenkins [[https://wiki.jenkins-ci.org/display/JENKINS/JClouds+Plugin|JClouds Plugin]].
The plugin will spin up new VMs when needed, install them and release them. While this mechanism is slower in having build environments available to the build system, it can scale to a high number of vCPUs on demand.

== Set up ==
/!\ This is really meant for sysadmins
To set up a new flavor, you need to
 1. In the [[http://build.squid-cache.org/configure|Jenkins > Manage Jenkins > Configure System]] page, in the Cloud (JClouds) section
   . create a new cloud instance template, copying one of the available ones
   . define an unique label for nodes in this template in the "labels" section
   . in order to find the image ID you'll need to use the CLI APIs
   . in the Advanced section, the "Init Script" contains the instructions to install the software needed for the build job. You can use the "yum-install" and "apt-get-install" aliases to have a more robust installation mechanism.
 1. XXX Finish writing this
 

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
