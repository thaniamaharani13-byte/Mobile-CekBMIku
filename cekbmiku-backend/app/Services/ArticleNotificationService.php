<?php

namespace App\Services;

use Illuminate\Support\Facades\DB;

class ArticleNotificationService
{
    // Mencari pengguna berdasarkan kategori BMI terbaru
    public function getEligibleUserIds(int $categoryId)
    {
        return DB::table('bmi_results as bmi')
            ->join('users', 'users.id', '=', 'bmi.user_id')
            ->where('users.role', 'user')
            ->where('bmi.category_id', $categoryId)

            // Pastikan hasil BMI ini merupakan pemeriksaan terbaru
            ->whereNotExists(function ($query) {
                $query->selectRaw('1')
                    ->from('bmi_results as newer')
                    ->whereColumn('newer.user_id', 'bmi.user_id')
                    ->where(function ($q) {
                        $q->whereColumn(
                            'newer.checked_at',
                            '>',
                            'bmi.checked_at'
                        )
                        ->orWhere(function ($sameTime) {
                            $sameTime->whereColumn(
                                'newer.checked_at',
                                '=',
                                'bmi.checked_at'
                            )
                            ->whereColumn(
                                'newer.id',
                                '>',
                                'bmi.id'
                            );
                        });
                    });
            })
            ->pluck('bmi.user_id');
    }

    // Membuat notifikasi untuk artikel yang sudah dipublikasikan
    public function createNotificationsForArticle(int $articleId): int
    {
        // Ambil informasi artikel
        $article = DB::table('articles')
            ->where('id', $articleId)
            ->first();

        // Hanya artikel published yang boleh menghasilkan notifikasi
        if (!$article || $article->status !== 'published') {
            throw new \RuntimeException(
                'Artikel belum dipublikasikan atau tidak ditemukan.'
            );
        }

        // Cari penerima berdasarkan kategori BMI terbaru
        $userIds = $this->getEligibleUserIds(
            (int) $article->category_id
        );

        $totalNotifikasi = 0;

        // Proses penerima secara bertahap
        foreach ($userIds->chunk(100) as $group) {
            $waktu = now();

            $data = $group->map(function ($userId) use ($article, $waktu) {
                return [
                    'user_id' => $userId,
                    'article_id' => $article->id,
                    'notification_type' => 'article',
                    'title' => 'Artikel Kesehatan Baru',
                    'message' => 'Artikel "' . $article->title .
                        '" tersedia untuk kategori BMI kamu.',
                    'is_read' => false,
                    'read_at' => null,
                    'created_at' => $waktu,
                    'updated_at' => $waktu,
                ];
            })->all();

            // Menghindari notifikasi ganda untuk artikel yang sama
            $totalNotifikasi += DB::table('notifications')
                ->insertOrIgnore($data);
        }

        return $totalNotifikasi;
    }
}
