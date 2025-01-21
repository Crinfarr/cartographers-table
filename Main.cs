using Godot;

public partial class Main : Control
{
	// Called when the node enters the scene tree for the first time.
	Window initPopup = ResourceLoader.Load<PackedScene>("res://assets/popup/InitDialog.tscn").Instantiate<Window>();
	public override void _Ready()
	{
        initPopup.CloseRequested += () => {
			GetTree().Quit();
		};
		// this.AddChild(initPopup);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
