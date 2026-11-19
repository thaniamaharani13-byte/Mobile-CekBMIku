
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Admin | CekBMIku</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: linear-gradient(
                135deg,
                #e7f1ff 0%,
                #f5f9ff 55%,
                #e4f3ff 100%
            );
        }

        /* KARTU LOGIN UTAMA */
        .login-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            width: 960px;
            max-width: 100%;
            min-height: 540px;
            background: #ffffff;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 20px 55px rgba(30, 72, 140, 0.12);
        }

        /* PANEL KIRI - BRANDING */
        .brand-section {
            background: linear-gradient(
                145deg,
                #1746a2 0%,
                #2879df 52%,
                #59c2f5 100%
            );
            color: #ffffff;
            padding: 48px 52px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        /* DEKORASI GRADASI */
        .brand-section::before {
            content: "";
            position: absolute;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
            top: -135px;
            right: -130px;
            pointer-events: none;
        }

        .brand-section::after {
            content: "";
            position: absolute;
            width: 230px;
            height: 230px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.07);
            bottom: -120px;
            left: -100px;
            pointer-events: none;
        }

        .brand-content {
            position: relative;
            z-index: 1;
        }

        /* LOGO CEKBMIKU */
        .logo-box {
            width: 210px;
            height: 125px;
            display: flex;
            align-items: center;
            justify-content: flex-start;
            margin-bottom: 22px;
        }

        .logo-box img {
            display: block;
            width: 100%;
            height: 100%;
            object-fit: contain;
            object-position: left center;
        }

        .brand-label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 2.5px;
            margin-bottom: 20px;
            color: rgba(255, 255, 255, 0.92);
        }

        .brand-section h1 {
            font-size: 35px;
            line-height: 1.3;
            font-weight: 700;
            letter-spacing: -0.5px;
            margin-bottom: 20px;
        }

        .brand-section p {
            font-size: 15px;
            line-height: 1.85;
            color: rgba(255, 255, 255, 0.94);
            max-width: 390px;
        }

        /* PANEL KANAN - FORM LOGIN */
        .form-section {
            padding: 55px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-section h2 {
            font-size: 29px;
            line-height: 1.3;
            font-weight: 700;
            color: #183b68;
            margin-bottom: 12px;
        }

        .subtitle {
            font-size: 14px;
            color: #7a899d;
            line-height: 1.7;
            margin-bottom: 34px;
        }

        .form-group {
            margin-bottom: 23px;
        }

        .form-group label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #334f70;
            margin-bottom: 10px;
        }

        .form-group input {
            width: 100%;
            padding: 15px 16px;
            border: 1px solid #dbe5f0;
            border-radius: 11px;
            background: #ffffff;
            color: #243b53;
            font-size: 14px;
            font-family: inherit;
            outline: none;
            transition: all 0.2s ease;
        }

        .form-group input::placeholder {
            color: #9aa9ba;
        }

        .form-group input:focus {
            border-color: #3488ed;
            box-shadow: 0 0 0 4px rgba(52, 136, 237, 0.11);
        }

        /* TOMBOL LOGIN */
        .login-button {
            display: block;
            width: 100%;
            padding: 16px;
            margin-top: 8px;
            background: linear-gradient(
                100deg,
                #2164ce,
                #349ded
            );
            color: #ffffff;
            font-family: inherit;
            font-size: 15px;
            font-weight: 700;
            border: none;
            border-radius: 11px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .login-button:hover {
            filter: brightness(1.07);
            transform: translateY(-1px);
            box-shadow: 0 6px 16px rgba(33, 100, 206, 0.2);
        }

        .login-button:focus-visible {
            outline: 3px solid #93c5fd;
            outline-offset: 3px;
        }

        .footer-text {
            text-align: center;
            font-size: 12px;
            color: #9caabd;
            margin-top: 29px;
            line-height: 1.6;
        }

        /* RESPONSIVE - TABLET */
        @media (max-width: 850px) {
            .brand-section {
                padding: 40px;
            }

            .brand-section h1 {
                font-size: 30px;
            }

            .form-section {
                padding: 42px 35px;
            }

            .form-section h2 {
                font-size: 26px;
            }
        }

        /* RESPONSIVE - MOBILE */
        @media (max-width: 650px) {
            body {
                padding: 16px;
            }

            .login-container {
                grid-template-columns: 1fr;
                border-radius: 20px;
            }

            .brand-section {
                padding: 32px;
            }

            .logo-box {
                width: 165px;
                height: 100px;
                margin-bottom: 15px;
            }

            .brand-label {
                margin-bottom: 14px;
            }

            .brand-section h1 {
                font-size: 26px;
                margin-bottom: 14px;
            }

            .brand-section p {
                font-size: 14px;
            }

            .form-section {
                padding: 38px 28px;
            }

            .form-section h2 {
                font-size: 25px;
            }

            .subtitle {
                margin-bottom: 28px;
            }
        }
        .error-message {
    color: #dc3545;
    font-size: 13px;
    margin-top: 8px;
    line-height: 1.5;
}
    </style>
</head>

<body>

    <main class="login-container">

        <!-- PANEL BRANDING KIRI -->
        <section class="brand-section">
            <div class="brand-content">

                <!-- LOGO APLIKASI -->
                <div class="logo-box">
                    <img
                        src="{{ asset('images/logo_footer.png') }}"
                        alt="Logo CekBMIku"
                    >
                </div>

                <span class="brand-label">
                    ADMIN PANEL
                </span>

                <h1>
                    Kelola Kesehatan dengan Lebih Mudah.
                </h1>

                <p>
                    Kelola artikel kesehatan dan rekomendasi
                    gaya hidup CekBMIku melalui satu
                    panel administrator.
                </p>

            </div>
        </section>

        <!-- FORM LOGIN KANAN -->
        <section class="form-section">

            <h2>Masuk ke Admin CekBMIku</h2>

            <p class="subtitle">
                Silakan masuk menggunakan akun administrator
                untuk mengakses dashboard.
            </p>

            <!-- Form tampilan, autentikasi ditambahkan berikutnya -->
            <form method="POST" action="{{ route('admin.login.submit') }}">
    @csrf

                <div class="form-group">
    <label for="email">Email Admin</label>

    <input
        type="email"
        id="email"
        name="email"
        value="{{ old('email') }}"
        placeholder="Masukkan email admin"
        autocomplete="username"
        required
    >

    @error('email')
        <p class="error-message">{{ $message }}</p>
    @enderror
</div>

                <div class="form-group">
                    <label for="password">Password</label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Masukkan password"
                        autocomplete="current-password"
                        required
                    >
                </div>

                <button
    type="submit"
    class="login-button"
>
    Masuk ke Dashboard
</button>

            </form>

            <p class="footer-text">
                © 2026 CekBMIku. Akses khusus administrator.
            </p>

        </section>

    </main>

</body>
</html>
