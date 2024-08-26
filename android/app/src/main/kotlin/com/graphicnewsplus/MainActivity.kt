package com.graphicnewsplus;

import android.content.BroadcastReceiver
import android.os.Bundle
import android.content.Context
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.android.FlutterFragmentActivity



class MainActivity : FlutterFragmentActivity() {
    // private val CHANNEL = "flutter.native/helper"
    private val CHANNEL = /*"https://gcgl.dci.in/channel"*/ "https://graphicnewsplus.com/channel"
    private val EVENTS =/* "https://gcgl.dci.in/events"*/"https://graphicnewsplus.com/events"
    private var startString: String? = null
    private var linksReceiver: BroadcastReceiver? = null


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//                .setMethodCallHandler { call, result ->
//                    // if (call.method.equals("openPdf", true)) {
//                    //     // val intent = Intent(this, SampleActivity::class.java)
//                    //     // var path =call.arguments.toString();
//                    //     //         intent.putExtra("path", path)
//                    //     // startActivity(intent)
//                    // } else {
//                    // }
//                    if (call.method == "initialLink") {
//                        Log.e("initialLink", "initialLink");
//                        if (startString != null) {
//                            Log.e("startString", startString);
//                            result.success(startString)
//                        }
//                    }
//                }

        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "initialLink") {
                
                if (startString != null) {
                   
                    result.success(startString)
                }
            }
        }

        EventChannel(flutterEngine.dartExecutor, EVENTS).setStreamHandler(
                object : EventChannel.StreamHandler {
                    override fun onListen(args: Any?, events: EventSink) {
                        linksReceiver = createChangeReceiver(events)
                    }

                    override fun onCancel(args: Any?) {
                        linksReceiver = null
                    }
                }
        )
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val intent = getIntent()
        startString = intent.data?.toString()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.action === Intent.ACTION_VIEW) {
            linksReceiver?.onReceive(this.applicationContext, intent)
        }
    }

    fun createChangeReceiver(events: EventSink): BroadcastReceiver? {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) { // NOTE: assuming intent.getAction() is Intent.ACTION_VIEW
                val dataString = intent.dataString
                        ?: events.error("UNAVAILABLE", "Link unavailable", null)
                events.success(dataString)
            }
        }
    }

}

 