<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
    Schema::create('posts', function (Blueprint $table) {
        $table->id();
        $table->foreignId('user_id')->constrained()->onDelete('cascade');
        $table->text('caption')->nullable();
        $table->string('image')->nullable(); // Path gambar
        $table->integer('likes')->default(0);
        $table->integer('comments')->default(0);
        $table->timestamps();
    });
    }
    
    public function down(): void
    {
        Schema::dropIfExists('posts');
    }
};
