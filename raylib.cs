using System.Runtime.InteropServices;

[StructLayout(LayoutKind.Sequential)]
public partial struct Texture2D
{
    public uint id;
    public int width;
    public int height;
    public int mipmaps;
    public int format;
}

public struct Color
{
    public byte r;
    public byte g;
    public byte b;
    public byte a;
}

public struct Rectangle
{
    public float x;
    public float y;
    public float width;
    public float height;

    public Rectangle(float x, float y, float width, float height)
    {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
}

[StructLayout(LayoutKind.Sequential)]
public partial struct Camera2D
{
    public Vector2 offset;
    public Vector2 target;
    public float rotation;
    public float zoom;

    public Camera2D(float offsetX, float offsetY, float targetX, float targetY, float rotation, float zoom)
    {
        this.offset = new Vector2(offsetX, offsetY);
        this.target = new Vector2(targetX, targetY);
        this.rotation = rotation;
        this.zoom = zoom;
    }
}


public struct Vector2
{
    public float x;
    public float y;

    public Vector2(float x, float y)
    {
        this.x = x;
        this.y = y;        
    }
}

public static unsafe class Raylib
{
    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void InitWindow(int width, int height, string title);

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void SetTargetFPS(int fps);

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern bool WindowShouldClose();

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void BeginDrawing();

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void ClearBackground(Color color);

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void EndDrawing();

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void CloseWindow();

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void DrawFPS(int x, int y);

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void DrawRectangleRec(Rectangle rec, Color color);

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void DrawText(string text, int posX, int posY, int fontSize, Color color);

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern Texture2D LoadTexture(string fileName);

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void DrawTexture(Texture2D texture, int posX, int posY, Color tint);

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void DrawTexturePro(
        Texture2D texture,
        Rectangle source,
        Rectangle dest,
        Vector2 origin,
        float rotation,
        Color tint
    );

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void UnloadTexture(Texture2D texture);

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void BeginMode2D(Camera2D camera);

    [DllImport("raylib", CallingConvention = CallingConvention.Cdecl)]
    public static extern void EndMode2D();
}