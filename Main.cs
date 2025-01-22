using Godot;

public partial class Main : Control
{
	InitDialog initPopup = ResourceLoader.Load<PackedScene>("res://assets/popup/InitDialog.tscn").Instantiate<InitDialog>();
    Window progressPopup = ResourceLoader.Load<PackedScene>("res://assets/popup/LoadingDialog.tscn").Instantiate<Window>();
    Config LoadedConfig;
	public override void _Ready()
	{
        initPopup.CloseRequested += () => {
			GetTree().Quit();
		};
        initPopup.FileCreateQueued += (filePath) => {

        };
        initPopup.FileOpenQueued += (filePath) => {
            initPopup.QueueFree();
            LoadConfig(filePath);
        };
		this.AddChild(initPopup);
	}
	public override void _Process(double delta)
	{
	}
    public void LoadConfig(string filePath) {
        LoadedConfig = Config.Load(filePath);
    }
}
