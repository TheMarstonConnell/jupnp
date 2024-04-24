:::::::: {#section.BinaryLightStartingApp .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Starting the application
:::

:::::: content
Compile the binary light demo application:

<div>

    $ javac -cp /path/to/seamless-jar-files:/path/to/jupnp-core.jar \
            -d classes/ \
            src/example/binarylight/BinaryLightServer.java \
            src/example/binarylight/BinaryLightClient.java \
            src/example/binarylight/SwitchPower.java

</div>

Don\'t forget to copy your `icon.png` file into the `classes` output
directory as well, into the right package from which it is loaded as a
reasource (the `example.binarylight` package if you followed the
previous sections verbatim).

You can start the server or client first, which one doesn\'t matter as
they will discover each other automatically:

<div>

    $ java -cp /path/to/seamless-jar-files:/path/to/jupnp-core.jar:classes/ \
            example.binaryLight.BinaryLightServer

</div>

<div>

    $ java -cp /path/to/seamless-jar-files:/path/to/jupnp-core.jar:classes/ \
            example.binaryLight.BinaryLightClient

</div>

You should see discovery and action execution messages on each console.
You can stop and restart the applications individually (press CTRL+C on
the console).
::::::
::::::::
