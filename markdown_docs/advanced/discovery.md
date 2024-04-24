::::::::::::::::: {#section.DiscoveryProblems .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Solving discovery problems
:::

::::::::::::::: content
Device discovery in UPnP is the job of SSDP, the Simple Service
Discovery Protocol. Of course, this protocol is not simple at all and
many device manufacturers and UPnP stacks get it wrong. jUPnP has some
extra settings to deal with such environments; if you want best
interoperability for your application, you have to read the following
sections.

::::: {#section.RemoteMaxAge .section}
::: title
Maximum age of remote devices
:::

::: content
If you are writing a control point and remote devices seem to randomly
disappear from your `Registry`, you are probably dealing with a remote
device that doesn\'t send regular alive NOTIFY heartbeats through
multicast. Or, your control point runs on a device that doesn\'t
properly receive multicast messages. (Android devices from HTC are known
to have this issue.)

jUPnP will usually expire remote devices once their initially advertised
\"maximum age\" has been reached and there was no ALIVE message to
refresh the advertisement. You can change this behavior with
`UpnpServiceConfiguration`:

    UpnpService upnpService = new UpnpServiceImpl(
        new DefaultUpnpServiceConfiguration() {

            @Override
            public Integer getRemoteDeviceMaxAgeSeconds() {
                return 0;
            }
        }
    );

If you return zero maximum age, all remote devices will forever stay in
your `Registry` once they have been discovered, jUPnP will not expire
them. You have to manually remove them from the `Registry` if you know
they are gone (e.g. once an action request fails with \"no response\").

Alternatively, you can return the number of seconds jUPnP should keep a
remote device in the `Registry`, ignoring the device\'s advertised
maximum age.
:::
:::::

::::: {#section.AliveInterval .section}
::: title
Alive messages at regular intervals
:::

::: content
Some control points have difficulties with M-SEARCH responses. They
search for your device, then can\'t process the
(specification-compliant) response made by jUPnP and therefore don\'t
discover your device when they search. However, such control points
typically have no problem with alive NOTIFY messages, only with search
responses.

The solution then is to repeat alive NOTIFY messages for all your local
devices on the network very frequently, let\'s say every 5 seconds:

    UpnpService upnpService = new UpnpServiceImpl(
        new DefaultUpnpServiceConfiguration() {

            @Override
            public int getAliveIntervalMillis() {
                return 5000;
            }
        }
    );

By default this method returns `0`, disabling alive message flooding and
relying on the regular triggering of local device advertisements (which
depends on the maximum age of each `LocalDeviceIdentity`).

If you return a non-zero value, jUPnP will send alive NOTIFY messages
repeatedly with the given interval, and remote control points should be
able to discover your device within that period. The downside is of
course more traffic on your network.
:::
:::::

::::: {#section.DiscoveryOptions .section}
::: title
Using discovery options for local devices
:::

::: content
If you create a `LocalDevice` that you don\'t want to announce to remote
control points, add it to the `Registry` with
`addDevice(localDevice, new DiscoveryOptions(false))`.

The `DiscoveryOptions` class offers several parameters to influence how
jUPnP handles device discovery.

With disabled advertising, jUPnP will then not send *any* NOTIFY
messages for a device; you can enable advertisement again with
`Registry#setDiscoveryOptions(UDN, null)`, or by providing different
options.

Note that remote control points will still be able to discover your
device if they know your device descriptor URL. They will also be able
to call actions and subscribe to services. This is not a switch to make
a `LocalDevice` \"private\", it only disables (multicast) advertising.

A rarely used setting of `DiscoveryOptions` is `byeByeBeforeFirstAlive`:
If enabled, jUPnP will send a byebye NOTIFY message before sending the
first alive NOTIFY message. This happens only once, when a `LocalDevice`
is added to the `Registry`, and it wasn\'t registered before.
:::
:::::

::::: {#section.ManualAdvertisement .section}
::: title
Manual advertisement of local devices
:::

::: content
You can force immediate advertisement of all registered `LocalDevice`s
with `Registry#advertiseLocalDevices()`. Note that no announcements will
be made for any device with disabled advertising (see previous section).
:::
:::::
:::::::::::::::
:::::::::::::::::
