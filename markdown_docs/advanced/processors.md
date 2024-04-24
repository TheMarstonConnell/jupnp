::::: {#section.SwitchingXMLProcessors .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Switching XML processors
:::

::: content
All control and event UPnP messages have an XML payload, and the control
messages are even wrapped in SOAP envelopes. Handling XML for control
and eventing is encapsulated in the jUPnP transport layer, with an
extensible service provider interface:

`org.jupnp.transport.spi.SOAPActionProcessor`
:   This processor reads and writes UPnP SOAP messages and transform
    them from/to `ActionInvocation` data. The protocol layer, on top of
    the transport layer, handles `ActionInvocation` only.

`org.jupnp.transport.spi.GENAEventProcessor`
:   This processor reads and writes UPnP GENA event messages and
    transform them from/to a `List<StateVariableValue>`.

For the `SOAPActionProcessor`, the following implementations are bundled
with jUPnP Core:

`org.jupnp.transport.impl.SOAPActionProcessorImpl` (default)
:   This implementation reads and writes XML with the JAXP-provided DOM
    API provided by JDK 6. You do not need any additional libraries to
    use this processor. However, its strict compliance with the UPnP
    specification can cause problems in real-world UPnP applications.
    This processor will produce errors during reading when XML messages
    violate the UPnP specification. Use it to test a UPnP stack or
    application for strict specification compliance.

`org.jupnp.transport.impl.PullSOAPActionProcessorImpl`
:   This processor uses the XML Pull API to read messages, and the JAXP
    DOM API to write messages. You need an implementation of the XML
    Pull API on your classpath to use this processor, for example,
    [XPP3](http://www.extreme.indiana.edu/xgws/xsoap/xpp/mxp1/index.html)
    or [kXML 2](http://kxml.sourceforge.net/kxml2/). Compared with the
    default processor, this processor is much more lenient when reading
    action message XML. It can deal with broken namespacing, missing
    SOAP envelopes, and other problems. In UPnP applications where
    interoperability is more important than specification compliance,
    you should use this parser.

`org.jupnp.transport.impl.RecoveringSOAPActionProcessorImpl`
:   This processor extends the `PullSOAPActionProcessorImpl` and
    additionally will work around known bugs of UPnP stacks in the wild
    and try to recover from parsing failures by modifying the XML text
    in different ways. This is the processor you should use for best
    interoperability with other (broken) UPnP stacks. Furthermore, it
    let\'s you handle a failure when reading an XML message easily by
    overriding the `handleInvalidMessage()` method, e.g. to create or
    log an error report. It is the default processor for
    `AndroidUpnpServiceConfiguration`.

For the `GENAEventProcessor`, the following implementations are bundled
with jUPnP Core:

`org.jupnp.transport.impl.GENAEventProcessorImpl` (default)
:   This implementation reads and writes XML with the JAXP-provided DOM
    API provided by JDK 6. You do not need any additional libraries to
    use this processor. However, its strict compliance with the UPnP
    specification can cause problems in real-world UPnP applications.
    This processor will produce errors during reading when XML messages
    violate the UPnP specification. Use it to test a UPnP stack or
    application for strict specification compliance.

`org.jupnp.transport.impl.PullGENAEventProcessorImpl`
:   This processor uses the XML Pull API to read messages, and the JAXP
    DOM API to write messages. You need an implementation of the XML
    Pull API on your classpath to use this processor, for example,
    [XPP3](http://www.extreme.indiana.edu/xgws/xsoap/xpp/mxp1/index.html)
    or [kXML 2](http://kxml.sourceforge.net/kxml2/). Compared with the
    default processor, this processor is much more lenient when reading
    action message XML. It can deal with broken namespacing, missing
    root element, and other problems. In UPnP applications where
    compatibility is more important than specification compliance, you
    should use this parser.

`org.jupnp.transport.impl.RecoveringGENAEventProcessorImpl`
:   This processor extends the `PullGENAEventProcessorImpl` and
    additionally will work around known bugs of UPnP stacks in the wild
    and try to recover from parsing failures by modifying the XML text
    in different ways. This is the processor you should use for best
    interoperability with other (broken) UPnP stacks. Furthermore, it
    will return partial results, when at least one single state variable
    value was successfully read from the event XML. It is the default
    processor for `AndroidUpnpServiceConfiguration`.

You can switch XML processors by overriding the
`UpnpServiceConfiguration`:

    UpnpService upnpService = new UpnpServiceImpl(
        new DefaultUpnpServiceConfiguration() {

            @Override
            public SOAPActionProcessor getSoapActionProcessor() {
                // Recommended for best interoperability with broken UPnP stacks!
                return new RecoveringSOAPActionProcessorImpl();
            }

            @Override
            public GENAEventProcessor getGenaEventProcessor() {
                // Recommended for best interoperability with broken UPnP stacks!
                return new RecoveringGENAEventProcessorImpl();
            }
        }
    );
:::
:::::
