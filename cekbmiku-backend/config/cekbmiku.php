<?php

return [
    // Publikasi artikel dinonaktifkan selama pengembangan
    'article_publishing_enabled' => env(
        'CEKBMIKU_ARTICLE_PUBLISHING_ENABLED',
        false
    ),
];
