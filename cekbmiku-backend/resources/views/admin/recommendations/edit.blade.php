<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Rekomendasi | CekBMIku Admin</title>

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

        .sidebar {
            width: 265px;
            flex-shrink: 0;
            background: linear-gradient(
                165deg, #1746a2, #2879df, #379de8
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
            object-fit: contain;
            padding: 7px;
            background: white;
            border-radius: 14px;
        }

        .brand-text h2 {
            font-size: 19px;
        }

        .brand-text p {
            margin-top: 5px;
            font-size: 11px;
            letter-spacing: 1px;
            opacity: 0.8;
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

        .menu-item:hover,
        .menu-item.active {
            background: rgba(255,255,255,0.2);
        }

        .menu-item.active {
            font-weight: 700;
        }

        .menu-icon {
            width: 24px;
            text-align: center;
            font-size: 19px;
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
            margin-bottom: 30px;
        }

        .page-heading h1 {
            font-size: 29px;
            margin-bottom: 8px;
        }

        .page-heading p {
            font-size: 14px;
            color: #8493a9;
        }

        .admin-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 17px;
            background: white;
            border: 1px solid #e4ebf5;
            border-radius: 13px;
        }

        .avatar {
            width: 38px;
            height: 38px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #e5f0ff;
            color: #2164ce;
            border-radius: 50%;
            font-weight: 700;
        }

        .profile-name {
            font-size: 13px;
            font-weight: 700;
        }

        .profile-role {
            margin-top: 4px;
            font-size: 11px;
            color: #8493a9;
        }

        .content-card {
            background: white;
            border: 1px solid #e7eef8;
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 6px 20px rgba(31,75,138,0.04);
        }

        .card-header {
            padding: 26px 30px;
            border-bottom: 1px solid #edf1f7;
        }

        .card-header h2 {
            font-size: 20px;
            margin-bottom: 7px;
        }

        .card-header p {
            font-size: 13px;
            color: #8493a9;
        }

        .form-content {
            padding: 30px;
        }

        .form-group {
            margin-bottom: 23px;
        }

        .form-group label {
            display: block;
            margin-bottom: 9px;
            font-size: 14px;
            font-weight: 600;
        }

        .form-control {
            width: 100%;
            padding: 13px 15px;
            border: 1px solid #dbe5f0;
            border-radius: 10px;
            font: inherit;
            font-size: 14px;
            color: #183b68;
            background: white;
            outline: none;
        }

        .form-control:focus {
            border-color: #2879df;
            box-shadow: 0 0 0 3px rgba(40,121,223,0.1);
        }

        textarea.form-control {
            min-height: 150px;
            resize: vertical;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-hint {
            margin-top: 7px;
            font-size: 12px;
            color: #8493a9;
            line-height: 1.6;
        }

        .error-text {
            margin-top: 6px;
            font-size: 12px;
            color: #d64545;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding-top: 22px;
            border-top: 1px solid #edf1f7;
        }

        .cancel-button {
            padding: 12px 20px;
            background: #edf4ff;
            color: #2164ce;
            text-decoration: none;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
        }

        
.save-button {
    padding: 12px 20px;
    background: linear-gradient(100deg, #2164ce, #349ded);
    color: white;
    border: none;
    border-radius: 10px;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    transition: 0.2s ease;
}

.save-button:hover:not(:disabled) {
    filter: brightness(1.08);
}

.save-button:disabled {
    background: #aebbd0;
    cursor: not-allowed;
    opacity: 0.8;
}

.current-image { margin-top: 12px; }
.current-image img {
    display: block;
    width: 130px;
    max-height: 130px;
    object-fit: cover;
    margin-top: 8px;
    border-radius: 10px;
    border: 1px solid #dbe5f0;
}

        .info-note {
            margin-top: 24px;
            padding: 17px 20px;
            background: #e9f3ff;
            border-radius: 13px;
            color: #38659c;
            font-size: 13px;
            line-height: 1.7;
        }

        @media (max-width: 800px) {
            .admin-layout {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            .main-content {
                padding: 25px 20px;
            }

            .topbar {
                flex-wrap: wrap;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .form-content {
                padding: 22px;
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
                <a href="{{ url('/admin/dashboard') }}" class="menu-item">
                    <span class="menu-icon">▦</span>
                    Dashboard
                </a>

                <a href="{{ route('admin.articles.index') }}" class="menu-item">
                    <span class="menu-icon">▤</span>
                    Artikel Kesehatan
                </a>

                <a
                    href="{{ route('admin.recommendations.index') }}"
                    class="menu-item active"
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
                <form method="POST" action="{{ route('admin.logout') }}">
                    @csrf
                    <button type="submit" class="logout-button">
                        Keluar dari Admin
                    </button>
                </form>
            </div>
        </aside>

        <!-- KONTEN UTAMA -->
        <main class="main-content">

            <header class="topbar">
                <div class="page-heading">
                    <h1>Edit Rekomendasi</h1>
                    <p>Perbarui informasi rekomendasi gaya hidup yang sudah terdaftar.</p>
                </div>

                <div class="admin-profile">
                    <div class="avatar">A</div>

                    <div>
                        <div class="profile-name">
                            {{ Auth::user()->name }}
                        </div>
                        <div class="profile-role">Administrator</div>
                    </div>
                </div>
            </header>

            <section class="content-card">

                <div class="card-header">
                    <h2>Formulir Edit Rekomendasi</h2>
                    <p>
                        Periksa dan ubah informasi rekomendasi yang akan ditampilkan
                        pada aplikasi CekBMIku.
                    </p>
                </div>

                <!-- Update belum dibuat. Form ini tidak mengirim data. -->
                
<form
    action="{{ route('admin.recommendations.update', $recommendation->id) }}"
    method="POST"
    enctype="multipart/form-data"
>
    @csrf
    @method('PUT')


                    <div class="form-content">

                        <!-- Judul -->
                        <div class="form-group">
                            <label for="title">Judul Rekomendasi</label>

                            <input
                                type="text"
                                id="title"
                                name="title"
                                class="form-control"
                                placeholder="Masukkan judul rekomendasi"
                                value="{{ old('title', $recommendation->title) }}"
                                maxlength="200"
                                required
                            >

                            @error('title')
                                <p class="error-text">{{ $message }}</p>
                            @enderror
                        </div>

                        <div class="form-row">

                            <!-- Jenis -->
                            <div class="form-group">
                                <label for="type">Jenis Rekomendasi</label>

                                <select
                                    id="type"
                                    name="type"
                                    class="form-control"
                                    required
                                >
                                    <option value="">Pilih Jenis</option>
                                    @foreach (['Makanan', 'Aktivitas Fisik', 'Gaya Hidup'] as $type)
                                        <option value="{{ $type }}"
                                            {{ old('type', $recommendation->type) === $type ? 'selected' : '' }}>
                                            {{ $type }}
                                        </option>
                                    @endforeach
                                </select>

                                @error('type')
                                    <p class="error-text">{{ $message }}</p>
                                @enderror
                            </div>

                            <!-- Kategori BMI -->
                            <div class="form-group">
                                <label for="category_id">Kategori BMI</label>

                                <select
                                    id="category_id"
                                    name="category_id"
                                    class="form-control"
                                    required
                                >
                                    <option value="">Pilih Kategori BMI</option>

                                    @foreach ($categories as $category)
                                        <option
                                            value="{{ $category->id }}"
                                            {{ old('category_id', $recommendation->category_id) == $category->id ? 'selected' : '' }}
                                        >
                                            {{ $category->category_name }}
                                        </option>
                                    @endforeach
                                </select>

                                @error('category_id')
                                    <p class="error-text">{{ $message }}</p>
                                @enderror
                            </div>
                        </div>

                        <!-- Deskripsi -->
                        <div class="form-group">
                            <label for="content">Deskripsi Rekomendasi</label>

                            <textarea
                                id="content"
                                name="content"
                                class="form-control"
                                placeholder="Tuliskan isi rekomendasi gaya hidup..."
                                required
                            >{{ old('content', $recommendation->content) }}</textarea>

                            @error('content')
                                <p class="error-text">{{ $message }}</p>
                            @enderror
                        </div>

<!-- Link Sumber Rekomendasi -->
<div class="form-group">
    <label for="source_url">Link Sumber Rekomendasi</label>

    <input
        type="url"
        class="form-control"
        id="source_url"
        name="source_url"
        value="{{ old('source_url', $recommendation->source_url ?? '') }}"
        placeholder="https://contoh.com/rekomendasi"
        maxlength="2048"
    >

    <span class="form-hint">
        Masukkan URL sumber rekomendasi asli.
        Link ini akan dibuka ketika pengguna memilih
        Baca Selengkapnya pada aplikasi CekBMIku.
    </span>

    @error('source_url')
        <p class="error-message">{{ $message }}</p>
    @enderror
</div>

                        <!-- Gambar -->
                        <div class="form-group">
                            <label for="image">Gambar Rekomendasi</label>

                            <input
                                type="file"
                                id="image"
                                name="image"
                                class="form-control"
                                accept=".jpg,.jpeg,.png,.webp"
                            >

                            @if ($recommendation->image_path)
                                <div class="current-image">
                                    <p class="form-hint">Gambar saat ini:</p>
                                    <img
                                        src="{{ asset('storage/' . $recommendation->image_path) }}"
                                        alt="Gambar rekomendasi saat ini"
                                    >
                                </div>
                            @endif

                            <p class="form-hint">
                                Format JPG, PNG, atau WebP. Maksimal 2 MB.
                                Kosongkan bila tidak ingin mengganti gambar.
                            </p>

                            @error('image')
                                <p class="error-text">{{ $message }}</p>
                            @enderror
                        </div>

                        <!-- Tombol -->
                        <div class="form-actions">
                            <a
                                href="{{ route('admin.recommendations.index') }}"
                                class="cancel-button"
                            >
                                Batal
                            </a>

                            <button type="submit" class="save-button">
    Simpan Perubahan
</button>
                        </div>

                    </div>
                </form>
            </section>

            <div class="info-note">
                Halaman edit sudah menampilkan data rekomendasi yang tersimpan.
                Tombol Simpan Perubahan sementara dinonaktifkan sampai fungsi
                update() dan route penyimpanan perubahan selesai dibuat.
            </div>

        </main>
    </div>
</body>
</html>