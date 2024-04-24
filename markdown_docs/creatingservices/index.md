::::::: {#chapter.CreatingServices .chapter xmlns="http://www.w3.org/1999/xhtml" xmlns:xi="http://www.w3.org/2001/XInclude"}
::: title
Creating and binding services
:::

::::: content
Out of the box, any Java class can be a UPnP service. Let\'s go back to
the first example of a UPnP service in chapter 1, the
[SwitchPower:1](#section.SwitchPower) service implementation, repeated
here:

[](javacode://example.binarylight.SwitchPower){#switchpower_repeat
.citation}

This class depends on the `org.jupnp.annotation` package at
compile-time. The metadata encoded in these source annotations is
preserved in the bytecode and jUPnP will read it at runtime when you
[bind the service](#section.BindingDevice) (\"binding\" is just a fancy
word for reading and writing metadata). You can load and execute this
class without accessing the annotations, in any environment and without
having the jUPnP libraries on your classpath. This is a compile-time
dependency only.

jUPnP annotations give you much flexibility in designing your service
implementation class, as shown in the following examples.

::: section
[](javadoc://example.localservice.BasicBindingTest){.citation}
:::

An important piece is missing from the
[SwitchPower:1](#section.SwitchPower) implementation: It doesn\'t fire
any events when the status of the power switch changes. This is in fact
required by the specification that defines the *SwitchPower:1* service.
The following section explains how you can propagate state changes from
within your UPnP service to local and remote subscribers.

::: section
[](javadoc://example.localservice.EventProviderTest){.citation}
:::

More advanced mappings are possible and often required, as shown in the
next examples. We are now leaving the *SwitchPower* service behind, as
it is no longer complex enough.
:::::
:::::::
