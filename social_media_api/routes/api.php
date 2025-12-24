<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PostController;

// Route Public (Tidak butuh token)
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']); // <-- Ini yang dipanggil Flutter

// Route Protected (Butuh token Bearer dari Flutter)
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/posts', [PostController::class, 'index']); // Ambil post
    Route::post('/posts', [PostController::class, 'store']); // Upload post
    Route::delete('/posts/{id}', [PostController::class, 'destroy']);
    
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    Route::post('/user/update', [AuthController::class, 'updateProfile']); 
    
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

});