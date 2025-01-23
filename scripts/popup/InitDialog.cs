using Godot;
using System;
using System.Reflection;
using System.Security.Principal;

public partial class InitDialog : Window
{
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
        Button createButton = GetNode<Button>("%CreateButton");
        Button cancelButton = GetNode<Button>("%CancelButton");
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
            GetNode<Button>("%SavePath").Pressed += () => {
                FileDialog selPathDialog = new FileDialog();
                selPathDialog.CurrentDir = "user://";
                selPathDialog.Access = FileDialog.AccessEnum.Filesystem;
                selPathDialog.Size = new Vector2I(1000, 800);
                selPathDialog.FileMode = FileDialog.FileModeEnum.SaveFile;
                selPathDialog.CurrentFile = "modpack.ctpak";
                selPathDialog.Filters = new string[] {"*.ctpak;Cartographer's Modpack"};
                selPathDialog.FileSelected += (filePath) => {
                    GetNode<Button>("%SavePath").Text = filePath;
                };
                this.AddChild(selPathDialog);
                selPathDialog.Show();
            };
            createButton.Pressed += () => {
                if (GetNode<Button>("%SavePath").Text == "Select...")
                    GetNode<Button>("%SavePath").Text = "./pack.ctpak";
                EmitSignal(SignalName.FileCreateQueued, GetNode<Button>("%SavePath").Text);
            };
            cancelButton.Pressed += () => {
                setupPanel.Hide();
                GetNode<LineEdit>("%ProjectName").Text = "";
                GetNode<OptionButton>("%MCVersion").Selected = 0;
                initPanel.Show();
            };
        };
    }
    public override void _Process(double delta)
    {
    }
}
