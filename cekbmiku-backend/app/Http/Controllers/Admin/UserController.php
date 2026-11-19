<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class UserController extends Controller
{
    public function index()
    {
        $users = DB::table('users')
            ->where('users.role', '!=', 'admin')
            ->select(
                'users.id',
                'users.name',
                'users.email',
                'users.created_at'
            )
            ->selectSub(function ($query) {
                $query->from('bmi_results')
                    ->selectRaw('COUNT(*)')
                    ->whereColumn('bmi_results.user_id', 'users.id');
            }, 'total_checks')
            ->selectSub(function ($query) {
                $query->from('bmi_results')
                    ->selectRaw('MAX(checked_at)')
                    ->whereColumn('bmi_results.user_id', 'users.id');
            }, 'last_check')
            ->orderBy('users.name')
            ->get();

        return view('admin.users.index', compact('users'));
    }

public function show(int $id)
{
    // Mengambil pengguna yang bukan admin
    $user = DB::table('users')
        ->where('id', $id)
        ->where('role', '!=', 'admin')
        ->select('id', 'name', 'email')
        ->first();

    // Menampilkan 404 jika pengguna tidak ditemukan
    abort_unless($user, 404);

    // Mengambil riwayat pemeriksaan BMI terbaru
    $histories = DB::table('bmi_results')
        ->where('user_id', $id)
        ->select(
            'id',
            'checked_at'
        )
        ->orderByDesc('checked_at')
        ->orderByDesc('id')
        ->get();

    return view('admin.users.show', compact('user', 'histories'));
}
}

