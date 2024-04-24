::::::::::::::::::::: {#section.BasicAPI.UpnpService .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Working with a UpnpService
:::

::::::::::::::::::: content
The `UpnpService` is an interface:

<div>

``` prettyprint
public interface UpnpService {

    public UpnpServiceConfiguration getConfiguration();
    public ProtocolFactory getProtocolFactory();
    public Router getRouter();

    public ControlPoint getControlPoint();
    public Registry getRegistry();

    public void shutdown();

}
```

</div>

An instance of `UpnpService` represents a running UPnP stack, including
all network listeners, background maintenance threads, and so on. jUPnP
Core bundles a default implementation which you can simply instantiate
as follows:

<div>

``` prettyprint
UpnpService upnpService = new UpnpServiceImpl();
```

</div>

With this implementation, the local UPnP stack is ready immediately, it
listens on the network for UPnP messages. You should call the
`shutdown()` method when you no longer need the UPnP stack. The bundled
implementation will then cut all connections with remote event listeners
and also notify all other UPnP participants on the network that your
local services are no longer available. If you do not shutdown your UPnP
stack, remote control points might think that your services are still
available until your earlier announcements expire.

The bundled implementation offers two additional constructors:

<div>

``` prettyprint
UpnpService upnpService =
    new UpnpServiceImpl(RegistryListener... registryListeners);
```

</div>

This constructor accepts your custom `RegistryListener` instances, which
will be activated immediately even before the UPnP stack listens on any
network interface. This means that you can be notified of *all* incoming
device and service registrations as soon as the network stack is ready.
Note that this is rarely useful, you\'d typically send search requests
after the stack is up and running anyway - after adding listeners to the
registry.

The second constructor supports customization of the UPnP stack
configuration:

<div>

``` prettyprint
UpnpService upnpService =
    new UpnpServiceImpl(new DefaultUpnpServiceConfiguration(8081));
```

</div>

This example configuration will change the TCP listening port of the
UPnP stack to `8081`, the default being an ephemeral (system-selected
free) port. The `UpnpServiceConfiguration` is also an interface, in the
example above you can see how the bundled default implementation is
instantiated.

The following section explain the methods of the `UpnpService` interface
and what they return in more detail.

:::::: {#section.BasicAPI.UpnpService.Configuration .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Customizing configuration settings
:::

:::: content
This is the configuration interface of the default UPnP stack in jUPnP
Core, an instance of which you have to provide when creating the
`UpnpServiceImpl`:

<div>

``` prettyprint
public interface UpnpServiceConfiguration {

    // NETWORK
    public NetworkAddressFactory createNetworkAddressFactory();

    public StreamClient createStreamClient();
    public StreamServer createStreamServer(NetworkAddressFactory naf);

    public MulticastReceiver createMulticastReceiver(NetworkAddressFactory naf);
    public DatagramIO createDatagramIO(NetworkAddressFactory naf);

    // PROCESSORS
    public DatagramProcessor getDatagramProcessor();
    public SOAPActionProcessor getSoapActionProcessor();
    public GENAEventProcessor getGenaEventProcessor();

    // DESCRIPTORS
    public DeviceDescriptorBinder getDeviceDescriptorBinderUDA10();
    public ServiceDescriptorBinder getServiceDescriptorBinderUDA10();

    // EXECUTORS
    public Executor getMulticastReceiverExecutor();
    public Executor getDatagramIOExecutor();
    public Executor getStreamServerExecutor();
    public Executor getAsyncProtocolExecutor();
    public Executor getSyncProtocolExecutor();
    public Executor getRegistryMaintainerExecutor();
    public Executor getRegistryListenerExecutor();

    // REGISTRY
    public Namespace getNamespace();
    public int getRegistryMaintenanceIntervalMillis();
    ...

}
```

</div>

This is quite an extensive SPI but you typically won\'t implement it
from scratch. Overriding and customizing the bundled
`DefaultUpnpServiceConfiguration` should suffice in most cases.

The configuration settings reflect the internal structure of jUPnP Core:

Network

:   The `NetworkAddressFactory` provides the network interfaces, ports,
    and multicast settings which are used by the UPnP stack. At the time
    of writing, the following interfaces and IP addresses are ignored by
    the default configuration: any IPv6 interfaces and addresses,
    interfaces whose name is \"vmnet\*\", \"vnic\*\", \"\*virtual\*\",
    or \"ppp\*\", and the local loopback. Otherwise, all interfaces and
    their TCP/IP addresses are used and bound.

    You can set the system property `org.jupnp.network.useInterfaces` to
    provide a comma-separated list of network interfaces you\'d like to
    bind exclusively. Additionally, you can restrict the actual TCP/IP
    addresses to which the stack will bind with a comma-separated list
    of IP address provided through the `org.jupnp.network.useAddresses`
    system property.

    Furthermore, the configuration produces the network-level message
    receivers and senders, that is, the implementations used by the
    network `Router`.

    Stream messages are TCP/HTTP requests and responses, the default
    configuration will use the Sun JDK 6.0 webserver to listen for HTTP
    requests, and it sends HTTP requests with the standard JDK
    `HttpURLConnection`. This means there are by default no additional
    dependencies on any HTTP server/library by jUPnP Core. However, if
    you are trying to use jUPnP Core in a runtime container such as
    Tomcat, JBoss AS, or Glassfish, you might run into an error on
    startup. The error tells you that jUPnP couldn\'t use the Java
    JDK\'s `HTTPURLConnection` for HTTP client operations. This is an
    old and badly designed part of the JDK: Only \"one application\" in
    the whole JVM can configure URL connections. If your container is
    already using the `HTTPURLConnection`, you have to switch jUPnP to
    an alternative HTTP client. See [Configuring network
    transports](#section.ConfiguringTransports) for other available
    options and how to change various network-related settings.

    UDP unicast and multicast datagrams are received, parsed, and send
    by a custom implementation bundled with jUPnP Core that does not
    require any particular Sun JDK classes, they should work an all
    platforms and in any environment.

Processors

:   The payload of SSDP datagrams is handled by a default processor, you
    rarely have to customize it. SOAP action and GENA event messages are
    also handled by configurable processors, you can provide alternative
    implementations if necessary, see [Switching XML
    processors](#section.SwitchingXMLProcessors). For best
    interoperability with other (broken) UPnP stacks, consider switching
    from the strictly specification-compliant default SOAP and GENA
    processors to the more lenient alternatives.

Descriptors

:   Reading and writing UPnP XML device and service descriptors is
    handled by dedicated binders, see [Switching descriptor XML
    binders](#section.SwitchingXMLDescriptorBinders). For best
    interoperability with other (broken) UPnP stacks, consider switching
    from the strictly specification-compliant default binders to the
    more lenient alternatives.

Executors

:   The jUPnP UPnP stack is multi-threaded, thread creation and
    execution is handled through `java.util.concurrent` executors. The
    default configuration uses a pool of threads with a maximum size of
    64 concurrently running threads, which should suffice for even very
    large installations. Executors can be configured fine-grained, for
    network message handling, actual UPnP protocol execution (handling
    discovery, control, and event procedures), and local registry
    maintenance and listener callback execution. Most likely you will
    not have to customize any of these settings.

Registry

:   Your local device and service XML descriptors and icons can be
    served with a given `Namespace`, defining how the URL paths of local
    resources is constructed. You can also configure how frequently
    jUPnP will check its `Registry` for outdated devices and expired
    GENA subscriptions.

There are various other, rarely needed, configuration options available
for customizing jUPnP\'s behavior, see the Javadoc of
`UpnpConfiguration`.
::::
::::::

:::::: {#section.BasicAPI.UpnpService.ProtocolFactory .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
The protocol factory
:::

:::: content
jUPnP Core internals are modular and any aspect of the UPnP protocol is
handled by an implementation (class) which can be replaced without
affecting any other aspect. The `ProtocolFactory` provides
implementations, it is always the first access point for the UPnP stack
when a message which arrives on the network or an outgoing message has
to be handled:

<div>

``` prettyprint
public interface ProtocolFactory {

    public ReceivingAsync createReceivingAsync(IncomingDatagramMessage message)
                            throws ProtocolCreationException;;

    public ReceivingSync createReceivingSync(StreamRequestMessage requestMessage);
                            throws ProtocolCreationException;;

    public SendingNotificationAlive createSendingNotificationAlive(LocalDevice ld);
    public SendingNotificationByebye createSendingNotificationByebye(LocalDevice ld);
    public SendingSearch createSendingSearch(UpnpHeader searchTarget);
    public SendingAction createSendingAction(ActionInvocation invocation, URL url);
    public SendingSubscribe createSendingSubscribe(RemoteGENASubscription s);
    public SendingRenewal createSendingRenewal(RemoteGENASubscription s);
    public SendingUnsubscribe createSendingUnsubscribe(RemoteGENASubscription s);
    public SendingEvent createSendingEvent(LocalGENASubscription s);
    
}
```

</div>

This API is a low-level interface that allows you to access the
internals of the UPnP stack, in the rare case you need to manually
trigger a particular procedure.

The first two methods are called by the networking code when a message
arrives, either multicast or unicast UDP datagrams, or a TCP (HTTP)
stream request. The default protocol factory implementation will then
pick the appropriate receiving protocol implementation to handle the
incoming message.

The local registry of local services known to the UPnP stack naturally
also sends messages, such as ALIVE and BYEBYE notifications. Also, if
you write a UPnP control point, various search, control, and eventing
messages are send by the local UPnP stack. The protocol factory
decouples the message sender (registry, control point) from the actual
creation, preparation, and transmission of the messages.

Transmission and reception of messages at the lowest-level is the job of
the network `Router`.
::::
::::::

:::::: {#section.BasicAPI.UpnpService.Router .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Accessing low-level network services
:::

:::: content
The reception and sending of messages, that is, all message transport,
is encapsulated through the `Router` interface:

<div>

``` prettyprint
public interface Router {

    public void received(IncomingDatagramMessage msg);
    public void received(UpnpStream stream);

    public void send(OutgoingDatagramMessage msg);
    public StreamResponseMessage send(StreamRequestMessage msg);

    public void broadcast(byte[] bytes);

}
```

</div>

UPnP works with two types of messages: Multicast and unicast UDP
datagrams which are typically handled asynchronously, and
request/response TCP messages with an HTTP payload. The jUPnP Core
bundled `RouterImpl` will instantiate and maintain the listeners for
incoming messages as well as transmit any outgoing messages.

The actual implementation of a message receiver which listens on the
network or a message sender is provided by the
`UpnpServiceConfiguration`, which we have introduced earlier. You can
access the `Router` directly if you have to execute low-level operations
on the network layer of the UPnP stack.

Most of the time you will however work with the `ControlPoint` and
`Registry` interfaces to interact with the UPnP stack.
::::
::::::
:::::::::::::::::::
:::::::::::::::::::::
