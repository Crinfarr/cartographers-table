using System.IO;
using Godot;

public partial class InitDialog : Window
{
    [Signal]
    public delegate void FileOpenQueuedEventHandler(string path);

    [Signal]
    public delegate void ProjectCreateQueuedEventHandler(string projectFilePath, string modFolderPath);
    public override void _Ready()
    {
        Control initPanel = GetNode<Control>("CreateOrOpen");
        Control setupPanel = GetNode<Control>("ProjectSetup");
        Button newButton = GetNode<Button>("%NewProject");
        Button openButton = GetNode<Button>("%OpenProject");
        Button createButton = GetNode<Button>("%CreateButton");
        Button cancelButton = GetNode<Button>("%CancelButton");
        this.FilesDropped += (files) =>
        {
            if (files.Length > 1)
            {
                return;
            }
            if (files[0].EndsWith(".ctpak"))
            {
                EmitSignal(SignalName.FileOpenQueued, files[0]);
            }
        };
        newButton.Pressed += () =>
        {
            initPanel.Hide();
            setupPanel.Show();
            GetNode<Button>("%SavePath").Pressed += () =>
            {
                FileDialog selPathDialog = new FileDialog();
                selPathDialog.CurrentDir = "user://";
                selPathDialog.Access = FileDialog.AccessEnum.Filesystem;
                selPathDialog.Size = new Vector2I(800, 600);
                selPathDialog.FileMode = FileDialog.FileModeEnum.SaveFile;
                selPathDialog.CurrentFile = "modpack.ctpak";
                selPathDialog.Filters = ["*.ctpak;Cartographer's Modpack"];
                selPathDialog.FileSelected += (filePath) =>
                {
                    GetNode<Button>("%SavePath").Text = filePath;
                };
                this.AddChild(selPathDialog);
                selPathDialog.Show();
            };
            GetNode<Button>("%ModsPath").Pressed += () =>
            {
                FileDialog selPathDialog = new FileDialog();
                selPathDialog.CurrentDir = "user://";
                selPathDialog.Access = FileDialog.AccessEnum.Filesystem;
                selPathDialog.Size = new Vector2I(800, 600);
                selPathDialog.FileMode = FileDialog.FileModeEnum.OpenDir;
                selPathDialog.CurrentDir = "mods";
                selPathDialog.Filters = ["mods;Mods Folder"];
                selPathDialog.DirSelected += (dirPath) =>
                {
                    GetNode<Button>("%ModsPath").Text = dirPath;
                };
                this.AddChild(selPathDialog);
                selPathDialog.Show();
            };
            createButton.Pressed += () =>
            {
                if (GetNode<Button>("%SavePath").Text == "Select...")
                    GetNode<Button>("%SavePath").Text = "./pack.ctpak";
                EmitSignal(SignalName.ProjectCreateQueued, GetNode<Button>("%SavePath").Text, GetNode<Button>("%ModsPath").Text);
            };
            cancelButton.Pressed += () =>
            {
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
