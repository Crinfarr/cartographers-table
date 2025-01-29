using System;
using System.Xml.Serialization;
using Godot;

public partial class Main : Control
{
    InitDialog initPopup = ResourceLoader.Load<PackedScene>("res://assets/popup/InitDialog.tscn").Instantiate<InitDialog>();
    Window progressPopup = ResourceLoader.Load<PackedScene>("res://assets/popup/LoadingDialog.tscn").Instantiate<Window>();
    Config LoadedConfig;
    Tree sidebar;
    TreeItem recipeRoot;

    public override void _Ready()
    {
        sidebar = GetNode<Tree>("%Sidebar");
        recipeRoot = sidebar.CreateItem();
        recipeRoot.SetText(0, "Recipes");
        sidebar.ButtonClicked += (clickedItm, _, _, _) =>
            {
                clickedItm.SetEditable(0, true);
            };
        for (int n = 0; n <= 100; n++)
        {
            TreeItem child = recipeRoot.CreateChild();
            child.AddButton(0, ResourceLoader.Load<Texture2D>("res://assets/icons/pen.svg"));
            child.SetText(0, n.ToString());
        }
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
