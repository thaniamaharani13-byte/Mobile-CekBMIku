<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin | CekBMIku</title>

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

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        /* SIDEBAR */
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
        }

        .sidebar-bottom {
            margin-top: auto;
            padding-top: 30px;
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

        /* AREA UTAMA */
        .main-content {
            flex: 1;
            min-width: 0;
            padding: 35px 40px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 35px;
        }

        .page-heading h1 {
            font-size: 29px;
            color: #183b68;
            margin-bottom: 8px;
        }

        .page-heading p {
            font-size: 14px;
            color: #8493a9;
        }

        .admin-profile {
            background: white;
            border: 1px solid #e4ebf5;
            border-radius: 13px;
            padding: 12px 17px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .avatar {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 38px;
            height: 38px;
            background: #e5f0ff;
            color: #2164ce;
            border-radius: 50%;
            font-weight: 700;
        }

        .profile-name {
            font-size: 13px;
            font-weight: 700;
            color: #183b68;
        }

        .profile-role {
            font-size: 11px;
            color: #8493a9;
            margin-top: 4px;
        }

        /* KARTU RINGKASAN */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 17px;
            padding: 25px;
            border: 1px solid #e7eef8;
            box-shadow: 0 6px 20px rgba(31, 75, 138, 0.04);
        }

        .stat-icon {
            width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #e8f2ff;
            border-radius: 12px;
            font-size: 21px;
            margin-bottom: 20px;
        }

        .stat-label {
            color: #7487a2;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .stat-number {
            color: #2164ce;
            font-size: 30px;
            font-weight: 700;
        }

        .stat-note {
            margin-top: 8px;
            font-size: 11px;
            color: #9ba9bc;
        }

        /* BAGIAN PENGELOLAAN */
        .section-title {
            font-size: 20px;
            color: #183b68;
            margin-bottom: 18px;
        }

        .management-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .management-card {
            background: white;
            border: 1px solid #e7eef8;
            border-radius: 18px;
            padding: 28px;
            box-shadow: 0 6px 20px rgba(31, 75, 138, 0.04);
        }

        .management-icon {
            width: 55px;
            height: 55px;
            background: linear-gradient(135deg, #e6f1ff, #d6eaff);
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 25px;
            margin-bottom: 20px;
        }

        .management-card h3 {
            font-size: 19px;
            margin-bottom: 12px;
        }

        .management-card p {
            font-size: 14px;
            line-height: 1.7;
            color: #7b8da5;
            margin-bottom: 20px;
        }

        .management-link {
            display: inline-block;
            padding: 11px 17px;
            border-radius: 10px;
            background: linear-gradient(100deg, #2164ce, #349ded);
            color: white;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: filter 0.2s ease;
        }

        .management-link:hover {
            filter: brightness(1.08);
        }

        .management-link:focus-visible,
        .menu-item:focus-visible {
            outline: 3px solid #f8bd63;
            outline-offset: 3px;
        }

        .info-note {
            margin-top: 25px;
            padding: 18px 20px;
            background: #e9f3ff;
            border-radius: 13px;
            color: #38659c;
            font-size: 13px;
            line-height: 1.7;
        }

        /* RESPONSIVE */
        @media (max-width: 1100px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 800px) {
            .admin-layout {
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

            .main-content {
                padding: 25px 20px;
            }

            .management-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 520px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

            .topbar {
                align-items: flex-start;
                flex-direction: column;
            }
        }
    </style>
</head>

<body>
    <div class="admin-layout">

        <!-- SIDEBAR -->
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
                    class="menu-item active"
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
    class="menu-item"
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

        <!-- KONTEN UTAMA -->
        <main class="main-content">

            <!-- HEADER -->
            <header class="topbar">
                <div class="page-heading">
                    <h1>Dashboard Admin</h1>
                    <p>
                        Selamat datang di panel pengelolaan CekBMIku.
                    </p>
                </div>

                <div class="admin-profile">
                    <div class="avatar">A</div>

                    <div>
                        <div class="profile-name">
                            {{ auth()->user()?->name ?? 'Administrator' }}
                        </div>
                        <div class="profile-role">
                            Administrator
                        </div>
                    </div>
                </div>
            </header>

            <!-- RINGKASAN -->
            <section class="stats-grid">

                <div class="stat-card">
                    <div class="stat-icon">▤</div>
                    <p class="stat-label">Total Artikel</p>
                    <div class="stat-number">{{ $totalArtikel }}</div>
                    <p class="stat-note">Data dari database CekBMIku</p>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">♡</div>
                    <p class="stat-label">Total Rekomendasi</p>
                    <div class="stat-number">{{ $totalRekomendasi }}</div>
                    <p class="stat-note">Data dari database CekBMIku</p>
                </div>

                <div class="stat-card">
                    <div class="stat-icon">♙</div>
                    <p class="stat-label">Total Pengguna</p>
                    <div class="stat-number">{{ $totalPengguna }}</div>
                    <p class="stat-note">Data dari database CekBMIku</p>

<a href="{{ route('admin.users.index') }}"
   style="display: inline-block; margin-top: 12px;
          color: #1765c1; font-size: 13px;
          font-weight: 600; text-decoration: none;">
    Lihat Pengguna &rarr;
</a>

                </div>

                <div class="stat-card">
                    <div class="stat-icon">▦</div>
                    <p class="stat-label">Kategori BMI</p>
                    <div class="stat-number">{{ $totalKategori }}</div>
                    <p class="stat-note">Data dari database CekBMIku</p>
                </div>

            </section>

            <!-- MANAJEMEN KONTEN -->
            <section>
                <h2 class="section-title">
                    Pengelolaan Konten
                </h2>

                <div class="management-grid">

                    <div class="management-card">
                        <div class="management-icon">▤</div>

                        <h3>Artikel Kesehatan</h3>

                        <p>
                            Tambah, edit, dan hapus artikel kesehatan berdasarkan
                            kategori BMI. Publikasi artikel masih dinonaktifkan
                            selama tahap pengujian.
                        </p>

                        <a
                            href="{{ route('admin.articles.index') }}"
                            class="management-link"
                        >
                            Kelola Artikel
                        </a>
                    </div>

                    <div class="management-card">
                        <div class="management-icon">♡</div>

                        <h3>Rekomendasi Gaya Hidup</h3>

                        <p>
                            Tambah, edit, dan hapus rekomendasi Makanan,
                            Aktivitas Fisik, dan Gaya Hidup berdasarkan
                            kategori BMI pengguna.
                        </p>

                        <a
                            href="{{ route('admin.recommendations.index') }}"
                            class="management-link"
                        >
                            Kelola Rekomendasi
                        </a>
                </div>
            </section>

            <div class="info-note">
                Dashboard menampilkan ringkasan data CekBMIku yang terintegrasi dengan database MySQL serta menyediakan akses pengelolaan Artikel Kesehatan dan Rekomendasi Gaya Hidup.
            </div>

        </main>
    </div>
</body>
</html>
