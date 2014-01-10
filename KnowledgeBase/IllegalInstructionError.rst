##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2014-01-09T22:11:27Z)>>
##Page-Original-Author:FrancescoChemolli
#format wiki
#language en

= Illegal Instruction errors on Squid 3.4 =

'''Synopsis'''
Squid 3.4 and later, running on certain ''paravirtualized systems'' (at least Xen and its derivatives are confirmed so far) crashes with an illegal instruction error soon after startup.


'''Symptoms'''

 * Squid crashes with Illegal Instruction error immediately after startup on a paravirtualized virtual machine (Xen) on Intel-compatible processors

'''Explanation'''

The Squid build system uses by default the {{{ -march=native }}} gcc option to optimize the resulting binary.
Unfortunately certain paravirtualization systems don't support the whole instruction set they advertise. The compiler doesn't know, and generates instructions which trigger this error.

'''Workaround'''

These optimizations are helpful but not necessary to have a fully functional squid, especially on ia64/amd64 platforms. The detected defaults can be overridden by supplying the {{{--disable-march-native}}} option to the {{{configure}}} script.

----
CategoryKnowledgeBase
