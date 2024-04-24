::::::: {#section.BasicAPI.Registry .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
The Registry
:::

::::: content
The `Registry`, which you access with `getRegistry()` on the
`UpnpService`, is the heart of a jUPnP Core UPnP stack. The registry is
responsible for:

-   Maintaining discovered UPnP devices on your network. It also offers
    a management API so you can register local devices and offer local
    services. This is how you expose your own UPnP devices on the
    network. The registry handles all notification, expiration, request
    routing, refreshing, and so on.
-   Managing GENA (general event & notification architecture)
    subscriptions. Any outgoing subscription to a remote service is
    known by the registry, it is refreshed periodically so it doesn\'t
    expire. Any incoming eventing subscription to a local service is
    also known and maintained by the registry (expired and removed when
    necessary).
-   Providing the interface for the addition and removal of
    `RegistryListener` instances. A registry listener is used in client
    or server UPnP applications, it provides a uniform interface for
    notification of registry events. Typically, you write and register a
    listener to be notified when a service you want to work with becomes
    available on the network - on a local or remote device - and when it
    disappears.

::: section
[](javadoc://example.registry.RegistryBrowseTest){.citation}
:::

::: section
[](javadoc://example.registry.RegistryListenerTest){.citation}
:::
:::::
:::::::
