::::: {#section.BinaryLightExecuteAction .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Executing an action
:::

::: content
The control point we are creating here is only interested in services
that implement *SwitchPower*. According to its template definition this
service has the `SwitchPower` service identifier, so when a device has
been discovered we can check if it offers that service:

[](javacode://example.binarylight.BinaryLightClient#createRegistryListener(UpnpService)){.citation}

If a service becomes available we immediately execute an action on that
service. When a `SwitchPower` device disappears from the network a log
message is printed. Remember that this is a very trivial control point,
it executes a single a fire-and-forget operation when a service becomes
available:

[](javacode://example.binarylight.BinaryLightClient){#BinaryLightClient.executeAction
.citation style="include: EXECUTEACTION"}

The `Action` (metadata) and the `ActionInvocation` (actual call data)
APIs allow very fine-grained control of how an invocation is prepared,
how input values are set, how the action is executed, and how the output
and outcome is handled. UPnP is inherently asynchronous, so just like
the registry listener, executing an action is exposed to you as a
callback-style API.

It is recommended that you encapsulate specific action invocations
within a subclass of `ActionInvocation`, which gives you an opportunity
to further abstract the input and output values of an invocation. Note
however that an instance of `ActionInvocation` is not thread-safe and
should not be executed in parallel by two threads.

The `ActionCallback` has two main methods you have to implement, one is
called when the execution was successful, the other when it failed.
There are many reasons why an action execution might fail, read the API
documentation for all possible combinations or just print the generated
user-friendly default error message.
:::
:::::
