package com.example.omni_notes

import android.app.AlarmManager
import android.app.Notification
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.getSystemService
import java.text.SimpleDateFormat
import java.util.Locale

class ReminderAlert {
    public fun scheduleReminder(context: Context, title: String, content: String, time: Long, nid: Int, cid: String) {
        val intent = Intent(context, ReminderView::class.java)

        intent.putExtra("notificationID", nid)
        intent.putExtra("channelID", cid)
        intent.putExtra("titleExtra", title)
        intent.putExtra("messageExtra", content)

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            nid,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

        alarmManager.setExactAndAllowWhileIdle(
            AlarmManager.RTC_WAKEUP,
            time,
            pendingIntent
        )

        val formattedTime = SimpleDateFormat("hh:mm a", Locale.getDefault()).format(time)
        Log.d("ReminderAlert", "Alarm scheduled for notification ID: $nid at time: $formattedTime")
    }

    public fun isAlarmSet(context: Context, nid: Int): Boolean {
        val intent = Intent(context, ReminderView::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            nid,
            intent,
            PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
        )
        return pendingIntent != null
    }
}