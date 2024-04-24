::::: {#section.SwitchPower .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
The SwitchPower service implementation
:::

::: content
This is the source of the *SwitchPower:1* service - note that although
there are many annotations in the source, no runtime dependency on jUPnP
exists:

[](javacode://example.binarylight.SwitchPower){.citation}

To compile this class the jUPnP Core library has to be available on your
classpath. However, once compiled this class can be instantiated and
executed in any environment, there are no dependencies on any framework
or library code.

The annotations are used by jUPnP to read the metadata that describes
your service, what UPnP state variables it has, how they are accessed,
and what methods should be exposed as UPnP actions. You can also provide
jUPnP metadata in an XML file or programmatically through Java code -
both options are discussed later in this manual. Source code annotations
are usually the best choice.

You might have expected something even simpler: After all, a *binary
light* only needs a single boolean state, it is either on or off. The
designers of this service also considered that there might be a
difference between switching the light on, and actually seeing the
result of that action. Imagine what happens if the light bulb is broken:
The target state of the light is set to *true* but the status is still
*false*, because the *SetTarget* action could not make the switch.
Obviously this won\'t be a problem with this simple demonstration
because it only prints the status to standard console output.
:::
:::::
