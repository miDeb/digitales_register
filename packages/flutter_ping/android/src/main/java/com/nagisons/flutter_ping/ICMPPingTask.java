package com.nagisons.flutter_ping;

import android.app.Activity;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.UnknownHostException;

class ICMPPingTask extends AsyncTask<String, Void, String> {

    protected String doInBackground(String... urls) {
        try {
            String pingCommand = "/system/bin/ping -c 1 " + urls[0];
            String inputLine = "";
            try {
                // execute the command on the environment interface
                Process process = Runtime.getRuntime().exec(pingCommand);
                // gets the input stream to get the output of the executed command
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));

                inputLine = bufferedReader.readLine();
                while ((inputLine != null)) {
                    if (inputLine.length() > 0 && inputLine.contains("avg")) {  // when we get to the last line of executed ping command
                        break;
                    }
                    inputLine = bufferedReader.readLine();
                }
                String afterEqual = inputLine.substring(inputLine.indexOf("="), inputLine.length()).trim();
                String afterFirstSlash = afterEqual.substring(afterEqual.indexOf('/') + 1, afterEqual.length()).trim();
                String afterSecondSlash = afterFirstSlash.substring(afterFirstSlash.indexOf('/') + 1, afterFirstSlash.length()).trim();
                String strMinRtt = afterEqual.substring(1, afterEqual.indexOf('/')).trim();
                String strAvgRtt = afterFirstSlash.substring(0, afterFirstSlash.indexOf('/')).trim();
                String strMaxRtt = afterSecondSlash.substring(0, afterSecondSlash.indexOf('/')).trim();
                return "{\"min\":" + strMinRtt + ",\"avg\":" + strAvgRtt + ",\"max\":" + strMaxRtt + "}";
            }
            catch (Exception e) {
                return e.toString();
            }
        } catch (Exception e) {
            return e.toString();
        }
    }

    protected void onPostExecute(String feed) {
        // TODO: check this.exception
        // TODO: do something with the feed
    }
}

