::::::: {#section.BinaryLightDebugApp .section xmlns="http://www.w3.org/1999/xhtml"}
::: title
Debugging and logging
:::

::::: content
Although the binary light is a very simple example, you might run into
problems. jUPnP Core helps you resolve most problems with extensive
logging. Internally, jUPnP Core uses now SLF4J API logging instead of
`java.util.logging`.

SLF4J can be configured according your preferences.

Next you want to configure logging levels for different logging
categories. jUPnP Core will output some INFO level messages on startup
and shutdown, but is otherwise silent during runtime unless a problem
occurs - it will then log messages at WARNING or SEVERE level.

For debugging, usually more detailed logging levels for various log
categories are required. The logging categories in jUPnP Core are
package names, e.g the root logger is available under the name
`org.jupnp`. The following tables show typically used categories and the
recommended level for debugging:

  ---------------------------------------------------------------------------------------------
  Network/Transport                                          
  --------------------------------------------------------- -----------------------------------
  `org.jupnp.transport.spi.DatagramIO (TRACE)`\             UDP communication
  `org.jupnp.transport.spi.MulticastReceiver (TRACE)`\      

  `org.jupnp.transport.spi.DatagramProcessor (TRACE)`\      UDP datagram processing and content

  `org.jupnp.transport.spi.UpnpStream (TRACE)`\             TCP communication
  `org.jupnp.transport.spi.StreamServer (TRACE)`\           
  `org.jupnp.transport.spi.StreamClient (TRACE)`\           

  `org.jupnp.transport.spi.SOAPActionProcessor (TRACE)`\    SOAP action message processing and
                                                            content

  `org.jupnp.transport.spi.GENAEventProcessor (TRACE)`\     GENA event message processing and
                                                            content

  `org.jupnp.transport.impl.HttpHeaderConverter (TRACE)`\   HTTP header processing
  ---------------------------------------------------------------------------------------------

\

  ----------------------------------------------------------------------------------------------
  UPnP Protocol                                               
  ---------------------------------------------------------- -----------------------------------
  `org.jupnp.protocol.ProtocolFactory (TRACE)`\              Discovery (Notification & Search)
  `org.jupnp.protocol.async (TRACE)`\                        

  `org.jupnp.protocol.ProtocolFactory (TRACE)`\              Description
  `org.jupnp.protocol.RetrieveRemoteDescriptors (TRACE)`\    
  `org.jupnp.protocol.sync.ReceivingRetrieval (TRACE)`\      
  `org.jupnp.binding.xml.DeviceDescriptorBinder (TRACE)`\    
  `org.jupnp.binding.xml.ServiceDescriptorBinder (TRACE)`\   

  `org.jupnp.protocol.ProtocolFactory (TRACE)`\              Control
  `org.jupnp.protocol.sync.ReceivingAction (TRACE)`\         
  `org.jupnp.protocol.sync.SendingAction (TRACE)`\           

  `org.jupnp.model.gena (TRACE)`\                            GENA
  `org.jupnp.protocol.ProtocolFactory (TRACE)`\              
  `org.jupnp.protocol.sync.ReceivingEvent (TRACE)`\          
  `org.jupnp.protocol.sync.ReceivingSubscribe (TRACE)`\      
  `org.jupnp.protocol.sync.ReceivingUnsubscribe (TRACE)`\    
  `org.jupnp.protocol.sync.SendingEvent (TRACE)`\            
  `org.jupnp.protocol.sync.SendingSubscribe (TRACE)`\        
  `org.jupnp.protocol.sync.SendingUnsubscribe (TRACE)`\      
  `org.jupnp.protocol.sync.SendingRenewal (TRACE)`\          
  ----------------------------------------------------------------------------------------------

\

  --------------------------------------------------------------------------------------
  Core                                                
  -------------------------------------------------- -----------------------------------
  `org.jupnp.transport.Router (TRACE)`\              Message Router

  `org.jupnp.registry.Registry (TRACE)`\             Registry
  `org.jupnp.registry.LocalItems (TRACE)`\           
  `org.jupnp.registry.RemoteItems (TRACE)`\          

  `org.jupnp.binding.annotations (TRACE)`\           Local service binding & invocation
  `org.jupnp.model.meta.LocalService (TRACE)`\       
  `org.jupnp.model.action (TRACE)`\                  
  `org.jupnp.model.state (TRACE)`\                   
  `org.jupnp.model.DefaultServiceManager (TRACE)`\   

  `org.jupnp.controlpoint (TRACE)`\                  Control Point interaction
  --------------------------------------------------------------------------------------

One way to configure SLF4J is to use logback with a config file. For
example, create the following file as `logback.xml`:

<div>

    <configuration>

        <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
            <!-- encoders are assigned the type ch.qos.logback.classic.encoder.PatternLayoutEncoder 
                by default -->
            <encoder>
                <pattern>%d{HH:mm:ss.SSS} [%-20thread] %-5level %-70(%logger{36}.%M:%line) - %msg%n
                </pattern>
            </encoder>
        </appender>

        <!--  Extra settings for various categories -->
        <logger name="org.jupnp.protocol" level="TRACE" />
        <logger name="org.jupnp.registry.Registry" level="TRACE" />
        <logger name="org.jupnp.registry.LocalItems" level="TRACE" />
        <logger name="org.jupnp.registry.RemoteItems" level="TRACE" />

        <!--  Extra settings to see on-the-wire traffic -->
        <logger name="org.jupnp.transport.spi.DatagramProcessor" level="TRACE" />
        <logger name="org.jupnp.transport.spi.SOAPActionProcessor" level="TRACE" />

        <!--  default root level -->
        <root level="INFO">
            <appender-ref ref="STDOUT" />
        </root>

    </configuration>

</div>

You can now start your application with a system property that names
your logging configuration:

<div>

    $ java -cp /path/to/seamless-jar-files:/path/to/jupnp-core.jar:classes/ \
            -Djava.util.logging.config.file=/path/to/mylogging.properties \
            example.binaryLight.BinaryLightServer

</div>

You should see the desired log messages printed on `System.out`.
:::::
:::::::
