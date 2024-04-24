::::::::: {#chapter.ClientInfo .chapter xmlns="http://www.w3.org/1999/xhtml" xmlns:xi="http://www.w3.org/2001/XInclude"}
::: title
Custom client/server information
:::
## content
Sometimes your service has to implement different procedures depending
on the client who makes the action request, or you want to send a
request with some identifying information about your client.

::::: {#section.ExtraRequestHeaders .section}
::: title
Adding extra request headers
:::

::: content
By default, jUPnP will add all necessary headers to all outbound request
messages. For HTTP-based messages such as descriptor retrieval, action
invocation, and GENA messages, the `User-Agent` HTTP header will be set
to a default value, obtained from your `StreamClientConfiguration`.

You can override this behavior for descriptor retrieval and GENA
subscription messages with a custom configuration. For example, this
configuration will send extra HTTP headers when device and service
descriptors have to be retrieved for a particular UDN:

    UpnpService upnpService = new UpnpServiceImpl(
        new DefaultUpnpServiceConfiguration() {

            @Override
            public UpnpHeaders getDescriptorRetrievalHeaders(RemoteDeviceIdentity identity) {
                if (identity.getUdn().getIdentifierString().equals("aa-bb-cc-dd-ee-ff")) {
                    UpnpHeaders headers = new UpnpHeaders();
                    headers.add(UpnpHeader.Type.USER_AGENT.getHttpName(), "MyCustom/Agent");
                    headers.add("X-Custom-Header", "foo");
                    return headers;
                }
                return null;
            }
        }
    );

For GENA subscription, renewal, and unsubscribe messages, you can set
extra headers depending on the service you are subscribing to:

    UpnpService upnpService = new UpnpServiceImpl(
        new DefaultUpnpServiceConfiguration() {

            @Override
            public UpnpHeaders getEventSubscriptionHeaders(RemoteService service) {
                if (service.getServiceType().implementsVersion(new UDAServiceType("Foo", 1))) {
                    UpnpHeaders headers = new UpnpHeaders();
                    headers.add("X-Custom-Header", "bar");
                    return headers;
                }
                return null;
            }
        }
    );

For action invocations to remote services, you can set custom headers
when constructing the `ActionInvocation`:

    UpnpHeaders extraHeaders = new UpnpHeaders();
    extraHeaders.add(UpnpHeader.Type.USER_AGENT.getHttpName(), "MyCustom/Agent");
    extraHeaders.add("X-Custom-Header", "foo");

    ActionInvocation actionInvocation =
        new ActionInvocation(
            action,
            new ClientInfo(extraHeaders)
        );

Any of these settings only affect outbound request messages! Any
outbound response to a remote request will have only headers required by
the UPnP protocols. See the next section on how to customize response
headers for remote action requests.

Very rarely you have to customize SSDP (MSEARCH and its response)
messages. First, subclass the default `ProtocolFactoryImpl` and override
the instantiation of the protocols as necessary. For example, override
`createSendingSearch()` and return your own instance of the
`SendingSearch` protocol. Next, override
`prepareOutgoingSearchRequest(OutgoingSearchRequest)` of the
`SendingSearch` protocol and modify the message. The same procedure can
be applied to customize search responses with the `ReceivingSearch`
protocol.
:::
:::::

::: section
[](javadoc://example.localservice.RemoteClientInfoTest){.citation}
:::

The `RemoteClientInfo` is also useful if you have to deal with
potentially long-running actions.
:::::::
:::::::::
