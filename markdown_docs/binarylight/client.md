::::: {#section.BinaryLightClient .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Creating a control point
:::

::: content
The client application has the same basic scaffolding as the server, it
also uses a shared single instance of `UpnpService`:

[](javacode://example.binarylight.BinaryLightClient){.citation
style="exclude: REGISTRYLISTENER, EXECUTEACTION"}

Typically a control point sleeps until a device with a specific type of
service becomes available on the network. The `RegistryListener` is
called by jUPnP when a remote device has been discovered - or when it
announced itself automatically. Because you usually do not want to wait
for the periodic announcements of devices, a control point can also
execute a search for all devices (or devices with certain service types
or UDN), which will trigger an immediate discovery announcement from
those devices that match the search query.

You can already see the `ControlPoint` API here with its `search(...)`
method, this is one of the main interfaces you interact with when
writing a UPnP client with jUPnP.

If you compare this code with the server code from the previous section
you can see that we are not shutting down the `UpnpService` when the
application quits. This is not an issue here, because this application
does not have any local devices or service event listeners (not the same
as registry listeners) bound and registered. Hence, we do not have to
announce their departure on application shutdown and can keep the code
simple for the sake of the example.

Let\'s focus on the registry listener implementation and what happens
when a UPnP device has been discovered on the network.
:::
:::::
