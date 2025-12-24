<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Post;
use Illuminate\Support\Facades\Storage;

class PostController extends Controller
{
    // API: Ambil semua postingan (untuk Home Page)
    public function index()
    {
        $posts = Post::with('user')->latest()->get(); // Ambil post terbaru beserta user-nya
        return response()->json([
            'message' => 'List of posts',
            'data' => $posts
        ]);
    }

    // API: Buat postingan baru (untuk Create Post Page)
    public function store(Request $request)
    {
        $request->validate([
            'caption' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
        ]);

        $imagePath = null;
        if ($request->hasFile('image')) {
            // Simpan gambar di folder 'public/posts'
            $imagePath = $request->file('image')->store('posts', 'public');
        }

        $post = Post::create([
            'user_id' => $request->user()->id,
            'caption' => $request->caption,
            'image' => $imagePath,
        ]);

        return response()->json([
            'message' => 'Post created successfully',
            'data' => $post
        ]);
    }

    // Fungsi Hapus Postingan
    public function destroy(Request $request, $id)
    {
        $post = Post::find($id);

        if (!$post) {
            return response()->json(['message' => 'Post not found'], 404);
        }

        // Pastikan yang menghapus adalah pemilik postingan
        if ($post->user_id != $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Hapus gambar dari storage jika ada
        if ($post->image) {
            Storage::disk('public')->delete($post->image);
        }

        $post->delete();

        return response()->json(['message' => 'Post deleted successfully']);
    }
}

