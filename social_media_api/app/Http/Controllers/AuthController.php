<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    // Fungsi Register (Opsional, buat test user)
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'User created successfully',
            'data' => $user,
            'token' => $token
        ]);
    }

    // Fungsi Login (Yang dipanggil Flutter)
    public function login(Request $request)
    {
        // Validasi input
        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json([
                'message' => 'Email atau password salah'
            ], 401);
        }

        $user = User::where('email', $request['email'])->firstOrFail();

        // Hapus token lama jika mau (opsional, agar 1 device login)
        // $user->tokens()->delete();

        // Buat token baru
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil',
            'token' => $token, // Ini token yang diambil Flutter
            'user' => $user
        ], 200);
    }

    // Fungsi Update Profile
    // Fungsi Update Profile (Name & Email)
    public function updateProfile(Request $request)
    {
        $user = $request->user(); // Ambil user yang sedang login

        // Validasi input
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            // Validasi Email: Wajib, Format Email, Unik (kecuali punya sendiri)
            'email' => 'required|string|email|max:255|unique:users,email,' . $user->id,
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        // Update data di database
        $user->update([
            'name' => $request->name,
            'email' => $request->email, // Simpan email baru
        ]);

        return response()->json([
            'message' => 'Profile updated successfully',
            'user' => $user,
        ]);
    }

    

    // Fungsi Logout
    public function logout()
    {
        // Menghapus token user yang sedang login
        auth()->user()->tokens()->delete();

        return response()->json([
            'message' => 'Logout berhasil'
        ]);
    }
}