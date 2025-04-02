package com.example.omni_notes

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.app.AlarmManager
import android.app.AlertDialog
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Handler
import android.os.Looper
import androidx.annotation.RequiresApi

import com.example.omni_notes.ReminderAlert;

class MainActivity : FlutterActivity() {
    private val CHANNEL = "nexina.omni.notes/reminder"

    @RequiresApi(VERSION_CODES.KITKAT)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            val ra = ReminderAlert();

            if (call.method == "setReminder") {
                val title = call.argument<String>("title") ?: "Default Title";
                val content = call.argument<String>("content") ?: "Default Content";
                val time = call.argument<Number>("time")?.toLong() ?: (System.currentTimeMillis() + 60000);
                val nid = call.argument<Number>("nid")?.toInt() ?: 101;
                val cid = call.argument<String>("cid") ?: "channel1";

               ra.scheduleReminder(this, title, content, time, nid, cid);

               showAlertMessage(this, title, content);
            }else {
                result.notImplemented()
            }
        }
    }

    private fun showAlertMessage(context: Context, title: String, message: String) {
        Handler(Looper.getMainLooper()).post {
            AlertDialog.Builder(context)
                .setTitle(title)
                .setMessage(message)
                .setPositiveButton("OK") { dialog, _ -> dialog.dismiss() }
                .show()
        }
    }

    // ✅ Move the function inside MainActivity and use 'this' for context
    private fun getBatteryLevel(): Int {
        return if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = this.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            intent?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1)?.let { level ->
                val scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
                if (scale > 0) level * 100 / scale else -1
            } ?: -1
        }
    }
}
