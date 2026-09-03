using Microsoft.Extensions.FileProviders;
using System.Diagnostics;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

string appPath = AppDomain.CurrentDomain.BaseDirectory;
DirectoryInfo? parent = Directory.GetParent(appPath);
while (parent != null && !File.Exists(Path.Combine(parent.FullName, "pubspec.yaml")))
{
    parent = parent.Parent;
}

string rootDir = parent?.FullName ?? Directory.GetCurrentDirectory();
string webBuildPath = Path.Combine(rootDir, "build", "web");

if (Directory.Exists(webBuildPath))
{
    app.UseDefaultFiles(new DefaultFilesOptions
    {
        FileProvider = new PhysicalFileProvider(webBuildPath),
        RequestPath = ""
    });

    app.UseStaticFiles(new StaticFileOptions
    {
        FileProvider = new PhysicalFileProvider(webBuildPath),
        RequestPath = ""
    });
}
else
{
    app.UseDefaultFiles();
    app.UseStaticFiles();

    app.MapGet("/", async context =>
    {
        context.Response.ContentType = "text/html; charset=utf-8";
        await context.Response.WriteAsync(@"
            <!DOCTYPE html>
            <html lang='ar' dir='rtl'>
            <head>
                <meta charset='utf-8'>
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                <title>غراس | Ghiras Mobile Flutter App</title>
                <style>
                    body { font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; background-color: #F7FAF7; margin: 0; padding: 20px; color: #1E293B; }
                    .header { text-align: center; margin-bottom: 30px; }
                    .logo { font-size: 40px; color: #1E7036; font-weight: bold; }
                    .subtitle { color: #64748B; font-size: 16px; margin-top: 5px; }
                    .card { background: white; max-width: 600px; margin: 0 auto; padding: 32px; border-radius: 24px; box-shadow: 0 10px 25px rgba(0,0,0,0.04); border: 1px solid #E2E8F0; text-align: center; }
                    .btn { background: #1E7036; color: white; border: none; padding: 14px 28px; border-radius: 14px; font-size: 16px; font-weight: bold; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 8px; justify-content: center; margin-top: 20px; }
                    .btn:hover { background: #145327; }
                    .badge { background: #E2F0D9; color: #1E7036; padding: 6px 14px; border-radius: 20px; font-size: 13px; font-weight: bold; display: inline-block; margin-bottom: 15px; }
                    .steps { text-align: right; background: #F8FAFC; padding: 20px; border-radius: 16px; margin-top: 25px; border: 1px solid #E2E8F0; }
                    .step-item { margin-bottom: 12px; font-size: 14px; color: #334155; line-height: 1.6; }
                    .step-item strong { color: #1E7036; }
                </style>
            </head>
            <body>
                <div class='header'>
                    <div class='logo'>🌿 غراس | Ghiras Mobile</div>
                    <div class='subtitle'>تطبيق الهاتف المحمول لمشروع غراس (Flutter Standalone App)</div>
                </div>

                <div class='card'>
                    <span class='badge'>Visual Studio 2026 Ready 🚀</span>
                    <h2>المشروع يعمل بنجاح ومجهز للتشغيل!</h2>
                    <p style='color: #475569;'>تم إعداد هيكلية تطبيق الفلاتر بالكامل بموجب تصاميم Adobe XD وتجهيز خيارات التشغيل لـ Visual Studio.</p>
                    
                    <div class='steps'>
                        <div class='step-item'>1. <strong>التشغيل السريع المباشر:</strong> انقر مرتين على ملف <code>RunFlutterApp.bat</code> في المجلد لتشغيل التطبيق التفاعلي فوراً.</div>
                        <div class='step-item'>2. <strong>التشغيل عبر سطر الأوامر:</strong> افتح الـ Developer PowerShell واكتب <code>flutter run -d chrome</code>.</div>
                    </div>

                    <a href='javascript:void(0)' onclick='location.reload()' class='btn'>تحديث الواجهة 🔄</a>
                </div>
            </body>
            </html>
        ");
    });
}

app.Run();
