::::: {#chapter.BasicAPI .chapter xmlns="http://www.w3.org/1999/xhtml" xmlns:xi="http://www.w3.org/2001/XInclude"}
::: title
The jUPnP Core API
:::

::: content
The programming interface of jUPnP is fundamentally the same for UPnP
clients and servers. The single entry point for any program is the
`UpnpService` instance. Through this API you access the local UPnP
stack, and either execute operations as a client (control point) or
provide services to local or remote clients through the registry.

The following diagram shows the most important interfaces of jUPnP Core:

![API
Overview](img/api_overview.png){style="display:block; margin-left: auto; margin-right:auto;"}

You\'ll be calling these interfaces to work with UPnP devices and
interact with UPnP services. jUPnP provides a fine-grained meta-model
representing these artifacts:

![Metamodel
Overview](img/metamodel_overview.png){style="display:block; margin-left: auto; margin-right:auto;"}

In this chapter we\'ll walk through the API and metamodel in more
detail, starting with the `UpnpService`.
:::
:::::
