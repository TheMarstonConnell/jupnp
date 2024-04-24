
# Client operations with ControlPoint
## content
Your primary API when writing a UPnP client application is the
`ControlPoint`. An instance is available with `getControlPoint()` on the
`UpnpService`.


``` java
public interface ControlPoint {

    public void search(UpnpHeader searchType);
    public void execute(ActionCallback callback);
    public void execute(SubscriptionCallback callback);

}
```


A UPnP client application typically wants to:

-   Search the network for a particular service which it knows how to
    utilize. Any response to a search request will be delivered
    asynchronously, so you have to listen to the `Registry` for device
    registrations, which will occur when devices respond to your search
    request.
-   Execute actions which are offered by services. Action execution is
    processed asynchronously in jUPnP Core, and your `ActionCallback`
    will be notified when the execution was a success (with result
    values), or a failure (with error status code and messages).
-   Subscribe to a service\'s eventing, so your `SubscriptionCallback`
    is notified asynchronously when the state of a service changes and
    an event has been received for your client. You also use the
    callback to cancel the event subscription when you are no longer
    interested in state changes.

Let's start with searching for UPnP devices on the network.

## Examples

### [SearchExecuteTest](../../bundles/org.jupnp/src/test/java/example/controlpoint/SearchExecuteTest.java)


### [ActionInvokation](../../bundles/org.jupnp/src/test/java/example/controlpoint/ActionInvocationTest.java)

### [EventSubscription](../../bundles/org.jupnp/src/test/java/example/controlpoint/EventSubscriptionTest.java)