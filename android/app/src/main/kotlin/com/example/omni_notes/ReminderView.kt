package com.example.omni_notes

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat

var notificationID = 121
var channelID = "channel1"
var titleExtra = "titleExtra"
var messageExtra = "messageExtra"

class ReminderView : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val notificationID = intent.getIntExtra("notificationID", 0)
        val channelID = intent.getStringExtra("channelID") ?: "default_channel"
        val title = intent.getStringExtra("titleExtra") ?: "Reminder"
        val message = intent.getStringExtra("messageExtra") ?: "You have a reminder!"

        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        // Create a notification channel for Android 8.0 and above
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelID,
                "Reminders",
                NotificationManager.IMPORTANCE_HIGH
            )
            notificationManager.createNotificationChannel(channel)
        }

        // Build and display the notification
        val notification = NotificationCompat.Builder(context, channelID)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle(title)
            .setContentText(message)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setAutoCancel(true)
            .build()

        notificationManager.notify(notificationID, notification)
    }
}