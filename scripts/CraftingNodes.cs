using Godot;
using System;

public partial class CraftingNodes : GraphEdit
{
    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        this.GuiInput += (ievent) =>
        {
            if (ievent is not InputEventMouseButton) return;
            InputEventMouseButton ieMouse = (InputEventMouseButton)ievent;
            GD.Print("MouseEvent fired");
            if (ieMouse.ButtonIndex == MouseButton.Right)
            {
                PopupPanel searchpanel = GetNode<PopupPanel>("ItemSearch");
                searchpanel.FocusExited += () =>
                {
                    searchpanel.Hide();
                };
                searchpanel.Position = (Vector2I)(ieMouse.GlobalPosition + GetWindow().Position);
                searchpanel.Show();
            }
        };
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }
}
