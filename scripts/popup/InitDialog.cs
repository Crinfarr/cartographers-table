using Godot;
using System;

public partial class InitDialog : Window
{
    // Called when the node enters the scene tree for the first time.

    public Signal projectReady = new();
    public override void _Ready()
    {
        Button newButton = GetNode<Button>("Control/CenterContainer/VBoxContainer/NewProject");
        newButton.Pressed += () =>
        {
            FileDialog createDialog = new FileDialog();
            AddChild(createDialog);
            createDialog.CurrentDir = "user://";
            createDialog.Access = FileDialog.AccessEnum.Filesystem;
            createDialog.Size = new Vector2I(1000, 800);
            createDialog.FileMode = FileDialog.FileModeEnum.SaveFile;
            createDialog.CurrentFile = "modpack.ctpak";
            createDialog.Filters = new string[] {"*.ctpak;Cartographer's Modpack"};
            createDialog.FileSelected += (selFile) =>
            {
                GD.Print("Selected file " + selFile);
            };
            createDialog.PopupCentered();
        };
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }
}
