<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\AdminAuthController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\ArticleController;

// Halaman awal Laravel
Route::get('/', function () {
    return view('welcome');
});

// Menampilkan halaman Login Admin
Route::get('/admin/login', [AdminAuthController::class, 'showLogin'])
    ->name('admin.login');

// Memproses Login Admin
Route::post('/admin/login', [AdminAuthController::class, 'login'])
    ->name('admin.login.submit');

// Memproses Logout Admin
Route::post('/admin/logout', [AdminAuthController::class, 'logout'])
    ->middleware('auth')
    ->name('admin.logout');

Route::get('/admin/dashboard', function (DashboardController $controller) {

    // Pengguna yang belum login diarahkan ke Login Admin
    if (!auth()->check()) {
        return redirect()->route('admin.login');
    }

    // Hanya akun dengan role admin yang boleh mengakses
    abort_unless(auth()->user()->role === 'admin', 403);

    // Menampilkan dashboard dengan data dari MySQL
    return $controller->index();

})->name('admin.dashboard');

 // Halaman Daftar Artikel Kesehatan
Route::get('/admin/articles', function (ArticleController $controller) {

    // Pengguna harus login terlebih dahulu
    if (!auth()->check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh mengakses
    abort_unless(auth()->user()->role === 'admin', 403);

    // Menampilkan daftar artikel dari database
    return $controller->index();

})->name('admin.articles.index');

 // Menampilkan formulir Tambah Artikel Kesehatan
Route::get('/admin/articles/create', function (ArticleController $controller) {

    // Pengguna harus login
    if (!auth()->check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh mengakses
    abort_unless(auth()->user()->role === 'admin', 403);

    // Menampilkan formulir Tambah Artikel
    return $controller->create();

})->name('admin.articles.create');

 // Menyimpan Artikel Kesehatan sebagai Draft
Route::post('/admin/articles', function (
    \Illuminate\Http\Request $request,
    ArticleController $controller
) {
    // Pengguna harus login
    if (!auth()->check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh menyimpan artikel
    abort_unless(auth()->user()->role === 'admin', 403);

    // Memproses penyimpanan artikel
    return $controller->store($request);

})->name('admin.articles.store');

 // Menampilkan formulir Edit Artikel
Route::get('/admin/articles/{id}/edit', function (
    $id,
    ArticleController $controller
) {
    // Pengguna harus login
    if (!auth()->check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh mengakses
    abort_unless(auth()->user()->role === 'admin', 403);

    return $controller->edit($id);

})->name('admin.articles.edit');

 // Memproses perubahan Artikel Kesehatan
Route::put('/admin/articles/{id}', function (
    \Illuminate\Http\Request $request,
    $id,
    ArticleController $controller
) {
    // Pengguna harus login
    if (!auth()->check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh mengedit
    abort_unless(auth()->user()->role === 'admin', 403);

    return $controller->update($request, $id);

})->name('admin.articles.update');

 // Menghapus Artikel Kesehatan
Route::delete('/admin/articles/{id}', function (
    $id,
    ArticleController $controller
) {
    // Pengguna harus login
    if (!auth()->check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh menghapus
    abort_unless(auth()->user()->role === 'admin', 403);

    return $controller->destroy($id);

})->name('admin.articles.destroy');

Route::post('/admin/articles/{id}/publish', function ($id) {

    // Memastikan admin sudah login
    if (!auth()->check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh publikasi
    abort_unless(auth()->user()->role === 'admin', 403);

    // Publikasi dinonaktifkan selama menggunakan data dummy
    abort_unless(
        config('cekbmiku.article_publishing_enabled', false),
        403,
        'Publikasi artikel belum diaktifkan.'
    );

    return app(\App\Http\Controllers\Admin\ArticleController::class)
        ->publish(
            $id,
            app(\App\Services\ArticleNotificationService::class)
        );

})->name('admin.articles.publish');

 // Menampilkan daftar Rekomendasi Gaya Hidup
Route::get('/admin/recommendations', function () {

    // Memastikan administrator sudah login
    if (!\Illuminate\Support\Facades\Auth::check()) {
        return redirect()->route('admin.login');
    }

    // Membatasi akses hanya untuk admin
    abort_unless(
        \Illuminate\Support\Facades\Auth::user()->role === 'admin',
        403
    );

    // Menampilkan halaman daftar rekomendasi
    return app(
        \App\Http\Controllers\Admin\LifestyleSuggestionController::class
    )->index();

})->name('admin.recommendations.index');

 // Menampilkan formulir Tambah Rekomendasi
Route::get('/admin/recommendations/create', function () {

    // Memastikan administrator sudah login
    if (!\Illuminate\Support\Facades\Auth::check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh mengakses
    abort_unless(
        \Illuminate\Support\Facades\Auth::user()->role === 'admin',
        403
    );

    // Memanggil fungsi create pada controller
    return app(
        \App\Http\Controllers\Admin\LifestyleSuggestionController::class
    )->create();

})->name('admin.recommendations.create');

 // Menyimpan Rekomendasi Gaya Hidup
Route::post('/admin/recommendations', function (
    \Illuminate\Http\Request $request
) {
    // Memastikan administrator sudah login
    if (!\Illuminate\Support\Facades\Auth::check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh menyimpan
    abort_unless(
        \Illuminate\Support\Facades\Auth::user()->role === 'admin',
        403
    );

    return app(
        \App\Http\Controllers\Admin\LifestyleSuggestionController::class
    )->store($request);

})->name('admin.recommendations.store');

 // Menampilkan formulir Edit Rekomendasi
Route::get('/admin/recommendations/{id}/edit', function ($id) {

    // Memastikan administrator sudah login
    if (!\Illuminate\Support\Facades\Auth::check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh mengakses
    abort_unless(
        \Illuminate\Support\Facades\Auth::user()->role === 'admin',
        403
    );

    // Memanggil fungsi edit pada controller
    return app(
        \App\Http\Controllers\Admin\LifestyleSuggestionController::class
    )->edit((int) $id);

})->whereNumber('id')->name('admin.recommendations.edit');

 // Memperbarui Rekomendasi Gaya Hidup
Route::put('/admin/recommendations/{id}', function (
    \Illuminate\Http\Request $request,
    $id
) {
    // Memastikan administrator sudah login
    if (!\Illuminate\Support\Facades\Auth::check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh mengubah data
    abort_unless(
        \Illuminate\Support\Facades\Auth::user()->role === 'admin',
        403
    );

    return app(
        \App\Http\Controllers\Admin\LifestyleSuggestionController::class
    )->update($request, (int) $id);

})->whereNumber('id')->name('admin.recommendations.update');

 // Menghapus Rekomendasi Gaya Hidup
Route::delete('/admin/recommendations/{id}', function ($id) {

    // Memastikan administrator sudah login
    if (!\Illuminate\Support\Facades\Auth::check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh menghapus
    abort_unless(
        \Illuminate\Support\Facades\Auth::user()->role === 'admin',
        403
    );

    // Memanggil fungsi destroy pada controller
    return app(
        \App\Http\Controllers\Admin\LifestyleSuggestionController::class
    )->destroy((int) $id);

})->whereNumber('id')->name('admin.recommendations.destroy');

 // Menampilkan Daftar Pengguna dan Ringkasan Pemeriksaan BMI
Route::get('/admin/users', function (
    \App\Http\Controllers\Admin\UserController $controller
) {
    // Pengguna harus login terlebih dahulu
    if (!auth()->check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh melihat data pengguna
    abort_unless(auth()->user()->role === 'admin', 403);

    // Menampilkan daftar pengguna dari database MySQL
    return $controller->index();

})->name('admin.users.index');

 // Menampilkan Riwayat Pemeriksaan BMI Pengguna
Route::get('/admin/users/{id}', function (
    $id,
    \App\Http\Controllers\Admin\UserController $controller
) {
    // Pengguna harus login terlebih dahulu
    if (!auth()->check()) {
        return redirect()->route('admin.login');
    }

    // Hanya administrator yang boleh melihat riwayat
    abort_unless(auth()->user()->role === 'admin', 403);

    // Menampilkan riwayat pemeriksaan pengguna
    return $controller->show((int) $id);

})->whereNumber('id')->name('admin.users.show');

