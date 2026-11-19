<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rekomendasi Gaya Hidup | CekBMIku Admin</title>

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
            background: linear-gradient(165deg, #1746a2, #2879df, #379de8);
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

        .menu-item.active,
        .menu-item:hover {
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            padding: 26px 28px;
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

        
.add-button {
    display: inline-block;
    padding: 13px 20px;
    background: linear-gradient(100deg, #2164ce, #349ded);
    color: white;
    font-size: 13px;
    font-weight: 700;
    text-decoration: none;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    transition: 0.2s ease;
}

.add-button:hover {
    filter: brightness(1.08);
}

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        thead {
            background: #f7faff;
        }

        th {
            padding: 17px 20px;
            color: #607c9e;
            font-size: 12px;
            white-space: nowrap;
        }

        td {
            padding: 19px 20px;
            border-top: 1px solid #edf1f7;
            font-size: 13px;
            color: #526b88;
        }

        .recommendation-title {
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
            color: #183b68;
        }

        .recommendation-image {
            width: 48px;
            height: 48px;
            border-radius: 9px;
            object-fit: cover;
        }

        .category-badge {
            display: inline-block;
            padding: 7px 11px;
            background: #edf4ff;
            color: #3974ce;
            border-radius: 8px;
            white-space: nowrap;
        }

        .empty-state {
            text-align: center;
            padding: 65px 25px;
        }

        .empty-icon {
            font-size: 34px;
            margin-bottom: 18px;
        }

        .empty-state h3 {
            font-size: 18px;
            margin-bottom: 10px;
        }

        .empty-state p {
            color: #8493a9;
            font-size: 13px;
            line-height: 1.8;
        }

        .table-footer {
            padding: 20px 28px;
            border-top: 1px solid #edf1f7;
            color: #8493a9;
            font-size: 12px;
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

/* Kolom Aksi */
.action-cell {
    text-align: center;
    vertical-align: middle;
}

.action-buttons {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

/* Tombol Edit */
.edit-button {
    display: inline-block;
    padding: 9px 16px;
    background: #e8f2ff;
    color: #2164ce;
    border-radius: 8px;
    text-decoration: none;
    font-size: 12px;
    font-weight: 600;
    transition: 0.2s ease;
}

.edit-button:hover {
    background: #d5e7ff;
}

.action-buttons form {
    margin: 0;
}

.delete-button {
    padding: 9px 16px;
    background: #fff0f0;
    color: #d64545;
    border: none;
    border-radius: 8px;
    font-family: inherit;
    font-size: 12px;
    font-weight: 600;
    cursor: pointer;
    transition: 0.2s ease;
}

.delete-button:hover {
    background: #ffdede;
}

/* MODAL KONFIRMASI HAPUS REKOMENDASI */
.modal-overlay {
    display: none;
    position: fixed;
    inset: 0;
    z-index: 9999;
    background: rgba(15, 35, 70, 0.55);
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.modal-overlay.is-open {
    display: flex;
}

.modal-box {
    width: 100%;
    max-width: 440px;
    padding: 32px;
    background: white;
    border-radius: 20px;
    text-align: center;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
}

.modal-icon {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 68px;
    height: 68px;
    margin: 0 auto 20px;
    background: #fff0f0;
    color: #dc3545;
    border-radius: 18px;
    font-size: 30px;
}

.modal-box h2 {
    margin-bottom: 12px;
    color: #183b68;
    font-size: 23px;
}

.modal-description {
    margin-bottom: 12px;
    color: #7487a2;
    font-size: 14px;
    line-height: 1.7;
}

.modal-recommendation-title {
    margin-bottom: 24px;
    color: #183b68;
    font-size: 14px;
    font-weight: 600;
    overflow-wrap: anywhere;
}

.modal-actions {
    display: flex;
    gap: 12px;
}

.modal-cancel,
.modal-confirm {
    flex: 1;
    padding: 13px 16px;
    border: none;
    border-radius: 10px;
    font: inherit;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
}

.modal-cancel {
    background: #edf4ff;
    color: #2164ce;
}

.modal-confirm {
    background: #dc3545;
    color: white;
}

.modal-cancel:hover {
    background: #dbeafe;
}

.modal-confirm:hover {
    background: #bb2d3b;
}

@media (max-width: 480px) {
    .modal-box {
        padding: 24px;
    }

    .modal-actions {
        flex-direction: column;
    }
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

            .topbar,
            .card-header {
                flex-wrap: wrap;
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

                <a href="{{ url('/admin/recommendations') }}"
                   class="menu-item active"
                   aria-current="page">
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
                    <h1>Rekomendasi Gaya Hidup</h1>
                    <p>Kelola rekomendasi berdasarkan kategori BMI.</p>
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
                    <div>
                        <h2>Daftar Rekomendasi</h2>
                        <p>
                            Total {{ $recommendations->total() }}
                            rekomendasi terdaftar.
                        </p>
                    </div>

                    <!-- Tombol diaktifkan setelah form tambah dibuat -->
                    <a href="{{ route('admin.recommendations.create') }}"
   class="add-button">
    + Tambah Rekomendasi
</a>
                </div>

                <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>Judul Rekomendasi</th>
                                <th>Jenis</th>
                                <th>Kategori BMI</th>
                                <th>Tanggal Dibuat</th>
                                <th style="text-align:center;">Aksi</th>
                            </tr>
                        </thead>

                        <tbody>
                            @forelse ($recommendations as $recommendation)
                                <tr>
                                    <td>
                                        <div class="recommendation-title">
                                            @if($recommendation->image_path)
                                                <img
                                                    class="recommendation-image"
                                                    src="{{ asset('storage/' . $recommendation->image_path) }}"
                                                    alt=""
                                                >
                                            @endif

                                            {{ $recommendation->title }}
                                        </div>
                                    </td>

                                    <td>{{ $recommendation->type }}</td>

                                    <td>
                                        <span class="category-badge">
                                            {{ $recommendation->category_name }}
                                        </span>
                                    </td>

                                    <td>
                                        {{ $recommendation->created_at
                                            ? \Carbon\Carbon::parse($recommendation->created_at)->format('d/m/Y')
                                            : '-' }}
                                    </td>

                                    
<td class="action-cell">
    <div class="action-buttons">
        <a
            href="{{ route('admin.recommendations.edit', $recommendation->id) }}"
            class="edit-button"
        >
            Edit
        </a>

<form
    method="POST"
    action="{{ route('admin.recommendations.destroy', $recommendation->id) }}"
>
    @csrf
    @method('DELETE')

    <button
        type="button"
        class="delete-button"
        data-recommendation-title="{{ $recommendation->title }}"
        onclick="openDeleteModal(this)"
    >
        Hapus
    </button>
</form>
    </div>
</td>
                                </tr>
                            @empty
                                <tr>
                                    <td colspan="5">
                                        <div class="empty-state">
                                            <div class="empty-icon">♡</div>
                                            <h3>Belum Ada Rekomendasi</h3>
                                            <p>
                                                Data rekomendasi gaya hidup belum ditambahkan.
                                                <br>
                                                Nantinya admin dapat mengelola rekomendasi
                                                Makanan, Aktivitas Fisik, dan Gaya Hidup.
                                            </p>
                                        </div>
                                    </td>
                                </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>

                <div class="table-footer">
                    Menampilkan {{ $recommendations->count() }}
                    dari {{ $recommendations->total() }} rekomendasi
                </div>
            </section>

            
<div class="info-note">
    Rekomendasi Gaya Hidup dikelompokkan menjadi tiga jenis:
    Makanan, Aktivitas Fisik, dan Gaya Hidup.
    Admin dapat menambah, mengedit, dan menghapus rekomendasi
    berdasarkan kategori BMI pengguna.
</div>
        </main>
    </div>

<!-- MODAL KONFIRMASI HAPUS REKOMENDASI -->
<div
    id="deleteModal"
    class="modal-overlay"
    role="dialog"
    aria-modal="true"
    aria-labelledby="deleteModalTitle"
    aria-hidden="true"
>
    <div class="modal-box">

        <div class="modal-icon">
            &#128465;
        </div>

        <h2 id="deleteModalTitle">
            Hapus Rekomendasi?
        </h2>

        <p class="modal-description">
            Apakah kamu yakin ingin menghapus rekomendasi berikut?
            Tindakan ini tidak dapat dibatalkan.
        </p>

        <p
            id="deleteRecommendationTitle"
            class="modal-recommendation-title"
        ></p>

        <div class="modal-actions">

            <button
                type="button"
                class="modal-cancel"
                onclick="closeDeleteModal()"
            >
                Batal
            </button>

            <button
                type="button"
                id="confirmDeleteButton"
                class="modal-confirm"
                onclick="confirmDeleteRecommendation()"
            >
                Ya, Hapus
            </button>

        </div>
    </div>
</div>

<script>
    let selectedDeleteForm = null;
    let previousFocus = null;

    const deleteModal = document.getElementById('deleteModal');

    // Membuka modal saat tombol Hapus diklik
    function openDeleteModal(button) {
        selectedDeleteForm = button.closest('form');
        previousFocus = button;

        document.getElementById('deleteRecommendationTitle')
            .textContent = button.dataset.recommendationTitle;

        deleteModal.classList.add('is-open');
        deleteModal.setAttribute('aria-hidden', 'false');

        document.getElementById('confirmDeleteButton').focus();
    }

    // Menutup modal tanpa menghapus data
    function closeDeleteModal() {
        deleteModal.classList.remove('is-open');
        deleteModal.setAttribute('aria-hidden', 'true');

        selectedDeleteForm = null;

        if (previousFocus) {
            previousFocus.focus();
        }
    }

    // Menghapus rekomendasi setelah dikonfirmasi
    function confirmDeleteRecommendation() {
        if (selectedDeleteForm) {
            const form = selectedDeleteForm;
            selectedDeleteForm = null;

            form.requestSubmit();
        }
    }

    // Menutup modal ketika area luar diklik
    deleteModal.addEventListener('click', function(event) {
        if (event.target === deleteModal) {
            closeDeleteModal();
        }
    });

    // Menutup modal dengan tombol Escape
    document.addEventListener('keydown', function(event) {
        if (
            event.key === 'Escape' &&
            deleteModal.classList.contains('is-open')
        ) {
            closeDeleteModal();
        }
    });
</script>
</body>
</html>
