using Godot;
using System.IO;

public partial class Config : Resource
{
    public string PackName { get; private set; }
    private Config()
    {
    }
    public static Config Load(string path)
    {
        Config r = new Config();
        Godot.FileAccess access = Godot.FileAccess.OpenCompressed(
            path,
            Godot.FileAccess.ModeFlags.Read,
            Godot.FileAccess.CompressionMode.Zstd
        );
        r.PackName = access.GetBuffer(access.Get8()).GetStringFromUtf8();

        return r;
    }
    public void Save(string path) {
        Godot.FileAccess access = Godot.FileAccess.OpenCompressed(
            path,
            Godot.FileAccess.ModeFlags.Write,
            Godot.FileAccess.CompressionMode.Zstd
        );
        access.Store8((byte) this.PackName.Length);
        access.StoreString(this.PackName);
    }
}
