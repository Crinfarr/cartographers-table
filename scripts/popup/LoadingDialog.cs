using Godot;
using System;

public partial class LoadingDialog : Window
{
    public Label BarText {get; private set;}
    public ProgressBar Bar {get; private set;}
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
        BarText = GetNode<Label>("Control/Center/VBox/BarLabel");
        Bar = GetNode<ProgressBar>("Control/Center/VBox/ProgressBar");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
