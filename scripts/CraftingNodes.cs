using Godot;
using System;
using System.Linq;
using System.Reflection;

public partial class CraftingNodes : GraphEdit
{
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        this.GuiInput += (ievent) =>
        {
            if (ievent is InputEventKey)
                if (((InputEventKey)ievent).Keycode == Key.Delete)
                    foreach (GraphNode child in this.GetChildren().Where((n) => n is GraphNode))
                        if (child.Selected)
                            child.Hide();
            if (ievent is not InputEventMouseButton) return;
            InputEventMouseButton ieMouse = (InputEventMouseButton)ievent;
            if (ieMouse.ButtonIndex == MouseButton.Right && ieMouse.Pressed)
            {
                GD.Print("MouseEvent fired");
                // PopupMenu searchpanel = GetNode<PopupMenu>("ContextMenu");
                // searchpanel.Position = (Vector2I)(ieMouse.GlobalPosition + GetWindow().Position);
                // searchpanel.Popup();
                TabContainer nodesBox = GetNode<TabContainer>("NodeBox");
                nodesBox.Show();
                foreach (ScrollContainer child in nodesBox.GetChildren())
                {
                    ItemList nodes = child.GetNode<ItemList>("container");
                    Action<long, Variant, Variant> iclicked = (item, _, _) =>
                    {
                        nodesBox.Hide();
                        // if (item == 0)
                        {
                            GraphNode node = ResourceLoader
                                .Load<PackedScene>("res://assets/graphNodes/ItemSelector.tscn")
                                .Instantiate<GraphNode>();
                            AddChild(node);
                            node.SetPosition(GetGlobalMousePosition());
                        }
                        
                    };
                    nodes.Connect(ItemList.SignalName.ItemClicked, Callable.From(iclicked), (uint) ConnectFlags.OneShot);
                }
            }
        };
    }
    public override void _Process(double delta)
    {
    }
}
