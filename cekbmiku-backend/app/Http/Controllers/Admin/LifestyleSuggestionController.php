<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class LifestyleSuggestionController extends Controller
{
    // Menampilkan daftar Rekomendasi Gaya Hidup
    public function index()
    {
        // Memastikan admin sudah login
        if (!Auth::check()) {
            return redirect()->route('admin.login');
        }

        // Hanya administrator yang boleh mengakses
        abort_unless(Auth::user()->role === 'admin', 403);

        // Mengambil rekomendasi dan kategori BMI dari database
        $recommendations = DB::table('lifestyle_suggestions')
            ->join(
                'bmi_categories',
                'lifestyle_suggestions.category_id',
                '=',
                'bmi_categories.id'
            )
            ->select(
                'lifestyle_suggestions.id',
                'lifestyle_suggestions.title',
                'lifestyle_suggestions.content',
                'lifestyle_suggestions.type',
                'lifestyle_suggestions.image_path',
                'lifestyle_suggestions.created_at',
                'bmi_categories.category_name'
            )
            ->orderByDesc('lifestyle_suggestions.id')
            ->paginate(10);

        // Menampilkan halaman daftar rekomendasi
        return view(
            'admin.recommendations.index',
            compact('recommendations')
        );
    }

    // Menampilkan formulir Tambah Rekomendasi
    public function create()
    {
        // Memastikan administrator sudah login
        if (!Auth::check()) {
            return redirect()->route('admin.login');
        }

        // Membatasi akses hanya untuk administrator
        abort_unless(Auth::user()->role === 'admin', 403);

        // Mengambil daftar kategori BMI dari database
        $categories = DB::table('bmi_categories')
            ->orderBy('id')
            ->get();

        // Menampilkan formulir Tambah Rekomendasi
        return view(
            'admin.recommendations.create',
            compact('categories')
        );
    }

    // Menyimpan Rekomendasi Gaya Hidup
    public function store(Request $request)
    {
        // Memastikan admin sudah login
        if (!Auth::check()) {
            return redirect()->route('admin.login');
        }

        // Hanya administrator yang boleh menyimpan
        abort_unless(Auth::user()->role === 'admin', 403);

        // Validasi data formulir
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:200'],
            'type' => [
                'required',
                Rule::in([
                    'Makanan',
                    'Aktivitas Fisik',
                    'Gaya Hidup'
                ])
            ],
            'category_id' => [
                'required',
                'integer',
                'exists:bmi_categories,id'
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

        // Menyimpan gambar jika ada
        $imagePath = null;

        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')
                ->store('recommendations', 'public');
        }

        // Menyimpan rekomendasi ke database MySQL
        DB::table('lifestyle_suggestions')->insert([
            'title' => $validated['title'],
            'type' => $validated['type'],
            'category_id' => $validated['category_id'],
            'content' => $validated['content'],
            'source_url' => $validated['source_url'] ?? null,
            'image_path' => $imagePath,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return redirect()
            ->route('admin.recommendations.index')
            ->with('success', 'Rekomendasi berhasil ditambahkan.');
    }

    // Menampilkan formulir Edit Rekomendasi
    public function edit(int $id)
    {
        // Memastikan administrator sudah login
        if (!Auth::check()) {
            return redirect()->route('admin.login');
        }

        // Hanya administrator yang boleh mengakses
        abort_unless(Auth::user()->role === 'admin', 403);

        // Mengambil rekomendasi berdasarkan ID
        $recommendation = DB::table('lifestyle_suggestions')
            ->where('id', $id)
            ->first();

        // Menampilkan 404 jika rekomendasi tidak ditemukan
        abort_if(!$recommendation, 404);

        // Mengambil daftar kategori BMI
        $categories = DB::table('bmi_categories')
            ->orderBy('id')
            ->get();

        // Menampilkan formulir Edit Rekomendasi
        return view(
            'admin.recommendations.edit',
            compact('recommendation', 'categories')
        );
    }

    // Memperbarui Rekomendasi Gaya Hidup
    public function update(Request $request, int $id)
    {
        // Memastikan administrator sudah login
        if (!Auth::check()) {
            return redirect()->route('admin.login');
        }

        // Hanya administrator yang boleh mengubah data
        abort_unless(Auth::user()->role === 'admin', 403);

        // Mengambil rekomendasi berdasarkan ID
        $recommendation = DB::table('lifestyle_suggestions')
            ->where('id', $id)
            ->first();

        abort_if(!$recommendation, 404);

        // Memvalidasi data formulir
        $validated = $request->validate([
            'title' => ['required', 'string', 'max:200'],
            'type' => [
                'required',
                Rule::in([
                    'Makanan',
                    'Aktivitas Fisik',
                    'Gaya Hidup'
                ])
            ],
            'category_id' => [
                'required',
                'integer',
                'exists:bmi_categories,id'
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
        $imagePath = $recommendation->image_path;

        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')
                ->store('recommendations', 'public');
        }

        try {
            // Memperbarui data berdasarkan ID
            DB::table('lifestyle_suggestions')
                ->where('id', $id)
                ->update([
                    'title' => $validated['title'],
                    'type' => $validated['type'],
                    'category_id' => $validated['category_id'],
                    'content' => $validated['content'],
                    'source_url' => $validated['source_url'] ?? null,
                    'image_path' => $imagePath,
                    'updated_at' => now(),
                ]);
        } catch (\Throwable $e) {
            // Hapus gambar baru jika update database gagal
            if ($request->hasFile('image') && $imagePath) {
                \Illuminate\Support\Facades\Storage::disk('public')
                    ->delete($imagePath);
            }

            throw $e;
        }

        // Menghapus gambar lama jika berhasil diganti
        if (
            $request->hasFile('image') &&
            $recommendation->image_path
        ) {
            \Illuminate\Support\Facades\Storage::disk('public')
                ->delete($recommendation->image_path);
        }

        return redirect()
            ->route('admin.recommendations.index')
            ->with('success', 'Rekomendasi berhasil diperbarui.');
    }

    // Menghapus Rekomendasi Gaya Hidup
    public function destroy(int $id)
    {
        // Memastikan administrator sudah login
        if (!Auth::check()) {
            return redirect()->route('admin.login');
        }

        // Hanya administrator yang boleh menghapus
        abort_unless(Auth::user()->role === 'admin', 403);

        // Mencari rekomendasi berdasarkan ID
        $recommendation = DB::table('lifestyle_suggestions')
            ->where('id', $id)
            ->first();

        // Menampilkan 404 jika data tidak ditemukan
        abort_if(!$recommendation, 404);

        // Menghapus rekomendasi dari database
        DB::table('lifestyle_suggestions')
            ->where('id', $id)
            ->delete();

        // Menghapus gambar jika tersedia
        if ($recommendation->image_path) {
            \Illuminate\Support\Facades\Storage::disk('public')
                ->delete($recommendation->image_path);
        }

        return redirect()
            ->route('admin.recommendations.index')
            ->with('success', 'Rekomendasi berhasil dihapus.');
    }
}
