##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2014-01-09T22:11:27Z)>>
##Page-Original-Author:FrancescoChemolli
#format wiki
#language en

= Illegal Instruction errors on Squid 3.4 =

'''Synopsis'''
Squid 3.4 and later, running on certain ''paravirtualized systems'' (at least Xen and its derivatives are confirmed so far) crashes with an illegal instruction error soon after creation.


'''Symptoms'''

 * Squid crashes with Illegal Instruction error immediately after startup on a paravirtualized virtual machine (Xen) on Intel-compatible processors

'''Explanation'''

[[Features/LargeRockStore]] needs 64-bit atomic operations to work. These are available natively on 64-bit architectures, but require processor-specific extensions on IA32 systems. In order to enable these extensions, the squid build systems needs to supply the {{{ -march=native }}} option to the compiler.
Unfortunately certain paravirtualization systems don't support the whole instruction set they advertise. The compiler doesn't know, and generates instructions which trigger the error.

'''Workaround'''

On 64-bit systems the native optimizations are helpful but not necessary to have a fully functional squid. The detected defaults can be overridden by supplying the {{{--disable-march-native}}} option to {{{configure}}}.
On 32-bit systems, these instructions '''are''' needed, so your only option is to run on a different environment. Full virtualization or a physical server are the best options.


----
CategoryKnowledgeBase
