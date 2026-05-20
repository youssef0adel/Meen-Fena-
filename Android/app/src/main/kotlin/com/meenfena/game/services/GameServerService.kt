package com.meenfena.game.services

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.meenfena.game.MainActivity
import java.net.ServerSocket

class GameServerService : Service() {
    
    private var serverSocket: ServerSocket? = null
    private var isRunning = false
    
    companion object {
        const val CHANNEL_ID = "game_server_channel"
        const val NOTIFICATION_ID = 1
        const val PORT = 8888
    }

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val notification = buildNotification()
        startForeground(NOTIFICATION_ID, notification)
        
        startServer()
        
        return START_STICKY
    }

    private fun startServer() {
        Thread {
            try {
                serverSocket = ServerSocket(PORT)
                isRunning = true
                
                while (isRunning) {
                    val client = serverSocket?.accept()
                    // Handle client connection
                    Thread {
                        handleClient(client)
                    }.start()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }.start()
    }

    private fun handleClient(client: java.net.Socket?) {
        // Implementation for client handling
        client?.use { socket ->
            val input = socket.getInputStream()
            val output = socket.getOutputStream()
            // Game logic here
        }
    }

    private fun buildNotification(): Notification {
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("🎮 مين فينا؟")
            .setContentText("السيرفر شغال - في انتظار اللاعبين...")
            .setSmallIcon(android.R.drawable.ic_menu_manage)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Game Server",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "قناة سيرفر اللعبة"
            }
            
            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        isRunning = false
        serverSocket?.close()
        super.onDestroy()
    }
}