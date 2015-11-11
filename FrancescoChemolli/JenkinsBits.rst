##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
[[TableOfContents]]

'''Accessing Slaves'''
{{{
for (String slave: Jenkins.instance.getSlaves()) {
    println slave;
}
}}}
'''Filtering slaves by label substring'''
{{{
def result = []
for (Slave slave: Jenkins.instance.getSlaves()) {
//    println slave.getNodeName() + ": " + slave.getNodeDescription() + ", " + slave.getLabelString();
    if ( slave.getLabelString().contains("farm")) {
      result += slave.getNodeName()
    }
}
println result.toString()
}}}

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
