::::::::::::::::::::::::::::::: {#chapter.Android .chapter xmlns="http://www.w3.org/1999/xhtml"}
::: title
jUPnP on Android
:::

::::::::::::::::::::::::::::: content
jUPnP Core provides a UPnP stack for Android applications. Typically
you\'d write control point applications, as most Android systems today
are small hand-held devices. You can however also write UPnP server
applications on Android, all features of jUPnP Core are supported.

Android platform level 15 (4.0) is required for jUPnP 2.x, use jUPnP 1.x
to support older Android versions.

:::: note
::: title
jUPnP on the Android emulator
:::

At the time of writing, receiving UDP Multicast datagrams was not
supported by the Android emulator. The emulator will send (multicast)
UDP datagrams, however. You will be able to send a multicast UPnP search
and receive UDP unicast responses, therefore discover existing running
devices. You will not discover devices which have been turned on after
your search, and you will not receive any message when a device is
switched off. Other control points on your network will not discover
your local Android device/services at all. All of this can be confusing
when testing your application, so unless you really understand what
works and what doesn\'t, you might want to use a real device instead.
::::

The following examples are based on the jUPnP demo applications for
Android, the `jupnp-demo-android-browser` and the
`jupnp-demo-android-light`, available in the jUPnP distribution.

::::: {#section.Android.ConfiguringService .section}
::: title
Configuring the application service
:::

::: content
You could instantiate the jUPnP `UpnpService` as usual in your Android
application\'s main activity. On the other hand, if several activities
in your application require access to the UPnP stack, a better design
would utilize a background `android.app.Service`. Any activity that
wants to access the UPnP stack can then bind and unbind from this
service as needed.

The interface of such a service component is available in jUPnP as
`org.jupnp.android.AndroidUpnpService`:

[](javacode://org.jupnp.android.AndroidUpnpService){.citation
style="include:CLASS;"}

An activity typically accesses the `Registry` of known UPnP devices or
searches for and controls UPnP devices with the `ControlPoint`.

You have to configure the built-in implementation of this service
component in your `AndroidManifest.xml`, along with various required
permissions:

[](file://AndroidManifest.xml){.citation}

If a WiFi interface is present, jUPnP requires access to the interface.
jUPnP will automatically detect when network interfaces are switched on
and off and handle this situation gracefully: Any client operation will
result in a \"no response from server\" state when no network is
available. Your client code has to handle such a situation anyway.

jUPnP uses a custom configuration on Android, the
`AndroidUpnpServiceConfiguration`, utilizing the Jetty transport and the
`Recovering*` XML parsers and processors. See the Javadoc of the class
for more information.

*Jetty 8 libraries are required to use jUPnP on Android, see the demo
applications for Maven dependencies!*

For example, these dependencies are usually required in a Maven POM for
jUPnP to work on Android:

    <dependency>
        <groupId>org.eclipse.jetty</groupId>
        <artifactId>jetty-server</artifactId>
        <version>${jetty.version}</version>
    </dependency>
    <dependency>
        <groupId>org.eclipse.jetty</groupId>
        <artifactId>jetty-servlet</artifactId>
        <version>${jetty.version}</version>
    </dependency>
    <dependency>
        <groupId>org.eclipse.jetty</groupId>
        <artifactId>jetty-client</artifactId>
        <version>${jetty.version}</version>
    </dependency>
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-jdk14</artifactId>
        <version>${slf4j.version}</version>
    </dependency>

The service component starts and stops the UPnP system when the service
component is created and destroyed. This depends on how you access the
service component from within your activities.
:::
:::::
## {#section.Android.BindService .section}
::: title
Accessing the service from an activity
:::

::::: content
The lifecycle of service components in Android is well defined. The
first activity which binds to a service will start the service if it is
not already running. When no activity is bound to the service any more,
the operating system will destroy the service.

Let\'s write a simple UPnP browsing activity. It shows all devices on
your network in a list and it has a menu option which triggers a search
action. The activity connects to the UPnP service and then listens to
any device additions or removals in the `Registry`, so the displayed
list of devices is kept up-to-date:

[](javacode://org.jupnp.demo.android.browser.BrowserActivity){.citation
style="include:CLASS, CLASS_END, SERVICE_BINDING;"}

We utilize the default layout provided by the Android runtime and the
`ListActivity` superclass. Note that this activity can be your
applications main activity, or further up in the stack of a task. The
`listAdapter` is the glue between the device additions and removals on
the jUPnP `Registry` and the list of items shown in the user interface.

:::: note
::: title
Debug logging on Android
:::

jUPnP uses SLF4J logging. Use either DEBUG or TRACE logging level.
::::

The `upnpService` variable is `null` when no backend service is bound to
this activity. Binding and unbinding occurs in the `onCreate()` and
`onDestroy()` callbacks, so the activity is bound to the service as long
as it is alive.

Binding and unbinding the service is handled with the
`ServiceConnection`: On connect, first a listener is added to the
`Registry` of the UPnP service. This listener will process additions and
removals of devices as they are discovered on your network, and update
the items shown in the user interface list. The `BrowseRegistryListener`
is removed when the activity is destroyed.

Then any already discovered devices are added manually to the user
interface, passing them through the listener. (There might be none if
the UPnP service was just started and no device has so far announced its
presence.) Finally, you start asynchronous discovery by sending a search
message to all UPnP devices, so they will announce themselves. This
search message is NOT required every time you connect to the service. It
is only necessary once, to populate the registry with all known devices
when your (main) activity and application starts.

This is the `BrowseRegistryListener`, its only job is to update the
displayed list items:

[](javacode://org.jupnp.demo.android.browser.BrowserActivity.BrowseRegistryListener){.citation}

For performance reasons, when a new device has been discovered, we
don\'t wait until a fully hydrated (all services retrieved and
validated) device metadata model is available. We react as quickly as
possible and don\'t wait until the `remoteDeviceAdded()` method will be
called. We display any device even while discovery is still running.
You\'d usually not care about this on a desktop computer, however,
Android handheld devices are slow and UPnP uses several bloated XML
descriptors to exchange metadata about devices and services. Sometimes
it can take several seconds before a device and its services are fully
available. The `remoteDeviceDiscoveryStarted()` and
`remoteDeviceDiscoveryFailed()` methods are called as soon as possible
in the discovery process. On modern fast Android handsets, and unless
you have to deal with dozens of UPnP devices on a LAN, you don\'t need
this optimization.

By the way, devices are equal (`a.equals(b)`) if they have the same UDN,
they might not be identical (`a==b`).

The `Registry` will call the listener methods in a separate thread. You
have to update the displayed list data in the thread of the user
interface.

The following methods on the activity add a menu with a search action,
so a user can refresh the list manually:

[](javacode://org.jupnp.demo.android.browser.BrowserActivity){#org.jupnp.demo.android.browser.BrowserActivity_menu
.citation style="include:CLASS, CLASS_END, MENU; exclude: OPTIONAL;"}

Finally, the `DeviceDisplay` class is a very simple JavaBean that only
provides a `toString()` method for rendering the list. You can display
any information about UPnP devices by changing this method:

[](javacode://org.jupnp.demo.android.browser.BrowserActivity.DeviceDisplay){.citation
style="exclude: DETAILS;"}

We have to override the equality operations as well, so we can remove
and add devices from the list manually with the `DeviceDisplay` instance
as a convenient handle.

So far we have implemented a UPnP control point, next we create a UPnP
device with services.
:::::
:::::::

:::::: {#section.Android.LocalDevice .section}
::: title
Creating a UPnP device
:::

The following activity provides a UPnP service, the well known
*SwitchPower:1* with a *BinaryLight:1* device:

[](javacode://org.jupnp.demo.android.light.LightActivity){.citation
style="include:CLASS, CLASS_END, SERVICE_BINDING; exclude: LOGGING;"}

When the UPnP service is bound, for the first time, we check if the
device has already been created by querying the `Registry`. If not, we
create the device and add it to the `Registry`.

:::: note
::: title
Generating a stable UDN on Android
:::

The UDN of a UPnP device is supposed to be stable: It should not change
between restarts of the device. Unfortunately, the jUPnP helper method
`UDN.uniqueSystemIdentifier()` doesn\'t work on Android, see its
Javadoc. Generating a new UUID every time your activity starts might be
OK for testing, in production you should generate a UUID once when your
application starts for the first time and store the UUID value in your
application\'s preferences.
::::

The activity is also a JavaBean `PropertyChangeListener`, registered
with `SwitchPower` service. Note that this is JavaBean eventing, it has
nothing to do with UPnP GENA eventing! We monitor the state of the
service and switch the UI accordingly, turning the light on and off:

[](javacode://org.jupnp.demo.android.light.LightActivity){#org.jupnp.demo.android.light.LightActivity_propertyChange
.citation style="include:CLASS, CLASS_END, PROPERTY_CHANGE;"}

The `createDevice()` method simply instantiates a new `LocalDevice`:

[](javacode://org.jupnp.demo.android.light.LightActivity){#org.jupnp.demo.android.light.LightActivity_createDevice
.citation style="include:CLASS, CLASS_END, CREATE_DEVICE;"}

For the `SwitchPower` class, again note the dual eventing for JavaBeans
and UPnP:

[](javacode://org.jupnp.demo.android.light.SwitchPower){.citation
style="include:CLASS"}
::::::

:::::::::::::: {#section.Android.Optimize .section}
::: title
Optimizing service behavior
:::

:::::::::::: content
The UPnP service consumes memory and CPU time while it is running.
Although this is typically not an issue on a regular machine, this might
be a problem on an Android handset. You can preserve memory and handset
battery power if you disable certain features of the jUPnP UPnP service,
or if you even pause and resume it when appropriate.

Furthermore, some Android handsets do not support multicast networking
(HTC phones, for example), so you have to configure jUPnP accordingly on
such a device and disable most of the UPnP discovery protocol.

::::: {#section.Android.Optimize.MaintainRegistry .section}
::: title
Tuning registry maintenance
:::

::: content
There are several things going on in the background while the service is
running. First, there is the registry of the service and its maintenance
thread. If you are writing a control point, this background registry
maintainer is going to renew your outbound GENA subscriptions with
remote services periodically. It will also expire and remove any
discovered remote devices when the drop off the network without saying
goodbye. If you are providing a local service, your device announcements
will be refreshed by the registry maintainer and inbound GENA
subscriptions will be removed if they haven\'t been renewed in time.
Effectively, the registry maintainer prevents stale state on the UPnP
network, so all participants have an up-to-date view of all other
participants, and so on.

By default the registry maintainer will run every second and check if
there is something to do (most of the time there is nothing to do, of
course). The default Android configuration however has a default sleep
interval of three seconds, so it is already consuming less background
CPU time - while your application might be exposed to somewhat outdated
information. You can further tune this setting by overriding the
`getRegistryMaintenanceIntervalMillis()` in the
`UpnpServiceConfiguration`. On Android, you have to subclass the service
implementation to provide a new configuration:

[](javacode://org.jupnp.demo.android.browser.BrowserUpnpService){.citation
style="include:CLASS; exclude: SERVICE_TYPE;"}

Don\'t forget to now configure `BrowserUpnpService` in your
`AndroidManifest.xml` instead of the original implementation. You also
have to use this class when binding to the service in your activities
instead of `AndroidUpnpServiceImpl`.
:::
:::::

::::: {#section.Android.Optimize.PauseRegistry .section}
::: title
Pausing and resuming registry maintenance
:::

::: content
Another more effective but also more complex optimization is pausing and
resuming the registry whenever your activities no longer need the UPnP
service. This is typically the case when an activity is no longer in the
foreground (paused) or even no longer visible (stopped). By default any
activity state change has no impact on the state of the UPnP service
unless you bind and unbind from and to the service in your activities
lifecycle callbacks.

In addition to binding and unbinding from the service you can also pause
its registry by calling `Registry#pause()` when your activity\'s
`onPause()` or `onStop()` method is called. You can then resume the
background service maintenance (thread) with `Registry#resume()`, or
check the status with `Registry#isPaused()`.

Please read the Javadoc of these methods for more details and what
consequences pausing registry maintenance has on devices, services, and
GENA subscriptions. Depending on what your application does, this rather
minor optimization might not be worth dealing with these effects. On the
other hand, your application should already be able to handle failed
GENA subscription renewals, or disappearing remote devices!
:::
:::::

::::: {#section.Android.Optimize.Discovery .section}
::: title
Configuring discovery
:::

::: content
The most effective optimization is selective discovery of UPnP devices.
Although the UPnP service\'s network transport layer will keep running
(threads are waiting and sockets are bound) in the background, this
feature allows you to drop discovery messages selectively and quickly.

For example, if you are writing a control point, you can drop any
received discovery message if it doesn\'t advertise the service you want
to control - you are not interested in any other device. On the other
hand if you only *provide* devices and services, all discovery messages
(except search messages for your services) can probably be dropped, you
are not interested in any remote devices and their services at all.

Discovery messages are selected and potentially dropped by jUPnP as soon
as the UDP datagram content is available, so no further parsing and
processing is needed and CPU time/memory consumption is significantly
reduced while you keep the UPnP service running even in the background
on an Android handset.

To configure which services are supported by your control point
application, override the configuration and provide an array of
`ServiceType` instances:

[](javacode://org.jupnp.demo.android.browser.BrowserUpnpService){#org.jupnp.demo.android.browser.BrowserUpnpService_serviceType
.citation style="include:CLASS; exclude: REGISTRY;"}

This configuration will ignore any advertisement from any device that
doesn\'t also advertise a *schemas-upnp-org:SwitchPower:1* service. This
is what our control point can handle, so we don\'t need anything else.
If instead you\'d return an empty array (the default behavior), all
services and devices will be discovered and no advertisements will be
dropped.

If you are not writing a control point but a server application, you can
return `null` in the `getExclusiveServiceTypes()` method. This will
disable discovery completely, now all device and service advertisements
are dropped as soon as they are received.
:::
:::::
::::::::::::
::::::::::::::
:::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::
