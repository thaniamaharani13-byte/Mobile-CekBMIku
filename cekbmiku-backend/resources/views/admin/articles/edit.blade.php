
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Artikel | CekBMIku Admin</title>

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
            font-size: 11px;
            letter-spacing: 1px;
            opacity: 0.8;
            margin-top: 5px;
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

        .menu-item.soon {
            opacity: 0.7;
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

        /* KONTEN UTAMA */
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
            font-size: 11px;
            color: #8493a9;
            margin-top: 4px;
        }

        /* FORM ARTIKEL */
        .content-card {
            background: white;
            border: 1px solid #e7eef8;
            border-radius: 18px;
            box-shadow: 0 6px 20px rgba(31,75,138,0.04);
            padding: 32px;
            max-width: 1000px;
        }

        .form-header {
            padding-bottom: 24px;
            margin-bottom: 28px;
            border-bottom: 1px solid #edf1f7;
        }

        .form-header h2 {
            font-size: 21px;
            margin-bottom: 9px;
        }

        .form-header p {
            color: #8493a9;
            font-size: 13px;
            line-height: 1.7;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-size: 14px;
            font-weight: 600;
            color: #334f70;
        }

        .required {
            color: #e35c69;
        }

        .form-control {
            display: block;
            width: 100%;
            padding: 14px 16px;
            border: 1px solid #dbe5f0;
            border-radius: 10px;
            background: white;
            font: inherit;
            font-size: 14px;
            color: #243b53;
            outline: none;
            transition: 0.2s;
        }

        .form-control:focus {
            border-color: #3488ed;
            box-shadow: 0 0 0 4px rgba(52,136,237,0.1);
        }

        textarea.form-control {
            min-height: 220px;
            resize: vertical;
            line-height: 1.7;
        }

        .form-hint {
            display: block;
            margin-top: 9px;
            font-size: 12px;
            line-height: 1.6;
            color: #8493a9;
        }

        .error-message {
            color: #dc3545;
            font-size: 12px;
            margin-top: 8px;
        }

        .draft-box {
            padding: 16px 18px;
            background: #fff8e9;
            border: 1px solid #f2e2b9;
            border-radius: 11px;
            color: #8c692c;
            font-size: 13px;
            line-height: 1.7;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #edf1f7;
        }

        .cancel-button {
            display: inline-block;
            padding: 14px 22px;
            border: 1px solid #dbe5f0;
            border-radius: 10px;
            background: white;
            color: #526b88;
            font: inherit;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
        }

        .save-button {
            padding: 14px 24px;
            border: none;
            border-radius: 10px;
            background: linear-gradient(100deg, #2164ce, #349ded);
            color: white;
            font: inherit;
            font-size: 13px;
            font-weight: 700;
        }

        .save-button:disabled {
            opacity: 0.65;
            cursor: not-allowed;
        }

        @media (max-width: 800px) {
            .admin-layout {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
            }

            .sidebar-bottom {
                margin-top: 20px;
            }

            .main-content {
                padding: 25px 20px;
            }

            .content-card {
                padding: 24px;
            }
        }

        @media (max-width: 520px) {
            .topbar {
                flex-direction: column;
                align-items: flex-start;
            }

            .form-actions {
                justify-content: stretch;
            }

            .form-actions a,
            .form-actions button {
                width: 100%;
                text-align: center;
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
                    href="{{ route('admin.dashboard') }}"
                    class="menu-item"
                >
                    <span class="menu-icon">▦</span>
                    Dashboard
                </a>

                <a
                    href="{{ route('admin.articles.index') }}"
                    class="menu-item active"
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
                    <h1>Edit Artikel Kesehatan</h1>
                    <p>
                        Buat artikel baru berdasarkan kategori BMI.
                    </p>
                </div>

                <div class="admin-profile">
                    <div class="avatar">A</div>
                    <div>
                        <div class="profile-name">
                            {{ auth()->user()?->name ?? 'Administrator' }}
                        </div>
                        <div class="profile-role">Administrator</div>
                    </div>
                </div>
            </header>

            <section class="content-card">

                <div class="form-header">
                    <h2>Informasi Artikel</h2>
                    <p>
                        Lengkapi informasi berikut untuk
                        menambahkan artikel kesehatan.
                    </p>
                </div>

                <!-- Penyimpanan diaktifkan pada langkah berikutnya -->
                <form
    method="POST"
    action="{{ route('admin.articles.update', $article->id) }}"
    enctype="multipart/form-data"
>
    @csrf
    @method('PUT')

                    <!-- JUDUL ARTIKEL -->
                    <div class="form-group">
                        <label for="title">
                            Judul Artikel
                            <span class="required">*</span>
                        </label>

                        <input
                            class="form-control"
                            type="text"
                            id="title"
                            name="title"
                            value="{{ old('title', $article->title) }}"
                            maxlength="200"
                            placeholder="Masukkan judul artikel kesehatan"
                            required
                        >

                        @error('title')
                            <p class="error-message">{{ $message }}</p>
                        @enderror
                    </div>

                    <!-- KATEGORI BMI -->
                    <div class="form-group">
                        <label for="category_id">
                            Kategori BMI
                            <span class="required">*</span>
                        </label>

                        <select
                            class="form-control"
                            id="category_id"
                            name="category_id"
                            required
                        >
                            <option value="">
                                -- Pilih Kategori BMI --
                            </option>

                            @foreach ($categories as $category)
                                <option
                                    value="{{ $category->id }}"
                                    @selected(old('category_id', $article->category_id) == $category->id)
                                >
                                    {{ $category->category_name }}
                                </option>
                            @endforeach
                        </select>

                        <span class="form-hint">
                            Kategori menentukan kelompok BMI
                            yang sesuai dengan artikel.
                        </span>

                        @error('category_id')
                            <p class="error-message">{{ $message }}</p>
                        @enderror
                    </div>


<!-- Kategori Artikel -->
<div class="form-group">
    <label for="topic_category">Kategori Artikel</label>

    <select
        class="form-control"
        id="topic_category"
        name="topic_category"
        required
    >
        <option value="">-- Pilih Kategori Artikel --</option>

        @foreach (['Nutrisi', 'Olahraga', 'BMI', 'Kesehatan', 'Penyakit'] as $topic)
            <option
                value="{{ $topic }}"
                @selected(old('topic_category', $article->topic_category) == $topic)
            >
                {{ $topic }}
            </option>
        @endforeach
    </select>

    <span class="form-hint">
        Kategori artikel ditampilkan sebagai label topik
        pada artikel di aplikasi CekBMIku.
    </span>

    @error('topic_category')
        <p class="error-message">{{ $message }}</p>
    @enderror
</div>

                    <!-- ISI ARTIKEL -->
                    <div class="form-group">
                        <label for="content">
                            Isi Artikel
                            <span class="required">*</span>
                        </label>

                        <textarea
                            class="form-control"
                            id="content"
                            name="content"
                            placeholder="Tuliskan isi artikel kesehatan di sini..."
                            required
                        >{{ old('content', $article->content) }}</textarea>

                        @error('content')
                            <p class="error-message">{{ $message }}</p>
                        @enderror
                    </div>

<!-- Link Artikel Asli -->
<div class="form-group">
    <label for="source_url">Link Artikel Asli</label>

    <input
        type="url"
        class="form-control"
        id="source_url"
        name="source_url"
        value="{{ old('source_url', $article->source_url) }}"
        placeholder="https://contoh.com/artikel"
        maxlength="2048"
    >

    <span class="form-hint">
        Masukkan URL sumber artikel asli. Link ini akan
        dibuka ketika pengguna memilih Baca Artikel
        Selengkapnya pada aplikasi CekBMIku.
    </span>

    @error('source_url')
        <p class="error-message">{{ $message }}</p>
    @enderror
</div>

                    <!-- GAMBAR ARTIKEL -->
                    <div class="form-group">
                        <label for="image">
                            Gambar Artikel (Opsional)
                        </label>

                        <input
                            class="form-control"
                            type="file"
                            id="image"
                            name="image"
                            accept=".jpg,.jpeg,.png,.webp"
                        >

                        <span class="form-hint">
                            Format yang direncanakan:
                            JPG, PNG, atau WebP.
                            Validasi ukuran dan penyimpanan gambar
                            akan diatur pada Controller.
                        </span>

                        @error('image')
                            <p class="error-message">{{ $message }}</p>
                        @enderror
                    </div>

                    <!-- STATUS AWAL -->
                    <div class="form-group">
                        <label>Status Artikel</label>

                        <div class="draft-box">
    Status artikel saat ini:
    <strong>
        {{ $article->status === 'published' ? 'Dipublikasikan' : 'Draft' }}
    </strong>.
    Mengedit artikel tidak otomatis mengubah status publikasinya.
</div>

                        <input
                            type="hidden"
                            value="draft"
                        >
                    </div>

                    <!-- TOMBOL FORMULIR -->
                    <div class="form-actions">
                        <a
                            href="{{ route('admin.articles.index') }}"
                            class="cancel-button"
                        >
                            Batal
                        </a>

                        <button
    type="submit"
    class="save-button"
>
    Simpan Perubahan
</button>
                    </div>

                </form>
            </section>

        </main>
    </div>
</body>
</html>
