##master-page:SquidTemplate
#format wiki
#language en
#acl +FrancescoChemolli:read,write,revert,admin -All:read,write

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
<<TableOfContents>>

== Openstack and fun ==
Boot iso image from grub: https://help.ubuntu.com/community/Grub2/ISOBoot

== web @ Rackspace ==
'''installed packages'''
 screen vim-nox uwsgi python-django nginx-full uwsgi-plugin-python python-virtualenv python-dev libxml2-dev libxslt-dev zblib1g-dev python-mysqldb unzip

'''uwsgi'''
 https://library.linode.com/web-servers/nginx/python-uwsgi/ubuntu-12.04-precise-pangolin

'''pootle'''
 https://pootle.readthedocs.org/en/latest/users/getting_started.html

'''notes'''
 virtual env /www/pootle
 activate with {{{source /www/pootle/bin/activate}}}
