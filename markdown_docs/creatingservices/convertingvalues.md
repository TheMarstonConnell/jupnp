::::::: {#section.CreatingServices.ConvertingValues .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Converting string action argument values
:::

::::: content
The UPnP specification defines no framework for custom datatypes. The
predictable result is that service designers and vendors are overloading
strings with whatever semantics they consider necessary for their
particular needs. For example, the UPnP A/V specifications often require
lists of values (like a list of strings or a list of numbers), which are
then transported between service and control point as a single string -
the individual values are represented in this string separated by
commas.

jUPnP supports these conversions and it tries to be as transparent as
possible.

::: section
[](javadoc://example.localservice.StringConvertibleTest){.citation}
:::

::: section
[](javadoc://example.localservice.EnumTest){.citation}
:::
:::::
:::::::
