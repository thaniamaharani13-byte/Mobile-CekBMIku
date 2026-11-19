<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AdminAuthController extends Controller
{
    // Menampilkan halaman login admin
    public function showLogin()
    {
        return view('admin.login');
    }

    // Memproses login admin
    public function login(Request $request)
    {
        $credentials = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        // Hanya akun dengan role admin yang boleh login
        $credentials['role'] = 'admin';

        if (Auth::attempt($credentials)) {
            $request->session()->regenerate();

            return redirect('/admin/dashboard');
        }

        return back()
            ->withErrors([
                'email' => 'Email atau password admin tidak sesuai.',
            ])
            ->onlyInput('email');
    }

    // Memproses logout admin
    public function logout(Request $request)
    {
        Auth::logout();

        $request->session()->invalidate();
        $request->session()->regenerateToken();

        return redirect('/admin/login');
    }
}
