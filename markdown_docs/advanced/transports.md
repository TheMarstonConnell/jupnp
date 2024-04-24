:::::: {#section.ConfiguringTransports .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Configuring network transports
:::

:::: content
jUPnP has to accept and make HTTP requests to implement UPnP discovery,
action processing, and GENA eventing. This is the job of the
`StreamServer` and `StreamClient` implementations, working together with
the `Router` as the jUPnP network transport layer.

For the `StreamClient` SPI, the following implementations are bundled
with jUPnP:

`org.jupnp.transport.impl.StreamClientImpl` (default)
:   This implementation uses the JDK\'s `HTTPURLConnection`, it doesn\'t
    require any additional libraries. Note that jUPnP has to customize
    (with an ugly hack, really) the VM\'s `URLStreamHandlerFactory` to
    support additional HTTP methods such as `NOTIFY`, `SUBSCRIBE`, and
    `UNSUBSCRIBE`. The designers of the JDK do not understand HTTP very
    well and made this extremely difficult to extend. jUPnP\'s patch
    only works if no other code in your environment has already set a
    custom `URLStreamHandlerFactory`, you will get an exception on
    startup if this issue is detected; then you have to switch to
    another `StreamClient` implementation. Note that this implementation
    does *NOT WORK* on Android, the `URLStreamHandlerFactory` can\'t be
    patched on Android!

`org.jupnp.transport.impl.jetty.JettyStreamClientImpl`
:   This implementation is based on the *Jetty 9.3* HTTP client, you
    need the artifact `org.eclipse.jetty:jetty-client:9.3.14` on your
    classpath to use it. This implementation works in any environment,
    including Android. It is the default transport for
    `AndroidUpnpServiceConfiguration`.

For the `StreamServer` SPI, the following implementations are bundled
with jUPnP:

`org.jupnp.transport.impl.async.AsyncServletStreamServerImpl`
:   This implementation is based on the standard *Servlet 3.0* API and
    can be used in any environment with a compatible servlet container.
    It requires a `ServletContainerAdapter` to integrate with the
    servlet container, the bundled `JettyServletContainer` is such an
    adapter for a standalone *Jetty 9* server. You need the artifact
    `org.eclipse.jetty:jetty-servlet:9.3` on your classpath to use it.
    This implementation works in any environment, including Android. It
    is the default transport for `AndroidUpnpServiceConfiguration`. For
    other containers, write your own adapter and provide it to the
    `AsyncServletStreamServerConfigurationImpl`.

Each `StreamClient` and `StreamServer` implementation is paired with an
implementation of `StreamClientConfiguration` and
`StreamServerConfiguration`. This is how you override the jUPnP network
transport configuration:

<div>

``` prettyprint
...
public class MyUpnpServiceConfiguration extends DefaultUpnpServiceConfiguration {

    @Override
    protected Namespace createNamespace() {
        return new Namespace("/upnp"); // This will be the servlet context path
    }

    @Override
    public StreamClient createStreamClient() {
        return new org.jupnp.transport.impl.jetty.StreamClientImpl(
            new org.jupnp.transport.impl.jetty.JettyStreamClientConfigurationImpl(
                getSyncProtocolExecutor()
            )
        );
    }

    @Override
    public StreamServer createStreamServer(NetworkAddressFactory networkAddressFactory) {
        return new org.jupnp.transport.impl.AsyncServletStreamServerImpl(
            new org.jupnp.transport.impl.AsyncServletStreamServerConfigurationImpl(
                org.jupnp.transport.impl.jetty.JettyServletContainer.INSTANCE,
                networkAddressFactory.getStreamListenPort()
            )
        );
    }

}
```

</div>

The above configuration will use the Jetty client and the Jetty servlet
container. The `JettyServletContainer.INSTANCE` adapter is managing a
standalone singleton server, it is started and stopped when jUPnP starts
and stops the UPnP stack. If you have run jUPnP with an existing,
external servlet container, provide a custom adapter.
::::
::::::
