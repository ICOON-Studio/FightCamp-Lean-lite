# Read-only: lists Windows kernel pool use by tag (what poolmon shows), biggest first.
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class PoolTags {
    [DllImport("ntdll.dll")] static extern int NtQuerySystemInformation(int cls, IntPtr buf, int len, out int ret);
    public static string[] Top(int n) {
        int len = 1 << 20; IntPtr buf = IntPtr.Zero; int ret = 0; int st = 0;
        for (int i = 0; i < 6; i++) {
            buf = Marshal.AllocHGlobal(len);
            st = NtQuerySystemInformation(22, buf, len, out ret);
            if (st == 0) break;
            Marshal.FreeHGlobal(buf); buf = IntPtr.Zero; len *= 2;
        }
        if (st != 0) return new string[] { "NtQuerySystemInformation failed 0x" + st.ToString("X8") };
        int count = Marshal.ReadInt32(buf);
        var rows = new System.Collections.Generic.List<Tuple<long, long, string, long, long>>();
        long totP = 0, totN = 0;
        for (int i = 0; i < count; i++) {
            IntPtr p = IntPtr.Add(buf, 8 + i * 40);
            byte[] t = new byte[4]; Marshal.Copy(p, t, 0, 4);
            string tag = "";
            foreach (byte b in t) tag += (b >= 32 && b < 127) ? ((char)b).ToString() : ".";
            long pAll = (uint)Marshal.ReadInt32(p, 4), pFree = (uint)Marshal.ReadInt32(p, 8);
            long pUsed = Marshal.ReadInt64(p, 16);
            long nAll = (uint)Marshal.ReadInt32(p, 24), nFree = (uint)Marshal.ReadInt32(p, 28);
            long nUsed = Marshal.ReadInt64(p, 32);
            totP += pUsed; totN += nUsed;
            rows.Add(Tuple.Create(pUsed, nUsed, tag, pAll - pFree, nAll - nFree));
        }
        Marshal.FreeHGlobal(buf);
        var o = new System.Collections.Generic.List<string>();
        o.Add(String.Format("tags {0}  paged total {1:N2} GB  nonpaged total {2:N2} GB", count, totP / 1073741824.0, totN / 1073741824.0));
        rows.Sort((a, b) => (b.Item1 + b.Item2).CompareTo(a.Item1 + a.Item2));
        for (int i = 0; i < Math.Min(n, rows.Count); i++)
            o.Add(String.Format("{0}  paged {1,9:N1} MB ({2,9:N0} live allocs)  nonpaged {3,8:N1} MB ({4,8:N0})", rows[i].Item3, rows[i].Item1 / 1048576.0, rows[i].Item4, rows[i].Item2 / 1048576.0, rows[i].Item5));
        return o.ToArray();
    }
}
"@
[PoolTags]::Top(18)
