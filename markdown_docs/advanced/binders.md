::::: {#section.SwitchingXMLDescriptorBinders .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Switching XML descriptor binders
:::

::: content
UPnP utilizes XML documents to transport device and service information
between the provider and any control points. These XML documents have to
be parsed by jUPnP to produce the `Device` model, and of course
generated from a `Device` model. The same approach is used for the
`Service` model. This parsing, generating, and binding is the job of the
`org.jupnp.binding.xml.DeviceDescriptorBinder` and the
`org.jupnp.binding.xml.ServiceDescriptorBinder`.

The following implementations are bundled with jUPnP Core for device
descriptor binding:

`org.jupnp.binding.xml.UDA10DeviceDescriptorBinderImpl` (default)
:   This implementation reads and writes UDA 1.0 descriptor XML with the
    JAXP-provided DOM API provided by JDK 6. You do not need any
    additional libraries to use this binder. Use this binder to validate
    strict specification compliance of your applications.

`org.jupnp.binding.xml.UDA10DeviceDescriptorBinderSAXImpl`
:   This implementation reads and writes UDA 1.0 descriptor XML with the
    JAXP-provided SAX API, you don\'t have to install additional
    libraries to use it. This binder may consume less memory when
    reading XML descriptors and perform better than the DOM-based
    parser. In practice, the difference is usually insignificant, even
    on very slow machines.

`org.jupnp.binding.xml.RecoveringUDA10DeviceDescriptorBinderImpl`
:   This implementation extends `UDA10DeviceDescriptorBinderImpl` and
    tries to recover from parsing failures, and works around known
    problems of other UPnP stacks. This is the binder you want for best
    interoperability in real-world UPnP applications. Furthermore, you
    can override the `handleInvalidDescriptor()` and
    `handleInvalidDevice()` methods to customize error handling, or if
    you want to repair invalid device information manually. It is the
    default binder for `AndroidUpnpServiceConfiguration`.

The following implementations are bundled with jUPnP Core for service
descriptor binding:

`org.jupnp.binding.xml.UDA10ServiceDescriptorBinderImpl` (default)
:   This implementation reads and writes UDA 1.0 descriptor XML with the
    JAXP-provided DOM API provided by JDK 6. You do not need any
    additional libraries to use this binder. Use this binder to validate
    strict specification compliance of your applications.

`org.jupnp.binding.xml.UDA10ServiceDescriptorBinderSAXImpl`
:   This implementation reads and writes UDA 1.0 descriptor XML with the
    JAXP-provided SAX API, you don\'t have to install additional
    libraries to use it. This binder may consume less memory when
    reading XML descriptors and perform better than the DOM-based
    parser. In practice, the difference is usually insignificant, even
    on very slow machines. It is the default binder for
    `AndroidUpnpServiceConfiguration`.

You can switch descriptor binders by overriding the
`UpnpServiceConfiguration`:

    UpnpService upnpService = new UpnpServiceImpl(
        new DefaultUpnpServiceConfiguration() {
        
            @Override
            public DeviceDescriptorBinder getDeviceDescriptorBinderUDA10() {
                // Recommended for best interoperability with broken UPnP stacks!
                return new RecoveringUDA10DeviceDescriptorBinderImpl();
            }
        
            @Override
            public ServiceDescriptorBinder getServiceDescriptorBinderUDA10() {
                return new UDA10ServiceDescriptorBinderSAXImpl();
            }
        
        }
    );

Performance problems with UPnP discovery are usually caused by too many
XML descriptors, not by their size. This is inherent in the bad design
of UPnP; each device may expose many individual service descriptors, and
jUPnP will always retrieve all device metadata. The HTTP requests
necessary to retrieve dozens of descriptor files usually outweighs the
cost of parsing each.

Note that binders are only used for device and service descriptors, not
for UPnP action and event message processing.
:::
:::::
