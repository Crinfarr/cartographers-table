using Godot;
using System;
using System.Security.Principal;

public partial class InitDialog : Window
{
    // Called when the node enters the scene tree for the first time.

    [Signal]
    public delegate void FileOpenQueuedEventHandler(string path);
    [Signal]
    public delegate void FileCreateQueuedEventHandler(string path);
    public override void _Ready()
    {
        Control initPanel = GetNode<Control>("CreateOrOpen");
        Control setupPanel = GetNode<Control>("ProjectSetup");
        Button newButton = GetNode<Button>("%NewProject");
        Button openButton = GetNode<Button>("%OpenProject");
        Button saveNew = GetNode<Button>("%CreateButton");
        Button cancelNew = GetNode<Button>("%CancelButton");
        this.FilesDropped += (files) => {
            if (files.Length > 1) {
                return;
            }
            if (files[0].EndsWith(".ctpak")) {
                EmitSignal(SignalName.FileOpenQueued, files[0]);
            }
        };
        newButton.Pressed += () =>
        {
            initPanel.Hide();
            setupPanel.Show();
            GetNode<Button>("%SaveNew").Pressed += () => {
                FileDialog selPathDialog = new FileDialog();
                selPathDialog.CurrentDir = "user://";
                selPathDialog.Access = FileDialog.AccessEnum.Filesystem;
                selPathDialog.Size = new Vector2I(1000, 800);
                selPathDialog.FileMode = FileDialog.FileModeEnum.SaveFile;
                selPathDialog.CurrentFile = "modpack.ctpak";
                selPathDialog.Filters = new string[] {"*.ctpak;Cartographer's Modpack"};
                selPathDialog.FileSelected += (filePath) => {
                    GetNode<Button>("%SaveNew").Text = filePath;
                };
            };
            saveNew.Pressed += () => {
                EmitSignal(SignalName.FileCreateQueued, GetNode<Button>("%SaveNew").Text);
            };
            cancelNew.Pressed += () => {
                setupPanel.Hide();
                GetNode<LineEdit>("%ProjectName").Text = "";
                GetNode<OptionButton>("%MCVersion").Selected = 0;
                initPanel.Show();
            };
            /*
            
            */
        };
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
    }
}
