# This is A Draft

Describe EliezerCroitoru/Drafts/rp_filter here.

# What is Reverse Path

Routing networks are complex since in many cases networks traffic is
"non-symetric".

In symetric networks the traffic from one network to another has a known
path which is known by all participating routers.

In asymetric(aka non-symetric) networks the traffic towards specific
network can flow towards the target inside a network which just forwards
the traffic closer to the target by assuming that the choosen path is
the best.

It can be an instruction by the admin or by an algorighm which the admin
applied.

The result can be that two packets from the same connection which by
definition is the same "tcp flow" (as an example) can be routed towards
the targer from 10 different ports of the target network edge router.

So there is only one or two(number for the example) routers in the
Internet that should publish a subnet to be theirs and by that all
traffic towards this subnet will flow towards them. There is no
restriction for this traffic to flow symetricly towards the target host.

A reverse path is a path, or can be sometimes identified by the router
"port", that is not the main for the router traffic to flow throw
towards the network.

As an example a router that has 3 interfaces with 3 IP addresses and
which interface 1 is the main traffic pipe of the network but also this
router allows another path of incomming packets towards it's network.

# What is Reverse Path Filtering?
