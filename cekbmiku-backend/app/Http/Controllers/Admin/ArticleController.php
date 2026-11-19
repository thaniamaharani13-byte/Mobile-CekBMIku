<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Services\ArticleNotificationService;
use Illuminate\Support\Facades\Auth;

class ArticleController extends Controller
{
    // Menampilkan daftar artikel
    
public function index()
{
    if (!Auth::check()) {
        return redirect()->route('admin.login');
    }

    abort_unless(Auth::user()->role === 'admin', 403);

    $articles = DB::table('articles')
        ->join(
            'bmi_categories',
            'articles.category_id',
            '=',
            'bmi_categories.id'
        )
        ->select(
            'articles.id',
            'articles.title',
            'articles.image_path',
            'articles.topic_category',
            'articles.status',
            'articles.created_at',
            'articles.published_at',
            'bmi_categories.category_name'
        )
        ->orderByDesc('articles.id')
        ->paginate(10);

    return view('admin.articles.index', compact('articles'));
}

    // Menampilkan formulir Tambah Artikel
    public function create()
    {
        	if (!Auth::check()) {
            return redirect()->route('admin.login');
        }

        abort_unless(Auth::user()->role === 'admin', 403);

        $categories = DB::table('bmi_categories')
            ->orderBy('id')
            ->get();

        return view('admin.articles.create', compact('categories'));
    }

    // Menyimpan artikel baru sebagai draft
    
public function store(Request $request)
{
    if (!Auth::check()) {
        return redirect()->route('admin.login');
    }

    abort_unless(Auth::user()->role === 'admin', 403);

    // Validasi data dari formulir
    $validated = $request->validate([
        'title' => ['required', 'string', 'max:200'],
        'category_id' => [
            'required',
            'integer',
            'exists:bmi_categories,id'
        ],
        'topic_category' => [
            'required',
            'in:Nutrisi,Olahraga,BMI,Kesehatan,Penyakit'
        ],
        'content' => ['required', 'string'],
        'image' => [
            'nullable',
            'image',
            'mimes:jpg,jpeg,png,webp',
            'max:2048'
        ],
'source_url' => [
    'nullable',
    'url:http,https',
    'max:2048'
],
    ]);

    // Menyimpan gambar jika admin mengunggahnya
    $imagePath = null;

    if ($request->hasFile('image')) {
        $imagePath = $request->file('image')
            ->store('articles', 'public');
    }

    // Menyimpan artikel ke database MySQL
    DB::table('articles')->insert([
        'title' => $validated['title'],
        'category_id' => $validated['category_id'],
        'topic_category' => $validated['topic_category'],
        'content' => $validated['content'],
        'source_url' => $validated['source_url'] ?? null,
        'image_path' => $imagePath,
        'status' => 'draft',
        'published_at' => null,
        'created_at' => now(),
        'updated_at' => now(),
    ]);

    // Kembali ke daftar artikel
    return redirect()
        ->route('admin.articles.index')
        ->with('success', 'Artikel draft berhasil ditambahkan.');
}

    // Menampilkan formulir Edit Artikel
    public function edit(int $id)
    {
        // Memastikan pengguna sudah login
        	if (!Auth::check()) {
            return redirect()->route('admin.login');
        }

        // Hanya administrator yang boleh mengakses
        abort_unless(Auth::user()->role === 'admin', 403);

        // Mengambil artikel berdasarkan ID
        $article = DB::table('articles')
            ->where('id', $id)
            ->first();

        // Menampilkan 404 jika artikel tidak ditemukan
        abort_if(!$article, 404);

        // Mengambil kategori BMI untuk pilihan dropdown
        $categories = DB::table('bmi_categories')
            ->orderBy('id')
            ->get();

        // Menampilkan halaman Edit Artikel
        return view('admin.articles.edit', compact(
            'article',
            'categories'
        ));
    }

    // Menyimpan perubahan Artikel Kesehatan
    public function update(Request $request, int $id)
    {
        // Memeriksa login administrator
        	if (!Auth::check()) {
            return redirect()->route('admin.login');
        }

        abort_unless(Auth::user()->role === 'admin', 403);

        // Mengambil artikel yang akan diedit
        $article = DB::table('articles')
            ->where('id', $id)
            ->first();

        abort_if(!$article, 404);

        // Memvalidasi input formulir
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:200'],
            
'category_id' => [
    'required',
    'integer',
    'exists:bmi_categories,id'
],
'topic_category' => [
    'required',
    'in:Nutrisi,Olahraga,BMI,Kesehatan,Penyakit'
],
'content' => ['required', 'string'],
            'image' => [
                'nullable',
                'image',
                'mimes:jpg,jpeg,png,webp',
                'max:2048'
            ],
'source_url' => [
    'nullable',
    'url:http,https',
    'max:2048'
],
        ]);

        // Mempertahankan gambar lama jika tidak diganti
        $imagePath = $article->image_path;

        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')
                ->store('articles', 'public');
        }

        // Memperbarui artikel dalam database
        DB::table('articles')
            ->where('id', $id)
            ->update([
                
'title' => $validated['title'],
'category_id' => $validated['category_id'],
'topic_category' => $validated['topic_category'],
'content' => $validated['content'],
'source_url' => $validated['source_url'] ?? null,
                'image_path' => $imagePath,
                'updated_at' => now(),
            ]);

        // Menghapus gambar lama setelah berhasil diganti
        if (
            $request->hasFile('image') &&
            $article->image_path
        ) {
            \Illuminate\Support\Facades\Storage::disk('public')
                ->delete($article->image_path);
        }

        return redirect()
            ->route('admin.articles.index')
            ->with('success', 'Artikel berhasil diperbarui.');
    }

    // Menghapus Artikel Kesehatan
    	public function destroy(int $id)
    {
        // Memastikan pengguna sudah login
        	if (!Auth::check()) {
            return redirect()->route('admin.login');
        }

        // Hanya administrator yang boleh menghapus
        abort_unless(Auth::user()->role === 'admin', 403);

        // Mencari artikel berdasarkan ID
        $article = DB::table('articles')
            ->where('id', $id)
            ->first();

        // Jika artikel tidak ditemukan
        abort_if(!$article, 404);

        // Menghapus artikel dari database
        DB::table('articles')
            ->where('id', $id)
            ->delete();

        // Menghapus gambar artikel jika tersedia
        if ($article->image_path) {
            \Illuminate\Support\Facades\Storage::disk('public')
                ->delete($article->image_path);
        }

        // Kembali ke halaman Daftar Artikel
        return redirect()
            ->route('admin.articles.index')
            ->with('success', 'Artikel berhasil dihapus.');
    }

    // Mempublikasikan Artikel Kesehatan
    
    // Mempublikasikan artikel dan membuat notifikasi
    public function publish(
    int $id,
    ArticleNotificationService $notificationService
) {
        // Memastikan pengguna sudah login
        	if (!Auth::check()) {
            return redirect()->route('admin.login');
        }

        // Hanya administrator yang boleh publikasi
        abort_unless(Auth::user()->role === 'admin', 403);

        // Mengambil artikel berdasarkan ID
        $article = DB::table('articles')
            ->where('id', $id)
            ->first();

        abort_if(!$article, 404);

        // Mencegah publikasi berulang
        if ($article->status === 'published') {
            return redirect()
                ->route('admin.articles.index')
                ->with('success', 'Artikel sudah dipublikasikan.');
        }

        // Publikasi dan penyimpanan notifikasi dalam satu transaksi
        DB::transaction(function () use ($id, $notificationService) {

            $updated = DB::table('articles')
                ->where('id', $id)
                ->where('status', 'draft')
                ->update([
                    'status' => 'published',
                    'published_at' => now(),
                    'updated_at' => now(),
                ]);

            // Membuat notifikasi hanya jika artikel baru dipublikasikan
            if ($updated === 1) {
                $notificationService
                    ->createNotificationsForArticle((int) $id);
            }
        });

        return redirect()
            ->route('admin.articles.index')
            ->with('success', 'Artikel berhasil dipublikasikan.');
    }
}
