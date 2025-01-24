using Godot;

public partial class Config : Resource
{
    public string PackName { get; private set; }
    public MCVersion version {get; private set;}
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
        r.version = (MCVersion) access.Get32();
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
        access.Store32((uint) version);
    }
    public enum MCVersion:uint {
        mc1_20_1 = 0x011401,
    }
    public void create(string savePath, string name, MCVersion version) {
        Godot.FileAccess access = Godot.FileAccess.OpenCompressed(
            savePath,
            Godot.FileAccess.ModeFlags.Write,
            Godot.FileAccess.CompressionMode.Zstd
        );
        access.Store8((byte) name.Length);
        access.StoreString(name);
        access.Store32((uint) version);
    }
}
