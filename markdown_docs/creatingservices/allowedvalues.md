::::::: {#section.CreatingServices.AllowedValues .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Restricting allowed state variable values
:::

::::: content
The UPnP specification defines a set of rules for restricting legal
values of state variables, in addition to their type. For string-typed
state variables, you can provide a list of exclusively allowed strings.
For numeric state variables, a value range with minimum, maximum, and
allowed \"step\" (the interval) can be provided.

::: section
[](javadoc://example.localservice.AllowedValueTest){.citation}
:::

::: section
[](javadoc://example.localservice.AllowedValueRangeTest){.citation}
:::
:::::
:::::::
