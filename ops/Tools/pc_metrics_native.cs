// pc_metrics_native.cs - the native half of ops/Tools/pc_metrics.ps1 for the board's /pc page (S379, operator: "you have way more
// info on metrics for the pc live"). The sampler compiles it once at start (Add-Type); nothing here starts a process.
//
//  Procs.Json(): WHAT IS USING THE PC. One NtQuerySystemInformation call returns every process's CPU time and private working set
//    (Task Manager's Memory column) - Defender's protected process included, no handle per process. Each process is NAMED for a
//    human (a Godot run by its worktree task and script, claude.exe as Claude sessions, agy/qwen/cursor as their seat + task from
//    live_runs.json) and grouped by that name; the top 8 by CPU and by RAM plus every running job (Godot film / render / test /
//    editor, agent seat, encode) come back as JSON. Command lines are read only for the kinds named from them and cached per
//    process, so a steady PC costs one syscall and ~450 dictionary hits a read.
//  Folders.Start(root): the folder sizes under root on ONE background thread in Windows' background mode (lowest CPU AND disk
//    priority), never following junctions/symlinks. The sampler starts it at most once an hour and caches the answer on disk.
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;

namespace FcPc
{
    public static class J
    {
        public static string S(string s)
        {
            if (s == null) return "\"\"";
            var b = new StringBuilder(s.Length + 2);
            b.Append('"');
            foreach (char ch in s)
            {
                if (ch == '"' || ch == '\\') { b.Append('\\').Append(ch); }
                else if (ch < 0x20) { b.Append("\\u").Append(((int)ch).ToString("x4")); }
                else b.Append(ch);
            }
            return b.Append('"').ToString();
        }
        public static string N(double v, int d) { return Math.Round(v, d).ToString(CultureInfo.InvariantCulture); }
        // Index of the highest value (the newest when tied), NaN = no reading; -1 when there is none.
        public static int PeakIndex(List<double> v)
        {
            int at = -1;
            for (int i = 0; i < v.Count; i++) if (!double.IsNaN(v[i]) && (at < 0 || v[i] >= v[at])) at = i;
            return at;
        }
    }

    public class Run { public string Id = "", Agent = "", Wt = ""; }

    class P { public int Pid, Ppid; public long Create, Cpu, Ram, Delta; public string Name = "", Cmd = "", Label = "", Kind = "", Detail = ""; }

    class G { public string Label = "", Kind = "", Detail = ""; public int N, Pid; public long Delta, Ram, Start = long.MaxValue; }

    public static class Procs
    {
        [DllImport("ntdll.dll")] static extern int NtQuerySystemInformation(int cls, IntPtr buf, int len, out int ret);
        [DllImport("ntdll.dll")] static extern int NtQueryInformationProcess(IntPtr h, int cls, IntPtr buf, int len, out int ret);
        [DllImport("kernel32.dll")] static extern IntPtr OpenProcess(int access, bool inherit, int pid);
        [DllImport("kernel32.dll")] static extern bool CloseHandle(IntPtr h);

        public static List<Run> Runs = new List<Run>();
        static IntPtr buf = IntPtr.Zero;
        static int bufLen = 0;
        static readonly Dictionary<int, long[]> last = new Dictionary<int, long[]>();          // pid -> {create, cpu}
        static readonly Dictionary<int, KeyValuePair<long, string>> cmds = new Dictionary<int, KeyValuePair<long, string>>();
        static long lastT = 0;
        static readonly int Ncpu = Environment.ProcessorCount;
        static readonly Regex RxWt = new Regex(@"/fightcamp/wt/([^/\s""]+)", RegexOptions.Compiled);
        static readonly Regex RxScript = new Regex(@"res://([^\s""]+?\.(?:gd|tscn))", RegexOptions.Compiled);
        static readonly Regex RxMovie = new Regex(@"--write-movie\s+""?([^""]+?\.(?:avi|png|ogv))", RegexOptions.Compiled | RegexOptions.IgnoreCase);
        static readonly Regex RxPy = new Regex(@"([\w.-]+)\.py\b", RegexOptions.Compiled);
        static readonly Regex RxDispatch = new Regex(@"seat_dispatch\.py\s+\w+\s+([\w-]+)", RegexOptions.Compiled);
        static readonly Regex RxOut = new Regex(@"\bout=([^\s""]+)", RegexOptions.Compiled);
        static readonly Regex RxPath = new Regex(@"--path\s+""?([^""\s]+)", RegexOptions.Compiled | RegexOptions.IgnoreCase);

        public static void SetRuns(string[] ids, string[] agents, string[] wts)
        {
            var l = new List<Run>();
            for (int i = 0; i < ids.Length; i++)
                l.Add(new Run { Id = ids[i] ?? "", Agent = (agents[i] ?? "").ToLowerInvariant(), Wt = (wts[i] ?? "").Replace('\\', '/').TrimEnd('/').ToLowerInvariant() });
            Runs = l;
        }

        static List<P> Read()
        {
            var list = new List<P>();
            if (IntPtr.Size != 8) return list;   // the offsets below are the x64 SYSTEM_PROCESS_INFORMATION
            if (bufLen == 0) { bufLen = 1 << 20; buf = Marshal.AllocHGlobal(bufLen); }
            int ret, st;
            while ((st = NtQuerySystemInformation(5, buf, bufLen, out ret)) == unchecked((int)0xC0000004))
            {
                Marshal.FreeHGlobal(buf); bufLen = Math.Max(bufLen * 2, ret + 65536); buf = Marshal.AllocHGlobal(bufLen);
            }
            if (st != 0) return list;
            long off = 0;
            while (true)
            {
                IntPtr p = new IntPtr(buf.ToInt64() + off);
                int next = Marshal.ReadInt32(p, 0);
                int pid = (int)Marshal.ReadIntPtr(p, 0x50).ToInt64();
                if (pid != 0)
                {
                    int nlen = (ushort)Marshal.ReadInt16(p, 0x38);
                    IntPtr nptr = Marshal.ReadIntPtr(p, 0x40);
                    list.Add(new P
                    {
                        Pid = pid,
                        Ppid = (int)Marshal.ReadIntPtr(p, 0x58).ToInt64(),
                        Create = Marshal.ReadInt64(p, 0x20),
                        Cpu = Marshal.ReadInt64(p, 0x28) + Marshal.ReadInt64(p, 0x30),
                        Ram = Marshal.ReadInt64(p, 0x08),   // WorkingSetPrivateSize = Task Manager's "Memory"
                        Name = nlen > 0 && nptr != IntPtr.Zero ? Marshal.PtrToStringUni(nptr, nlen / 2) : "System"
                    });
                }
                if (next == 0) break;
                off += next;
            }
            return list;
        }

        static string CmdLine(int pid)
        {
            IntPtr h = OpenProcess(0x1000, false, pid);   // PROCESS_QUERY_LIMITED_INFORMATION
            if (h == IntPtr.Zero) return "";
            try
            {
                int len = 8192;
                for (int i = 0; i < 3; i++)
                {
                    IntPtr b = Marshal.AllocHGlobal(len);
                    try
                    {
                        int r; int st = NtQueryInformationProcess(h, 60, b, len, out r);   // ProcessCommandLineInformation
                        if (st == 0)
                        {
                            int l = (ushort)Marshal.ReadInt16(b, 0);
                            IntPtr s = Marshal.ReadIntPtr(b, 8);
                            return l > 0 && s != IntPtr.Zero ? Marshal.PtrToStringUni(s, l / 2) : "";
                        }
                        if (r > len) { len = r + 64; continue; }
                        return "";
                    }
                    finally { Marshal.FreeHGlobal(b); }
                }
            }
            finally { CloseHandle(h); }
            return "";
        }

        static bool WantsCmd(string n)
        {
            return n.StartsWith("godot") || n.StartsWith("python") || n == "node.exe" || n == "powershell.exe" || n == "pwsh.exe" || n == "claude.exe";
        }

        // A worktree path names its task: E:/FightCamp/wt/LEAN_FIGHT9R9 -> the live_runs row whose worktree it is (FIGHT9R9), else
        // the folder without its LEAN_ prefix. The main checkout (E:/FightCamp/Lean) gives "".
        static string WtTask(string lc)
        {
            var m = RxWt.Match(lc);
            if (!m.Success) return "";
            string wt = m.Groups[1].Value;
            foreach (var r in Runs) if (r.Wt.EndsWith("/" + wt)) return r.Id;
            string up = wt.ToUpperInvariant();
            return up.StartsWith("LEAN_") ? up.Substring(5) : up;
        }

        static string Seat(string agent, string shown, string lc)
        {
            Run hit = null; int n = 0;
            foreach (var r in Runs)
            {
                if (r.Agent != agent && !(agent == "antigravity" && r.Agent == "agy")) continue;
                n++;
                if (r.Wt.Length > 0 && lc.Contains(r.Wt)) hit = r;
                if (hit == null && n == 1) hit = r;
            }
            if (n > 1 && (hit == null || !lc.Contains(hit.Wt))) return shown + " seat (" + n + " runs)";
            return hit != null ? shown + " seat - " + hit.Id : shown + " (no running task)";
        }

        static string Friendly(string s)
        {
            switch (s)
            {
                case "grapple_orbit": return "grapple preview render";
                case "clip_orbit": return "boxer clip preview render";
                case "layout_snapshot": return "screen stills";
                case "fight3d_play": return "fight play-through";
                case "fight3d_film": case "judge_film": return "fight film";
                case "corner_film": return "corner film";
            }
            if (s.EndsWith("_still") || s.EndsWith("_stills")) return s.Replace('_', ' ') + " render";
            if (s.EndsWith("_probe")) return s.Replace('_', ' ');
            return s.Length > 0 ? s.Replace('_', ' ') + " render" : "render";
        }

        static string Join(string task, string what) { return task.Length > 0 ? task + " " + what : what; }

        static string Godot(P p, string lc)
        {
            string task = WtTask(lc);
            var mp = RxPath.Match(p.Cmd.Replace('\\', '/'));
            string proj = mp.Success ? mp.Groups[1].Value.TrimEnd('/') : "";
            if (proj.Length > 1 && proj.IndexOf("/fightcamp/", StringComparison.OrdinalIgnoreCase) < 0)
            {
                p.Kind = "other"; return "Godot - " + Path.GetFileName(proj) + " (another project)";
            }
            var ms = RxScript.Match(lc);
            string script = ms.Success ? ms.Groups[1].Value : "";
            string sname = script.Length > 0 ? Path.GetFileNameWithoutExtension(script) : "";
            var mm = RxMovie.Match(p.Cmd.Replace('\\', '/'));
            var mo = RxOut.Match(p.Cmd.Replace('\\', '/'));
            if (mm.Success) { p.Kind = "film"; p.Detail = mm.Groups[1].Value; return task.Length > 0 ? task + " film" : Friendly(sname).Replace(" render", "") + " film"; }
            if (lc.Contains("--editor") || Regex.IsMatch(lc, @"\s-e(\s|$)") || (task.StartsWith("ZIVA") && script.Length == 0))
            {
                p.Kind = "editor"; return task.StartsWith("ZIVA") ? "Ziva editor" : Join(task, "Godot editor");
            }
            if (lc.Contains("--headless"))
            {
                p.Kind = "test";
                return Join(task, (script.StartsWith("tests/") ? "headless test " : "headless ") + (sname.Length > 0 ? sname : "run"));
            }
            if (script.Length > 0) { p.Kind = "render"; if (mo.Success) p.Detail = mo.Groups[1].Value; return Join(task, Friendly(sname)); }
            p.Kind = "game"; return Join(task, "Godot game window");
        }

        static string Label(P p)
        {
            string n = p.Name.ToLowerInvariant();
            if (n.EndsWith(".exe")) n = n.Substring(0, n.Length - 4);
            string lc = p.Cmd.Replace('\\', '/').ToLowerInvariant();
            if (n.StartsWith("godot")) return Godot(p, lc);
            switch (n)
            {
                case "claude": return lc.Contains("/windowsapps/") ? "Claude desktop app" : "Claude sessions";
                case "agy": p.Kind = "seat"; return Seat("antigravity", "agy", lc);
                case "chrome": return "Chrome";
                case "msedge": case "msedgewebview2": return "Edge / WebView";
                case "brave": return "Brave";
                case "firefox": return "Firefox";
                case "steam": case "steamwebhelper": case "steamservice": case "gameoverlayui": return "Steam";
                case "msmpeng": case "mpdefendercoreservice": case "nissrv": case "mpcmdrun": return "Windows Defender scanning";
                case "memory compression": return "Windows memory compression";
                case "system": case "registry": case "secure system": return "Windows kernel";
                case "dwm": return "Windows desktop (dwm)";
                case "explorer": return "Windows Explorer";
                case "svchost": return "Windows services";
                case "wmiprvse": return "Windows WMI (sensor reads)";
                case "searchindexer": case "searchprotocolhost": case "searchfilterhost": return "Windows search indexing";
                case "librehardwaremonitor": return "LibreHardwareMonitor (temps)";
                case "codex": return "Codex app";
                case "onedrive": return "OneDrive sync";
                case "ffmpeg": p.Kind = "encode"; return "video encode (ffmpeg)";
                case "blender": p.Kind = "render"; return "Blender";
                case "cascadeur": p.Kind = "render"; return "Cascadeur";
                case "git": case "git-remote-https": return "git";
                case "conhost": return "console hosts";
            }
            if (n == "node")
            {
                if (lc.Contains("qwen")) { p.Kind = "seat"; return Seat("qwen", "Qwen", lc); }
                if (lc.Contains("cursor-agent")) { p.Kind = "seat"; return Seat("cursor", "Cursor", lc); }
                if (lc.Contains("rea.mjs") || lc.Contains("rea-agents")) return "REA tool servers";
                if (lc.Contains("codex")) return "Codex tools";
                return "Node.js";
            }
            if (n.StartsWith("python"))
            {
                if (lc.Contains("opsboard")) return lc.Contains("/fightcamp/") ? "Ops board server" : "Other project's board";
                var d = RxDispatch.Match(p.Cmd);
                if (d.Success) return "seat dispatcher - " + d.Groups[1].Value;
                if (lc.Contains("hidden_desktop.py")) return "hidden-desktop wrapper";
                if (lc.Contains("lean_grapple_render")) return "grapple preview render (driver)";
                if (lc.Contains("lean_anim_render") || lc.Contains("anim_orbit_render")) return "boxer clip preview render (driver)";
                if (lc.Contains("agent_events.py")) return "agent watcher";
                if (lc.Contains("gemini_judge")) return "Gemini judge";
                var m = RxPy.Match(lc);
                return m.Success ? "Python " + m.Groups[1].Value : "Python";
            }
            if (n == "powershell" || n == "pwsh")
            {
                if (lc.Contains("pc_metrics")) return "PC live sampler (this page)";
                if (lc.Contains("pc_watchdog") && lc.Contains("-once")) return "PC watchdog check";
                if (lc.Contains("pc_watchdog")) return "PC watchdog";
                if (lc.Contains("heat_governor")) return "Heat governor";
                if (lc.Contains("ram_trim")) return "RAM trim";
                return "PowerShell";
            }
            return p.Name.EndsWith(".exe", StringComparison.OrdinalIgnoreCase) ? p.Name.Substring(0, p.Name.Length - 4) : p.Name;
        }

        // To check a name by hand: [FcPc.Procs]::Name('Godot_v4.7.2-stable_win64.exe', '<command line>') -> 'FIGHT9R9 film [film]'.
        public static string Name(string exe, string cmd) { var p = new P { Name = exe, Cmd = cmd ?? "" }; string l = Label(p); return l + " [" + p.Kind + "]"; }

        static string Row(G g, double span)
        {
            double cpu = span > 0 ? 100.0 * g.Delta / (span * Ncpu) : 0;
            return "{\"l\":" + J.S(g.Label) + ",\"n\":" + g.N + ",\"cpu\":" + J.N(cpu, 1) + ",\"mb\":" + (g.Ram / 1048576) +
                   ",\"kind\":" + J.S(g.Kind) + "}";
        }

        // An agent CLI whose command line does not name its worktree (agy runs IN it): the seat_dispatch.py run <TASK> that started
        // it, up to 4 parents up (a qwen/cursor seat is node <- cmd <- the dispatcher).
        static string DispatchTask(P p, Dictionary<int, P> byPid)
        {
            P q = p;
            for (int i = 0; i < 4; i++)
            {
                P up;
                if (!byPid.TryGetValue(q.Ppid, out up) || up.Create > q.Create) return null;   // gone, or the pid was reused
                var m = RxDispatch.Match(up.Cmd);
                if (m.Success) return m.Groups[1].Value;
                q = up;
            }
            return null;
        }

        static long Unix(long fileTime) { return (DateTime.FromFileTimeUtc(fileTime) - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).Ticks / 10000000; }

        // One read. Returns {"n":<processes>,"span_s":..,"cpu":[top 8 groups],"ram":[top 8 groups],"jobs":[every job group, oldest first]}.
        public static string Json()
        {
            long now = DateTime.UtcNow.Ticks;
            var list = Read();
            double span = lastT > 0 ? now - lastT : 0;
            lastT = now;
            var byPid = new Dictionary<int, P>();
            foreach (var p in list)
            {
                byPid[p.Pid] = p;
                long[] prev;
                if (last.TryGetValue(p.Pid, out prev) && prev[0] == p.Create) p.Delta = Math.Max(0, p.Cpu - prev[1]);
                else p.Delta = span > 0 ? Math.Max(0, Math.Min(p.Cpu, (long)span * Ncpu)) : 0;   // new since the last read
                last[p.Pid] = new long[] { p.Create, p.Cpu };
                if (WantsCmd(p.Name.ToLowerInvariant()))
                {
                    KeyValuePair<long, string> c;
                    if (!cmds.TryGetValue(p.Pid, out c) || c.Key != p.Create) { c = new KeyValuePair<long, string>(p.Create, CmdLine(p.Pid)); cmds[p.Pid] = c; }
                    p.Cmd = c.Value ?? "";
                }
            }
            foreach (var k in new List<int>(last.Keys)) if (!byPid.ContainsKey(k)) { last.Remove(k); cmds.Remove(k); }
            var groups = new Dictionary<string, G>();
            foreach (var p in list)
            {
                p.Label = Label(p);
                if (p.Kind == "seat" && (p.Label.EndsWith(" runs)") || p.Label.EndsWith("(no running task)")))
                {
                    string task = DispatchTask(p, byPid);
                    int k = p.Label.IndexOf(" seat"); if (k < 0) k = p.Label.IndexOf(" (");
                    if (task != null && k > 0) p.Label = p.Label.Substring(0, k) + " seat - " + task;
                }
                G g;
                if (!groups.TryGetValue(p.Label, out g)) { g = new G { Label = p.Label, Kind = p.Kind, Pid = p.Pid }; groups[p.Label] = g; }
                g.N++; g.Delta += p.Delta; g.Ram += p.Ram;
                if (p.Create < g.Start) { g.Start = p.Create; g.Pid = p.Pid; }
                if (g.Detail.Length == 0) g.Detail = p.Detail;
            }
            var gl = new List<G>(groups.Values);
            var b = new StringBuilder();
            b.Append("{\"n\":").Append(list.Count).Append(",\"span_s\":").Append(J.N(span / 1e7, 1)).Append(",\"ncpu\":").Append(Ncpu);
            gl.Sort((x, y) => y.Delta.CompareTo(x.Delta));
            b.Append(",\"cpu\":[");
            for (int i = 0; i < Math.Min(8, gl.Count); i++) b.Append(i > 0 ? "," : "").Append(Row(gl[i], span));
            gl.Sort((x, y) => y.Ram.CompareTo(x.Ram));
            b.Append("],\"ram\":[");
            for (int i = 0; i < Math.Min(8, gl.Count); i++) b.Append(i > 0 ? "," : "").Append(Row(gl[i], span));
            // Jobs: every Godot (film / render / test / editor / window / another project's), agent seat and encode, oldest first.
            var jobs = gl.FindAll(g => g.Kind.Length > 0);
            jobs.Sort((x, y) => x.Start.CompareTo(y.Start));
            b.Append("],\"jobs\":[");
            for (int i = 0; i < jobs.Count; i++)
            {
                var g = jobs[i];
                double cpu = span > 0 ? 100.0 * g.Delta / (span * Ncpu) : 0;
                b.Append(i > 0 ? "," : "").Append("{\"kind\":").Append(J.S(g.Kind)).Append(",\"l\":").Append(J.S(g.Label)).Append(",\"n\":").Append(g.N)
                 .Append(",\"pid\":").Append(g.Pid).Append(",\"start\":").Append(Unix(g.Start)).Append(",\"cpu\":").Append(J.N(cpu, 1))
                 .Append(",\"mb\":").Append(g.Ram / 1048576).Append(",\"detail\":").Append(J.S(g.Detail)).Append('}');
            }
            return b.Append("]}").ToString();
        }
    }

    public static class Folders
    {
        [DllImport("kernel32.dll")] static extern IntPtr GetCurrentThread();
        [DllImport("kernel32.dll")] static extern bool SetThreadPriority(IntPtr h, int p);
        [DllImport("kernel32.dll", CharSet = CharSet.Unicode)] static extern IntPtr FindFirstFileExW(string name, int level, out FD data, int op, IntPtr filter, int flags);
        [DllImport("kernel32.dll", CharSet = CharSet.Unicode)] static extern bool FindNextFileW(IntPtr h, out FD data);
        [DllImport("kernel32.dll")] static extern bool FindClose(IntPtr h);

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        struct FD
        {
            public uint Attr, C1, C2, A1, A2, W1, W2, SizeHigh, SizeLow, R0, R1;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)] public string Name;
            [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 14)] public string Alt;
        }

        class Node { public string Name = ""; public long Bytes; public List<Node> Kids = new List<Node>(); }

        public static volatile bool Running;
        public static volatile string Result = "";
        public static volatile string Error = "";
        static long files;

        public static bool Start(string root)
        {
            if (Running) return false;
            Running = true; Error = "";
            var t = new Thread(() => Scan(root)) { IsBackground = true, Priority = ThreadPriority.Lowest, Name = "folder-sizes" };
            t.Start();
            return true;
        }

        // Size of dir (recursive), skipping reparse points. depth 1 and 2 nodes are kept for the answer.
        static long Walk(string dir, int depth, Node into)
        {
            long total = 0;
            FD d;
            IntPtr h = FindFirstFileExW(@"\\?\" + dir + @"\*", 1, out d, 0, IntPtr.Zero, 2);   // basic info, large fetch
            if (h == new IntPtr(-1)) return 0;
            try
            {
                do
                {
                    if (d.Name == "." || d.Name == "..") continue;
                    if ((d.Attr & 0x400) != 0) continue;   // junction / symlink: not ours to count, and never a loop
                    if ((d.Attr & 0x10) != 0)
                    {
                        Node k = depth < 2 ? new Node { Name = d.Name } : null;
                        long s = Walk(dir + "\\" + d.Name, depth + 1, k);
                        if (k != null) { k.Bytes = s; into.Kids.Add(k); }
                        total += s;
                    }
                    else
                    {
                        total += ((long)d.SizeHigh << 32) | d.SizeLow;
                        files++;
                    }
                } while (FindNextFileW(h, out d));
            }
            finally { FindClose(h); }
            return total;
        }

        static void Scan(string root)
        {
            var t0 = DateTime.UtcNow;
            SetThreadPriority(GetCurrentThread(), 0x00010000);   // THREAD_MODE_BACKGROUND_BEGIN: low CPU, disk and memory priority
            try
            {
                files = 0;
                var top = new Node { Name = root };
                long total = Walk(root.TrimEnd('\\'), 0, top);
                top.Kids.Sort((x, y) => y.Bytes.CompareTo(x.Bytes));
                var b = new StringBuilder();
                b.Append("{\"root\":").Append(J.S(root)).Append(",\"at\":").Append((long)(DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalSeconds)
                 .Append(",\"secs\":").Append(J.N((DateTime.UtcNow - t0).TotalSeconds, 1)).Append(",\"files\":").Append(files)
                 .Append(",\"bytes\":").Append(total).Append(",\"top\":[");
                for (int i = 0; i < Math.Min(8, top.Kids.Count); i++)
                {
                    var k = top.Kids[i];
                    k.Kids.Sort((x, y) => y.Bytes.CompareTo(x.Bytes));
                    b.Append(i > 0 ? "," : "").Append("{\"name\":").Append(J.S(k.Name)).Append(",\"bytes\":").Append(k.Bytes).Append(",\"kids\":[");
                    for (int j = 0; j < Math.Min(3, k.Kids.Count); j++)
                        b.Append(j > 0 ? "," : "").Append("{\"name\":").Append(J.S(k.Kids[j].Name)).Append(",\"bytes\":").Append(k.Kids[j].Bytes).Append('}');
                    b.Append("]}");
                }
                Result = b.Append("]}").ToString();
            }
            catch (Exception e) { Error = e.Message; }
            finally { SetThreadPriority(GetCurrentThread(), 0x00020000); Running = false; }
        }
    }
}
