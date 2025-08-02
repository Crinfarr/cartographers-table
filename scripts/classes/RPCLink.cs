using Godot;

public partial class RPCLink : Resource
{
    [Signal]
    public delegate void StreamWaitingEventHandler(string currentStatus);

    [Signal]
    public delegate void StreamReadyEventHandler();
    private StreamPeerTcp rpcConnector;

    public RPCLink(string host, int port)
    {
        rpcConnector = new StreamPeerTcp();
        Error status = rpcConnector.ConnectToHost(host, port);
        while (status != Error.Ok)
        {
            EmitSignal(SignalName.StreamWaiting, status.ToString());
        }
        EmitSignal(SignalName.StreamReady);
    }
}