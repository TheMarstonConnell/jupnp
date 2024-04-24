::::: {#section.BindingDevice .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Binding a UPnP device
:::

::: content
Devices (and embedded devices) are created programmatically in jUPnP,
with plain Java code that instantiates an immutable graph of objects.
The following method creates such a device graph and binds the service
from the previous section to the root device:

[](javacode://example.binarylight.BinaryLightServer#createDevice()){.citation}

Let\'s step through this code. As you can see, all arguments that make
up the device\'s metadata have to be provided through constructors,
because the metadata classes are immutable and hence thread-safe.

DeviceIdentity

:   Every device, no matter if it is a root device or an embedded device
    of a root device, requires a unique device name (UDN). This UDN
    should be stable, that is, it should not change when the device is
    restarted. When you physically unplug a UPnP appliance from the
    network (or when you simply turn it off or put it into standby
    mode), and when you make it available later on, it should expose the
    same UDN so that clients know they are dealing with the same device.
    The `UDN.uniqueSystemIdentifier()` method provides exactly that: A
    unique identifier that is the same every time this method is called
    on the same computer system. It hashes the network cards hardware
    address and a few other elements to guarantee uniqueness and
    stability.

DeviceType

:   The type of a device also includes its version, a plain integer. In
    this case the *BinaryLight:1* is a standardized device template
    which adheres to the UDA (UPnP Device Architecture) specification.

DeviceDetails

:   This detailed information about the device\'s \"friendly name\", as
    well as model and manufacturer information is optional. You should
    at least provide a friendly name value, this is what UPnP
    applications will display primarily.

Icon

:   Every device can have a bunch of icons associated with it which
    similar to the friendly name are shown to users when appropriate.
    You do not have to provide any icons if you don\'t want to, use a
    constructor of `LocalDevice` without an icon parameter.

Service

:   Finally, the most important part of the device are its services.
    Each `Service` instance encapsulates the metadata for a particular
    service, what actions and state variables it has, and how it can be
    invoked. Here we use the jUPnP annotation binder to instantiate a
    `Service`, reading the annotation metadata of the `SwitchPower`
    class.

Because a `Service` instance is only metadata that describes the
service, you have to set a `ServiceManager` to do some actual work. This
is the link between the metadata and your implementation of a service,
where the rubber meets the road. The `DefaultServiceManager` will
instantiate the given `SwitchPower` class when an action which operates
on the service has to be executed (this happens lazily, as late as
possible). The manager will hold on to the instance and always re-use it
as long as the service is registered with the UPnP stack. In other
words, the service manager is the factory that instantiates your actual
implementation of a UPnP service.

Also note that `LocalDevice` is the interface that represents a UPnP
device which is \"local\" to the running UPnP stack on the host. Any
device that has been discovered through the network will be a
`RemoteDevice` with `RemoteService`\'s, you typically do not instantiate
these directly.

A `ValidationException` will be thrown when the device graph you
instantiated was invaild, you can call `getErrors()` on the exception to
find out which property value of which class failed an integrity rule.
The local service annotation binder will provide a
`LocalServiceBindingException` if something is wrong with your
annotation metadata on your service implementation class. An
`IOException` can only by thrown by this particular `Icon` constructor,
when it reads the resource file.
:::
:::::
