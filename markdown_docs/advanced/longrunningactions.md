::::::: {#section.LongRunningActions .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Long-running actions
:::

::::: content
An action of a service might take a long time to complete and consume
resources. For example, if your service has to process significant
amounts of data, you might want to stop processing when the client
calling your action is actually no longer connected. On the client side,
you might want to give your users the option to interrupt and abort
action requests if the service takes too long to respond. These are two
distinct issues, and we\'ll first look at it from the client\'s
perspective.

::: section
[](javadoc://example.controlpoint.ActionCancellationTest){.citation}
:::

::: section
[](javadoc://example.controlpoint.SwitchPowerWithInterruption){.citation}
:::
:::::
:::::::
