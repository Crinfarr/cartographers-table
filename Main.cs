using Godot;

public partial class Main : Control
{
    InitDialog initPopup = ResourceLoader.Load<PackedScene>("res://assets/popup/InitDialog.tscn").Instantiate<InitDialog>();
    Window progressPopup = ResourceLoader.Load<PackedScene>("res://assets/popup/LoadingDialog.tscn").Instantiate<Window>();
    Config LoadedConfig;
    public override void _Ready()
    {
        initPopup.CloseRequested += () =>
        {
            GetTree().Quit();
        };
        initPopup.FileCreateQueued += (filePath) =>
        {
            GD.Print("FileCreateQueued fired");
            closeInitWindow();
            // LoadedConfig = new Config();
        };
        initPopup.FileOpenQueued += (filePath) =>
        {
            GD.Print("FileOpenQueued fired");
            closeInitWindow();
            LoadConfig(filePath);
        };
        this.AddChild(initPopup);
    }
    public override void _Process(double delta)
    {
    }
    private void closeInitWindow()
    {
        initPopup.Hide();
    }

    public void LoadConfig(string filePath)
    {
        LoadedConfig = Config.Load(filePath);
    }
}
