package com.nagisons.flutter_ping;

import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.Socket;
import java.net.URL;
import java.util.concurrent.ExecutionException;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterPingPlugin */
public class FlutterPingPlugin implements MethodCallHandler {

  Activity context;
  MethodChannel methodChannel;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_ping");
    channel.setMethodCallHandler(new FlutterPingPlugin(registrar.activity(), channel));
  }

  public FlutterPingPlugin(Activity activity, MethodChannel methodChannel) {
    this.context = activity;
    this.methodChannel = methodChannel;
    this.methodChannel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
      if (call.method.equals("pingURL")) {
      String url_string = call.argument("url");
      try {
        result.success(new ICMPPingTask().execute(url_string).get());
      } catch (ExecutionException e) {
        result.success(e.toString());
      } catch (InterruptedException e) {
        result.success(e.toString());
      }
    } else {
      result.notImplemented();
    }
  }
}
