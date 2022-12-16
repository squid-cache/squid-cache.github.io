---
categories: KnowledgeBase
---
# Illegal Instruction errors on Squid 3.4 and later

## Synopsis

Squid 3.4 and later, running on certain *paravirtualized systems*
and even some claiming full virtualization (at least KVM, Xen,
and Xen derivatives are confirmed so far) crashes with an illegal
instruction error soon after startup.

## Symptoms

  - Squid crashes with Illegal Instruction error immediately after
    startup on a virtual machine on Intel-compatible processors

## Explanation

The Squid build system uses by default the `  -march=native  ` gcc
option to optimize the resulting binary. Unfortunately certain
(para-)virtualization systems don't support the whole instruction set
they advertise. The compiler doesn't know, and generates instructions
which trigger this error.

## Workaround

These optimizations are helpful but not necessary to have a fully
functional squid, especially on ia64/amd64 platforms. The detected
defaults can be overridden by supplying the `--disable-arch-native`
option to the `configure` script.


