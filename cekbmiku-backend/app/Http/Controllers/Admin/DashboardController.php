<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        // Menghitung total artikel kesehatan
        $totalArtikel = DB::table('articles')->count();

        // Menghitung total rekomendasi gaya hidup
        $totalRekomendasi = DB::table('lifestyle_suggestions')->count();

        // Menghitung total pengguna aplikasi (selain admin)
        $totalPengguna = DB::table('users')
            ->where('role', 'user')
            ->count();

        // Menghitung jumlah kategori BMI
        $totalKategori = DB::table('bmi_categories')->count();

        // Mengirim data ke tampilan Dashboard Admin
        return view('admin.dashboard', compact(
            'totalArtikel',
            'totalRekomendasi',
            'totalPengguna',
            'totalKategori'
        ));
    }
}
