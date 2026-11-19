
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Pengguna - CekBMIku</title>

    
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Segoe UI', Arial, sans-serif;
        background: #f4f8ff;
        color: #183b68;
    }

    .layout {
        display: flex;
        min-height: 100vh;
    }

    /* SIDEBAR - SAMA DENGAN DASHBOARD */
    .sidebar {
        width: 265px;
        flex-shrink: 0;
        min-height: 100vh;
        background: linear-gradient(
            165deg,
            #1746a2,
            #2879df,
            #379de8
        );
        color: white;
        padding: 30px 20px;
        display: flex;
        flex-direction: column;
    }

    .brand {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 0 10px 30px;
        border-bottom: 1px solid rgba(255,255,255,0.2);
    }

    .brand-logo {
        width: 65px;
        height: 65px;
        background: white;
        border-radius: 14px;
        padding: 7px;
        object-fit: contain;
    }

    .brand-text h2 {
        font-size: 19px;
        color: white;
    }

    .brand-text p {
        font-size: 11px;
        opacity: 0.8;
        margin-top: 5px;
        letter-spacing: 1px;
    }

    .menu-label {
        margin: 32px 12px 14px;
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 1.5px;
        opacity: 0.7;
    }

    .menu {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .menu-item {
        display: flex;
        align-items: center;
        gap: 13px;
        padding: 14px 16px;
        border-radius: 11px;
        color: white;
        text-decoration: none;
        font-size: 14px;
    }

    .menu-item.active,
    .menu-item:hover {
        background: rgba(255,255,255,0.2);
    }

    .menu-item.active {
        font-weight: 700;
    }

    .menu-icon {
        font-size: 19px;
        width: 24px;
        text-align: center;
        flex-shrink: 0;
    }

    .sidebar-bottom {
        margin-top: auto;
        padding-top: 30px;
    }

    .sidebar-bottom form {
        margin: 0;
    }

    .logout-button {
        width: 100%;
        padding: 13px;
        background: rgba(255,255,255,0.14);
        border: 1px solid rgba(255,255,255,0.3);
        border-radius: 10px;
        color: white;
        font: inherit;
        font-size: 14px;
        cursor: pointer;
    }

    .logout-button:hover {
        background: rgba(255,255,255,0.25);
    }

    .menu-item:focus-visible,
    .logout-button:focus-visible,
    .btn-detail:focus-visible {
        outline: 3px solid #f8bd63;
        outline-offset: 3px;
    }

    /* AREA UTAMA */
    .main {
        flex: 1;
        min-width: 0;
        padding: 35px 40px;
    }

    /* JUDUL HALAMAN */
    .heading {
        margin-bottom: 30px;
    }

    .heading h1 {
        font-size: 29px;
        color: #183b68;
        margin-bottom: 8px;
    }

    .heading p {
        font-size: 14px;
        color: #8493a9;
        line-height: 1.6;
    }

    /* KARTU RINGKASAN PENGGUNA */
    .summary {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        margin-bottom: 30px;
    }

    .summary-card {
        background: white;
        border: 1px solid #e7eef8;
        border-radius: 17px;
        padding: 25px;
        min-width: 230px;
        box-shadow: 0 6px 20px rgba(31, 75, 138, 0.04);
    }

    .summary-card span {
        display: block;
        color: #7487a2;
        font-size: 13px;
        margin-bottom: 12px;
    }

    .summary-card strong {
        color: #2164ce;
        font-size: 28px;
        font-weight: 700;
    }

    /* KARTU DATA PENGGUNA */
    .table-card {
        background: white;
        border: 1px solid #e7eef8;
        border-radius: 17px;
        padding: 28px 30px;
        box-shadow: 0 6px 20px rgba(31, 75, 138, 0.04);
    }

    .table-card h2 {
        font-size: 19px;
        color: #183b68;
        margin-bottom: 22px;
    }

    /* TABEL PENGGUNA */
    .table-wrapper {
        overflow-x: auto;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        text-align: left;
    }

    th {
        background: #f1f6ff;
        color: #456188;
        font-size: 13px;
        font-weight: 700;
        padding: 16px;
        white-space: nowrap;
    }

    td {
        padding: 17px 16px;
        border-bottom: 1px solid #edf1f6;
        font-size: 14px;
        color: #183b68;
    }

    tbody tr:last-child td {
        border-bottom: none;
    }

    tbody tr:hover {
        background: #fafcff;
    }

    /* STATUS PENGGUNA */
    .badge {
        display: inline-block;
        padding: 7px 12px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        white-space: nowrap;
    }

    .badge-success {
        background: #e5f8ee;
        color: #238652;
    }

    .badge-warning {
        background: #fff4db;
        color: #a66b13;
    }

    .badge-muted {
        background: #f0f2f5;
        color: #78869a;
    }

    /* TOMBOL LIHAT RIWAYAT */
    .btn-detail {
        display: inline-block;
        padding: 9px 14px;
        background: #e8f2ff;
        color: #2164ce;
        border-radius: 9px;
        text-decoration: none;
        font-size: 13px;
        font-weight: 600;
        white-space: nowrap;
        transition: background 0.2s ease, color 0.2s ease;
    }

    .btn-detail:hover {
        background: #2164ce;
        color: white;
    }

    /* DATA KOSONG */
    .empty {
        padding: 35px;
        text-align: center;
        color: #8794a7;
    }

    /* RESPONSIVE */
    @media (max-width: 800px) {
        .layout {
            flex-direction: column;
        }

        .sidebar {
            width: 100%;
            min-height: auto;
        }

        .sidebar-bottom {
            margin-top: 20px;
            padding-top: 10px;
        }

        .main {
            padding: 25px 20px;
        }
    }

    @media (max-width: 520px) {
        .heading h1 {
            font-size: 24px;
        }

        .summary {
            flex-direction: column;
        }

        .summary-card {
            min-width: 0;
            width: 100%;
        }

        .table-card {
            padding: 20px;
        }
    }
</style>

</head>

<body>
<div class="layout">

     <aside class="sidebar">

            <div class="brand">
                <img
                    class="brand-logo"
                    src="{{ asset('images/logo_footer.png') }}"
                    alt="Logo CekBMIku"
                >

                <div class="brand-text">
                    <h2>CekBMIku</h2>
                    <p>ADMIN PANEL</p>
                </div>
            </div>

            <p class="menu-label">MENU UTAMA</p>

            <nav class="menu">
                <a
                    href="{{ url('/admin/dashboard') }}"
                    class="menu-item"
                    aria-current="page"
                >
                    <span class="menu-icon">▦</span>
                    Dashboard
                </a>

                <a
                    href="{{ route('admin.articles.index') }}"
                    class="menu-item"
                >
                    <span class="menu-icon">▤</span>
                    Artikel Kesehatan
                </a>

                <a
                    href="{{ route('admin.recommendations.index') }}"
                    class="menu-item"
                >
                    <span class="menu-icon">♡</span>
                    Rekomendasi Gaya Hidup
                </a>
                
<a
    href="{{ route('admin.users.index') }}"
    class="menu-item active"
    aria-current="page"
>
    <span class="menu-icon">♙</span>
    Daftar Pengguna
</a>

            </nav>

            <div class="sidebar-bottom">
                <form
                    method="POST"
                    action="{{ route('admin.logout') }}"
                >
                    @csrf

                    <button
                        type="submit"
                        class="logout-button"
                    >
                        Keluar dari Admin
                    </button>
                </form>
            </div>

        </aside>

    <main class="main">

        <div class="heading">
            <h1>Daftar Pengguna</h1>
            <p>
                Ringkasan pengguna dan aktivitas pemeriksaan BMI
                pada aplikasi CekBMIku.
            </p>
        </div>

        <div class="summary">
            <div class="summary-card">
                <span>Total Pengguna</span>
                <strong>{{ $users->count() }}</strong>
            </div>

            <div class="summary-card">
                <span>Pengguna Pernah Cek BMI</span>
                <strong>
                    {{ $users->where('total_checks', '>', 0)->count() }}
                </strong>
            </div>
        </div>

        <div class="table-card">
            <h2>Data Pengguna Terdaftar</h2>

            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>No.</th>
                            <th>Nama</th>
                            <th>Email</th>
                            <th>Total Cek BMI</th>
                            <th>Pemeriksaan Terakhir</th>
                            <th>Status</th>
<th>Aksi</th>
                        </tr>
                    </thead>

                    <tbody>
                        @forelse ($users as $user)
                            <tr>
                                <td>{{ $loop->iteration }}</td>
                                <td>{{ $user->name }}</td>
                                <td>{{ $user->email }}</td>
                                <td>{{ $user->total_checks }} kali</td>
                                <td>
                                    {{ $user->last_check
                                        ? \Carbon\Carbon::parse($user->last_check)->format('d M Y, H:i')
                                        : 'Belum pernah' }}
                                </td>
                                <td>
                                    
@if (!$user->last_check)
    <span class="badge badge-muted">
        Belum Cek BMI
    </span>
@elseif (\Carbon\Carbon::parse($user->last_check)->lessThanOrEqualTo(now()->subMonthNoOverflow()))
    <span class="badge badge-warning">
        Perlu Pemeriksaan Ulang
    </span>
@else
    <span class="badge badge-success">
        Aktif Pemeriksaan
    </span>
@endif
                                </td>

<td>
    <a href="{{ route('admin.users.show', $user->id) }}"
       class="btn-detail">
        Lihat Riwayat
    </a>
</td>

                            </tr>
                        @empty
                            <tr>
                                <td colspan="7" class="empty">
                                    Belum ada pengguna terdaftar.
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>
</body>
</html>
